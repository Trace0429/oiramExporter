#ifndef _Serializer_hpp__
#define _Serializer_hpp__

#include <string>
#include <vector>
#include <map>
#include <set>
#include <memory>
#include "type.h"
#include "requisites.h"
#include "scene.h"
#include <windows.h>

namespace oiram
{
	// 材质信息
	struct Material
	{
		// 运算方法
		enum Operation {	Op_Source1, Op_Source2, Op_Modulate, Op_Modulate_x2, Op_Modulate_x4,
							Op_Add, Op_Add_Signed, Op_Add_Smooth, Op_Substract,
							Op_Blend_Diffuse_Alpha, Op_Blend_Texture_Alpha, Op_Blend_Current_Alpha,
							Op_Manual, Op_Dotproduct, Op_Diffuse_Colour, Op_Default	};

		// 数据源
		enum Source { Src_Current, Src_Texture, Src_Diffuse, Src_Specular, Src_Manual };

		// 纹理类型
		enum TextureUnit { TU_Unknow, TU_Operation, TU_DiffuseMap, TU_LightMap, TU_NormalMap, TU_SpecularMap, TU_EmissiveMap, TU_ReflectionMap };

		// 颜色运算
		struct ColourOpEx
		{
			Operation					operation;	// 混合方式
			Source						source1;	// 数据源1
			Source						source2;	// 数据源2
		};

		// Alpha运算
		struct AlphaOpEx
		{
			Operation					operation;	// 混合方式
			Source						source1;	// 数据源1
			Source						source2;	// 数据源2
		};

		// 纹理
		struct TextureSlot
		{
			std::string					name;		// 名称
			TextureUnit					texunit;	// 类型
			int							mapChannel;	// 通道
			ColourOpEx					colourOpEx;	// color混合方式
			AlphaOpEx					alphaOpEx;	// alpha混合方式
			std::vector<std::string>	frames;		// 序列帧
			float						frameTime;	// 帧间时间(只对序列帧有效)
		};
		typedef std::vector<std::unique_ptr<TextureSlot>> TextureSlotContainer;
		TextureSlotContainer	textureSlots;			// 纹理

		// 纹理寻址模式
		enum TextureAdressMode { wrap, clamp, mirror };
		struct UVCoordinate
		{
			TextureAdressMode	u_mode;		// U寻址模式
			TextureAdressMode	v_mode;		// V寻址模式
			oiram::matrix		transform;	// 纹理矩阵
		};
		typedef std::map<int, std::unique_ptr<UVCoordinate>> UVCoordinateMap;
		UVCoordinateMap			uvCoordinateMap;		// UV通道->坐标

		std::string				rootName;				// 根材质的名称
		std::string				name;					// 材质的名称

		bool					twoSided;				// 双面
		bool					phongShading;			// 光照模型
		bool					alphaBlend;				// 透明
		bool					alphaTest;				// 镂空
		bool					addBlend;				// 叠加

		vec4					diffuseColour;			// 漫反射颜色
		bool					diffuseColourEnable;	// 漫反射颜色开关
		vec4					emissiveColour;			// 自发光颜色
		bool					emissiveColourEnable;	// 自发光颜色开关
		vec4					specularColour;			// 高光颜色
		bool					specularColourEnable;	// 高光颜色开关

		bool					packedTexcoords;		// 纹理坐标打包(仅用于diffuseMap+lightMap+vertexCompression)

		// 同一个材质可以被赋予静态或动态的物体, 当使用shader时要根据动/静来决定使用什么渲染
		std::set<std::string>	extended;				// 扩展类型(对于FF无意义)

		bool					isUsed;					// 是否被几何体使用到了(有时mesh的material是multi, 但实际只用到其中一个)

		Material() : twoSided(false), phongShading(true), alphaBlend(false), alphaTest(false), addBlend(false),
			diffuseColourEnable(true), emissiveColourEnable(true), specularColourEnable(true), 
			packedTexcoords(false), isUsed(false) {}
	};
	typedef std::shared_ptr<Material> MaterialPtr;
	typedef std::map<void*, MaterialPtr> MaterialMap;
	typedef std::vector<MaterialPtr> MaterialContainer;


