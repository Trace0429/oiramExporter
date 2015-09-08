#include "stdafx.h"
#include "Exporter.h"
#include <modstack.h>
#include <CS/Phyexp.h>
#include <CS/bipexp.h>
#include <iskin.h>
#include <IGame/IGame.h>
#include <tchar.h>
#include "Analyzer.h"
#include "Serializer.h"
#include "LogManager.h"
#include "DotSceneExport.h"
#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include "strutil.h"
#include "requisites.h"
#include "Optimizer.h"

Exporter::
Exporter(oiram::Serializer* serializer)
:	mSerializer(serializer), mAnalyzer(new Analyzer)
{
	// 精度
	const float maxPrecision = MAX_PRECISION - config.optimizationEpsilon + 1.0f;
	float epsilon = std::min(0.01f, powf(0.1f * maxPrecision, static_cast<float>(config.optimizationEpsilon)));
	Optimizer::getSingleton().setEpsilon(epsilon);
}


Exporter::
~Exporter()
{
	delete mAnalyzer;
}


bool Exporter::
Export(bool exportSelected)
{
	// 以max文件名称为输出目录, 如果目录已存在则改名后缀加上当前时间
	if (_access(config.exportPath.c_str(), 0) != -1)
	{
		auto oldname = config.exportPath;
		oldname.pop_back();
		time_t tm;
		time(&tm);
		auto newname = oldname + '_' + std::to_string(tm);
		rename(oldname.c_str(), newname.c_str());
	}
	CreateDirectory(Ansi2Mstr(config.exportPath), NULL);

	// 初始化
	IGameScene* gameScene = GetIGameInterface();
	GetConversionManager()->SetCoordSystem(IGameConversionManager::IGAME_OGL);
	bool result = gameScene->InitialiseIGame(exportSelected);
	assert(result);

	// 得到所有节点
	int nodeCount = gameScene->GetTopLevelNodeCount();
	for (int nodeIdx = 0; nodeIdx < nodeCount; ++nodeIdx)
	{
		IGameNode* node = gameScene->GetTopLevelNode(nodeIdx);
		dumpNodes(node);
	}

	// 保证每次随机数是一样的(目的是让随后的唯一随机字符串每次输出都是一样的)
	srand(4172485);

	// 清空
	UniqueNameGenerator::getSingleton().clear();
	// 是否自动添加前缀
	if (config.prependRenaming)
		UniqueNameGenerator::getSingleton().setPrependName(config.maxName);

	// 收集所有节点的信息
	NodeContainer meshNodes, physxNodes, tagNodes;
	for (auto& sceneNodeItor : mSceneNodeMap)
	{
		IGameNode* gameNode = sceneNodeItor.first;
		SceneNode& sceneNode = sceneNodeItor.second;

		// 自定义属性
		processNodeUserDefinedProperties(gameNode, sceneNode);

		// max允许node重名, 而这里保证名称唯一. 是否需要唯一的名称, 默认为true
		auto uniqueItor = sceneNode.userDefinedPropertyMap.find("unique");
		bool useUniqueName = !(uniqueItor != sceneNode.userDefinedPropertyMap.end() && uniqueItor->second == "false");
		std::string gameNodeName = Mchar2Ansi(gameNode->GetName());
		if (useUniqueName)
			gameNodeName = UniqueNameGenerator::getSingleton().generate(gameNodeName, "node", true, true);

		if (mSceneNodeNameSet.count(gameNodeName))
			LogManager::getSingleton().logMessage(true, "Scene node name has been exists: \"%s\".", gameNodeName.c_str());
		else
			mSceneNodeNameSet.insert(gameNodeName);

		// 初始化
		INode* maxNode = gameNode->GetMaxNode();
		sceneNode.name = sceneNode.meshName = gameNodeName;
		sceneNode.nodeReference = &sceneNode;
		sceneNode.hasUV = false;
		sceneNode.hasSkeleton = isNodeSkinned(maxNode);
		sceneNode.hasMorph = isNodeMorphed(maxNode);

		// 判断是否是引用的另外的几何体
		Object* objectRef = maxNode->GetObjOrWSMRef();
		auto result = mSceneNodeInstanceMap.insert(std::make_pair(objectRef, &sceneNode));
		if (!result.second)
		{
			// 节点引用
			sceneNode.nodeReference = result.first->second;

			// 设置为引用的几何体的mesh名称
			sceneNode.meshName = sceneNode.nodeReference->meshName;
			
			// 如果引用的几何体的材质与当前几何体材质相同, 则将材质名称清空以标注不需要更换材质
			if (sceneNode.nodeReference->materialFileName == sceneNode.materialFileName)
				sceneNode.materialFileName.clear();
			else
			{
				// 保存材质名称
				IGameMaterial* gameMaterial = gameNode->GetNodeMaterial();
				if (gameMaterial)
				{
					sceneNode.materialFileName = Mchar2Ansi(gameMaterial->GetMaterialName());
					strLegalityCheck(sceneNode.materialFileName);
				}
			}
		}

		// 动画信息
		processAnimation(sceneNode);

		// 收集MESH
		if (sceneNode.type == SceneNodeType::Geometry)
			meshNodes.push_back(gameNode);

		// 收集PhysX
		if (sceneNode.type == SceneNodeType::PhysX)
			physxNodes.push_back(gameNode);

		// 收集TAG HELPER(因为dumpNodes保证了其父节点肯定已经处理过了, 所以这里可以写在此循环里)
		if (sceneNode.type == SceneNodeType::Helper)
		{
			IGameNode* rootNode = Analyzer::getRootNode(gameNode);
			if (rootNode)
			{
				// 父节点是骨骼, 并且自定义属性中标注tag = true则认为是挂载点
				assert(mSceneNodeMap.count(gameNode));
				const SceneNode& sceneNode = mSceneNodeMap[gameNode];
				if (sceneNode.type == SceneNodeType::Bone)
				{
					auto tagItor = sceneNode.userDefinedPropertyMap.find("tag");
					if (tagItor != sceneNode.userDefinedPropertyMap.end() &&
						tagItor->second == "true")
					{
						tagNodes.push_back(gameNode);
					}
				}
			}
		}
	}

	// 处理material
	LogManager::getSingleton().logMessage(false, "Exporting materials...");
	for (auto& gameNode : meshNodes)
	{
		IGameMaterial* gameRootMaterial = gameNode->GetNodeMaterial();
		if (gameRootMaterial != nullptr)
		{
			auto rootMaterialName = UniqueNameGenerator::getSingleton().generate(Mchar2Ansi(gameRootMaterial->GetMaterialName()), "rootMaterial", true, true);
			mAnalyzer->processMaterial(gameRootMaterial, rootMaterialName);
		}
		else
		{
			LogManager::getSingleton().logMessage(true, "Node material is null: \"%s\" .", gameNode->GetName());
		}
	}

	LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");

	// 处理tag
	for (auto& gameNode : tagNodes)
		mAnalyzer->processTag(gameNode);

	// 处理mesh
	LogManager::getSingleton().logMessage(false, "Exporting geometries...");

	for (auto& gameNode : meshNodes)
	{
		assert(mSceneNodeMap.count(gameNode));
		SceneNode* sceneNode = &mSceneNodeMap[gameNode];

		// 引用的节点与实际节点是否相同, 多个引用的mesh只需要处理一次
		if (sceneNode->nodeReference == sceneNode)
		{
			// 分析
			mAnalyzer->processGeometry(gameNode, mSceneNodeMap);

			// 顶点缝合、VertexCache、材质排序
			Optimizer::getSingleton().optimizeMesh(mAnalyzer->mMesh);

			// 顶点数据压缩
			Optimizer::getSingleton().vertexCompression(mAnalyzer->mMesh, sceneNode);

			// 写入磁盘
			mSerializer->exportMesh(mAnalyzer->mMesh, sceneNode->animationDescs);
		}
		else
		{
			// 复制范围信息
			sceneNode->positionCenterX = sceneNode->nodeReference->positionCenterX;
			sceneNode->positionCenterY = sceneNode->nodeReference->positionCenterY;
			sceneNode->positionCenterZ = sceneNode->nodeReference->positionCenterZ;
			sceneNode->positionExtentX = sceneNode->nodeReference->positionExtentX;
			sceneNode->positionExtentY = sceneNode->nodeReference->positionExtentY;
			sceneNode->positionExtentZ = sceneNode->nodeReference->positionExtentZ;

			sceneNode->hasUV = sceneNode->nodeReference->hasUV;
			sceneNode->uvCenterU = sceneNode->nodeReference->uvCenterU;
			sceneNode->uvCenterV = sceneNode->nodeReference->uvCenterV;
			sceneNode->uvExtentU = sceneNode->nodeReference->uvExtentU;
			sceneNode->uvExtentV = sceneNode->nodeReference->uvExtentV;
		}
	}

	LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");

	// 导出纹理
	LogManager::getSingleton().logMessage(false, "Exporting textures...");
	mAnalyzer->exportTextures();

	// 导出材质
	mSerializer->exportMaterial(mAnalyzer->mMaterials);

	LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");

	// 处理skeleton
	if (!mAnalyzer->mSkeletonMap.empty())
	{
		LogManager::getSingleton().logMessage(false, "Exporting skeletons...");

		mAnalyzer->processSkeleton(mSceneNodeMap);

		// 导出skeleton
		for (auto& skeletonElement : mAnalyzer->mSkeletonMap)
		{
			IGameNode* rootNode = static_cast<IGameNode*>(skeletonElement.first);
			auto& skeleton = skeletonElement.second;

			AnimationDesc animDescs;
			auto sceneNodeItor = mSceneNodeMap.find(rootNode);
			if (sceneNodeItor != mSceneNodeMap.end())
				animDescs = sceneNodeItor->second.animationDescs;
			mSerializer->exportSkeleton(*skeleton, animDescs);
		}

		LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");
	}

	if ((config.exportObject & EO_PhysX) &&
		!physxNodes.empty())
	{
		LogManager::getSingleton().logMessage(false, "Exporting PhysX...");

		for (auto& gameNode : physxNodes)
		{
			assert(mSceneNodeMap.count(gameNode));
			SceneNode* sceneNode = &mSceneNodeMap[gameNode];

			// 检查physx自定义属性
			auto physxItor = sceneNode->userDefinedPropertyMap.find("physx");
			if (physxItor != sceneNode->userDefinedPropertyMap.end())
			{
				int physxFlag = std::stoi(physxItor->second);
				Optimizer::getSingleton().dumpPhysXCookMesh(gameNode, sceneNode->name, physxFlag);
			}
		}

		LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");
	}


	// 输出场景.scene文件
	if (config.exportObject & EO_Scene)
	{
		LogManager::getSingleton().logMessage(false, "Exporting scene: %s.scene", config.maxName.c_str());

		auto dotSceneFileName = config.exportPath + config.maxName + ".scene";
		dotSceneExport mDotSceneExport(dotSceneFileName, mSceneNodeMap);

		LogManager::getSingleton().logMessage(false, "---------------------------------------------------------");
	}

	// 打包
	if (config.package)
		mSerializer->exportPackage(config.exportPath, config.prependRenaming ? config.maxName + "_" + config.maxName : config.maxName);

	// 释放资源
	gameScene->ReleaseIGame();

	return true;
}


