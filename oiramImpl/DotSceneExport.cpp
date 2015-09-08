#include "stdafx.h"
#include "DotSceneExport.h"
#include <gencam.h>
#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include "strutil.h"
#include "LogManager.h"
#include "fogatmos.h"
#include "requisites.h"
#include "type.h"
#include "serializer.h"
#include "Optimizer.h"
#include <strutil.h>
using namespace rapidxml;

// 有时浮点数很小会以2.05188e-015形式表示, 将过小的数字直接认为0
void Point3Verify(float* v)
{
	using namespace oiram;
	if (fzero(v[0]))
		v[0] = 0.0f;
	if (fzero(v[1]))
		v[1] = 0.0f;
	if (fzero(v[2]))
		v[2] = 0.0f;
}

void QuatVerify(float* v)
{
	using namespace oiram;
	if (fzero(v[0]))
		v[0] = 0.0f;
	if (fzero(v[1]))
		v[1] = 0.0f;
	if (fzero(v[2]))
		v[2] = 0.0f;
	if (fzero(v[3]))
		v[3] = 0.0f;
}


dotSceneExport::
dotSceneExport(const std::string& dotSceneFileName, const SceneNodeMap& sceneNodeMap)
:	mSceneNodeMap(sceneNodeMap)
{
	xml_document<> doc;
	
	auto decl = doc.allocate_node(rapidxml::node_declaration);
    decl->append_attribute(doc.allocate_attribute("version", "1.0"));
	decl->append_attribute(doc.allocate_attribute("encoding", config.dotSceneUTF8 ? "UTF-8" : "us-ascii"));
    doc.append_node(decl);

	auto scene = doc.allocate_node(node_element, "scene");
	doc.append_node(scene);
	{
		// 版本
		auto formatVersion = doc.allocate_attribute("formatVersion", "1.0.5");
		scene->append_attribute(formatVersion);
		auto author = doc.allocate_attribute("generator", "oiramExporter");
		scene->append_attribute(author);

		// 环境参数
		auto environment = doc.allocate_node(node_element, "environment");
		{
			Interface* coreInterface = GetCOREInterface();

			// 环境光
			auto colourAmbient = doc.allocate_node(node_element, "colourAmbient");
			environment->append_node(colourAmbient);
			{
				Point3 ambient = coreInterface->GetAmbient(0, FOREVER);
				auto r = doc.allocate_attribute("r", doc.allocate_string(std::to_string(ambient.x).c_str()));
				auto g = doc.allocate_attribute("g", doc.allocate_string(std::to_string(ambient.y).c_str()));
				auto b = doc.allocate_attribute("b", doc.allocate_string(std::to_string(ambient.z).c_str()));
				colourAmbient->append_attribute(r);
				colourAmbient->append_attribute(g);
				colourAmbient->append_attribute(b);
			}

			// 查找雾效
			int numAtmospheric = coreInterface->NumAtmospheric();
			for (int n = 0; n < numAtmospheric; ++n)
			{
				Atmospheric* atmospheric = coreInterface->GetAtmospheric(n);
				if (atmospheric->ClassID() == fogClassID)
				{
					FogAtmos* fogAtmos = static_cast<FogAtmos*>(atmospheric);
					if (fogAtmos->GetType() == 0) // 0:Standard, 1:Layered
					{
						auto fog = doc.allocate_node(node_element, "fog");
						environment->append_node(fog);
						{
							float fogDensity = fogAtmos->GetDensity(0) * 0.01f;
							bool fogLinear = fogAtmos->pblock->GetInt(PB_EXP) ? false : true;
							auto density	= doc.allocate_attribute("density", doc.allocate_string(std::to_string(fogDensity).c_str()));
							auto start		= doc.allocate_attribute("start", doc.allocate_string(std::to_string(fogAtmos->GetNear(0)).c_str()));
							auto end		= doc.allocate_attribute("end", doc.allocate_string(std::to_string(fogAtmos->GetFar(0)).c_str()));
							auto mode		= doc.allocate_attribute("mode", doc.allocate_string(fogLinear ? "linear" : "exp"));
							fog->append_attribute(density);
							fog->append_attribute(start);
							fog->append_attribute(end);
							fog->append_attribute(mode);
							{
								auto colour = doc.allocate_node(node_element, "colour");
								fog->append_node(colour);
								Color color = fogAtmos->GetColor(0);
								auto r = doc.allocate_attribute("r", doc.allocate_string(std::to_string(color.r).c_str()));
								auto g = doc.allocate_attribute("g", doc.allocate_string(std::to_string(color.g).c_str()));
								auto b = doc.allocate_attribute("b", doc.allocate_string(std::to_string(color.b).c_str()));
								colour->append_attribute(r);
								colour->append_attribute(g);
								colour->append_attribute(b);
							}
						}
						break;
					}
				}
			}
		}
		scene->append_node(environment);
	}

	auto nodes = doc.allocate_node(node_element, "nodes");
	scene->append_node(nodes);

	// 按照从上往下的层次顺序导出所有节点
	IGameScene* gameScene = GetIGameInterface();
	int nodeCount = gameScene->GetTopLevelNodeCount();
	for (int nodeIdx = 0; nodeIdx < nodeCount; ++nodeIdx)
	{
		LogManager::getSingleton().setProgress(static_cast<int>(100.0f * nodeIdx / nodeCount));
		IGameNode* node = gameScene->GetTopLevelNode(nodeIdx);
		dumpNodes(node, doc, scene, nodes, nodes);
	}

	std::string xml;
	print(std::back_inserter(xml), doc);

	// 写文件
	FILE* fp = fopen(dotSceneFileName.c_str(), "wt");
	if (fp)
	{
		// 转换为utf8编码
		if (config.dotSceneUTF8)
		{
			const char* str = xml.c_str();
			int len = MultiByteToWideChar(CP_ACP, 0, str, -1, NULL, 0);
			std::vector<wchar_t> unicode(len);
			MultiByteToWideChar(CP_ACP, 0, str, -1, unicode.data(), len);

			len = WideCharToMultiByte(CP_UTF8, 0, unicode.data(), -1, NULL, 0, NULL, NULL);
			std::vector<char> utf8(len);
			WideCharToMultiByte(CP_UTF8, 0, unicode.data(), -1, utf8.data(), len, NULL, NULL);

			// 去掉\0
			utf8.pop_back();
			fwrite(utf8.data(), utf8.size(), 1, fp);
		}
		else
		{
			fwrite(xml.c_str(), static_cast<size_t>(xml.length()), 1, fp);
		}

		fclose(fp);
	}
}