	// 顶点元素
	enum VertexElementSemantic
	{
		Ves_Position				= 1 <<  1,
		Ves_Normal					= 1 <<  2,
		Ves_Diffuse					= 1 <<  3,
		Ves_Texture_Coordinate0		= 1 <<  4,
		Ves_Texture_Coordinate1		= 1 <<  5,
		Ves_Texture_Coordinate2		= 1 <<  6,
		Ves_Texture_Coordinate3		= 1 <<  7,
		Ves_Texture_Coordinate4		= 1 <<  8,
		Ves_Texture_Coordinate5		= 1 <<  9,
		Ves_Texture_Coordinate6		= 1 << 10,
		Ves_Texture_Coordinate7		= 1 << 11,
        Ves_Binormal				= 1 << 12,
        Ves_Tangent					= 1 << 13,
		Ves_Blend_Weights			= 1 << 14,
        Ves_Blend_Indices			= 1 << 15,

		Ves_VertexAnimationIndex	= 1 << 16,
	};

	// 顶点数据
	struct Vertex
	{
		vec3					vec3Position;		// 顶点
		short4					short4Position;		// 顶点short4

		unsigned long			diffuse;			// 颜色

		vec3					vec3Normal;			// 法线float3
		ubyte4					ubyte4Normal;		// 法线unsigned char4

		std::vector<vec2>		vec2Texcoords;		// 纹理坐标uv0, uv1, ... float2
		std::vector<short2>		short2Texcoords;	// 纹理坐标uv0, uv1, ... short2
		short4					short4Texcoord;		// 当只有diffuseMap和lightMap时使用一个short4的xyzw来保存两组uv

		vec4					vec4Tangent;		// 切线(w是手向)float4
		ubyte4					ubyte4Tangent;		// 切线(w是手向)unsigned char4

		vec3					vec3Binormal;		// 副切线float3
		ubyte4					ubyte4Binormal;		// 副切线unsigned char4

		vec4					vec4BlendWeight;	// 骨骼权重float4
		ubyte4					ubyte4BlendWeight;	// 骨骼权重unsigned char4
		unsigned long			blendIndex;			// 骨骼索引

		unsigned long			animationIndex;		// 动画索引
	};

	// 变形顶点数据
	struct MorphVertex
	{
		vec3			vec3Position;	// 顶点float3
		short4			short4Position;	// 顶点short4

		vec3			vec3Normal;		// 法线float3
		ubyte4			ubyte4Normal;	// 法线unsigned char4
	};
	// 变形关键帧时间
	typedef int MorphKeyTick;
	// 变形关键帧顶点数据
	typedef std::vector<MorphVertex> MorphKeyFrame;
	// 变形关键帧轨迹
	typedef std::map<MorphKeyTick, MorphKeyFrame> MorphAnimationTrack;
	// 变形动画
	typedef std::vector<std::vector<MorphKeyTick>> MorphAnimations;

	// LOD
	struct LOD
	{
		unsigned int	indexCount;		// 顶点索引的数量
		void*			indexBuffer;	// 顶点索引的缓冲

		LOD() : indexCount(0), indexBuffer(0) {}
		~LOD() { delete []indexBuffer; }
	};

	// 顶点类型 -> 顶点缓冲
	typedef unsigned int VertexDeclaration;
	typedef std::vector<Vertex> VertexBuffer;
	struct IndexBuffer
	{
		bool						use32BitIndices;		// 是否为32bits索引
		std::vector<unsigned int>	uiIndexBuffer;			// 32bits索引缓冲
		std::vector<unsigned short>	usIndexBuffer;			// 16bits索引缓冲

		IndexBuffer() : use32BitIndices(false) {}
	};

	struct GeometryData
	{
		MaterialPtr					material;				// 材质

		VertexDeclaration			vertexDeclaration;		// 顶点类型
		VertexBuffer				vertexBuffer;			// 顶点缓冲
		
