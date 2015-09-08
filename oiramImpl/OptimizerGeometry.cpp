#include "stdafx.h"
#include <d3dx9.h>
#include <max.h>
#include <algorithm>
#include <functional>
#include <limits>
#include "requisites.h"
#include "scene.h"
#include "serializer.h"
#include "Optimizer.h"

void Optimizer::
optimizeMesh(oiram::Mesh& mesh)
{
	if (mD3DDevice)
	{
		// 遍历收集所有的geometry
		std::set<oiram::Geometry> geometrySet;
		if (mesh.sharedGeometry)
			geometrySet.insert(mesh.sharedGeometry);

		for (auto& subMesh : mesh.subMeshes)
			geometrySet.insert(subMesh->geometry);

		for (auto& geometry : geometrySet)
		{
			size_t lodCount = config.lodDescs.size();
			if (lodCount > 0)
				geometry->indexLODs.resize(lodCount);

			auto vertexDeclaration = geometry->vertexDeclaration;
			// 生成D3D的顶点定义
			int stride = 0;
			std::vector<D3DVERTEXELEMENT9> szDecl;
			if (vertexDeclaration & oiram::Ves_Position)
			{
				D3DVERTEXELEMENT9 element =	{0, stride, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0};
				szDecl.push_back(element);
				stride += sizeof(oiram::vec3);
			}

			if (vertexDeclaration & oiram::Ves_Normal)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_NORMAL,	0};
				szDecl.push_back(element);
				stride += sizeof(oiram::vec3);
			}

			if (vertexDeclaration & oiram::Ves_Diffuse)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_D3DCOLOR, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_COLOR, 0};
				szDecl.push_back(element);
				stride += sizeof(unsigned long);
			}

			if (vertexDeclaration & oiram::Ves_Texture_Coordinate0)
				for (size_t ch = 0; ch < geometry->vertexBuffer[0].vec2Texcoords.size(); ++ch)
				{
					D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_FLOAT2, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_TEXCOORD, static_cast<BYTE>(ch)};
					szDecl.push_back(element);
					stride += sizeof(oiram::vec2);
				}

			if (vertexDeclaration & oiram::Ves_Tangent)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_FLOAT4, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_TANGENT, 0};
				szDecl.push_back(element);
				stride += sizeof(oiram::vec4);
			}

			if (vertexDeclaration & oiram::Ves_Binormal)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_BINORMAL, 0};
				szDecl.push_back(element);
				stride += sizeof(oiram::vec3);
			}

			if (vertexDeclaration & oiram::Ves_Blend_Weights)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_FLOAT4, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_BLENDWEIGHT, 0};
				szDecl.push_back(element);
				stride += sizeof(oiram::vec4);
			}

			if (vertexDeclaration & oiram::Ves_Blend_Indices)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_UBYTE4, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_BLENDINDICES, 0};
				szDecl.push_back(element);
				stride += sizeof(unsigned long);
			}

			if (vertexDeclaration & oiram::Ves_VertexAnimationIndex)
			{
				D3DVERTEXELEMENT9 element = {0, stride, D3DDECLTYPE_UBYTE4, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_PSIZE, 0};
				szDecl.push_back(element);
				stride += sizeof(unsigned long);
			}

			// End of vertex element
			{
				D3DVERTEXELEMENT9 element = {0xFF, 0, D3DDECLTYPE_UNUSED, 0, 0, 0};
				szDecl.push_back(element);
			}

			// 创建D3D MESH
			LPD3DXMESH pMesh = 0;
			bool use32BitIndices = geometry->vertexBuffer.size() > 65535;
			DWORD options = use32BitIndices ? D3DXMESH_SYSTEMMEM | D3DXMESH_DYNAMIC | D3DXMESH_32BIT : D3DXMESH_SYSTEMMEM | D3DXMESH_DYNAMIC;
			DWORD numVertices = static_cast<DWORD>(geometry->vertexBuffer.size()), numFaces = numVertices / 3;
			if (SUCCEEDED(D3DXCreateMesh(numFaces, numVertices, options, &szDecl[0], mD3DDevice, &pMesh)))
			{
				// 填充Index Buffer
				LPVOID pData = 0;
				if (SUCCEEDED(pMesh->LockIndexBuffer(D3DLOCK_DISCARD, &pData)))
				{
					// 共享geometry需要将所有submesh的index打包在一起
					if (geometry == mesh.sharedGeometry)
					{
						// 区分32和16bits
						if (use32BitIndices)
						{
							unsigned int* uiData = reinterpret_cast<unsigned int*>(pData);
							for (auto& subMesh : mesh.subMeshes)
							{
								if (geometry == subMesh->geometry)
								{
									if (subMesh->indexBuffer.use32BitIndices)
									{
										for (auto idx : subMesh->indexBuffer.uiIndexBuffer)
											 *uiData++ = idx;
									}
									else
									{
										// submesh存的是unsigned short, 强制转换为unsigned int写入
										for (auto idx : subMesh->indexBuffer.usIndexBuffer)
											 *uiData++ = static_cast<unsigned int>(idx);
									}
								}
							}
						}
						else
						{
							unsigned short* uiData = reinterpret_cast<unsigned short*>(pData);
							for (auto& subMesh : mesh.subMeshes)
							{
								if (geometry == subMesh->geometry)
								{
									assert(!subMesh->indexBuffer.use32BitIndices);
									for (auto idx : subMesh->indexBuffer.usIndexBuffer)
										*uiData++ = idx;
								}
							}
						}
					}
					else
					{
						// 如果是独立的geometry, 找到对应的submesh, 将index填入
						for (auto& subMesh : mesh.subMeshes)
						{
							if (geometry == subMesh->geometry)
							{
								assert(use32BitIndices == subMesh->indexBuffer.use32BitIndices);
								if (use32BitIndices)
									memcpy(pData, subMesh->indexBuffer.uiIndexBuffer.data(), 
										subMesh->indexBuffer.uiIndexBuffer.size() * sizeof(unsigned int));
								else
									memcpy(pData, subMesh->indexBuffer.usIndexBuffer.data(), 
										subMesh->indexBuffer.usIndexBuffer.size() * sizeof(unsigned short));
								break;
							}
						}
					}

					pMesh->UnlockIndexBuffer();
				}

				// 填充Vertex Buffer
				if (SUCCEEDED(pMesh->LockVertexBuffer(D3DLOCK_DISCARD, &pData)))
				{
					// SubMesh中数据是分开存放, 而D3D VB要求放在一起, 使用pointer指针指向SubMesh中不同类型的顶点数据
					unsigned char* pointer = static_cast<unsigned char*>(pData);

					for (auto& vertex : geometry->vertexBuffer)
					{
						if (vertexDeclaration & oiram::Ves_Position)
						{
							memcpy(pointer, &vertex.vec3Position, sizeof(oiram::vec3));
							pointer += sizeof(oiram::vec3);
						}

						if (vertexDeclaration & oiram::Ves_Normal)
						{
							memcpy(pointer, &vertex.vec3Normal, sizeof(oiram::vec3));
							pointer += sizeof(oiram::vec3);
						}

						if (vertexDeclaration & oiram::Ves_Diffuse)
						{
							memcpy(pointer, &vertex.diffuse, sizeof(unsigned long));
							pointer += sizeof(unsigned long);
						}

						if (vertexDeclaration & oiram::Ves_Texture_Coordinate0)
						{
							memcpy(pointer, &vertex.vec2Texcoords[0], sizeof(oiram::vec2) * vertex.vec2Texcoords.size());
							pointer += sizeof(oiram::vec2) * vertex.vec2Texcoords.size();
						}

						if (vertexDeclaration & oiram::Ves_Tangent)
						{
							memcpy(pointer, &vertex.vec4Tangent, sizeof(oiram::vec4));
							pointer += sizeof(oiram::vec4);
						}

						if (vertexDeclaration & oiram::Ves_Binormal)
						{
							memcpy(pointer, &vertex.vec3Binormal, sizeof(oiram::vec3));
							pointer += sizeof(oiram::vec3);
						}

						if (vertexDeclaration & oiram::Ves_Blend_Weights)
						{
							memcpy(pointer, &vertex.vec4BlendWeight.x, sizeof(oiram::vec4));
							pointer += sizeof(oiram::vec4);
						}

						if (vertexDeclaration & oiram::Ves_Blend_Indices)
						{
							memcpy(pointer, &vertex.blendIndex, sizeof(unsigned long));
							pointer += sizeof(unsigned long);
						}

						if (vertexDeclaration & oiram::Ves_VertexAnimationIndex)
						{
							memcpy(pointer, &vertex.animationIndex, sizeof(unsigned long));
							pointer += sizeof(unsigned long);
						}
					}

					pMesh->UnlockVertexBuffer();
				}

				// 处理attributes
				if (SUCCEEDED(pMesh->LockAttributeBuffer(D3DLOCK_DISCARD, (DWORD**)(&pData))))
				{
					// 如果是共享几何数据, 依次将submesh的matID按face数量填入attribute buffer
					DWORD* dwAttr = static_cast<DWORD*>(pData);
					if (geometry == mesh.sharedGeometry)
					{
						for (auto& subMesh : mesh.subMeshes)
						{
							if (geometry == subMesh->geometry)
							{
								size_t faceCount = subMesh->indexBuffer.use32BitIndices ? 
											subMesh->indexBuffer.uiIndexBuffer.size() / 3 :
											subMesh->indexBuffer.usIndexBuffer.size() / 3;
								DWORD matID = subMesh->matID;
								for (size_t attr = 0; attr < faceCount; ++attr)
									*dwAttr++ = matID;
							}
						}
					}
					else
					{
						// 独立geometry将submesh的matID按face数量填入attribute buffer
						size_t faceCount = geometry->vertexBuffer.size() / 3;
						DWORD matID = 0;
						for (auto& subMesh : mesh.subMeshes)
						{
							if (geometry == subMesh->geometry)
							{
								matID = subMesh->matID;
								break;
							}
						}
						for (size_t attr = 0; attr < faceCount; ++attr)
							*dwAttr++ = matID;
					}

					pMesh->UnlockAttributeBuffer();
				}

				// 进行Mesh优化
				{
					HRESULT hr = S_OK;
					DWORD dwFaces = pMesh->GetNumFaces();
					DWORD dwVertices = pMesh->GetNumVertices();
					std::vector<DWORD> szAdjacencies(dwFaces * 3);
					DWORD* pAdjacency = szAdjacencies.data();
					hr = pMesh->GenerateAdjacency(0.0f, pAdjacency);
					// 清理mesh
					hr = D3DXCleanMesh(D3DXCLEAN_SIMPLIFICATION, pMesh, pAdjacency, &pMesh, pAdjacency, NULL);
					if (hr == S_OK)
					{
						// 去除mesh中重复的顶点
						D3DXWELDEPSILONS weldEpsilones = { mEpsilon };
						// 这里应该自己用8叉树处理模型, 然后自行缝合顶点, 多个共享顶点的法线要做特殊处理
						weldEpsilones.Normal = 0.3f;
						hr = D3DXWeldVertices(pMesh, D3DXWELDEPSILONS_WELDPARTIALMATCHES, &weldEpsilones, pAdjacency, pAdjacency, NULL, NULL);
						if (hr == S_OK)
						{
							hr = D3DXValidMesh(pMesh, pAdjacency, NULL);
							if (hr == S_OK)
							{
								dwFaces = pMesh->GetNumFaces();
								dwVertices = pMesh->GetNumVertices();

								// 生成LOD
								size_t lodCount = config.lodDescs.size();
								if (lodCount > 0)
								{
									LPD3DXPMESH pPMesh = 0;
									D3DXATTRIBUTEWEIGHTS attrbuteWeights = { 1.0, 0.0 };
									hr = D3DXGeneratePMesh(pMesh, pAdjacency, &attrbuteWeights, NULL, 1, D3DXMESHSIMP_VERTEX, &pPMesh);
									if (hr == S_OK)
									{
										DWORD	dwVerticesMin = pPMesh->GetMinVertices(), 
												dwVerticesMax = pPMesh->GetMaxVertices();
										pPMesh->SetNumVertices(dwVerticesMax);

										// 根据模型的顶点数量的百分比简化mesh
										for (size_t n = 0; n < lodCount; ++n)
										{
											const LODesc& desc = config.lodDescs[n];
											DWORD dwNewVertices = static_cast<DWORD>(dwVerticesMax * desc.reduction * 0.01f);
											hr = pPMesh->SetNumVertices(dwNewVertices);
											hr = pPMesh->OptimizeBaseLOD(D3DXMESHOPT_COMPACT | 
												D3DXMESHOPT_VERTEXCACHE | D3DXMESHOPT_DEVICEINDEPENDENT, NULL);

											LPVOID pData = 0;
											if (SUCCEEDED(hr = pPMesh->LockIndexBuffer(D3DLOCK_READONLY | D3DLOCK_DISCARD, &pData)))
											{
												oiram::LOD& lod = geometry->indexLODs[n];
												lod.indexCount = pPMesh->GetNumFaces() * 3;
												auto& indexBuffer = lod.indexBuffer;
												delete[] indexBuffer;
												bool use32BitIndices = lod.indexCount > 65535;
												if (use32BitIndices)
													indexBuffer = new unsigned int[lod.indexCount];
												else
													indexBuffer = new unsigned short[lod.indexCount];

												memcpy(indexBuffer, pData, use32BitIndices ? lod.indexCount * sizeof(unsigned int) :
																						lod.indexCount * sizeof(unsigned short));
												hr = pPMesh->UnlockIndexBuffer();
											}
										}

										pPMesh->SetNumVertices(dwVertices);
										pMesh->Release();
										hr = pPMesh->CloneMesh(pPMesh->GetOptions(), &szDecl[0], mD3DDevice, &pMesh);
									}
								}
								else
								{
									// 优化mesh适应VERTEXCACHE
									hr = pMesh->OptimizeInplace(D3DXMESHOPT_COMPACT | 
																D3DXMESHOPT_VERTEXCACHE | D3DXMESHOPT_DEVICEINDEPENDENT, 
										pAdjacency, pAdjacency, NULL, NULL);
								}
							}
						}
					}
				}

				// 取出Index Buffer
				if (SUCCEEDED(pMesh->LockIndexBuffer(D3DLOCK_READONLY | D3DLOCK_DISCARD, &pData)))
				{
					// 得到材质属性列表
					std::vector<D3DXATTRIBUTERANGE> attrTable;
					//为获取属性表中的元素个数，将函数GetAttributeTable的第一个参数设置为0
					DWORD numSubsets = 0;
					pMesh->GetAttributeTable(0, &numSubsets);

					//得到属性表中的元素个数后，可以用属性数据来填充D3DXATTRIBUTERANGE类型的结构体
					attrTable.resize(numSubsets);
					pMesh->GetAttributeTable(attrTable.data(), &numSubsets);

					// 检查是否为32bits顶点索引缓冲
					use32BitIndices = pMesh->GetOptions() & D3DXMESH_32BIT;

					// 遍历属性表, 同时遍历submesh, 根据matID == attrID, 将index buffer写入
					for (auto& attr : attrTable)
					{
						for (auto& subMesh : mesh.subMeshes)
						{
							if (subMesh->matID == attr.AttribId)
							{
								// 顶点数量
								DWORD numIndices = attr.FaceCount * 3;

								// 如果D3DXMesh存的是32bits index buffer
								if (use32BitIndices)
								{
									unsigned int* uiData = reinterpret_cast<unsigned int*>(pData);
									// 先取出数据
									std::vector<unsigned int> indices32(numIndices);
									memcpy(indices32.data(), uiData + attr.FaceStart * 3, numIndices * sizeof(unsigned int));
									// 判断顶点索引里是否有大于65535的数值
									subMesh->indexBuffer.use32BitIndices = 
										std::any_of(indices32.begin(), indices32.end(), std::bind2nd(std::greater<unsigned int>(), 65535));

									if (subMesh->indexBuffer.use32BitIndices)
									{
										// 直接memcpy复制
										subMesh->indexBuffer.uiIndexBuffer.resize(numIndices);
										memcpy(subMesh->indexBuffer.uiIndexBuffer.data(), 
											uiData + attr.FaceStart * 3,
											numIndices * sizeof(unsigned int));
									}
									else
									{
										// submesh是16bits index buffer, 强制转换后依次填入
										subMesh->indexBuffer.usIndexBuffer.resize(numIndices);
										for (DWORD idx = 0; idx < numIndices; ++idx)
											subMesh->indexBuffer.usIndexBuffer[idx] = static_cast<unsigned short>(uiData[attr.FaceStart * 3 + idx]);
									}
								}
								else
								{
									subMesh->indexBuffer.use32BitIndices = numIndices > 65535;
									// 直接memcpy复制
									unsigned short* usData = reinterpret_cast<unsigned short*>(pData);
									{
										subMesh->indexBuffer.usIndexBuffer.resize(numIndices);
										memcpy(subMesh->indexBuffer.usIndexBuffer.data(), 
											usData + attr.FaceStart * 3,
											numIndices * sizeof(unsigned short));
									}
								}
								break;
							}
						}
					}

					pMesh->UnlockIndexBuffer();
				}

				{
					D3DVERTEXELEMENT9 szDecl[MAX_FVF_DECL_SIZE] = {0};
					pMesh->GetDeclaration(szDecl);
					UINT decLength = D3DXGetDeclLength(szDecl);
					UINT vertexSize = D3DXGetDeclVertexSize(szDecl, 0);

					// 取出Vertex Buffer
					DWORD dwVertices = pMesh->GetNumVertices();
					geometry->vertexBuffer.resize(dwVertices);

					if (SUCCEEDED(pMesh->LockVertexBuffer(D3DLOCK_READONLY | D3DLOCK_DISCARD, &pData)))
					{
						for (DWORD n = 0; n < dwVertices; ++n)
						{
							oiram::Vertex& vertex = geometry->vertexBuffer[n];
							vertex.vec2Texcoords.clear();
							unsigned char* pointer = static_cast<unsigned char*>(pData) + vertexSize * n;

							for (auto& decl : szDecl)
							{
								switch (decl.Usage)
								{
								case D3DDECLUSAGE_POSITION:
									memcpy(&vertex.vec3Position, pointer + decl.Offset, sizeof(oiram::vec3));
									break;

								case D3DDECLUSAGE_NORMAL:
									memcpy(&vertex.vec3Normal, pointer + decl.Offset, sizeof(oiram::vec3));
									break;

								case D3DDECLUSAGE_COLOR:
									memcpy(&vertex.diffuse, pointer + decl.Offset, sizeof(unsigned long));
									break;

								case D3DDECLUSAGE_TEXCOORD:
									{
										oiram::vec2 texcoord;
										memcpy(&texcoord, pointer + decl.Offset, sizeof(oiram::vec2));
										vertex.vec2Texcoords.push_back(texcoord);
									}
									break;

								case D3DDECLUSAGE_TANGENT:
									memcpy(&vertex.vec4Tangent, pointer + decl.Offset, sizeof(oiram::vec4));
									break;

								case D3DDECLUSAGE_BINORMAL:
									memcpy(&vertex.vec3Binormal, pointer + decl.Offset, sizeof(oiram::vec3));
									break;

								case D3DDECLUSAGE_BLENDWEIGHT:
									memcpy(&vertex.vec4BlendWeight, pointer + decl.Offset, sizeof(oiram::vec4));
									break;

								case D3DDECLUSAGE_BLENDINDICES:
									memcpy(&vertex.blendIndex, pointer + decl.Offset, sizeof(unsigned long));
									break;

								case D3DDECLUSAGE_PSIZE:
									memcpy(&vertex.animationIndex, pointer + decl.Offset, sizeof(unsigned long));
									break;

								default:
									break;
								}
							}
						}
						pMesh->UnlockVertexBuffer();
					}
				}
				pMesh->Release();
			}

			// 顶点动画数据处理
			if (mesh.hasMorph)
			{
				// 得到顶点优化后的动画索引
				size_t vertexCount = geometry->vertexBuffer.size();
				std::vector<unsigned long> morphVertexIndices(vertexCount);
				for (size_t n = 0; n < vertexCount; ++n)
				{
					oiram::Vertex& vertex = geometry->vertexBuffer[n];
					morphVertexIndices[n] = vertex.animationIndex;
				}

				// 更新顶点动画关键帧中的信息
				for (auto& element : geometry->morphAnimationTrack)
				{
					auto& morphKeyFrame = element.second;
					auto morphKeyFrameCopy = morphKeyFrame;
					morphKeyFrame.clear();

					for (size_t n = 0; n < vertexCount; ++n)
						morphKeyFrame.push_back(morphKeyFrameCopy[morphVertexIndices[n]]);
				}
			}
		}
	}

	// 根据材质对subMesh排序
	std::sort(mesh.subMeshes.begin(), mesh.subMeshes.end(),
		[](const oiram::SubMeshContainer::value_type& a, const oiram::SubMeshContainer::value_type& b){
			return a->materialName > b->materialName; });
}