SceneNodeType Exporter::
getSceneNodeType(INode* node)
{
	auto name = node->GetName();
	ObjectState os = node->EvalWorldState(0);
	if (os.obj)
	{
		SClass_ID scid = os.obj->SuperClassID();
		switch (scid)
		{
		case CAMERA_CLASS_ID:
			return SceneNodeType::Camera;

		case LIGHT_CLASS_ID:
			return SceneNodeType::Light;

		case HELPER_CLASS_ID:
			return SceneNodeType::Helper;

		case SPLINESHAPE_CLASS_ID:
			return SceneNodeType::Spline;

		case GEOMOBJECT_CLASS_ID:
			if (node->IsTarget())
				return SceneNodeType::Target;
			else
			{
				auto classid = os.obj->ClassID();
				if (classid == BONE_OBJ_CLASSID)
					return SceneNodeType::Bone;
				else
				{
					Control* ctrl = node->GetTMController();
					if (ctrl)
					{
						Class_ID cid = ctrl->ClassID();
						if (cid == BIPSLAVE_CONTROL_CLASS_ID ||
							cid == BIPBODY_CONTROL_CLASS_ID)
							return SceneNodeType::Bone;
					}

					if (os.obj->CanConvertToType(Class_ID(TRIOBJ_CLASS_ID, 0)))
					{
						SceneNodeType type = SceneNodeType::UnSupported;
						TriObject* tri = (TriObject *)os.obj->ConvertToType(0, Class_ID(TRIOBJ_CLASS_ID, 0));
						int numFaces = tri->mesh.numFaces;
						// 忽略没有顶点的对象
						if (numFaces > 0)
						{
							// 检查自定义属性里是否有physx
							MSTR mstr;
							node->GetUserPropBuffer(mstr);
							std::string str = Mstr2Ansi(mstr);
							if (str.find("physx") != std::string::npos)
							{
								type = SceneNodeType::PhysX;
							}
							else
							{
								// 空材质的物体将被认为是没有意义的, 而且不会被导出
								Mtl* mtl = node->GetMtl();
								if (mtl)
								{
									Class_ID classID = mtl->ClassID();
									if (classID == Class_ID(DMTL_CLASS_ID, 0))
									{
										type = SceneNodeType::Geometry;
									}
									else
									if (classID == Class_ID(BAKE_SHELL_CLASS_ID, 0))
									{
										type = SceneNodeType::Geometry;
									}
									else
									if (classID == Class_ID(MULTI_CLASS_ID, 0) && mtl->IsMultiMtl())
									{
										std::set<int> matIDs;
										for (int i = 0; i < numFaces; ++i)
											matIDs.insert(tri->mesh.faces[i].getMatID());
										for (auto matID : matIDs)
										{
											Mtl* subMtl = mtl->GetSubMtl(matID);
											if (subMtl)
											{
												type = SceneNodeType::Geometry;
												break;
											}
										}
									}
								}								
							}
						}

						if (tri != os.obj)
							tri->DeleteMe();

						return type;
					}
				}
			}
			break;
		}
	}

	return SceneNodeType::UnSupported;
}
	
	
bool Exporter::
isNodeSkinned(INode* node)
{
	Object *pObj = node->GetObjectRef();
	if (pObj)
	{
		// Is it a derived object?   
		while (pObj->SuperClassID() == GEN_DERIVOB_CLASS_ID)
		{
			// Yes -> Cast
			IDerivedObject *pDerivedObj = static_cast<IDerivedObject*>(pObj);

			// Iterate over all entries of the modifier stack
			int ModStackIndex = 0;
			while (ModStackIndex < pDerivedObj->NumModifiers())
			{
				// Get current modifier
				Modifier* pMod = pDerivedObj->GetModifier(ModStackIndex);

				// 即使修改器堆栈里有Physique或者Skin, 也需要进一步确保有蒙皮信息
				Class_ID classID = pMod->ClassID();
				if (classID == Class_ID(PHYSIQUE_CLASS_ID_A, PHYSIQUE_CLASS_ID_B))
				{
					bool isSkinned = false;
					IPhysiqueExport* pPhysique = (IPhysiqueExport *)pMod->GetInterface(I_PHYINTERFACE);
					if (pPhysique)
					{
						IPhyContextExport* pPhysiqueContext = (IPhyContextExport *)pPhysique->GetContextInterface(node);
						if (pPhysiqueContext)
						{
							int numVertices = pPhysiqueContext->GetNumberVertices();
							isSkinned = numVertices > 0;

							pPhysique->ReleaseContextInterface(pPhysiqueContext);
						}
						pMod->ReleaseInterface(I_PHYINTERFACE, pPhysique);
					}

					return isSkinned;
				}
				else if (classID == SKIN_CLASSID)
				{
					bool isSkinned = false;
					ISkin* pSkin = (ISkin*)pMod->GetInterface(I_SKIN);
					if (pSkin)
					{
						ISkinContextData* pSkinContext = pSkin->GetContextInterface(node);
						if (pSkinContext)
						{
							int numAssignedBones = pSkinContext->GetNumAssignedBones(0);
							isSkinned = numAssignedBones > 0;
						}
						pMod->ReleaseInterface(I_SKIN, pSkin);
					}

					return isSkinned;
				}

				// Next modifier stack entry
				ModStackIndex++;
			}
			pObj = pDerivedObj->GetObjRef();
		}
	}

	return false;
}