void dotSceneExport::
dumpNodes(IGameNode* gameNode, xml_document<>& doc, xml_node<>* scene, xml_node<>* nodes, xml_node<>* parent)
{
	xml_node<>* parent_node = parent;

	// 忽略没有必要导出的节点
	SceneNodeMap::const_iterator sceneNodeItor = mSceneNodeMap.find(gameNode);
	if (sceneNodeItor != mSceneNodeMap.end())
	{
		const SceneNode& sceneNode = sceneNodeItor->second;

		xml_node<>* node = nullptr;
		switch (sceneNode.type)
		{
		case SceneNodeType::Geometry:
			node = processNode(gameNode, sceneNode, doc, parent);
			break;

		case SceneNodeType::Camera:
			node = processCamera(gameNode, sceneNode, doc, scene);
			break;

		case SceneNodeType::Light:
			node = processLight(gameNode, sceneNode, doc, nodes);
			break;

		case SceneNodeType::Helper:
			node = processHelper(gameNode, sceneNode, doc, parent);
			break;

		case SceneNodeType::Spline:
			node = processSpline(gameNode, sceneNode, doc, parent);
			break;

		case SceneNodeType::PhysX:
			node = processNode(gameNode, sceneNode, doc, parent);
			break;

		default:
			//assert(0);
			break;
		}

		parent_node = node == nullptr ? nodes : node;

		// 递归处理所有子节点
		int count = gameNode->GetChildCount();
		for (int n = 0; n < count; ++n)
		{
			IGameNode* childGameNode = gameNode->GetNodeChild(n);
			dumpNodes(childGameNode, doc, scene, nodes, parent_node);
		}
	}
}


