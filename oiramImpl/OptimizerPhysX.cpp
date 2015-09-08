#include "stdafx.h"
#include <PxPhysicsAPI.h>
#include "requisites.h"
#include "serializer.h"
#include "Optimizer.h"
#include "LogManager.h"

// 内存数据
class PxCookMesh : public physx::PxInputData, public physx::PxOutputStream
{
public:
	PxCookMesh()
	: mSize(0), mData(0), mPos(0), mCapacity(0)
	{
	}

	~PxCookMesh()
	{
		delete[] mData;
	}


	physx::PxU32 write(const void* src, physx::PxU32 size)
	{
		physx::PxU32 expectedSize = mSize + size;
		if (expectedSize > mCapacity)
		{
			mCapacity = expectedSize + 4096;

			physx::PxU8* newData = new physx::PxU8[mCapacity];
			PX_ASSERT(newData != nullptr);

			if (newData)
			{
				memcpy(newData, mData, mSize);
				delete[] mData;
			}
			mData = newData;
		}
		memcpy(mData + mSize, src, size);
		mSize += size;

		return size;
	}


	physx::PxU32 getSize()const { return mSize; }
	physx::PxU8* getData()const { return mData; }

	void setData(physx::PxU8* data, physx::PxU32 length)
	{
		mSize = length;
		mData = data;
		mPos = 0;
	}

	physx::PxU32 read(void* dest, physx::PxU32 count)
	{
		physx::PxU32 length = physx::PxMin<physx::PxU32>(count, mSize - mPos);
		memcpy(dest, mData + mPos, length);
		mPos += length;

		return length;
	}

	physx::PxU32 getLength()const { return mSize; }

	void seek(physx::PxU32 offset) { mPos = physx::PxMin<physx::PxU32>(mSize, offset); }
	physx::PxU32 tell()const { return mPos; }

private:
	physx::PxU32	mSize;
	physx::PxU8		*mData;
	physx::PxU32	mPos;
	physx::PxU32	mCapacity;
};


class PxOiramErrorCallback : public physx::PxErrorCallback
{
public:
	PxOiramErrorCallback() {}
	~PxOiramErrorCallback() {}

	void reportError(physx::PxErrorCode::Enum code, const char* message, const char* file, int line)
	{
		LogManager::getSingleton().logMessage(true, "PhysX - PxErrorCode: (%d), message: \"%s\", file: \"%s\", line: (%d)", code, message, file, line);
	}
};


