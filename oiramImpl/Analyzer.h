#ifndef _Analyzer_hpp__
#define _Analyzer_hpp__

#include "serializer.h"
#include <IGame/IGameType.h>
#include <box3.h>
class IGameNode;
class IGameMaterial;
struct SceneNode;

class Analyzer
{
public:
	Analyzer();
	~Analyzer();

	// 统计及生成材质数据
	void processMaterial(IGameMaterial* gameMaterial, const std::string& rootMaterialName);
	// 导出纹理数据
	void exportTextures();

	// 统计及生成几何数据
	void processGeometry(IGameNode* gameNode, const SceneNodeMap& sceneNodeMap);
	// 统计挂载点
	void processTag(IGameNode* tagNode);
	// 计算骨骼信息
	void processSkeleton(const SceneNodeMap& sceneNodeMap);

	// 得到节点的根节点
	static IGameNode* getRootNode(IGameNode* gameNode);

public:
	oiram::MaterialMap			mMaterialMap;	// 材质信息表
	oiram::MaterialContainer	mMaterials;		// 所有材质(唯一)
	oiram::Mesh					mMesh;			// 网格信息
	oiram::SkeletonMap			mSkeletonMap;	// 骨骼信息表
	GMatrix						mInitSkinTM;


private:
	// 材质属性比较
	bool materialComp(const oiram::Material& lhs, const oiram::Material& rhs);
	// 创建默认材质
	void createDefaultMaterial();
	// 定位贴图
	bool getMapPath(MSTR& mapPath);
	// 增加材质
	void addMaterial(IGameMaterial* gameMaterial, const std::shared_ptr<oiram::Material>& oiramMaterial);
	// 导出材质信息
	std::shared_ptr<oiram::Material> dumpMaterialProperty(IGameMaterial* gameMaterial, const std::string& rootMaterialName);

	// 更新顶点包裹盒
	void updateVertexBounds(const oiram::vec3& position);
	// 更新纹理坐标包裹盒
	void updateUVBounds(const oiram::vec2& uv);
	// 导出顶点动画关键帧信息
	void processVertexAnimation(IGameNode* gameNode, const SceneNode* sceneNode, std::vector<TimeValue>& morphKeyFrameTimes);
	// 导出整幅骨架
	void dumpSkeletal(IGameNode* gameNode);
	// 导出相关骨骼信息
	unsigned short dumpBone(IGameNode* pBone, bool isTag=false);
	// 处理镜像骨骼
	void checkMirroredMatrix(GMatrix& tm);
	// 得到指定时间帧的矩阵
	GMatrix getNodeTransform(IGameNode* pNode, oiram::Bone& bone, TimeValue t);
	// 取出节点相对于父节点的旋转、位置、缩放等信息
	void decomposeNodeMatrix(IGameNode* pBone, IGameNode* rootNode, Point3& nodePos, Point3& nodeScale, Quat& nodeOriet, TimeValue t, bool exportInitMatrix=false, bool isTag=false);

	// Box3 -> oiram:box3
	oiram::box3 fromBox3(Box3 box);
	// oiram::matrix -> GMatrix
	GMatrix toGMatrix(const oiram::matrix& m);
	// GMatrix -> oiram::matrix
	oiram::matrix fromGMatrix(const GMatrix& gm);

	// 优化网格
	void optimizeMesh();
	// 顶点数据压缩
	void vertexCompression(SceneNode* sceneNode);
};

#endif
