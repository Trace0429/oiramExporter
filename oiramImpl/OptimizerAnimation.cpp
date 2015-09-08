#include "stdafx.h"
#include <max.h>
#include <algorithm>
#include <functional>
#include <iterator>
#include "requisites.h"
#include "serializer.h"
#include "Optimizer.h"

// std::advance不保证iterator是否越界, 这里实现确保iterator有效
template <typename container_type>
typename container_type::iterator advanceEx(container_type& container, 
											typename container_type::iterator itor, 
											typename container_type::difference_type offset)
{
	container_type::difference_type	before = -std::distance(container.begin(), itor),
									after = std::distance(itor, container.end());
	offset = std::max(before, std::min(after, offset));
	if (offset != 0)
		std::advance(itor, offset);

	return itor;
}


// 两帧是否相同
bool KeyFrameEquals(const oiram::KeyFrame& lhs, const oiram::KeyFrame& rhs, float epsilon)
{
	return (lhs.translation.equals(rhs.translation, epsilon) &&
			lhs.scale.equals(rhs.scale, epsilon) &&
			lhs.rotation.equals(rhs.rotation, epsilon));
}

Point3 fromVec3(const oiram::vec3& p){ return Point3(p.x, p.y, p.z); }

// 当前帧是否可以通过前后帧的插值生成
bool KeyFrameLerpEquals(const oiram::KeyFrame& keyFrame1, const oiram::KeyFrame& keyFrame2, const oiram::KeyFrame& keyFrame3, float epsilon)
{
	// 计算第2号关键帧的时间比例
	float t = (keyFrame2.keyTime - keyFrame1.keyTime) / (keyFrame3.keyTime - keyFrame1.keyTime);

	// 计算插值数据
	oiram::KeyFrame lerpKeyFrame = {
		Slerp(	Quat(keyFrame1.rotation.x, keyFrame1.rotation.y, keyFrame1.rotation.z, keyFrame1.rotation.w), 
				Quat(keyFrame3.rotation.x, keyFrame3.rotation.y, keyFrame3.rotation.z, keyFrame3.rotation.w), t	),
		fromVec3(keyFrame1.translation) + (fromVec3(keyFrame3.translation) - fromVec3(keyFrame1.translation)) * t,
		fromVec3(keyFrame1.scale) + (fromVec3(keyFrame3.scale) - fromVec3(keyFrame1.scale)) * t };

	// 如果第2号关键帧是否正好是第1和3号关键帧的差值数据
	return KeyFrameEquals(keyFrame2, lerpKeyFrame, epsilon);
}

// 二元函数对象
struct KeyFrameOperator : public std::binary_function<oiram::KeyFrame, oiram::KeyFrame, bool>
{
	static float epsilon;	// 精度控制
};
float KeyFrameOperator::epsilon = 1e-6f;

// operator ==
struct KeyFrameEqualTo : public KeyFrameOperator
{
	bool operator ()(const oiram::KeyFrame& lhs, const oiram::KeyFrame& rhs)const
	{
		return KeyFrameEquals(lhs, rhs, epsilon);
	}
};

// operator !=
struct KeyFrameNotEqualTo : public KeyFrameOperator
{
	bool operator ()(const oiram::KeyFrame& lhs, const oiram::KeyFrame& rhs)const
	{
		return !KeyFrameEquals(lhs, rhs, epsilon);
	}
};