void optimizePhysXMesh(int flag, IDirect3DDevice9* D3DDevice, float epsilon, std::vector<physx::PxVec3>& pxVertices, oiram::IndexBuffer& indexBuffer)
{
	assert(D3DDevice);

	D3DVERTEXELEMENT9 szDecl[] = {
		{0,		0,		D3DDECLTYPE_FLOAT3,		D3DDECLMETHOD_DEFAULT,	D3DDECLUSAGE_POSITION,	0},
		{0xFF,	0,		D3DDECLTYPE_UNUSED,		0,						0,						0}
	};

	// 创建D3D MESH
	LPD3DXMESH pMesh = 0;
	DWORD options = D3DXMESH_SYSTEMMEM | D3DXMESH_DYNAMIC;
	if (indexBuffer.use32BitIndices)
		options |= D3DXMESH_32BIT;
	DWORD numVertices = static_cast<DWORD>(pxVertices.size()), numFaces = numVertices / 3;
	HRESULT hr = D3DXCreateMesh(numFaces, numVertices, options, szDecl, D3DDevice, &pMesh);
	if (SUCCEEDED(hr))
	{
		LPVOID pData = nullptr;
		// 填充Index Buffer
		if (SUCCEEDED(pMesh->LockIndexBuffer(D3DLOCK_DISCARD, &pData)))
		{
			if (indexBuffer.use32BitIndices)
				memcpy(pData, indexBuffer.uiIndexBuffer.data(), indexBuffer.uiIndexBuffer.size() * sizeof(physx::PxU32));
			else
				memcpy(pData, indexBuffer.usIndexBuffer.data(), indexBuffer.usIndexBuffer.size() * sizeof(physx::PxU16));

			pMesh->UnlockIndexBuffer();
		}

		// 填充Vertex Buffer
		if (SUCCEEDED(pMesh->LockVertexBuffer(D3DLOCK_DISCARD, &pData)))
		{
			memcpy(pData, pxVertices.data(), pxVertices.size() * sizeof(physx::PxVec3));
			pMesh->UnlockVertexBuffer();
		}

		// 进行Mesh优化
		DWORD dwFaces = pMesh->GetNumFaces();
		std::vector<DWORD> szAdjacencies(dwFaces * 3);
		DWORD* pAdjacency = &szAdjacencies[0];
		pMesh->GenerateAdjacency(epsilon, pAdjacency);
		// 清理mesh
		hr = D3DXCleanMesh(D3DXCLEAN_SIMPLIFICATION, pMesh, pAdjacency, &pMesh, pAdjacency, NULL);
		if (SUCCEEDED(hr))
		{
			// 去除mesh中重复的顶点
			hr = D3DXWeldVertices(pMesh, D3DXWELDEPSILONS_WELDALL, NULL, pAdjacency, pAdjacency, NULL, NULL);
			if (SUCCEEDED(hr))
			{
				// 将优化后的数据写回mesh data
				DWORD numIndices = pMesh->GetNumFaces() * 3;
				indexBuffer.use32BitIndices = numIndices > 65535;
				if (indexBuffer.use32BitIndices)
					indexBuffer.uiIndexBuffer.resize(numIndices);
				else
					indexBuffer.usIndexBuffer.resize(numIndices);

				// 取出Index Buffer
				if (SUCCEEDED(pMesh->LockIndexBuffer(D3DLOCK_READONLY | D3DLOCK_DISCARD, &pData)))
				{
					if (indexBuffer.use32BitIndices)
						memcpy(indexBuffer.uiIndexBuffer.data(), pData, indexBuffer.uiIndexBuffer.size() * sizeof(physx::PxU32));
					else
						memcpy(indexBuffer.usIndexBuffer.data(), pData, indexBuffer.usIndexBuffer.size() * sizeof(physx::PxU16));

					pMesh->UnlockIndexBuffer();
				}

				// 取出Vertex Buffer
				DWORD dwVertices = pMesh->GetNumVertices();
				pxVertices.resize(dwVertices);

				if (SUCCEEDED(pMesh->LockVertexBuffer(D3DLOCK_READONLY | D3DLOCK_DISCARD, &pData)))
				{
					memcpy(pxVertices.data(), pData, pxVertices.size() * sizeof(physx::PxVec3));
					pMesh->UnlockVertexBuffer();
				}
			}
		}

		pMesh->Release();
	}
}


