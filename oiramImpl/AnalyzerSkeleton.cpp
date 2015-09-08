#include "stdafx.h"
#include "Analyzer.h"
#include <IGame\IGame.h>
#include <algorithm>
#include "requisites.h"
#include "LogManager.h"
#include "strutil.h"
#include "Optimizer.h"

void Analyzer::
processTag(IGameNode* tagNode)
{
	// 将挂载点存放在各自所属的骨架中
	IGameNode* rootNode = getRootNode(tagNode);
	auto& skeleton = mSkeletonMap[rootNode];
	skeleton->tagArray.push_back(tagNode);
}


void Analyzer::
processSkeleton(const SceneNodeMap& sceneNodeMap)
{
	for (auto& skeletonItor : mSkeletonMap)
	{
		IGameNode* rootNode = static_cast<IGameNode*>(skeletonItor.first);
		auto& skeleton = skeletonItor.second;

		// 骨骼名称取根节点的名称
		if (config.prependRenaming)
			skeleton->skeletonName = config.maxName + '_' + Mchar2Ansi(rootNode->GetName());
		else
			skeleton->skeletonName = Mchar2Ansi(rootNode->GetName());
		strLegalityCheck(skeleton->skeletonName);

		// 导出挂载点
		for (size_t n = 0; n < skeleton->tagArray.size(); ++n)
			dumpBone(static_cast<IGameNode*>(skeleton->tagArray[n]), true);

		// 计算骨骼绑定时的初始数据
		for (auto& boneItor : skeleton->boneMap)
		{
			IGameNode* pBone = static_cast<IGameNode*>(boneItor.first);
			auto& bone = boneItor.second;
			Point3 initTranslation, initScale;
			Quat initRotation;
			decomposeNodeMatrix(pBone, rootNode, initTranslation, initScale, initRotation, 0, true, bone->isTag);
			bone->initTranslation = initTranslation * config.unitMultiplier;
			bone->initScale = initScale;
			bone->initRotation = initRotation;
		}
	}

	// 导出动画关键数据
	for (auto& skeletonItor : mSkeletonMap)
	{
		IGameNode* rootNode = static_cast<IGameNode*>(skeletonItor.first);
		auto& skeleton = skeletonItor.second;

		LogManager::getSingleton().logMessage(false, "Exporting: %s.skeleton", skeleton->skeletonName.c_str());

		auto sceneNodeItor = sceneNodeMap.find(rootNode);
		if (sceneNodeItor != sceneNodeMap.end())
		{
			const SceneNode& sceneNode = sceneNodeItor->second;
			const AnimationDesc& animDescs = sceneNode.animationDescs;

			oiram::BoneMap& boneMap = skeleton->boneMap;
			auto boneBeginItor = boneMap.begin(), boneEndItor = boneMap.end();
			for (auto boneItor = boneBeginItor; boneItor != boneEndItor; ++boneItor)
			{
				LogManager::getSingleton().setProgress(static_cast<int>(100.0f * std::distance(boneMap.begin(), boneItor) / boneMap.size()));

				IGameNode* pBone = static_cast<IGameNode*>(boneItor->first);
				auto& bone = boneItor->second;

				// 数据是否已经处理过, 或是不需要处理
				if (!bone->nonuniformScaleChecked)
				{
					// 记录动画
					size_t animationCount = animDescs.size();
					bone->animations.resize(animationCount);
					for (size_t i = 0; i < animationCount; ++i)
					{
						oiram::Animation& animation = bone->animations[i];
						const auto& animDesc = animDescs[i];
						TimeValue	timeStart = animDesc.start * config.ticksPerFrame,
							timeEnd = animDesc.end * config.ticksPerFrame;
						// 总帧数
						size_t keyCount = (animDesc.end - animDesc.start + 1);
						animation.keyFrames.resize(keyCount);
						for (TimeValue frameTime = timeStart, n = 0; frameTime <= timeEnd; frameTime += config.ticksPerFrame, ++n)
						{
							oiram::KeyFrame& keyFrame = animation.keyFrames[n];
							// 得到每一帧骨骼的变换数据
							Point3 translation, scale;
							Quat rotation;
							decomposeNodeMatrix(pBone, rootNode, translation, scale, rotation, frameTime, false, bone->isTag);

							// 保存相对信息
							keyFrame.frameTime = frameTime;
							keyFrame.keyTime = (frameTime - timeStart) / config.ticksPerFrame * config.framePerSecond;
							keyFrame.translation = (translation - Point3(bone->initTranslation.x, bone->initTranslation.y, bone->initTranslation.z)) * config.unitMultiplier;
							keyFrame.rotation = Inverse(Quat(bone->initRotation.x, bone->initRotation.y, bone->initRotation.z, bone->initRotation.w)) * rotation;
							keyFrame.scale = scale / Point3(bone->initScale.x, bone->initScale.y, bone->initScale.z);
						}

						animation.animationRange.Set(animation.keyFrames.front().frameTime, animation.keyFrames.back().frameTime);
					}

					// 优化动画数据, 只留下关键帧
					size_t animCount = bone->animations.size();
					for (size_t n = 0; n < animCount; ++n)
					{
						oiram::Animation& animation = bone->animations[n];
						std::vector<oiram::KeyFrame>& keyFrames = animation.keyFrames;
						animation.animationRange = Optimizer::getSingleton().optimizeAnimation(keyFrames);
					}

					// 设置等比缩放已检查过
					bone->nonuniformScaleChecked = true;

					// 更新骨架的动画时间
					for (size_t i = 0; i < animationCount; ++i)
					{
						oiram::Animation& animation = bone->animations[i];
						if (!animation.animationRange.Empty())
							skeleton->animationRange.Set(std::min(skeleton->animationRange.Start(), animation.animationRange.Start()),
							std::max(skeleton->animationRange.End(), animation.animationRange.End()));
					}
				}
			}
		}
	}
}


