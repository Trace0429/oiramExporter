#include "stdafx.h"
#include "Analyzer.h"
#include <IGame/IGameModifier.h>
#include <algorithm>
#include <xfunctional>
#include "requisites.h"
#include "scene.h"
#include "strutil.h"
#include "LogManager.h"

Analyzer::
Analyzer()
{
	createDefaultMaterial();
}


Analyzer::
~Analyzer()
{
}


void Analyzer::
processGeometry(IGameNode* gameNode, const SceneNodeMap& sceneNodeMap)
{
	assert(sceneNodeMap.count(gameNode));
	const SceneNode* sceneNode = &sceneNodeMap.find(gameNode)->second;

	LogManager::getSingleton().logMessage(false, "Exporting: %s", sceneNode->name.c_str());
	LogManager::getSingleton().setProgress(0);

	// 世界矩阵的逆矩阵
	GMatrix nodeInvWorldTM;
	GMatrix localTM = gameNode->GetLocalTM();
	// 判断是否需要翻转法线
	bool flipNormal = localTM.Parity() == -1;

	IGameObject* gameObject = gameNode->GetIGameObject();
	IGameMesh* gameMesh = static_cast<IGameMesh*>(gameObject);

	// mMesh会被反复使用, 所以需要在每次导出前初始化清零
	mMesh.initialize();
	// 节点名称(max允许node重名, 而这里保证名称唯一)
	mMesh.name = sceneNode->meshName;

	mMesh.hasSkeleton = sceneNode->hasSkeleton;
	// 取得蒙皮对象
	IGameSkin* skin = nullptr;
	if (mMesh.hasSkeleton && gameObject->IsObjectSkinned())
	{
		skin = gameObject->GetIGameSkin();
		skin->GetInitSkinTM(mInitSkinTM);
		
		nodeInvWorldTM = mInitSkinTM.Inverse();

		// 有可能出现修改器堆栈中有Skin或者Physique, 但却没有蒙皮的情况
		// 在导出之前已经保证mMesh.hasSkeleton == true的node绝对是有实际绑定了骨骼的
		int numSkinBones = skin->GetTotalBoneCount();
		assert(numSkinBones > 0);
		if (numSkinBones > 0)
		{
			IGameNode* rootNode = getRootNode(skin->GetIGameBone(0, true));
			assert(rootNode);
			if (rootNode)
			{
				// 得到骨架名称
				if (config.prependRenaming)
					mMesh.skeletonName = config.maxName + '_' + Mchar2Ansi(rootNode->GetName());
				else
					mMesh.skeletonName = Mchar2Ansi(rootNode->GetName());
				strLegalityCheck(mMesh.skeletonName);

				// 导出整幅骨架
				if (config.fullSkeletal)
					dumpSkeletal(rootNode);
			}
		}
	}
	else
	{
		nodeInvWorldTM = gameNode->GetWorldTM().Inverse();
	}

	std::vector<TimeValue> morphKeyFrameTimes;
	// 如果有顶点动画, 记录下关键帧的时间
	if (sceneNode->hasMorph)
		processVertexAnimation(gameNode, sceneNode, morphKeyFrameTimes);

	bool ret = gameMesh->InitializeData();

	// 如果mesh没有normal时调用gameMesh->GetNumberOfVerts()会报错
	bool hasNormal = false;
	Mesh* mesh = gameMesh->GetMaxMesh();
	if (mesh && mesh->normalCount > 0)
		hasNormal = true;

	// 查找tangentMapChannel
	int tangentMapChannel = -1;
	if (config.renderingType != RT_FixedFunction)
	{
		for (int mapChannel = -2; mapChannel <= 99; ++mapChannel)
		{
			if (gameMesh->GetNumberOfTangents(mapChannel) > 0)
			{
				tangentMapChannel = mapChannel;
				break;
			}
		}
	}

	// 子网格描述信息
	struct SubMeshDesc
	{
		int									matID;
		oiram::VertexDeclaration			vertexDeclaration;
		std::set<int>						mapChannelSet;
		std::vector<FaceEx*>				faces;
		size_t								numVertices;
		oiram::Geometry						geometry;
	};
	typedef std::unique_ptr<SubMeshDesc> SubMeshDescPtr;

	// material -> subMesh
	std::map<oiram::MaterialPtr, SubMeshDescPtr> subMeshDescMap;
	// 统计使用次数最多的顶点声明
	std::multiset<oiram::VertexDeclaration> vertexDeclSet;

	// 总的面数
	int faceTotalCount = 0;
	// 收集所有材质信息
	Tab<int> matIDs = gameMesh->GetActiveMatIDs();
	int matIDCount = matIDs.Count();
	for (int matIdx = 0; matIdx < matIDCount; ++matIdx)
	{
		int matID = matIDs[matIdx];
		auto faces = gameMesh->GetFacesFromMatID(matID);
		int numFaces = faces.Count();
		faceTotalCount += numFaces;
		assert(numFaces > 0);

		FaceEx* face = faces[0];
		// faces所有的顶点都应该是同一个材质
		IGameMaterial* gameMaterial = gameMesh->GetMaterialFromFace(face);

		// 没有附材质的面将被忽略
		if (gameMaterial == nullptr)
		{
			LogManager::getSingleton().logMessage(true, "Ignore Submesh(matID: %d) with no material.", matID);
			continue;
		}

		// 如果是多重材质
		if (gameMaterial->IsMultiType())
		{
			// 如果是壳材质
			MCHAR* materialClass = gameMaterial->GetMaterialClass();
			if (_tcscmp(_T("Shell Material"), materialClass) == 0)
			{
				// 如果子材质超过1个
				if (gameMaterial->GetSubMaterialCount() > 1)
				{
					// 第一层是original, 第二层是baked
					gameMaterial = gameMaterial->GetSubMaterial(0);
					// 壳材质下可能是多重材质
					if (gameMaterial->IsMultiType())
					{
						// 遍历所有子材质
						int origSubCount = gameMaterial->GetSubMaterialCount();
						int index = 0;
						for (; index < origSubCount; ++index)
						{
							// matID必须匹配
							int subMtlID = gameMaterial->GetMaterialID(index);
							if (subMtlID == matID)
								break;
						}
						// 如果没有找到, 默认使用第0个
						if (index == origSubCount)
							index = 0;

						gameMaterial = gameMaterial->GetSubMaterial(index);
					}
				}
			}
		}

		// 查找到材质数据
		assert(mMaterialMap.count(gameMaterial));
		auto& material = mMaterialMap[gameMaterial];

		// 新材质才需要分析顶点声明
		auto subMeshDescItor = subMeshDescMap.find(material);
		if (subMeshDescItor == subMeshDescMap.end())
		{
			// 标记材质已使用
			material->isUsed = true;

			// 填充描述信息
			SubMeshDescPtr subMeshDesc(new SubMeshDesc);
			subMeshDesc->matID = matID;
			subMeshDesc->faces.reserve(numFaces);
			std::copy(faces.Addr(0), faces.Addr(0) + numFaces, std::back_inserter(subMeshDesc->faces));
			auto& vertexDeclaration = subMeshDesc->vertexDeclaration;
			auto& mapChannelSet = subMeshDesc->mapChannelSet;

			// oiram::Ves_Position
			vertexDeclaration = oiram::Ves_Position;

			// oiram::Ves_Normal
			if (hasNormal)
				vertexDeclaration |= oiram::Ves_Normal;

			// oiram::Ves_Diffuse
			{
				// 顶点色是否存在
				Point3 rgb(1.0f, 1.0f, 1.0f);
				if (gameMesh->GetColorVertex(face->color[0], rgb) && !rgb.Equals(Point3(-1.0f, -1.0f, -1.0f)))
					vertexDeclaration |= oiram::Ves_Diffuse;
			}

			// oiram::Ves_Texture_Coordinates
			{
				// 统计所有纹理通道
				for (auto& textureSlot : material->textureSlots)
				{
					if (textureSlot->texunit != oiram::Material::TU_Operation)
					{
						int mapChannel = textureSlot->mapChannel;
						if (gameMesh->GetMaxMesh()->mapSupport(mapChannel))
							mapChannelSet.insert(mapChannel);
						else
							LogManager::getSingleton().logMessage(true, "Unsupported map channel : (%d).", mapChannel);
					}
				}
				// 最大不超过8层
				const size_t MaxTexUnits = 8;
				assert(mapChannelSet.size() <= MaxTexUnits);
				size_t maxTexUnitNum = std::min(MaxTexUnits, mapChannelSet.size());
				for (size_t n = 0; n < maxTexUnitNum; ++n)
					vertexDeclaration |= oiram::Ves_Texture_Coordinate0 << n;
			}

			// oiram::Ves_Binormal, oiram::Ves_Tangent
			{
				// 如果存在tangent frame数据, 同时有normalmap贴图
				if (tangentMapChannel != -1 &&
					gameMesh->GetFaceVertexTangentBinormal(face->meshFaceIndex, 0, tangentMapChannel) != -1)
				{
					bool hasNormalMap = false;
					for (auto& textureSlot : material->textureSlots)
					{
						if (textureSlot->texunit == oiram::Material::TU_NormalMap)
						{
							hasNormalMap = true;
							break;
						}
					}

					if (hasNormalMap)
						vertexDeclaration |= oiram::Ves_Binormal | oiram::Ves_Tangent;
				}
			}

			// oiram::Ves_Blend_Weights, oiram::Ves_Blend_Indices
			{
				// 检查是否存在骨骼绑定数据
				if (mMesh.hasSkeleton)
					vertexDeclaration |= oiram::Ves_Blend_Weights | oiram::Ves_Blend_Indices;
			}

			// oiram::Ves_VertexAnimationIndex
			{
				if (mMesh.hasMorph)
					vertexDeclaration |= oiram::Ves_VertexAnimationIndex;
			}

			// 记录
			subMeshDescMap.insert(std::make_pair(material, std::move(subMeshDesc)));
			vertexDeclSet.insert(vertexDeclaration);
		}
		else
		{
			// 记录相同材质的面
			auto& subMeshDesc = subMeshDescItor->second;
			vertexDeclSet.insert(subMeshDesc->vertexDeclaration);
			std::copy(faces.Addr(0), faces.Addr(0) + numFaces, std::back_inserter(subMeshDesc->faces));
		}
	}

	// 有效面数不为0, 顶点声明集合有效
	assert(faceTotalCount > 0 && !vertexDeclSet.empty());

	// 使用次数最多的顶点声明
	size_t sharedVertexDeclarationUsed = 0;
	oiram::VertexDeclaration sharedVertexDeclaration = 0;
	// 因为是multimap, 所以下面的for只会遍历所有的key
	for (auto& itor = vertexDeclSet.begin(); itor != vertexDeclSet.end(); itor = vertexDeclSet.upper_bound(*itor))
	{
		auto& vertexDeclaration = *itor;
		size_t vertexDeclUsed = vertexDeclSet.count(vertexDeclaration);

		// 记录使用次数最多的那一个顶点声明
		if (vertexDeclUsed > sharedVertexDeclarationUsed)
		{
			sharedVertexDeclarationUsed = vertexDeclUsed;
			sharedVertexDeclaration = vertexDeclaration;
		}
	}

	// 创建共享几何数据
	assert(sharedVertexDeclaration != 0);
	mMesh.sharedGeometry.reset(new oiram::GeometryData);
	// 共享几何的顶点总数
	size_t sharedVertexCount = 0;

	for (auto& desc : subMeshDescMap)
	{
		auto& material = desc.first;
		auto& subMeshDesc = desc.second;

		// 计算顶点数量
		size_t numVertices = subMeshDesc->faces.size() * 3;
		subMeshDesc->numVertices = numVertices;

		// 创建几何数据, 记录顶点声明
		auto& geometry = subMeshDesc->geometry;
		if (sharedVertexDeclaration == subMeshDesc->vertexDeclaration)
		{
			geometry = mMesh.sharedGeometry;
			sharedVertexCount += numVertices;
		}
		else
		{
			// 预分配内存
			geometry.reset(new oiram::GeometryData);
			geometry->vertexBuffer.reserve(numVertices);
		}

		geometry->vertexDeclaration = subMeshDesc->vertexDeclaration;
		geometry->material = material;
	}
	// 预分配内存
	if (mMesh.sharedGeometry)
		mMesh.sharedGeometry->vertexBuffer.reserve(sharedVertexCount);

	// 按材质依次处理模型的顶点数据
	int faceProgress = 0;
	Interface* coreInterface = GetCOREInterface();
	TimeValue sceneStartTime = GetIGameInterface()->GetSceneStartTime();
	for (auto& desc : subMeshDescMap)
	{
		auto& material = desc.first;
		auto& subMeshDesc = desc.second;

		auto matID = subMeshDesc->matID;
		auto& mapChannelSet = subMeshDesc->mapChannelSet;
		auto& geometry = subMeshDesc->geometry;
		auto& vertexDeclaration = geometry->vertexDeclaration;
		auto& faces = subMeshDesc->faces;
		auto& numVertices = subMeshDesc->numVertices;

		// 记录材质名称
		std::string materialName = material->name;
		assert(!materialName.empty());
		// 如果使用shading
		if (config.renderingType != RT_FixedFunction)
		{
			std::string extended;
			if (mMesh.hasSkeleton)
				extended = "_skeleton";
			else if (mMesh.hasMorph)
				extended = "_morph";
			else
				extended = "_static";
			material->extended.insert(extended);
			if (!materialName.empty())
				materialName += extended;
		}

		// 填写SubMesh
		std::unique_ptr<oiram::SubMesh> subMesh(new oiram::SubMesh);
		subMesh->materialName = materialName;
		subMesh->matID = matID;
		subMesh->geometry = geometry;

		// 面的顶点数据, 根据双面调整大小
		size_t numVertex = 3;
		std::vector<oiram::Vertex> vertices(numVertex);
		std::vector<std::vector<oiram::MorphVertex>> morphTrackVertices;
		if (mMesh.hasMorph)
		{
			morphTrackVertices.resize(numVertex);
			// 根据关键帧的数量保存动画顶点
			std::for_each(morphTrackVertices.begin(), morphTrackVertices.end(), 
				std::bind2nd(std::mem_fun_ref(&std::vector<oiram::MorphVertex>::resize), morphKeyFrameTimes.size()));
		}

		// 骨骼数据
		std::set<unsigned short> boneAssignments;

		// 以面为单位处理顶点
		size_t numFaces = faces.size();
		for (size_t f = 0; f < numFaces; ++f, ++faceProgress)
		{
			// 刷新一次进度条
			LogManager::getSingleton().setProgress(static_cast<int>(static_cast<float>(faceProgress) / faceTotalCount * 100));

			// 以面为单位记录材质ID
			FaceEx* face = faces[f];
			for (int v = 0; v < 3; ++v)
			{
				auto& vertex = vertices[v];
				int vertexIndex = face->vert[v];

				// 顶点动画在取数据时会改变当前帧时间
				if (mMesh.hasMorph)
					coreInterface->SetTime(sceneStartTime, FALSE);

				// position
				if (vertexDeclaration & oiram::Ves_Position)
				{
					Point3 position = gameMesh->GetVertex(vertexIndex, false);
					position = position * nodeInvWorldTM;
					position *= config.unitMultiplier;

					vertex.vec3Position = position;
					updateVertexBounds(vertex.vec3Position);
				}

				// normal
				if (vertexDeclaration & oiram::Ves_Normal)
				{
					// 根据顶点索引取出模型空间的法线(双面的顶点使用同样的顶点索引)
					Point3 normal;
					gameMesh->GetNormal(face->norm[v], normal, true);
					// 如果需要反转法线则取反
					if (flipNormal)
						normal *= -1.0f;

					vertex.vec3Normal = normal;
				}

				// diffuse
				if (vertexDeclaration & oiram::Ves_Diffuse)
				{
					// 把颜色从BGR转换为RGB
					Point3 rgb(1,1,1);
					gameMesh->GetColorVertex(face->color[v], rgb);
					std::swap(rgb.y, rgb.z);
					float a = 1.0;
					gameMesh->GetAlphaVertex(face->alpha[v], a);
					// 颜色取出来有时是负数, 所以这里忽略符号
					unsigned char argb[4] = {	static_cast<unsigned char>(fabs(a)		* 255),
												static_cast<unsigned char>(fabs(rgb.x)  * 255),
												static_cast<unsigned char>(fabs(rgb.y)  * 255),
												static_cast<unsigned char>(fabs(rgb.z)  * 255)	};
					vertex.diffuse = argb[0] << 24 | argb[1] << 16 | argb[2] << 8 | argb[3];
				}

				if (vertexDeclaration & oiram::Ves_Texture_Coordinate0)
				{
					// 记录所有纹理的UV信息
					vertex.vec2Texcoords.clear();
					for (auto& mapChannel : mapChannelSet)
					{
						int mapVertexIndex = gameMesh->GetFaceTextureVertex(face->meshFaceIndex, v, mapChannel);
						Point3 mapVertex = gameMesh->GetMapVertex(mapChannel, mapVertexIndex);

						// Programmable pipeline需要将过大或过小的纹理坐标都将被钳制到有效区间
						if (config.renderingType != RT_FixedFunction)
						{
							const float TexcoordRange = 500.0f;
							mapVertex.x = std::min(TexcoordRange, std::max(mapVertex.x, -TexcoordRange));
							mapVertex.y = std::min(TexcoordRange, std::max(mapVertex.y, -TexcoordRange));
							if (oiram::fzero(mapVertex.x))
								mapVertex.x = 0;
							if (oiram::fzero(mapVertex.y))
								mapVertex.y = 0;
						}

						assert(material->uvCoordinateMap.count(mapChannel));
						auto& uvCoordinate = material->uvCoordinateMap[mapChannel];
						GMatrix uvTransform = toGMatrix(uvCoordinate->transform);
						mapVertex = mapVertex * uvTransform;
						// mirror除了tex_address_mode要设置为mirror之外, map vertex也要乘以2, 则效果就与max一致了
						if (uvCoordinate->u_mode == oiram::Material::mirror)
							mapVertex.x *= 2;
						if (uvCoordinate->v_mode == oiram::Material::mirror)
							mapVertex.y *= 2;

						// OGL的UV原点在左下角
						oiram::vec2 uv(mapVertex.x, 1.0f - mapVertex.y);
						vertex.vec2Texcoords.push_back(uv);
						updateUVBounds(uv);
					}
				}

				if (vertexDeclaration & oiram::Ves_Tangent)
				{
					int tangentIndex = gameMesh->GetFaceVertexTangentBinormal(face->meshFaceIndex, v, tangentMapChannel);
					Point3	tangent = gameMesh->GetTangent(tangentIndex, tangentMapChannel),
							binormal = gameMesh->GetBinormal(tangentIndex, tangentMapChannel),
							normal(vertex.vec3Normal.x, vertex.vec3Normal.y, vertex.vec3Normal.z);

					// Gram-Schmidt orthogonalize
					tangent = (tangent - normal * DotProd(normal, tangent)).Normalize();
					// Calculate handedness
					float handedness = (DotProd(CrossProd(normal, tangent), binormal) < 0.0f) ? -1.0f : 1.0f;

					vertex.vec4Tangent.set(tangent.x, tangent.y, tangent.z, handedness);
					vertex.vec3Binormal.set(binormal.x, binormal.y, binormal.z);
				}

				if (vertexDeclaration & oiram::Ves_Blend_Weights)
				{
					float weight = 0.0f;
					int numBones = skin->GetNumberOfBones(vertexIndex);
					// numBones的值可能会是-1 ...
					if (numBones > 0)
					{
						// 蒙皮骨骼
						struct SkinBone {
							IGameNode*	boneNode;	// 节点
							float		weight;		// 权重
							// 按权重由大到小排序
							bool operator < (const SkinBone& rhs)const { return weight > rhs.weight; }
						};

						// 过小的权重将被忽略
						const float weightEpsilon = 0.002f;
						// 这里只是reserve出空间, 因为bone指针不一定有效, 所以bone的数量目前还不一定
						std::vector<SkinBone> skinBones;
						skinBones.reserve(numBones);
						for (int idx = 0; idx < numBones; ++idx)
						{
							IGameNode* boneNode = skin->GetIGameBone(vertexIndex, idx);
							if (boneNode)
							{
								float weight = skin->GetWeight(vertexIndex, idx);
								if (weight > weightEpsilon)
									skinBones.push_back({ boneNode, weight });
							}
						}

						// 受大于4个骨骼影响, 只取前4个权重最大的骨骼, 并保证权重和为1
						numBones = static_cast<int>(skinBones.size());
						if (numBones > 4)
						{
							// 权重按降序排序
							std::sort(skinBones.begin(), skinBones.end());
							// 只留前4个
							skinBones.resize(4);
							numBones = 4;
						}

						if (numBones > 0)
						{
							// 总权重值
							float weightTotal = 0.0f;
							for (auto& skinBone : skinBones)
								weightTotal += skinBone.weight;

							if (!oiram::fequal(weightTotal, 1.0f))
							{
								// 归一化, 保证权重和为1
								float weightFactor = 1.0f / weightTotal;
								int idx = 0;
								weightTotal = 0.0f;
								for (; idx < numBones - 1; ++idx)
								{
									float& weight = skinBones[idx].weight;
									weight *= weightFactor;
									weightTotal += weight;
								}
								skinBones[idx].weight = 1.0f - weightTotal;
							}
						}

						// 权重和索引(不足4根骨骼的index将被设置导出时会被忽略的无效值0xff, 权重默认为1.0)
						Point4 weights(1, 1, 1, 1);
						unsigned long indices = 0xffffffff;
						unsigned char* subIndices = reinterpret_cast<unsigned char*>(&indices);
						int boneIndex = 0;
						for (; boneIndex < numBones; ++boneIndex)
						{
							const SkinBone& bone = skinBones[boneIndex];
							weights[boneIndex] = bone.weight;
							unsigned short boneHandle = dumpBone(bone.boneNode);
							*subIndices++ = static_cast<unsigned char>(boneHandle);
							boneAssignments.insert(boneHandle);
						}

						vertex.vec4BlendWeight = weights;
						vertex.blendIndex = indices;
					}
				}

				if (mMesh.hasMorph)
				{
					// 收集所有关键帧的顶点和法线信息
					for (size_t k = 0; k < morphKeyFrameTimes.size(); ++k)
					{
						TimeValue t = morphKeyFrameTimes[k];
						coreInterface->SetTime(t, FALSE);
						auto& morphVertex = morphTrackVertices[v][k];

						// position
						{
							Point3 position = gameMesh->GetVertex(vertexIndex, false);
							position = position * nodeInvWorldTM;
							position *= config.unitMultiplier;

							morphVertex.vec3Position = position;
							updateVertexBounds(morphVertex.vec3Position);
						}

						// normal
						{
							Point3 normal;
							gameMesh->GetNormal(face->norm[v], normal, true);
							// 如果需要反转法线则取反
							if (flipNormal)
								normal *= -1.0f;

							morphVertex.vec3Normal = normal;
						}
					}
				}
			}

			for (size_t v = 0; v < numVertex; ++v)
			{
				oiram::Vertex& vertex = vertices[v];

				size_t index = geometry->vertexBuffer.size();

				// 记录动画关键帧信息
				if (mMesh.hasMorph)
				{
					const auto& morphTrack = morphTrackVertices[v];
					for (size_t k = 0; k < morphKeyFrameTimes.size(); ++k)
					{
						// 根据关键帧时间保存顶点动画
						const auto& t = morphKeyFrameTimes[k];
						const auto& morphVertex = morphTrack[k];
						auto& morphKeyFrame = geometry->morphAnimationTrack[t];
						morphKeyFrame.push_back(morphVertex);
					}
					vertex.animationIndex = static_cast<unsigned long>(index);
				}

				// 依次将顶点信息存入vertexBuffer中
				geometry->vertexBuffer.push_back(vertex);
			}
		}

		// 一个submesh相当于一个batch, 如果使用GPU skinning, 那么骨骼的总数会受寄存器数量的影响
		// 例如sm2.0只有256个寄存器, 相当于64个matrix, 除开其他的uniform, 通常只有60个matrix甚至更少可供使用
		if (mMesh.hasSkeleton)
			LogManager::getSingleton().logMessage(false, "Bone assignments size = %d.", boneAssignments.size());

		// 生成顶点索引
		size_t numIndices = geometry->vertexBuffer.size();
		assert(numIndices > 0);
		subMesh->indexBuffer.use32BitIndices = numIndices > 65535;
		if (subMesh->indexBuffer.use32BitIndices)
			subMesh->indexBuffer.uiIndexBuffer.resize(numVertices);
		else
			subMesh->indexBuffer.usIndexBuffer.resize(numVertices);

		size_t indexStart = numIndices - numVertices;
		for (size_t idx = 0; idx < numVertices; ++idx)
		{
			if (subMesh->indexBuffer.use32BitIndices)
				subMesh->indexBuffer.uiIndexBuffer[idx] = static_cast<unsigned int>(idx + indexStart);
			else
				subMesh->indexBuffer.usIndexBuffer[idx] = static_cast<unsigned short>(idx + indexStart);
		}

		mMesh.subMeshes.push_back(std::move(subMesh));
	}

	gameNode->ReleaseIGameObject();

	LogManager::getSingleton().setProgress(100);
}