xml_node<>* dotSceneExport::
processNode(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent, const char* nodeName)
{
	auto node = doc.allocate_node(node_element, nodeName);
	parent->append_node(node);

	// 骨骼动画已经导出的是world space
	if (sceneNode.hasSkeleton)
	{
		auto name = doc.allocate_attribute("name", doc.allocate_string(sceneNode.name.c_str()));
		node->append_attribute(name);

		auto skeleton = doc.allocate_attribute("skeleton", doc.allocate_string("true"));
		node->append_attribute(skeleton);
	}
	// 导出节点transform信息
	else
	{
		processNodeTransform(gameNode, sceneNode, doc, node);
	}

	// 如果是mesh则加入entity/meshFile/materialFile属性
	if (sceneNode.type == SceneNodeType::Geometry)
	{
		auto entity = doc.allocate_node(node_element, "entity");
		node->append_node(entity);
		{
			auto mesh = doc.allocate_attribute("mesh", doc.allocate_string((sceneNode.meshName + ".mesh").c_str()));
			entity->append_attribute(mesh);

			// 是否引用了几何体
			if (sceneNode.nodeReference != &sceneNode &&
				// 是否需要更新材质
				!sceneNode.materialFileName.empty())
			{
				// 获取材质名称
				auto material = doc.allocate_attribute("material", doc.allocate_string((sceneNode.materialFileName + ".material").c_str()));
				entity->append_attribute(material);
			}

			// 非固定管线默认使用顶点压缩
			if (config.renderingType != RT_FixedFunction)
			{
				// position范围
				auto positionCenter = doc.allocate_node(node_element, "positionCenter");
				entity->append_node(positionCenter);
				{
					auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(sceneNode.positionCenterX).c_str()));
					auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(sceneNode.positionCenterY).c_str()));
					auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(sceneNode.positionCenterZ).c_str()));
					positionCenter->append_attribute(x);
					positionCenter->append_attribute(y);
					positionCenter->append_attribute(z);
				}

				auto positionExtent = doc.allocate_node(node_element, "positionExtent");
				entity->append_node(positionExtent);
				{
					auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(sceneNode.positionExtentX).c_str()));
					auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(sceneNode.positionExtentY).c_str()));
					auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(sceneNode.positionExtentZ).c_str()));
					positionExtent->append_attribute(x);
					positionExtent->append_attribute(y);
					positionExtent->append_attribute(z);
				}

				if (sceneNode.hasUV)
				{
					// UV的范围
					auto uvCenter = doc.allocate_node(node_element, "uvCenter");
					entity->append_node(uvCenter);
					{
						auto u = doc.allocate_attribute("u", doc.allocate_string(std::to_string(sceneNode.uvCenterU).c_str()));
						auto v = doc.allocate_attribute("v", doc.allocate_string(std::to_string(sceneNode.uvCenterV).c_str()));
						uvCenter->append_attribute(u);
						uvCenter->append_attribute(v);
					}

					auto uvExtent = doc.allocate_node(node_element, "uvExtent");
					entity->append_node(uvExtent);
					{
						auto u = doc.allocate_attribute("u", doc.allocate_string(std::to_string(sceneNode.uvExtentU).c_str()));
						auto v = doc.allocate_attribute("v", doc.allocate_string(std::to_string(sceneNode.uvExtentV).c_str()));
						uvExtent->append_attribute(u);
						uvExtent->append_attribute(v);
					}
				}
			}
		}
	}

	// 处理节点自定义属性
	processNodeUserDefinedProperties(sceneNode.userDefinedPropertyMap, doc, node);

	// 处理节点动画(target节点的动画为spline)
	processNodeTrack(gameNode, sceneNode, doc, node, !gameNode->IsTarget());

	// 处理节点的路径约束
	IGameControl* gc = gameNode->GetIGameControl();
	if (gc)
	{
		bool x = gc->IsAnimated(IGAME_POS);
		IGameControl::MaxControlType T = gc->GetControlType(IGAME_POS);
		if (T == IGameControl::IGAME_LIST)
		{
			int subNum = gc->GetNumOfListSubControls(IGAME_POS);
			for (int n = 0; n < subNum; ++n)
			{
				IGameControl* gcPosition = gc->GetListSubControl(n, IGAME_POS);
				IGameControl::MaxControlType T = gcPosition->GetControlType(IGAME_POS);

				if (T == IGameControl::IGAME_POS_CONSTRAINT)
				{
					IGameConstraint* gConstraint = gcPosition->GetConstraint(IGAME_POS);
					if (gConstraint->GetConstraintType() == IGameConstraint::IGAME_PATH)
					{
						int numConstraintNodes = gConstraint->NumberOfConstraintNodes();
						for (int i = 0; i < numConstraintNodes; ++i)
						{
							IGameNode* gameNode = gConstraint->GetConstraintNodes(i);
							std::string name = Mchar2Ansi(gameNode->GetName());
							float weight = gConstraint->GetConstraintWeight(i);
							int startFrame = gConstraint->GetLinkConstBeginFrame(i);
							Control* cPos = gcPosition->GetMaxControl(IGAME_POS);
							IPathPosition* pathPosition = static_cast<IPathPosition*>(cPos);
							BOOL follow = pathPosition->GetFollow();
							BOOL loop = pathPosition->GetLoop();
							int axis = pathPosition->GetAxis();

							IPathPosition* ipcp = static_cast<IPathPosition*>(pathPosition);
							int keys = ipcp->NumKeys();

							xml_attribute<>* constraint = doc.allocate_attribute("constraint", doc.allocate_string(name.c_str()));
							node->append_attribute(constraint);
							break;
						}
					}
					break;
				}
			}
		}
	}

	return node;
}