void Analyzer::
dumpSkeletal(IGameNode* gameNode)
{
	dumpBone(gameNode);

	// 递归处理所有子节点
	int count = gameNode->GetChildCount();
	for (int n = 0; n < count; ++n)
	{
		IGameNode* childNode = gameNode->GetNodeChild(n);
		dumpSkeletal(childNode);
	}
}


unsigned short Analyzer::
dumpBone(IGameNode* pBone, bool isTag)
{
	// 初始化骨骼动画时间
	IGameNode* rootNode = getRootNode(pBone);
	auto& skeleton = mSkeletonMap[rootNode];
	if (!skeleton)
		skeleton.reset(new oiram::Skeleton);

	auto& bone = skeleton->boneMap[pBone];
	if (!bone)
	{
		bone.reset(new oiram::Bone);
		// 填充骨骼信息
		bone->isTag = isTag;
		bone->name = UniqueNameGenerator::getSingleton().generate(Mchar2Ansi(pBone->GetName()), "bone", false, false);
		bone->handle = static_cast<unsigned short>(skeleton->boneMap.size()) - 1;
		bone->parentHandle = -1;
		// 第0帧骨骼信息
		GMatrix initTM = getNodeTransform(pBone, *bone, 0);
		bone->initMatrix = fromGMatrix(initTM); // 已保证checkMirroredMatrix

		// 递归处理父骨骼
		IGameNode* pParentBone = pBone->GetNodeParent();
		if (pParentBone)
			bone->parentHandle = dumpBone(pParentBone);	// 父节点句柄直接赋值
	}

	return bone->handle;
}


void Analyzer::
checkMirroredMatrix(GMatrix& tm)
{
	// 美术有可能使用标准面板中来镜像骨骼, 导致GMatrix中的旋转不正确, 通过奇偶校验来判断
	if (tm.Parity() == -1)
		tm[2] *= -1.0f; // 反向旋转一下
}