oiram::interval Optimizer::
optimizeAnimation(std::vector<oiram::KeyFrame>& keyFrames, bool keepLength)
{
	// 空帧
	const oiram::KeyFrame emptyKeyFrame = { oiram::vec4(0,0,0,1), oiram::vec3(0,0,0), oiram::vec3(1,1,1), 0, 0 };
	// 初始化精度
	KeyFrameOperator::epsilon = mEpsilon;

	std::vector<oiram::KeyFrame>::iterator beginItor, endItor;
	// 全是空帧
	if (std::find_if(keyFrames.begin(), keyFrames.end(), std::bind1st(KeyFrameNotEqualTo(), emptyKeyFrame)) == keyFrames.end())
	{
		// 没有存在的必要, 干脆清空
		//keyFrames.clear();
	}
	// 为确保动画的完整, 起始和结束帧一定会采样, 所以接下来操作的区间在[begin + 1, end - 1]
	else
	{
		// 删除尾部相同帧
		if (!keepLength && keyFrames.size() > 1)
		{
			// 最后一帧
			oiram::KeyFrame lastKeyFrame = keyFrames.back();
			// 所有与最后一帧相同的起始帧
			auto sameItor = std::find_if(keyFrames.rbegin(), keyFrames.rend(), std::bind1st(KeyFrameNotEqualTo(), lastKeyFrame)).base();
			// 留一帧
			if (sameItor != keyFrames.end())
				++sameItor;
			// 删除后面的
			keyFrames.erase(sameItor, keyFrames.end());
		}

		// 删除空帧
		if (keyFrames.size() > 2)
		{
			beginItor = advanceEx(keyFrames, keyFrames.begin(), 1);
			endItor = advanceEx(keyFrames, keyFrames.end(), -1);
			keyFrames.erase(std::remove_if(beginItor, endItor, std::bind1st(KeyFrameEqualTo(), emptyKeyFrame)), endItor);
		}

		// 删除相邻重复帧
		if (keyFrames.size() > 2)
		{
			beginItor = advanceEx(keyFrames, keyFrames.begin(), 1);
			endItor = advanceEx(keyFrames, keyFrames.end(), -1);
			std::vector<oiram::KeyFrame>::iterator adjacentItor;
			while ((adjacentItor = std::adjacent_find(beginItor, endItor, KeyFrameEqualTo())) != endItor)
			{
				keyFrames.erase(++adjacentItor);
				beginItor = advanceEx(keyFrames, keyFrames.begin(), 1);
				endItor = advanceEx(keyFrames, keyFrames.end(), -1);
			}
		}

		// 删除可以通过插值生成的关键帧(因为循环内会删除帧, 所以必须每次都直接调用keyFrames.end())
		if (keyFrames.size() > 2)
		{
			for (auto keyFrameItor = advanceEx(keyFrames, keyFrames.begin(), 1); keyFrameItor != advanceEx(keyFrames, keyFrames.end(), -1);)
			{
				// 遍历时间轴上的连续的3个关键帧
				auto	previousKeyItor = advanceEx(keyFrames, keyFrameItor, -1),
						nextKeyItor = advanceEx(keyFrames, keyFrameItor, 1);

				// 假设有abcd四帧, 当前指向c, 而c可以通过b和d的插值生成, 则删除c后, erase会将iterator指向d
				// 这时需要将iterator指向b, 原因是因为c被删除后, 需要再一次判断是否b可以通过a和d插值生成
				// 处理时必须保证 previousKeyItor != keyFrameItor != nextKeyItor
				if (previousKeyItor != keyFrameItor && keyFrameItor != nextKeyItor &&
					KeyFrameLerpEquals(*previousKeyItor, *keyFrameItor, *nextKeyItor, mEpsilon))
					keyFrameItor = advanceEx(keyFrames, keyFrames.erase(keyFrameItor), -1);
				else
					++keyFrameItor;
			}
		}

		// 保持动画长度时可能导致最后2帧完全相同, 此时可以删除相同的倒数第2帧
		if (keepLength && keyFrames.size() > 2)
		{
			std::vector<oiram::KeyFrame>::iterator tailItor;
			tailItor = advanceEx(keyFrames, keyFrames.end(), -2);
			endItor = advanceEx(keyFrames, keyFrames.end(), -1);
			if (KeyFrameEquals(*tailItor, *endItor, KeyFrameOperator::epsilon))
				keyFrames.erase(tailItor);
		}
	}

	oiram::interval animationRange;
	// 更新动画时间
	if (keyFrames.empty())
		animationRange.SetEmpty();
	else
		animationRange.Set(keyFrames.front().frameTime, keyFrames.back().frameTime);

	return animationRange;
}
