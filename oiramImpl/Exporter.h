#ifndef _Exporter_hpp__
#define _Exporter_hpp__

#include "scene.h"
#include "strutil.h"

class IGameScene;
class IGameNode;
class IGameMesh;
class IGameMaterial;
class Analyzer;

namespace oiram
{
	struct Mesh;
	class Serializer;
}

class Exporter
{
public:
	Exporter(oiram::Serializer* serializer);
	~Exporter();

	// 实际导出接口
	bool Export(bool exportSelected);

private:
	SceneNodeType getSceneNodeType(INode* node);
	// 节点是否有蒙皮
	bool isNodeSkinned(INode* node);
	// 节点是否有顶点动画
	bool isNodeMorphed(Animatable* node);
	// 节点是否隐藏
	bool isNodeHidden(IGameNode* gameNode);
	// 导出子节点
	void dumpNodes(IGameNode* gameNode);
	// 导出自定义属性
	void processNodeUserDefinedProperties(IGameNode* gameNode, SceneNode& sceneNode);
	// 解析动画信息
	void processAnimation(SceneNode& sceneNode);

private:
	SceneNodeMap			mSceneNodeMap;			// 所有场景节点信息
	SceneNodeNameSet		mSceneNodeNameSet;		// 所有场景节点名称列表
	SceneNodeInstanceMap	mSceneNodeInstanceMap;	// 几何节点引用
	Analyzer*				mAnalyzer;				// 解析器
	oiram::Serializer*		mSerializer;			// 序列化
};

#endif