xml_node<>* dotSceneExport::
processHelper(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent)
{
	// 当辅助节点与场景有联系(有子节点, 有父节点或者有自定义属性), 才进行处理
	// 有子节点代表辅助节点的子节点可能链接着重要的信息, 这里没有确认是否子节点全是无效的空节点, 只是简单得判断了子节点的数目
	// 有自义属性代表记录着重要的信息
	if (parent != nullptr &&
		(gameNode->GetNodeParent() || 
		 gameNode->GetChildCount() > 0 ||
		 !sceneNode.userDefinedPropertyMap.empty()))
	{
		auto helper = doc.allocate_node(node_element, "node");
		parent->append_node(helper);

		// 处理节点transform信息
		processNodeTransform(gameNode, sceneNode, doc, helper);

		// 处理节点自定义属性
		processNodeUserDefinedProperties(sceneNode.userDefinedPropertyMap, doc, helper);

		// 处理节点动画
		processNodeTrack(gameNode, sceneNode, doc, helper, !gameNode->IsTarget());

		return helper;
	}

	return 0;
}

#define FOV_W 0
#define FOV_H 1
#define FOV_D 2

xml_node<>* dotSceneExport::
processCamera(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent)
{
	Object* object = gameNode->GetMaxNode()->GetObjectRef();
	if (object)
	{
		GenCamera* cameraObject = static_cast<GenCamera*>(object);
		struct CameraState cameraState;
		if (REF_SUCCEED == cameraObject->EvalCameraState(0, FOREVER, &cameraState))
		{
			auto camera = doc.allocate_node(node_element, "camera");
			parent->append_node(camera);

			processNodeTransform(gameNode, sceneNode, doc, camera);
	
			auto projectionType = doc.allocate_attribute("projectionType", cameraState.isOrtho ? "orthographic" : "perspective");
			camera->append_attribute(projectionType);

			float aspect = GetCOREInterface()->GetRendImageAspect();
			auto aspectRatio = doc.allocate_attribute("aspectRatio", doc.allocate_string(std::to_string(aspect).c_str()));
			camera->append_attribute(aspectRatio);

			// 取得的fov类型默认是width-related FOV, 根据需要转换为height-related FOV
			float yfov = cameraState.fov;
			if (cameraObject->GetFOVType() == FOV_W)
				yfov = 2.0f * atan(tan(yfov / 2.0f) / aspect);

			auto fov = doc.allocate_attribute("fov", doc.allocate_string(std::to_string(RadToDeg(yfov)).c_str()));
			camera->append_attribute(fov);

			auto clipping = doc.allocate_node(node_element, "clipping");
			camera->append_node(clipping);
			auto nearClipping = doc.allocate_attribute("near", doc.allocate_string(std::to_string(cameraState.hither).c_str()));
			clipping->append_attribute(nearClipping);
			auto farClipping = doc.allocate_attribute("far", doc.allocate_string(std::to_string(cameraState.yon).c_str()));
			clipping->append_attribute(farClipping);

			// 处理轨迹动画
			processNodeTrack(gameNode, sceneNode, doc, camera, false);

			// 处理目标节点
			INode* targetNode = gameNode->GetMaxNode()->GetTarget();
			if (targetNode)
			{
				IGameScene* gameScene = GetIGameInterface();
				IGameNode* targetGameNode = gameScene->GetIGameNode(targetNode);
				if (targetGameNode)
				{
					SceneNodeMap::const_iterator sceneNodeItor = mSceneNodeMap.find(targetGameNode);
					if (sceneNodeItor != mSceneNodeMap.end())
					{
						const SceneNode& targetSceneNode = sceneNodeItor->second;
						processNode(targetGameNode, targetSceneNode, doc, camera, "lookTarget");
					}
				}
			}

			return camera;
		}
	}

	return 0;
}