void Analyzer::
updateVertexBounds(const oiram::vec3& position)
{
	mMesh.vertexBoundingBox.pmax.x = std::max(mMesh.vertexBoundingBox.pmax.x, position.x);
	mMesh.vertexBoundingBox.pmax.y = std::max(mMesh.vertexBoundingBox.pmax.y, position.y);
	mMesh.vertexBoundingBox.pmax.z = std::max(mMesh.vertexBoundingBox.pmax.z, position.z);

	mMesh.vertexBoundingBox.pmin.x = std::min(mMesh.vertexBoundingBox.pmin.x, position.x);
	mMesh.vertexBoundingBox.pmin.y = std::min(mMesh.vertexBoundingBox.pmin.y, position.y);
	mMesh.vertexBoundingBox.pmin.z = std::min(mMesh.vertexBoundingBox.pmin.z, position.z);
}


void Analyzer::
updateUVBounds(const oiram::vec2& uv)
{
	mMesh.uvBoundingBox.pmax.x = std::max(mMesh.uvBoundingBox.pmax.x, uv.x);
	mMesh.uvBoundingBox.pmax.y = std::max(mMesh.uvBoundingBox.pmax.y, uv.y);

	mMesh.uvBoundingBox.pmin.x = std::min(mMesh.uvBoundingBox.pmin.x, uv.x);
	mMesh.uvBoundingBox.pmin.y = std::min(mMesh.uvBoundingBox.pmin.y, uv.y);
}