		MorphAnimationTrack			morphAnimationTrack;	// 变形动画轨迹
		
		std::vector<LOD>			indexLODs;				// 顶点索引LOD数组

		GeometryData() : vertexDeclaration(0) {}
	};
	typedef std::shared_ptr<GeometryData> Geometry;

	// 网格数据
	struct SubMesh
	{
		std::string					materialName;			// 材质名称
		int							matID;					// 材质ID
		Geometry					geometry;				// 几何数据
		IndexBuffer					indexBuffer;			// 索引缓冲

		SubMesh() : matID(-1) {}
	};
	typedef std::vector<std::unique_ptr<SubMesh>> SubMeshContainer;


	struct Mesh
	{
		std::string				name;					// 名称
		bool					hasSkeleton;			// 是否有骨骼动画信息
		std::string				skeletonName;			// 骨骼名称
		bool					hasMorph;				// 是否有顶点动画信息
		box3					vertexBoundingBox;		// 顶点包裹盒
		box2					uvBoundingBox;			// 纹理坐标包裹盒

		Geometry				sharedGeometry;			// 共享几何数据
		SubMeshContainer		subMeshes;				// 子网络数据
		MorphAnimations			morphAnimations;		// 变形动画

		Mesh() { initialize(); }

		void initialize()
		{
			name.clear();
			hasSkeleton = false;
			skeletonName.clear();
			hasMorph = false;
			vertexBoundingBox.Init();
			uvBoundingBox.Init();
			sharedGeometry.reset();
			subMeshes.clear();
			morphAnimations.clear();
		}
	};


	// 骨骼关键帧
	struct KeyFrame
	{
		vec4		rotation;		// 旋转
		vec3		translation;	// 位置
		vec3		scale;			// 缩放
		float		fov;			// FOV
		int			frameTime;		// 帧时间(tick)
		float		keyTime;		// 帧时间(秒)
	};

	// 骨骼动画
	struct Animation
	{
		interval				animationRange;	// 动画时间
		std::vector<KeyFrame>	keyFrames;		// 关键帧
	};

	// 骨骼
	struct Bone
	{
		bool						isTag;					// 是否为挂载点
		bool						nonuniformScaleChecked;	// 等比缩放检查

		std::string					name;					// 名称
		unsigned short				handle;					// 句柄
		unsigned short				parentHandle;			// 父节点句柄

		// 初始信息
		vec3						initTranslation;		// 位置
		vec4						initRotation;			// 旋转
		vec3						initScale;				// 缩放

		matrix						initMatrix;				// 矩阵
		typedef std::map<int, matrix> TransformMap;
		TransformMap				worldTM;				// 时间->变换映射表

		std::vector<Animation>		animations;			// 动画

		Bone() : isTag(false), nonuniformScaleChecked(false), handle(0), parentHandle(0) {}
	};
	typedef std::map<void*, std::unique_ptr<Bone>> BoneMap;

	// 骨架
	struct Skeleton
	{
		std::string					skeletonName;	// 骨骼名称
		interval					animationRange;	// 动画时间
		BoneMap						boneMap;		// 骨骼映射表
		std::vector<void*>			tagArray;		// 挂载点
	};
	typedef std::map<void*, std::unique_ptr<Skeleton>> SkeletonMap;


	// 序列化基类
	class Serializer
	{
	public:
		Serializer() {}
		virtual ~Serializer() = 0 {};

		virtual const char* getName()const = 0;
		void setConfig(const Config& config) { mConfig = config; }

		virtual void exportMaterial(const oiram::MaterialContainer& materials) = 0;
		virtual void exportMesh(const oiram::Mesh& mesh, const AnimationDesc& animDescs) = 0;
		virtual void exportSkeleton(const oiram::Skeleton& skeleton, const AnimationDesc& animDescs) = 0;
		virtual void exportPackage(const std::string& directory, const std::string& name) = 0;

	protected:
		Config					mConfig;
	};
}

#endif