xml_node<>* dotSceneExport::
processLight(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent)
{
	// 取出光源的属性
	Object* object = gameNode->GetMaxNode()->GetObjectRef();
	if (object)
	{
		LightObject* lightObject = static_cast<LightObject*>(object);
		LightState lightState;
		if (REF_SUCCEED == lightObject->EvalLightState(0, FOREVER, &lightState))
		{
			// 记录光源的transform信息, 记录在node节点
			auto node = doc.allocate_node(node_element, "node");
			parent->append_node(node);

			processNodeTransform(gameNode, sceneNode, doc, node);

			auto light = doc.allocate_node(node_element, "light");
			node->append_node(light);

			// 取出唯一的节点名称
			auto name = doc.allocate_attribute("name", doc.allocate_string(sceneNode.name.c_str()));
			light->append_attribute(name);

			// 类型
			std::string lightType = lightState.type == SPOT_LGT ? "spot" : lightState.type == DIRECT_LGT ? "directional" : "point";
			auto type = doc.allocate_attribute("type", doc.allocate_string(lightType.c_str()));
			light->append_attribute(type);

			// 可见
			auto visible = doc.allocate_attribute("visible", lightState.on ? "true" : "false");
			light->append_attribute(visible);

			// 是否生成阴影
			auto castShadows = doc.allocate_attribute("castShadows", lightState.shadow ? "true" : "false");
			light->append_attribute(castShadows);
			{
				if (lightState.type == DIRECT_LGT || lightState.type == SPOT_LGT)
				{
					/* 正确计算光源方向的代码如下, 但因为max默认光源方向朝下, 即float3(0, -1, 0)
					为了实现光源的轨迹运动, 因为track动画只对SceneNode作用, 则将position/rotation/scale记录在光源父节点中
					所以这里光源的方向永远为float3(0, -1, 0), 由父节点变换成实际的方向
					Matrix3 tm = ctm.ExtractMatrix3();
					tm.NoTrans();
					tm.NoScale();
					Point3 lightDirection = tm * Point3(0.0f, -1.0f, 0.0f);
					lightDirection = lightDirection.Normalize();
					*/
					auto direction = doc.allocate_node(node_element, "normal");
					light->append_node(direction);
					{
						auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(0.0f).c_str()));
						auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(-1.0f).c_str()));
						auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(0.0f).c_str()));
						direction->append_attribute(x);
						direction->append_attribute(y);
						direction->append_attribute(z);
					}
				}

				// 是否有diffuse信息
				if (lightState.affectDiffuse)
				{
					auto colourDiffuse = doc.allocate_node(node_element, "colourDiffuse");
					light->append_node(colourDiffuse);
					{
						// 实际颜色受放大系数影响
						Color diffuseColor = lightState.color * lightState.intens;

						auto r = doc.allocate_attribute("r", doc.allocate_string(std::to_string(diffuseColor.r).c_str()));
						auto g = doc.allocate_attribute("g", doc.allocate_string(std::to_string(diffuseColor.g).c_str()));
						auto b = doc.allocate_attribute("b", doc.allocate_string(std::to_string(diffuseColor.b).c_str()));
						colourDiffuse->append_attribute(r);
						colourDiffuse->append_attribute(g);
						colourDiffuse->append_attribute(b);
					}

					// 是否有specular信息
					if (lightState.affectSpecular)
					{
						// 复制diffuse信息
						auto colourSpecular = doc.clone_node(colourDiffuse);
						colourSpecular->name("colourSpecular");
						light->append_node(colourSpecular);
					}
				}

				const float maxRange = Sqrt(0.95f * FLT_MAX);
				// 如果有使用远裁剪距离则直接作为范围, 否则视为无限距离
				float rangeValue = lightState.useAtten ? lightState.attenEnd : maxRange;
				float constantValue = 1.0f;
				float linearValue = 0.0f;
				float quadraticValue = 0.0f;
				// 得到衰减类型
				GenLight* genLight = static_cast<GenLight*>(lightObject);
				int decayType = genLight->GetDecayType();
				switch (decayType)
				{
				case DECAY_INVSQ:
					// The Inverse Square (quadratic) Attenuation uses the fact that
					// the DecayRadius is in attenStart.  The Far Attenuation end value
					// is in attenEnd and is used as the Range of the light.
					constantValue = 1.0f;
					linearValue = 0.0f;
					quadraticValue = 1.0f / (lightState.attenStart * lightState.attenStart);
					break;

				case DECAY_INV:
					// The Inverse (linear) Attenuation uses the fact that the
					// DecayRadius is in attenStart.  The Far Attenuation end value is
					// in attenEnd and is used as the Range of the light.
					constantValue = 1.0f;
					linearValue = 1.0f / lightState.attenStart;
					quadraticValue = 0.0f;
					break;

				case DECAY_NONE:
					// The Far Attenuation uses linear attenuation to approximate the
					// effect.  The Far Attenuation end value is in attenEnd and is
					// used as the Range of the light.
					if (lightState.useAtten)
					{
						constantValue = 1.0f;
						linearValue = 4.0f / lightState.attenEnd;
						quadraticValue = 0.0f;
					}
					// No Attenuation.  Set the Range of the light to maxRange.
					else
					{
						constantValue = 1.0f;
						linearValue = 0.0f;
						quadraticValue = 0.0f;
					}
					break;

				default:
					break;
				}
				{
					auto lightAttenuation = doc.allocate_node(node_element, "lightAttenuation");
					light->append_node(lightAttenuation);
					{
						auto range		= doc.allocate_attribute("range", doc.allocate_string(std::to_string(rangeValue).c_str()));
						auto constant	= doc.allocate_attribute("constant", doc.allocate_string(std::to_string(constantValue).c_str()));
						auto linear		= doc.allocate_attribute("linear", doc.allocate_string(std::to_string(linearValue).c_str()));
						auto quadratic	= doc.allocate_attribute("quadratic", doc.allocate_string(std::to_string(quadraticValue).c_str()));
						lightAttenuation->append_attribute(range);
						lightAttenuation->append_attribute(constant);
						lightAttenuation->append_attribute(linear);
						lightAttenuation->append_attribute(quadratic);
					}
				}

				if (lightState.type == SPOT_LGT)
				{
					auto lightRange = doc.allocate_node(node_element, "lightRange");
					light->append_node(lightRange);
					{
						float innerValue = lightState.hotsize;
						float outerValue = lightState.fallsize;
						float falloffValue = 1.0f;

						auto inner		= doc.allocate_attribute("inner", doc.allocate_string(std::to_string(innerValue).c_str()));
						auto outer		= doc.allocate_attribute("outer", doc.allocate_string(std::to_string(outerValue).c_str()));
						auto falloff	= doc.allocate_attribute("falloff", doc.allocate_string(std::to_string(falloffValue).c_str()));
						lightRange->append_attribute(inner);
						lightRange->append_attribute(outer);
						lightRange->append_attribute(falloff);
					}
				}
			}

			// 处理节点自定义属性
			processNodeUserDefinedProperties(sceneNode.userDefinedPropertyMap, doc, light);

			// 处理节点动画(target节点的动画为spline)
			processNodeTrack(gameNode, sceneNode, doc, node, !gameNode->IsTarget());

			return node;
		}
	}

	return 0;
}