bool Exporter::
isNodeMorphed(Animatable* node)
{
	SClass_ID sid = node->SuperClassID();
	if (node->IsAnimated() && (sid == CTRL_MORPH_CLASS_ID))
		return true;

	return false;
}


bool Exporter::
isNodeHidden(IGameNode* gameNode)
{
	bool isHidden = gameNode->IsNodeHidden();
	// 如果节点是隐藏的, 同时有子节点, 只要任何一个子节点是非隐藏状态, 那么该节点就必须要导出, 类型改为helper
	if (isHidden)
	{
		int count = gameNode->GetChildCount();
		for (int n = 0; n < count; ++n)
		{
			IGameNode* childNode = gameNode->GetNodeChild(n);
			if (!isNodeHidden(childNode))
			{
				isHidden = false;
				break;
			}
		}
	}

	return isHidden;
}


void Exporter::
dumpNodes(IGameNode* gameNode)
{
	// 忽略隐藏的节点
	bool isHidden = isNodeHidden(gameNode);
	if (!isHidden)
	{
		auto type = getSceneNodeType(gameNode->GetMaxNode());
		bool exportObject = false;
		switch (type)
		{
		case SceneNodeType::Geometry:
			exportObject = (config.exportObject & EO_Geometry) ? true : false;
			break;

		case SceneNodeType::Light:
			exportObject = (config.exportObject & EO_Light) ? true : false;
			break;

		case SceneNodeType::Camera:
			exportObject = (config.exportObject & EO_Camera) ? true : false;
			break;

		case SceneNodeType::Bone:
			exportObject = true;
			break;

		case SceneNodeType::Helper:
			exportObject = (config.exportObject & EO_Helper) ? true : false;
			break;

		case SceneNodeType::Spline:
			exportObject = (config.exportObject & EO_Spline) ? true : false;
			break;

		case SceneNodeType::Target:
			exportObject = (config.exportObject & EO_Target) ? true : false;
			break;

		case SceneNodeType::Apex:
		case SceneNodeType::PhysX:
		case SceneNodeType::UnSupported:
			exportObject = true;
			break;
		}

		// 不导出就直接认为是隐藏节点
		if (exportObject)
		{
			SceneNode& sceneNode = mSceneNodeMap[gameNode];
			sceneNode.type = type;
		}

		// 递归处理所有子节点
		int count = gameNode->GetChildCount();
		for (int n = 0; n < count; ++n)
		{
			IGameNode* childNode = gameNode->GetNodeChild(n);
			dumpNodes(childNode);
		}
	}
}


