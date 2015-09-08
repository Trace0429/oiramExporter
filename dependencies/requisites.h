#ifndef _requisites_hpp__
#define _requisites_hpp__

#include <string>
#include <vector>
#include <io.h>
#include "type.h"

enum ExportObject
{
	EO_Scene	= 1 << 0,
	EO_Geometry = 1 << 1,
	EO_Light	= 1 << 2,
	EO_Camera	= 1 << 3,
	EO_Helper	= 1 << 4,
	EO_Spline	= 1 << 5,
	EO_Target	= 1 << 6,
	EO_PhysX	= 1 << 7,
	EO_APEX		= 1 << 8,

	EO_All		= EO_Scene | EO_Geometry | EO_Light | EO_Camera | EO_Helper | EO_Spline | EO_Target | EO_PhysX | EO_APEX
};

// 精度(小数点后几位, 默认0.00001)
#define MIN_PRECISION 3
#define MAX_PRECISION 6
#define DEFAULT_PRECISION 5

enum RenderingType
{
	RT_FixedFunction,
	RT_Programmable
};

enum CompressionType
{
	CT_Original,
	CT_PNG,
	CT_TGA,
	CT_DXTC,
	CT_ETC1,
	CT_ETC2,
	CT_PVRTC2_4BPP,
};

enum CompressionQuality
{
	CQ_Low,
	CQ_Normal,
	CQ_High
};

enum TextureFiltering
{
	TF_Bilinear,
	TF_Trilinear,
	TF_Anisotropic_8,
	TF_Anisotropic_16,
};

struct LODesc
{
	int			reduction;
	int			value1;
	std::string	value2;
};

struct Config
{
	int									exportObject;				// 导出对象
	bool								dotSceneUTF8;				// 以UTF8编码输出.scene
	bool								prependRenaming;			// 重命名(将max文件名作为前缀, 加到除scene之外所有的文件名上)
	bool								fullSkeletal;				// 导出全部骨架
	bool								onlyPhysX;					// 只输出PhysX数据
	RenderingType						renderingType;				// 渲染方式
	int									skeletonMaxBones;			// 最大骨骼数(GPU skinning受寄存器数量影响)
	int									optimizationEpsilon;		// 优化的精度阀值(影响geometry, skeleton, morph, animation node)

	CompressionType						imageCompressionType;		// 图像压缩类型
	CompressionQuality					imageCompressionQuality;	// 压缩精度
	bool								imageGenerationMipmaps;		// 生成mipmaps
	TextureFiltering					imageTextureFiltering;		// 过滤方式
	bool								imagePowerOfTwo;			// 图像必须是2的幂
	int									imageMaxSize;				// 图像最大尺寸
	float								imageScale;					// 图像缩放

	std::string							outputFolder;				// 输出目录
	bool								package;					// 文件打包

	std::vector<LODesc>					lodDescs;					// LOD信息

	// 动态信息记录
	bool								mobilePlatform;				// 移动平台
	std::string							maxName;					// 文件名称
	std::string							exportPath;					// 导出路径
	float								unitMultiplier;				// 单位缩放(根据max的单位比例)
	int									ticksPerFrame;				// 嘀嗒/帧
	float								framePerSecond;				// 帧率
};

extern Config config;


inline void strLegalityCheck(std::string& str)
{
	// 非法字符都将被替换为下划线
	std::replace_if(str.begin(), str.end(),
		[](std::string::value_type c) { return (c == ' ' || c == '/' || c == '\\' || c == ':' || c == '#' || c == '.'); },
		'_');
}


// 生成唯一节点名称
class UniqueNameGenerator
{
public:
	static UniqueNameGenerator& getSingleton(){
		static UniqueNameGenerator msSingleton;
		return msSingleton;
	}

	void setPrependName(const std::string& prepend) { mPrependName = prepend; }
	void clear() { mStringPool.clear(); }
	std::string generate(const std::string& str, const std::string& group, bool prependNaming, bool legalityChecking)
	{
		// 检查名称的有效性
		std::string uniqueStr;
		if (prependNaming)
		{
			if (mPrependName.empty())
				uniqueStr = str;
			else
				uniqueStr = mPrependName + '_' + str;
		}
		else
		{
			uniqueStr = str;
		}

		// 字符串合法性检查
		if (legalityChecking)
			strLegalityCheck(uniqueStr);

		// 为了避免节点名称重名, 将判断是否存在该名称, 否则将随机在名称后面添加字条使之唯一
		while (mStringPool[group].count(uniqueStr))
			uniqueStr += static_cast<wchar_t>(rand() % 10 + '0');
		mStringPool[group].insert(uniqueStr);

		return uniqueStr;
	}

private:
	std::string										mPrependName;
	std::map<std::string, std::set<std::string>>	mStringPool;
};


#ifdef assert
	#undef assert
	#define assert(exp) if(!(exp)){ DebugBreak(); }
#endif

#ifdef _UNICODE
	#if defined(MAX_RELEASE) && MAX_RELEASE > 14000
		inline std::string Mstr2Ansi(const MSTR& str)
		{
			return std::string(str.ToACP());
		}

		inline MSTR FromACP(const char* str)
		{
			return MSTR::FromACP(str);
		}
	#else
		#include "strutil.h"

		inline std::string Mstr2Ansi(const MSTR& mstr)
		{
			return str::to_utf8(mstr.data());
		}
		inline MSTR Ansi2Mstr(const std::string& str)
		{
			return str::to_wcs(str).c_str();
		}
	#endif

	#define ToString(v) std::to_wstring(v)
#else
	#define Mstr2Ansi(str) (str.operator const char *())
	#define Mchar2Ansi(str) (str)
	#define Ansi2Mstr(str) (str.c_str())

	#define ToString(v) std::to_string(v)
#endif

#endif