rapidxml::xml_node<>* dotSceneExport::
processSpline(IGameNode* gameNode, const SceneNode& sceneNode, rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent)
{
	// 初始化数据才能取出节点数据
	IGameObject* gameObject = gameNode->GetIGameObject();
	gameObject->InitializeData();
	IGameSpline* spline = static_cast<IGameSpline*>(gameObject);

	// 世界坐标
	GMatrix wtm = gameNode->GetWorldTM();
	int splineCount = spline->GetNumberOfSplines();
	std::vector<Point3> knots;
	knots.reserve(splineCount * 3);
	for (int n = 0; n < splineCount; ++n)
	{
		IGameSpline3D* spline3D = spline->GetIGameSpline3D(n);
		int knotCount = spline3D->GetIGameKnotCount();
		for (int i = 0; i < knotCount; ++i)
		{
			IGameKnot* knot = spline3D->GetIGameKnot(i);
			Point3 pos = knot->GetKnotPoint();
			// 这里怀疑是IGame的bug, 没有把max坐标系转换过来
			std::swap(pos.y, pos.z);
			pos.z = - pos.z;
			pos = pos * wtm;
			knots.push_back(pos);
		}
	}

	gameNode->ReleaseIGameObject();

	auto track = doc.allocate_node(node_element, "track");
	parent->append_node(track);

	// 取出唯一的节点名称
	auto name = doc.allocate_attribute("name", doc.allocate_string(sceneNode.name.c_str()));
	track->append_attribute(name);

	TimeValue duration = GetCOREInterface()->GetAnimRange().Duration();
	float factor = 1.0f / config.ticksPerFrame * config.framePerSecond;
	float animLength = duration * factor;
	auto length = doc.allocate_attribute("length", doc.allocate_string(std::to_string(animLength).c_str()));
	track->append_attribute(length);

	size_t count = knots.size();
	auto knotCount = doc.allocate_attribute("count", doc.allocate_string(std::to_string(count).c_str()));
	track->append_attribute(knotCount);

	auto type = doc.allocate_attribute("type", "spline");
	track->append_attribute(type);

	for (auto& knot : knots)
	{
		auto key = doc.allocate_node(node_element, "key");
		track->append_node(key);

		float keyTime = 0.0f;
		auto time = doc.allocate_attribute("time", doc.allocate_string(std::to_string(keyTime).c_str()));
		key->append_attribute(time);

		auto position = doc.allocate_node(node_element, "position");
		key->append_node(position);
		{
			auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(knot.x).c_str()));
			auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(knot.y).c_str()));
			auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(knot.z).c_str()));
			position->append_attribute(x);
			position->append_attribute(y);
			position->append_attribute(z);
		}
	}

	return track;
}