bool Optimizer::
dumpPhysXCookMesh(IGameNode* gameNode, const std::string& nodeName, int flag)
{
	// 受缩放影响
	GMatrix worldTM = gameNode->GetWorldTM();
	Point3 scale = worldTM.Scaling();
	// 世界矩阵的逆矩阵
	GMatrix nodeInvWorldTM = gameNode->GetWorldTM().Inverse();
	IGameObject* gameObject = gameNode->GetIGameObject();
	IGameMesh* gameMesh = static_cast<IGameMesh*>(gameObject);
	gameMesh->InitializeData();
	int numFaces = gameMesh->GetNumberOfFaces();
	int numVertex = numFaces * 3;
	std::vector<physx::PxVec3> pxVertices;
	pxVertices.reserve(numVertex);
	oiram::IndexBuffer indexBuffer;
	indexBuffer.use32BitIndices = numVertex > 65535;
	indexBuffer.use32BitIndices ? indexBuffer.uiIndexBuffer.reserve(numVertex) : indexBuffer.usIndexBuffer.reserve(numVertex);
	for (int i = 0; i < numFaces; ++i)
	{
		FaceEx* face = gameMesh->GetFace(i);
		for (int v = 0; v < 3; ++v)
		{
			Point3 position = gameMesh->GetVertex(face->vert[v], false);
			position = position * nodeInvWorldTM;
			pxVertices.push_back(physx::PxVec3(position.x * scale.x, position.y * scale.y, position.z * scale.z));
			if (indexBuffer.use32BitIndices)
				indexBuffer.uiIndexBuffer.push_back(static_cast<unsigned int>(indexBuffer.uiIndexBuffer.size()));
			else
				indexBuffer.usIndexBuffer.push_back(static_cast<unsigned short>(indexBuffer.usIndexBuffer.size()));
		}
	}
	gameNode->ReleaseIGameObject();

	// 初始化physx对象
	physx::PxDefaultAllocator s_defAlloc;
	PxOiramErrorCallback s_defErrCb;
	physx::PxFoundation* pFound = PxCreateFoundation(PX_PHYSICS_VERSION, s_defAlloc, s_defErrCb);
	physx::PxCooking* pCooking = PxCreateCooking(PX_PHYSICS_VERSION, *pFound, physx::PxCookingParams());

	// 优化物理模型顶点
	optimizePhysXMesh(flag, mD3DDevice, mEpsilon, pxVertices, indexBuffer);

	bool success = false;
	PxCookMesh cookMesh;
	switch (flag)
	{
	// cookConvexMesh
	case 1:
	default:
		{
			physx::PxConvexMeshDesc meshDesc;
			meshDesc.points.data = pxVertices.data();
			meshDesc.points.count = static_cast<physx::PxU32>(pxVertices.size());
			meshDesc.points.stride = sizeof(physx::PxVec3);
			meshDesc.flags = physx::PxConvexFlag::eCOMPUTE_CONVEX;

			// 先尝试导出
			success = meshDesc.isValid() && pCooking->cookConvexMesh(meshDesc, cookMesh);
			if (!success)
			{
				// polygon数量大于255的时候需要加上eINFLATE_CONVEX
				meshDesc.flags |= physx::PxConvexFlag::eINFLATE_CONVEX;
				success = meshDesc.isValid() && pCooking->cookConvexMesh(meshDesc, cookMesh);
			}
		}
		break;

	// cookTriangleMesh
	case 2:
		{
			physx::PxTriangleMeshDesc meshDesc;
			meshDesc.points.data = pxVertices.data();
			meshDesc.points.count = static_cast<physx::PxU32>(pxVertices.size());
			meshDesc.points.stride = sizeof(physx::PxVec3);

			if (indexBuffer.use32BitIndices)
			{
				meshDesc.triangles.data = indexBuffer.uiIndexBuffer.data();
				meshDesc.triangles.count = static_cast<physx::PxU32>(indexBuffer.uiIndexBuffer.size()) / 3;
				meshDesc.triangles.stride = sizeof(physx::PxU32) * 3;
			}
			else
			{
				meshDesc.triangles.data = indexBuffer.usIndexBuffer.data();
				meshDesc.triangles.count = static_cast<physx::PxU16>(indexBuffer.usIndexBuffer.size()) / 3;
				meshDesc.triangles.stride = sizeof(physx::PxU16) * 3;
				meshDesc.flags = physx::PxMeshFlag::e16_BIT_INDICES;
			}

			success = meshDesc.isValid();
			success = success && pCooking->cookTriangleMesh(meshDesc, cookMesh);
		}
		break;
	}

	if (success)
	{
		std::string pxName = nodeName + ".px";
		LogManager::getSingleton().logMessage(false, "Exporting: %s", pxName.c_str());

		pxName = config.exportPath + pxName;
		FILE* fp = fopen(pxName.c_str(), "wb");
		if (fp)
		{
			fwrite(cookMesh.getData(), cookMesh.getSize(), 1, fp);
			fclose(fp);
		}
	}

	pCooking->release();
	pFound->release();
	
	return success;
}
