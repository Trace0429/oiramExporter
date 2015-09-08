#ifndef _Scene_Type_hpp__
#define _Scene_Type_hpp__

#include <string>
#include <map>
#include <vector>

class IGameNode;
class Object;

typedef std::multimap<std::string, std::string> UserDefinedPropertyMap;

// 动画信息
struct Animation
{
	std::string	name;
	int			start;
	int			end;
};
typedef std::vector<Animation> AnimationDesc;

// 场景节点类型
enum class SceneNodeType{
	Geometry, Camera, Light, Bone, Helper, Spline, Target, PhysX, Apex, UnSupported
};

// 场景节点
struct SceneNode
{
	SceneNodeType			type;					// 类型
	std::string				name;					// 名称
	SceneNode*				nodeReference;			// 引用的场景节点
	std::string				meshName;				// mesh名称
	std::string				materialFileName;		// 材质文件名称(仅在相同mesh不同材质时有效)
	bool					hasUV;					// 是否有UV
	float					uvCenterU,				// UV0的范围
							uvCenterV,
							uvExtentU,
							uvExtentV;
	float					positionCenterX,		// position的范围
							positionCenterY,
							positionCenterZ,
							positionExtentX,
							positionExtentY,
							positionExtentZ;
	bool					hasSkeleton;			// 是否有蒙皮
	bool					hasMorph;				// 是否有变形动画
	UserDefinedPropertyMap	userDefinedPropertyMap;	// 用户自定义属性映射表
	AnimationDesc			animationDescs;			// 动画信息
};

typedef std::map<IGameNode*, SceneNode> SceneNodeMap;
typedef std::set<std::string> SceneNodeNameSet;
typedef std::map<Object*, SceneNode*> SceneNodeInstanceMap;
typedef std::vector<IGameNode*> NodeContainer;

#endif