void dotSceneExport::
processNodeTransform(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent)
{
	// 取出唯一的节点名称
	auto name = doc.allocate_attribute("name", doc.allocate_string(sceneNode.name.c_str()));
	parent->append_attribute(name);

	// 设置position, scale, rotation
	{
		GMatrix tm = gameNode->GetLocalTM();
		Point3	nodePosition = tm.Translation();
		Point3	nodeScale = tm.Scaling();
		Quat	nodeRotation = tm.Rotation();
		// 翻转quaternion.w后旋转才正确
		nodeRotation.w *= -1.0f;

		// Camera需要围x轴旋转半个圆
		if (sceneNode.type == SceneNodeType::Camera)
		{
			// Now rotate around the X Axis PI/2
			Quat zRev = RotateXMatrix(PI / 2);
			nodeRotation = nodeRotation / zRev;
		}


		// position不为空
		if (!nodePosition.Equals(Point3::Origin))
		{
			Point3Verify(nodePosition);
			auto position = doc.allocate_node(node_element, "position");
			parent->append_node(position);
			{
				auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(nodePosition.x).c_str()));
				auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(nodePosition.y).c_str()));
				auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(nodePosition.z).c_str()));
				position->append_attribute(x);
				position->append_attribute(y);
				position->append_attribute(z);
			}
		}

		// rotation有角度变化
		if (!nodeRotation.IsIdentity())
		{
			QuatVerify(nodeRotation);
			auto rotation = doc.allocate_node(node_element, "rotation");
			parent->append_node(rotation);
			{
				auto qx = doc.allocate_attribute("qx", doc.allocate_string(std::to_string(nodeRotation.x).c_str()));
				auto qy = doc.allocate_attribute("qy", doc.allocate_string(std::to_string(nodeRotation.y).c_str()));
				auto qz = doc.allocate_attribute("qz", doc.allocate_string(std::to_string(nodeRotation.z).c_str()));
				auto qw = doc.allocate_attribute("qw", doc.allocate_string(std::to_string(nodeRotation.w).c_str()));
				rotation->append_attribute(qx);
				rotation->append_attribute(qy);
				rotation->append_attribute(qz);
				rotation->append_attribute(qw);
			}
		}

		// scale不全为1
		if (!nodeScale.Equals(Point3(1,1,1)))
		{
			Point3Verify(nodeScale);
			auto scale = doc.allocate_node(node_element, "scale");
			parent->append_node(scale);
			{
				auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(nodeScale.x).c_str()));
				auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(nodeScale.y).c_str()));
				auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(nodeScale.z).c_str()));
				scale->append_attribute(x);
				scale->append_attribute(y);
				scale->append_attribute(z);
			}
		}
	}
}