void Optimizer::
vertexCompression(oiram::Mesh& mesh, SceneNode* sceneNode)
{
	// 非固定管线默认使用顶点压缩
	if (config.renderingType != RT_FixedFunction)
	{
		// 遍历所有geometry
		std::set<oiram::Geometry> geometrySet;
		if (mesh.sharedGeometry)
			geometrySet.insert(mesh.sharedGeometry);
		for (auto& subMesh : mesh.subMeshes)
			geometrySet.insert(subMesh->geometry);

		// 计算position的范围
		oiram::vec3 posCenter = mesh.vertexBoundingBox.center(),
					posExtent = mesh.vertexBoundingBox.halfSize();

		// 计算UV的范围
		oiram::vec2 uvCenter = mesh.uvBoundingBox.center(),
					uvExtent = mesh.uvBoundingBox.halfSize();

		sceneNode->positionCenterX = posCenter.x;
		sceneNode->positionCenterY = posCenter.y;
		sceneNode->positionCenterZ = posCenter.z;

		sceneNode->positionExtentX = posExtent.x;
		sceneNode->positionExtentY = posExtent.y;
		sceneNode->positionExtentZ = posExtent.z;

		sceneNode->uvCenterU = uvCenter.x;
		sceneNode->uvCenterV = uvCenter.y;
		sceneNode->uvExtentU = uvExtent.x;
		sceneNode->uvExtentV = uvExtent.y;

		// UV的最小/最大值
		oiram::vec2	uvMin(std::numeric_limits<float>::max(), std::numeric_limits<float>::max()), uvMax(0.0f, 0.0f);

		for (auto& geometry : geometrySet)
		{
			auto vertexDeclaration = geometry->vertexDeclaration;
			
			// 顶点数据压缩
			for (auto& vertex : geometry->vertexBuffer)
			{
				if (vertexDeclaration & oiram::Ves_Position)
				{
					oiram::vec4 norm((vertex.vec3Position.x - posCenter.x) / posExtent.x,
									 (vertex.vec3Position.y - posCenter.y) / posExtent.y,
									 (vertex.vec3Position.z - posCenter.z) / posExtent.z,
									 1.0f);
					vertex.short4Position = oiram::short4(norm);
				}

				if (vertexDeclaration & oiram::Ves_Normal)
					vertex.ubyte4Normal = oiram::ubyte4(vertex.vec3Normal, true);

				if (vertexDeclaration & oiram::Ves_Tangent)
					vertex.ubyte4Tangent = oiram::ubyte4(vertex.vec4Tangent, true);

				if (vertexDeclaration & oiram::Ves_Binormal)
					vertex.ubyte4Binormal = oiram::ubyte4(vertex.vec3Binormal, true);

				if (vertexDeclaration & oiram::Ves_Blend_Weights)
					vertex.ubyte4BlendWeight = oiram::ubyte4(vertex.vec4BlendWeight, false);

				// 归一化UV
				oiram::vec2	norm0, norm1;
				if (vertexDeclaration & oiram::Ves_Texture_Coordinate0)
				{
					sceneNode->hasUV = true;
					auto& uv = vertex.vec2Texcoords[0];
					norm0.x = (uv.x - uvCenter.x) / uvExtent.x;
					norm0.y = (uv.y - uvCenter.y) / uvExtent.y;
				}
				if (vertexDeclaration & oiram::Ves_Texture_Coordinate1)
				{
					auto& uv = vertex.vec2Texcoords[1];
					norm1.x = (uv.x - uvCenter.x) / uvExtent.x;
					norm1.y = (uv.y - uvCenter.y) / uvExtent.y;
				}

				// 记录压缩UV
				if (geometry->material->packedTexcoords)
				{
					vertex.short4Texcoord = oiram::short4(norm0, norm1);
				}
				else
				{
					vertex.short2Texcoords.resize(vertex.vec2Texcoords.size());
					if (vertexDeclaration & oiram::Ves_Texture_Coordinate0)
					{
						vertex.short2Texcoords[0] = oiram::short2(norm0);
					}
					if (vertexDeclaration & oiram::Ves_Texture_Coordinate1)
						vertex.short2Texcoords[1] = oiram::short2(norm1);
				}
			}

			// 压缩变形动画
			for (auto& morph : geometry->morphAnimationTrack)
			{
				for (auto& morphVertex : morph.second)
				{
					oiram::vec4 norm((morphVertex.vec3Position.x - posCenter.x) / posExtent.x,
									 (morphVertex.vec3Position.y - posCenter.y) / posExtent.y,
									 (morphVertex.vec3Position.z - posCenter.z) / posExtent.z,
									 1.0f);
					morphVertex.short4Position = oiram::short4(norm);

					morphVertex.ubyte4Normal = oiram::ubyte4(morphVertex.vec3Normal, true);
				}
			}
		}
	}
}
