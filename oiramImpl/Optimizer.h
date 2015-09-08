#ifndef _Utility_hpp__
#define _Utility_hpp__

#include "serializer.h"

struct Optimizer
{
public:
	~Optimizer();

	static Optimizer& getSingleton();

	void setEpsilon(float epsilon);

	void optimizeMesh(oiram::Mesh& mesh);
	void vertexCompression(oiram::Mesh& mesh, SceneNode* sceneNode);

	oiram::interval optimizeAnimation(std::vector<oiram::KeyFrame>& keyFrames, bool keepLength = false);
	bool dumpPhysXCookMesh(IGameNode* gameNode, const std::string& nodeName, int flag);

private:
	Optimizer();

private:
	IDirect3D9*			mD3D;			// D3D9接口
	IDirect3DDevice9*	mD3DDevice;		// D3D设备
	float				mEpsilon;		// 阀值
};

#endif