void dotSceneExport::
processNodeTrack(IGameNode* gameNode, const SceneNode& sceneNode, xml_document<>& doc, xml_node<>* parent, bool linear)
{
	const AnimationDesc& animDescs = sceneNode.animationDescs;
	if (!animDescs.empty())
	{
		// 是否有变换动画
		bool hasAnimation = false;
		Control* tmCtrl = gameNode->GetMaxNode()->GetTMController();
		if (tmCtrl)
			hasAnimation = tmCtrl->IsAnimated() == TRUE;
		if (hasAnimation)
		{
			bool dumpCameraFov = false;
			if (sceneNode.type == SceneNodeType::Camera &&
				!gameNode->IsTarget())
			{
				Object* object = gameNode->GetMaxNode()->GetObjectRef();
				if (object)
				{
					CameraObject* cameraObject = static_cast<CameraObject*>(object);
					GenCamera* genericCameraObject = static_cast<GenCamera*>(cameraObject);
					Control* fovControl = genericCameraObject->GetFOVControl();
					if (fovControl)
						dumpCameraFov = fovControl->IsAnimated() == TRUE;
				}
			}

			for (auto& animDesc : animDescs)
			{
				TimeValue	timeStart = animDesc.start * config.ticksPerFrame, 
							timeEnd = animDesc.end * config.ticksPerFrame;
				float aspect = GetCOREInterface()->GetRendImageAspect();
				size_t keyCount = (animDesc.end - animDesc.start + 1);
				if (keyCount > 1)
				{
					GMatrix initTM = gameNode->GetLocalTM(timeStart);
					std::vector<oiram::KeyFrame> keyFrames(keyCount);
					for (TimeValue frameTime = timeStart, n = 0; frameTime <= timeEnd; frameTime += config.ticksPerFrame, ++n)
					{
						oiram::KeyFrame& keyFrame = keyFrames[n];
						keyFrame.frameTime = frameTime;
						keyFrame.keyTime = (frameTime - timeStart) / config.ticksPerFrame * config.framePerSecond;

						GMatrix tm = gameNode->GetLocalTM(frameTime);
						tm *= initTM.Inverse();
						keyFrame.translation = tm.Translation();
						keyFrame.scale = tm.Scaling();
						keyFrame.rotation = tm.Rotation();
						// 翻转quaternion.w后旋转才正确
						keyFrame.rotation.w *= -1.0f;

						Point3Verify(&keyFrame.translation.x);
						QuatVerify(&keyFrame.rotation.x);
						Point3Verify(&keyFrame.scale.x);

						if (dumpCameraFov)
						{
							Object* object = gameNode->GetMaxNode()->GetObjectRef();
							GenCamera* cameraObject = static_cast<GenCamera*>(object);
							// 取得的fov类型默认是width-related FOV, 根据需要转换为height-related FOV
							float yfov = cameraObject->GetFOV(frameTime);
							if (cameraObject->GetFOVType() == FOV_W)
								yfov = 2.0f * atan(tan(yfov / 2.0f) / aspect);
							keyFrame.fov = RadToDeg(yfov);
						}
					}

					// 优化动画数据, 只留下关键帧
					oiram::interval animationRange = Optimizer::getSingleton().optimizeAnimation(keyFrames, true);

					// 动画总时间
					float animLength = (animationRange.End() - animationRange.Start() + 1) / config.ticksPerFrame * config.framePerSecond;

					auto track = doc.allocate_node(node_element, "track");
					parent->append_node(track);

					auto name = doc.allocate_attribute("name", doc.allocate_string(animDesc.name.c_str()));
					track->append_attribute(name);

					auto length = doc.allocate_attribute("length", doc.allocate_string(std::to_string(animLength).c_str()));
					track->append_attribute(length);

					auto type = doc.allocate_attribute("type", linear ? "linear" : "spline");
					track->append_attribute(type);

					// 导出各个关键帧的信息
					keyCount = keyFrames.size();
					for (size_t n = 0; n < keyCount; ++n)
					{
						const oiram::KeyFrame& keyFrame = keyFrames[n];

						// 有position key, 而且该帧的position有偏移
						bool exportPosKey = !keyFrame.translation.equals(oiram::vec3(0, 0, 0));
						// 有rotation key, 而且该帧的rotation有偏移
						bool exportRotKey = !keyFrame.rotation.equals(oiram::vec4(0,0,0,1));
						// 有scale key, 而且该帧的scale有偏移
						bool exportSclKey = !keyFrame.scale.equals(oiram::vec3(1,1,1));
						// 有fov key, 而且该帧的fov有变化
						bool exportFovKey = dumpCameraFov && keyFrame.fov != 0;

						auto key = doc.allocate_node(node_element, "key");
						track->append_node(key);

						auto time = doc.allocate_attribute("time", doc.allocate_string(std::to_string(keyFrame.keyTime).c_str()));
						key->append_attribute(time);

						if (exportPosKey)
						{
							auto position = doc.allocate_node(node_element, "position");
							key->append_node(position);
							{
								auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(keyFrame.translation.x).c_str()));
								auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(keyFrame.translation.y).c_str()));
								auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(keyFrame.translation.z).c_str()));
								position->append_attribute(x);
								position->append_attribute(y);
								position->append_attribute(z);
							}
						}

					
						if (exportRotKey)
						{
							auto rotation = doc.allocate_node(node_element, "rotation");
							key->append_node(rotation);
							{
								auto qx = doc.allocate_attribute("qx", doc.allocate_string(std::to_string(keyFrame.rotation.x).c_str()));
								auto qy = doc.allocate_attribute("qy", doc.allocate_string(std::to_string(keyFrame.rotation.y).c_str()));
								auto qz = doc.allocate_attribute("qz", doc.allocate_string(std::to_string(keyFrame.rotation.z).c_str()));
								auto qw = doc.allocate_attribute("qw", doc.allocate_string(std::to_string(keyFrame.rotation.w).c_str()));
								rotation->append_attribute(qx);
								rotation->append_attribute(qy);
								rotation->append_attribute(qz);
								rotation->append_attribute(qw);
							}
						}

						// 有scale key, 而且该帧的scale有偏移
						if (exportSclKey)
						{
							auto scale = doc.allocate_node(node_element, "scale");
							key->append_node(scale);
							{
								auto x = doc.allocate_attribute("x", doc.allocate_string(std::to_string(keyFrame.scale.x).c_str()));
								auto y = doc.allocate_attribute("y", doc.allocate_string(std::to_string(keyFrame.scale.y).c_str()));
								auto z = doc.allocate_attribute("z", doc.allocate_string(std::to_string(keyFrame.scale.z).c_str()));
								scale->append_attribute(x);
								scale->append_attribute(y);
								scale->append_attribute(z);
							}
						}

						if (exportFovKey)
						{
							auto fov = doc.allocate_node(node_element, "fov");
							key->append_node(fov);

							auto f = doc.allocate_attribute("fov", doc.allocate_string(std::to_string(keyFrame.fov).c_str()));
							fov->append_attribute(f);
						}
					}
				}
			}
		}
	}
}


void dotSceneExport::
processNodeUserDefinedProperties(const UserDefinedPropertyMap& userDefinedPropertyMap, xml_document<>& doc, xml_node<>* parent)
{
	for (auto& property : userDefinedPropertyMap)
	{
		auto& propKey = property.first;
		auto& propValue = property.second;

		auto userDefined = doc.allocate_node(node_element, "userDataReference");
		parent->append_node(userDefined);

		auto key = doc.allocate_attribute("key", doc.allocate_string(propKey.c_str()));
		userDefined->append_attribute(key);

		auto value = doc.allocate_attribute("value", doc.allocate_string(propValue.c_str()));
		userDefined->append_attribute(value);
	}
}
