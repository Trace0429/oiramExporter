#ifndef _Dot_Scene_Export__
#define _Dot_Scene_Export__

#include "scene.h"

class dotSceneExport
{
public:
	dotSceneExport(const std::string& dotSceneFileName, const SceneNodeMap& sceneNodeMap);
	~dotSceneExport() {}

private:
	void dumpNodes(IGameNode* gameNode, rapidxml::xml_document<>& doc, 
		rapidxml::xml_node<>* scene, rapidxml::xml_node<>* nodes, rapidxml::xml_node<>* parent);

	// 处理节点
	rapidxml::xml_node<>* processNode(IGameNode* gameNode, const SceneNode& sceneNode, 
		rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent, const char* nodeName = "node");
	// 处理挂载点
	rapidxml::xml_node<>* processHelper(IGameNode* gameNode, const SceneNode& sceneNode, 
		rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);
	// 处理摄像机
	rapidxml::xml_node<>* processCamera(IGameNode* gameNode, const SceneNode& sceneNode, 
		rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);
	// 处理光源
	rapidxml::xml_node<>* processLight(IGameNode* gameNode, const SceneNode& sceneNode, 
		rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);
	// 处理样条
	rapidxml::xml_node<>* processSpline(IGameNode* gameNode, const SceneNode& sceneNode, 
		rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);

	// 处理节点的变换
	void processNodeTransform(IGameNode* gameNode, const SceneNode& sceneNode, rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);
	// 处理节点动画
	void processNodeTrack(IGameNode* gameNode, const SceneNode& sceneNode, rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent, bool linear = true);
	// 处理节点的自定义属性
	void processNodeUserDefinedProperties(const UserDefinedPropertyMap& userDefinedPropertyMap, rapidxml::xml_document<>& doc, rapidxml::xml_node<>* parent);

private:
	// 动画关键帧
	struct BoneKeyFrame
	{
		Point3	translation;
		Quat	rotation;
		Point3	scale;
		float	fov;			// for camera

		BoneKeyFrame() : translation(0,0,0), scale(1,1,1), rotation(0.0f,0.0f,0.0f,1.0f), fov(0) {}
	};

	const SceneNodeMap&		mSceneNodeMap;	// 几何信息表
};

#endif