GMatrix Analyzer::
getNodeTransform(IGameNode* pNode, oiram::Bone& bone, TimeValue t)
{
	// 因为pNode->GetWorldTM(t)非常耗时(估计是通过遍历所有父节点计算得出)
	// 所以保存处理过的变换矩阵, 以供后续可直接查找使用
	auto transItor = bone.worldTM.find(t);
	if (transItor == bone.worldTM.end())
	{
		GMatrix tm = pNode->GetWorldTM(t);
		// 扯回原点
		tm = tm * mInitSkinTM.Inverse();
		checkMirroredMatrix(tm);

		transItor = bone.worldTM.insert(std::make_pair(t, fromGMatrix(tm))).first;
	}

	return toGMatrix(transItor->second);
}


void Analyzer::
decomposeNodeMatrix(IGameNode* pBone, IGameNode* rootNode, Point3& nodePos, Point3& nodeScale, Quat& nodeOriet, TimeValue t, bool exportInitMatrix, bool isTag)
{
	auto& boneMap = mSkeletonMap[rootNode]->boneMap;
	auto& bone = boneMap[pBone];
	GMatrix tm;
	// 初始骨骼信息
	if (exportInitMatrix)
	{
		tm = toGMatrix(bone->initMatrix);

		IGameNode* parentNode = pBone->GetNodeParent();
		if (parentNode)
		{
			// 没办法, GMatrix::Inverse()竟然不是const的
			GMatrix ptm = toGMatrix(boneMap[parentNode]->initMatrix);
			tm *= ptm.Inverse();
		}
	}
	else
	{
		// 时间t所在帧的骨骼信息
		tm = getNodeTransform(pBone, *bone, t);

		IGameNode* parentNode = pBone->GetNodeParent();
		if (parentNode)
		{
			auto& parentBone = boneMap[parentNode];
			GMatrix ptm = getNodeTransform(parentNode, *parentBone, t);

			tm *= ptm.Inverse();
		}
	}

	nodePos = tm.Translation();

	// 挂载点的缩放始终为1
	if (isTag)
	{
		nodeScale.Set(1,1,1);
		bone->nonuniformScaleChecked = true;
	}
	else
	{
		nodeScale = tm.Scaling();

		if (!bone->nonuniformScaleChecked)
		{
			// 避免0缩放
			const float epsilon = 1e-5f;
			if (nodeScale.x < epsilon) nodeScale.x = epsilon;
			if (nodeScale.y < epsilon) nodeScale.y = epsilon;
			if (nodeScale.z < epsilon) nodeScale.z = epsilon;

			// 检查Nonuniform scale
			const float tolerance = 1e-3f;
			float	xyScale = nodeScale.x / nodeScale.y,
					xzScale = nodeScale.x / nodeScale.z,
					yzScale = nodeScale.y / nodeScale.z;
			if (!oiram::fequal(xyScale, xzScale, tolerance) ||
				!oiram::fequal(xyScale, yzScale, tolerance) ||
				!oiram::fequal(xyScale, yzScale, tolerance))
			{
				bone->nonuniformScaleChecked = true;
				LogManager::getSingleton().logMessage(true, "Nonuniform scale found: \"%s\".", pBone->GetName());
			}
		}
	}

	nodeOriet = tm.Rotation();
	// 在取GMatrix的scale,translation和rotation时实际上是调用decomp_affine, 这些都没转换
	// 但GMatrix在之前已经转变了坐标系, 所以没关系, 不过quaternion还是左手坐标系, 所以w要取负
	nodeOriet.w = -nodeOriet.w;
}


GMatrix Analyzer::
toGMatrix(const oiram::matrix& m)
{
	GMatrix gm;
	memcpy(&(gm[0][0]), &m, sizeof(m));
	return gm;
}


oiram::matrix Analyzer::
fromGMatrix(const GMatrix& gm)
{
	oiram::matrix m;
	memcpy(&m, &(gm[0][0]), sizeof(m));
	return m;
}


IGameNode* Analyzer::
getRootNode(IGameNode* gameNode)
{
	// 递归直到搜索到根节点
	if (gameNode)
	{
		IGameNode* parentNode = gameNode->GetNodeParent();
		if (parentNode == 0)
			return gameNode;
		else
			return getRootNode(parentNode);
	}

	return 0;
}