void Analyzer::
processVertexAnimation(IGameNode* gameNode, const SceneNode* sceneNode, std::vector<TimeValue>& morphKeyFrameTimes)
{
	// 如果有顶点动画, 记录下关键帧的时间
	IGameControl* gameControl = gameNode->GetIGameControl();
	if (gameControl &&
		gameControl->IsAnimated(IGAME_POINT3))
	{
		IGameKeyTab samples;
		if (gameControl->GetQuickSampledKeys(samples, IGAME_POINT3))
		{
			// 确认是否有动画
			int keyFrameCount = samples.Count();
			if (keyFrameCount > 0)
			{
				mMesh.hasMorph = true;

				// 根据动画信息依次收集关键帧信息
				size_t animationCount = sceneNode->animationDescs.size();
				mMesh.morphAnimations.resize(animationCount);
				for (size_t n = 0; n < animationCount; ++n)
				{
					const auto& animDesc = sceneNode->animationDescs[n];
					TimeValue	timeStart = animDesc.start * config.ticksPerFrame, 
								timeEnd = animDesc.end * config.ticksPerFrame;

					// 首尾关键帧必须保存
					auto& morphAnimations = mMesh.morphAnimations[n];
					morphAnimations.push_back(timeStart);
					morphKeyFrameTimes.push_back(timeStart);
					for (int i = 0; i < keyFrameCount; ++i)
					{
						TimeValue t = samples[i].t;
						if (t >= timeStart && t <= timeEnd)
						{
							morphAnimations.push_back(t);
							morphKeyFrameTimes.push_back(t);
						}
					}
					morphAnimations.push_back(timeEnd);
					morphKeyFrameTimes.push_back(timeEnd);

					// 确保关键帧时间唯一
					std::sort(morphAnimations.begin(), morphAnimations.end());
					morphAnimations.erase(std::unique(morphAnimations.begin(), morphAnimations.end()), morphAnimations.end());
				}
				std::sort(morphKeyFrameTimes.begin(), morphKeyFrameTimes.end());
				morphKeyFrameTimes.erase(std::unique(morphKeyFrameTimes.begin(), morphKeyFrameTimes.end()), morphKeyFrameTimes.end());
			}
		}
	}
}


oiram::box3 Analyzer::
fromBox3(Box3 box)
{
	assert(!box.IsEmpty());

	// 从max坐标系转换到右手坐标系
	std::swap(box.pmin.y, box.pmin.z);
	box.pmin.z = -box.pmin.z;
	std::swap(box.pmax.y, box.pmax.z);
	box.pmax.z = -box.pmax.z;

	// 取出的box有时pmax会小于pmin的分量, 这里确保pmin的所有分量都小于pmax
	if (box.pmin.x > box.pmax.x)
		std::swap(box.pmin.x, box.pmax.x);
	if (box.pmin.y > box.pmax.y)
		std::swap(box.pmin.y, box.pmax.y);
	if (box.pmin.z > box.pmax.z)
		std::swap(box.pmin.z, box.pmax.z);

	return	{ { box.pmin.x, box.pmin.y, box.pmin.z }, { box.pmax.x, box.pmax.y, box.pmax.z } };
}