void Exporter::
processNodeUserDefinedProperties(IGameNode* gameNode, SceneNode& sceneNode)
{
	// 得到全部的自定义属性
	MSTR str;
	gameNode->GetMaxNode()->GetUserPropBuffer(str);
	std::string userPropBuffer = Mstr2Ansi(str);
	if (!userPropBuffer.empty())
	{
		// 自行解析, 以\n为分隔符拆分出各个属性
		std::vector<std::string> properties = str::explode("\n", userPropBuffer);
		for (size_t n = 0; n < properties.size(); ++n)
		{
			// 以=为分隔符取出key和value
			std::string& line = properties[n];
			std::vector<std::string> prop = str::explode("=", line);
			if (prop.size() > 1)
			{
				std::string propKey = str::trim(prop[0]);
				std::string propValue = str::trim(prop[1]);
				sceneNode.userDefinedPropertyMap.insert(std::make_pair(propKey, propValue));
			}
		}
	}

// max2011之后内置了PhysX, 而PhysX总是默认给每一个节点加上"LastPose=undefined"的自定义属性, 这里判断并将其去掉
#if defined(MAX_RELEASE_R13_ALPHA) && MAX_RELEASE >= MAX_RELEASE_R13_ALPHA
	auto LastPoseItor = sceneNode.userDefinedPropertyMap.find("LastPose");
	if (LastPoseItor != sceneNode.userDefinedPropertyMap.end() &&
		LastPoseItor->second == "undefined")
	{
		sceneNode.userDefinedPropertyMap.erase(LastPoseItor);
	}
#endif
}


void Exporter::
processAnimation(SceneNode& sceneNode)
{
	auto range = sceneNode.userDefinedPropertyMap.equal_range("anim");
	for (auto itor = range.first; itor != range.second; ++itor)
	{
		std::string str = itor->second;
		auto descs = str::explode(",", str);
		if (descs.size() == 3)
		{
			Animation anim = {
				descs[0],
				std::stoi(descs[1]),
				std::stoi(descs[2])};
			sceneNode.animationDescs.push_back(anim);
		}
	}

	if (sceneNode.animationDescs.empty() &&
		(sceneNode.hasMorph || sceneNode.hasSkeleton))
	{
		Animation anim = {
			"_auto_",
			GetIGameInterface()->GetSceneStartTime() / GetIGameInterface()->GetSceneTicks(),
			GetIGameInterface()->GetSceneEndTime() / GetIGameInterface()->GetSceneTicks() };
		sceneNode.animationDescs.push_back(anim);
	}
}
