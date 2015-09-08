#include "stdafx.h"
#include "Analyzer.h"
#include <IGame/IGame.h>
#include <IGame/IGameObject.h> 
#include <stdmat.h>
#if defined(MAX_RELEASE_R12_ALPHA) && MAX_RELEASE >= MAX_RELEASE_R12_ALPHA
	#include <IFileResolutionManager.h>
#pragma comment(lib, "assetmanagement.lib")
#else
	#include <IPathConfigMgr.h>
#endif
#include <fstream>
#include <algorithm>
#include "normalrender.h"
#include "mix.h"
#include "ImageLoader.h"
#include "ImageCompressor.h"
#include "requisites.h"
#include "scene.h"
#include "strutil.h"
#include "LogManager.h"

bool Analyzer::
materialComp(const oiram::Material& lhs, const oiram::Material& rhs)
{
	bool result = true;
	result = result && (lhs.twoSided == rhs.twoSided);
	result = result && (lhs.phongShading == rhs.phongShading);
	result = result && (lhs.alphaBlend == rhs.alphaBlend);
	result = result && (lhs.alphaTest == rhs.alphaTest);
	result = result && (lhs.addBlend == rhs.addBlend);

	result = result && (lhs.diffuseColour.equals(rhs.diffuseColour));
	result = result && (lhs.diffuseColourEnable == rhs.diffuseColourEnable);
	result = result && (lhs.emissiveColour.equals(rhs.emissiveColour));
	result = result && (lhs.emissiveColourEnable == rhs.emissiveColourEnable);
	result = result && (lhs.specularColour.equals(rhs.specularColour));
	result = result && (lhs.specularColourEnable == rhs.specularColourEnable);

	result = result && (lhs.textureSlots.size() == rhs.textureSlots.size());
	if (result)
	{
		for (size_t t = 0; t < lhs.textureSlots.size(); ++t)
		{
			auto& x = lhs.textureSlots[t];
			auto& y = rhs.textureSlots[t];

			result = result && (x->name == y->name);
			result = result && (x->texunit == y->texunit);
			result = result && (x->mapChannel == y->mapChannel);
			result = result && (x->colourOpEx.operation == y->colourOpEx.operation);
			result = result && (x->colourOpEx.source1 == y->colourOpEx.source1);
			result = result && (x->colourOpEx.source2 == y->colourOpEx.source2);
			result = result && (x->alphaOpEx.operation == y->alphaOpEx.operation);
			result = result && (x->alphaOpEx.source1 == y->alphaOpEx.source1);
			result = result && (x->alphaOpEx.source2 == y->alphaOpEx.source2);
			result = result && (x->frames.size() == y->frames.size());
			if (result)
			{
				for (size_t f = 0; f < x->frames.size(); ++f)
				{
					auto& a = x->frames[f];
					auto& b = y->frames[f];
					result = result && (a == b);
				}
			}
			result = result && (oiram::fequal(x->frameTime, y->frameTime));
		}
	}	

	result = result && (lhs.uvCoordinateMap.size() == rhs.uvCoordinateMap.size());
	if (result)
	{
		for (auto& uvCoordinateItor : lhs.uvCoordinateMap)
		{
			auto& channel = uvCoordinateItor.first;
			auto& coordinate = uvCoordinateItor.second;

			auto findItor = rhs.uvCoordinateMap.find(channel);
			result = result && (findItor != rhs.uvCoordinateMap.end());
			if (result)
			{
				result = result && (coordinate->u_mode == findItor->second->u_mode);
				result = result && (coordinate->v_mode == findItor->second->v_mode);
			}
		}
	}

	return result;
}


void Analyzer::
createDefaultMaterial()
{
	// 没有材质的物体的material指针是nullptr, 对应为默认材质
	std::shared_ptr<oiram::Material> defaultMaterial(new oiram::Material);
	defaultMaterial->rootName = defaultMaterial->name = "";
	defaultMaterial->twoSided = false;
	defaultMaterial->phongShading = false;
	defaultMaterial->alphaBlend = false;
	defaultMaterial->alphaTest = false;
	defaultMaterial->addBlend = false;
	defaultMaterial->diffuseColourEnable = false;
	defaultMaterial->emissiveColourEnable = false;
	defaultMaterial->specularColourEnable = false;

	mMaterialMap.insert(std::make_pair(nullptr, defaultMaterial));
}


void Analyzer::
processMaterial(IGameMaterial* gameMaterial, const std::string& rootMaterialName)
{
	// 如果是多重材质
	if (gameMaterial->IsMultiType())
	{
		// 如果是壳材质
		MCHAR* materialClass = gameMaterial->GetMaterialClass();
		if (_tcscmp(materialClass, _T("Shell Material")) == 0)
		{
			// 如果子材质超过1个
			if (gameMaterial->GetSubMaterialCount() > 1)
			{
				// 将第二层认为是lightingMap层
				IGameMaterial* gameOrigMaterial = gameMaterial->GetSubMaterial(0);
				IGameMaterial* gameBakedMaterial = gameMaterial->GetSubMaterial(1);

				// 壳材质下可能是多重材质
				if (gameOrigMaterial->IsMultiType() &&
					gameBakedMaterial->IsMultiType())
				{
					// 依次导出信息
					int origSubCount = gameOrigMaterial->GetSubMaterialCount(),
						bakedSubCount = gameBakedMaterial->GetSubMaterialCount();
					assert(origSubCount >= bakedSubCount);
					for (int n = 0; n < origSubCount; ++n)
					{
						IGameMaterial* gameOrigSubMaterial = gameOrigMaterial->GetSubMaterial(n);
						int bakedIndex = std::min(n, bakedSubCount - 1);
						IGameMaterial* gameBakedSubMaterial = gameBakedMaterial->GetSubMaterial(bakedIndex);
						auto origSubMaterial = dumpMaterialProperty(gameOrigSubMaterial, rootMaterialName), 
							bakedSubMaterial = dumpMaterialProperty(gameBakedSubMaterial, rootMaterialName);

						// 将第二层材质的的diffuseMap存回第一层材质作为lightingMap
						auto textureSlotItor = std::find_if(bakedSubMaterial->textureSlots.begin(), bakedSubMaterial->textureSlots.end(), 
							[](const oiram::Material::TextureSlotContainer::value_type& textureSlot){
								return textureSlot->name == "diffuseMap"; });
						if (textureSlotItor != bakedSubMaterial->textureSlots.end())
						{
							auto& textureSlot = *textureSlotItor;
							textureSlot->name = "lightMap";
							textureSlot->texunit = oiram::Material::TU_LightMap;
							// 使用diffuseMap的alpha通道
							textureSlot->alphaOpEx.operation = oiram::Material::Op_Source1;
							textureSlot->alphaOpEx.source1 = oiram::Material::Src_Current;
							textureSlot->alphaOpEx.source2 = oiram::Material::Src_Texture;

							if (origSubMaterial->uvCoordinateMap.count(textureSlot->mapChannel))
								LogManager::getSingleton().logMessage(true, "Diffuse map and lightmap, using the same channel : (%d).", textureSlot->mapChannel);

							// 将lightingMap的map channle也加入源材质中
							int bakedMapChannel = textureSlot->mapChannel;
							origSubMaterial->uvCoordinateMap.insert(
								std::make_pair(bakedMapChannel, std::move(bakedSubMaterial->uvCoordinateMap[bakedMapChannel])));

							origSubMaterial->textureSlots.push_back(std::move(textureSlot));

							// 非固定管线默认使用顶点压缩, 同时UV通道大于1个
							if (config.renderingType != RT_FixedFunction &&
								origSubMaterial->uvCoordinateMap.size() > 1)
								origSubMaterial->packedTexcoords = true;
						}
						addMaterial(gameOrigSubMaterial, origSubMaterial);
					}
				}
				else
				{
					auto	origMaterial = dumpMaterialProperty(gameOrigMaterial, rootMaterialName),
							bakedMaterial = dumpMaterialProperty(gameBakedMaterial, rootMaterialName);

					// 将第二层材质的的diffuseMap存回第一层材质作为lightingMap
					auto textureSlotItor = std::find_if(bakedMaterial->textureSlots.begin(), bakedMaterial->textureSlots.end(), 
						[](const oiram::Material::TextureSlotContainer::value_type& textureSlot){
							return textureSlot->name == "diffuseMap"; });
					if (textureSlotItor != bakedMaterial->textureSlots.end())
					{
						auto& textureSlot = *textureSlotItor;
						textureSlot->name = "lightMap";
						textureSlot->texunit = oiram::Material::TU_LightMap;
						// 使用diffuseMap的alpha通道
						textureSlot->alphaOpEx.operation = oiram::Material::Op_Source1;
						textureSlot->alphaOpEx.source1 = oiram::Material::Src_Current;
						textureSlot->alphaOpEx.source2 = oiram::Material::Src_Texture;

						// 将lightingMap的map channle也加入源材质中
						int bakedMapChannel = textureSlot->mapChannel;
						origMaterial->uvCoordinateMap.insert(
							std::make_pair(bakedMapChannel, std::move(bakedMaterial->uvCoordinateMap[bakedMapChannel])));

						origMaterial->textureSlots.push_back(std::move(textureSlot));

						// 非固定管线默认使用顶点压缩, 同时UV通道大于1个
						if (config.renderingType != RT_FixedFunction &&
							origMaterial->uvCoordinateMap.size() > 1)
							origMaterial->packedTexcoords = true;
					}
					addMaterial(gameOrigMaterial, origMaterial);
				}
			}
			// 处理第一层材质
			else
			{
				auto origMaterial = dumpMaterialProperty(gameMaterial->GetSubMaterial(0), rootMaterialName);
				addMaterial(gameMaterial, origMaterial);
			}
		}
		else
		{
			// 依次处理多个子材质
			for (int n = 0; n < gameMaterial->GetSubMaterialCount(); ++n)
				processMaterial(gameMaterial->GetSubMaterial(n), rootMaterialName);
		}
	}
	// 处理唯一的材质
	else
	{
		auto material = dumpMaterialProperty(gameMaterial, rootMaterialName);
		addMaterial(gameMaterial, material);
	}
}


// 贴图资源
struct BitmapResource
{
	std::string						rename;			// 重命名后的名称
	std::string						srcFilePath;	// 源路径
	std::string						dstFilePath;	// 目标路径
	oiram::Material::TextureUnit	texunit;		// 类型
	BitmapResource() : texunit(oiram::Material::TextureUnit::TU_Unknow) {}
};

void Analyzer::
exportTextures()
{
	// mMaterialMap里面可能会有一些相同的材质, 收集到mMaterials中的材质绝对唯一
	mMaterials.reserve(mMaterialMap.size());
	for (auto& materialPair : mMaterialMap)
	{
		auto& material = materialPair.second;
		if (material->isUsed &&
			materialPair.first &&
			std::find(mMaterials.begin(), mMaterials.end(), material) == mMaterials.end())
		{
			mMaterials.push_back(material);
		}
	}

	// 如果是保持原贴图则不需要处理文件名的是否有效性
	bool legalityChecking = config.imageCompressionType != CT_Original;
	// 处理纹理
	std::map<std::string, BitmapResource> bitmapMap;	// 纹理信息表
	for (auto& material : mMaterials)
	{
		// 遍历所有的纹理(包括序列帧)
		for (auto& textureSlot : material->textureSlots)
		{
			for (auto& frame : textureSlot->frames)
			{
				auto result = bitmapMap.insert(std::make_pair(frame, BitmapResource()));
				if (result.second)
				{
					auto& resource = result.first->second;
					// 仅保存文件名
					std::string::size_type pos = frame.find_last_of('\\');
					resource.rename = pos == std::string::npos ? frame : frame.substr(pos + 1);
					// 文件名唯一
					resource.rename = UniqueNameGenerator::getSingleton().generate(resource.rename, "bitmap", true, legalityChecking);
					// 源文件路径
					resource.srcFilePath = frame;
					// 目标文件路径
					resource.dstFilePath = config.exportPath + resource.rename;
					resource.texunit = textureSlot->texunit;
				}
			}
		}
	}

	// 复制所有收集到的贴图
	LogManager::getSingleton().setProgress(0);
	size_t textureProgress = 0, numTextures = bitmapMap.size();
	for (auto& texture : bitmapMap)
	{
		auto& resource = texture.second;
		// 复制贴图
		bool originalCopy = true;
		std::string imageName = resource.rename;
		LogManager::getSingleton().logMessage(false, "Exporting: %s", imageName.c_str());
		LogManager::getSingleton().setProgress(static_cast<int>(static_cast<float>(textureProgress++) / numTextures * 100));

		// FreeImage只能读dds而不能写dds, 所以当源贴图是DDS时使用pvrtclib处理
		CompressionType compressionType = config.imageCompressionType;
		std::string::size_type pos = resource.srcFilePath.find_last_of('.');
		if (pos != std::string::npos)
		{
			std::string ext = str::lowercase(resource.srcFilePath.substr(pos));
			if (ext == ".dds")
				compressionType = CT_DXTC;
		}

		bool isNormalMap = resource.texunit == oiram::Material::TU_NormalMap;
		bool isLightMap = resource.texunit == oiram::Material::TU_LightMap;
		bool isCompression = false;
		// 通过PVRTCLib处理压缩贴图
		if (compressionType != CT_Original)
		{
			// 直接将压缩格式的后缀添加到原贴图文件名的后面
			switch (config.imageCompressionType)
			{
			case CT_PNG:
				imageName += ".png";
				break;

			case CT_TGA:
				imageName += ".tga";
				break;

			case CT_DXTC:
				imageName += ".dds";
				isCompression = true;
				break;

			case CT_ETC1:
			case CT_ETC2:
				imageName += ".ktx";
				isCompression = true;
				break;

			case CT_PVRTC2_4BPP:
				imageName += ".pvr";
				isCompression = true;
				break;
			}

			if (isCompression)
			{
				originalCopy = !ImageCompressor::compress(compressionType, resource.srcFilePath, resource.dstFilePath,
					isNormalMap, isLightMap, config.imageCompressionQuality, config.imageGenerationMipmaps);

				// 压缩失败, 改为普通复制, 发出警告信息
				if (originalCopy)
					LogManager::getSingleton().logMessage(true, "Image compression failure: \"%s\" to \"%s\".",
					resource.srcFilePath.c_str(), resource.dstFilePath.c_str());
			}
		}

		// 如果是普通复制, 或者是压缩失败
		if (originalCopy)
		{
			const std::string& srcImageName = resource.srcFilePath;
			std::string dstImageName = config.exportPath + imageName;

			bool result = false;
			ImageLoader& imageLoader = ImageLoader::getSingleton();
			if (imageLoader.load(srcImageName, isNormalMap))
			{
				if (config.imageCompressionType == CT_PNG)
					ImageLoader::getSingleton().saveAsPNG();
				else
				if (config.imageCompressionType == CT_TGA)
					ImageLoader::getSingleton().saveAsTGA();

				result = imageLoader.save(dstImageName);
				if (!result)
					result = TRUE == CopyFile(srcImageName.c_str(), dstImageName.c_str(), FALSE);
			}

			if (!result)
				LogManager::getSingleton().logMessage(true, "Copy image failure: \"%s\" to \"%s\".", srcImageName.c_str(), dstImageName.c_str());
		}

		resource.rename = imageName;
	}

	// 更新纹理的贴图文件名
	for (auto& material : mMaterials)
	{
		// 遍历所有的纹理(包括序列帧)
		for (auto& textureSlot : material->textureSlots)
		{
			for (auto& frame : textureSlot->frames)
			{
				assert(bitmapMap.count(frame));
				auto& resource = bitmapMap[frame];

				// 更新名称
				frame = resource.rename;
			}
		}
	}
}


bool Analyzer::
getMapPath(MSTR& mapPath)
{
// 2010(包括)之前都是可以通过IPathConfigMgr::GetPathConfigMgr()->GetFullFilePath在路径设置列表中搜索文件
// 之后该接口被取消了, 换成使用IFileResolutionManager::GetFullFilePath(const TCHAR* filePath, MaxSDK::AssetManagement::AssetType assetType). 
// 通过接口可以从所有项目路径中搜索, 然后返回实际贴图路径
#if defined(MAX_RELEASE_R12_ALPHA) && MAX_RELEASE >= MAX_RELEASE_R12_ALPHA
	MSTR mstrFullFilePath = IFileResolutionManager::GetInstance()->GetFullFilePath(mapPath, MaxSDK::AssetManagement::kBitmapAsset);
#else
	MSTR mstrFullFilePath = IPathConfigMgr::GetPathConfigMgr()->GetFullFilePath(mapPath, false);
#endif

	bool result = !mstrFullFilePath.isNull();
	if (result)
		mapPath = mstrFullFilePath;
	else
		LogManager::getSingleton().logMessage(true, "Cannot find map: \"%s\".", mapPath);

	return result;
}


void Analyzer::
addMaterial(IGameMaterial* gameMaterial, const std::shared_ptr<oiram::Material>& oiramMaterial)
{
	// 在已有的材质中查找
	for (auto& materialPair : mMaterialMap)
	{
		auto& storageMaterial = materialPair.second;
		// 如果新材质与现有的材质属性相同
		if (materialComp(*storageMaterial, *oiramMaterial))
		{
			// 则直接使用现有的材质, 立即返回
			mMaterialMap.insert(std::make_pair(gameMaterial, storageMaterial));
			return;
		}
	}

	// 添加新材质
	mMaterialMap.insert(std::make_pair(gameMaterial, oiramMaterial));
}


// 位图
struct BitmapSlot
{
	std::string					name;		// 名称
	BitmapTex*					bitmapTex;	// 位图纹理
	oiram::Material::ColourOpEx	colourOpEx;	// color混合方式
	oiram::Material::AlphaOpEx	alphaOpEx;	// alpha混合方式
};

std::shared_ptr<oiram::Material> Analyzer::
dumpMaterialProperty(IGameMaterial* gameMaterial, const std::string& rootMaterialName)
{
	std::shared_ptr<oiram::Material> material(new oiram::Material);

	// 材质文件的名称 = 根材质的名称
	material->rootName = rootMaterialName;

	material->name = Mchar2Ansi(gameMaterial->GetMaterialName());
	material->name = UniqueNameGenerator::getSingleton().generate(material->name, "material", true, true);

	LogManager::getSingleton().logMessage(false, "Exporting: %s", material->name.c_str());

	// 取出漫反射颜色
	IGameProperty* p = gameMaterial->GetDiffuseData();
	if (p && p->GetType() == IGAME_POINT3_PROP)
	{
		Point3 diffuse;
		p->GetPropertyValue(diffuse);

		// 纯白的不需要导出
		if (diffuse.Equals(Point3(1, 1, 1)))
			material->diffuseColourEnable = false;
		else
			material->diffuseColour.set(diffuse.x, diffuse.y, diffuse.z, 1.0f);
	}

	// 透明度
	p = gameMaterial->GetOpacityData();
	if (p && p->GetType() == IGAME_FLOAT_PROP)
	{
		float opacity = 0.0f;
		p->GetPropertyValue(opacity);

		if (material->diffuseColourEnable)
			material->diffuseColour.w = opacity;
	}

	// 取出高光颜色
	p = gameMaterial->GetSpecularData();
	if (p && p->GetType() == IGAME_POINT3_PROP)
	{
		Point3 specular;
		p->GetPropertyValue(specular);

		// 纯黑的不需要导出
		if (specular.Equals(Point3(0, 0, 0)))
			material->specularColourEnable = false;
		else
			material->specularColour.set(specular.x, specular.y, specular.z, 100.0f);
	}

	// 光泽度
	p = gameMaterial->GetGlossinessData();
	if (p && p->GetType() == IGAME_FLOAT_PROP)
	{
		float glossiness = 0.0f;
		p->GetPropertyValue(glossiness);

		if (material->specularColourEnable)
			material->specularColour.w = glossiness * 255.0f;
	}

	// 取出自发光颜色
	p = gameMaterial->GetEmissiveData();
	if (p && p->GetType() == IGAME_POINT3_PROP)
	{
		Point3 emissive;
		p->GetPropertyValue(emissive);

		// 纯黑不需要导出
		if (emissive.Equals(Point3(0,0,0)))
			material->emissiveColourEnable = false;
		else
			material->emissiveColour.set(emissive.x, emissive.y, emissive.z, 1.0f);
	}

	// 处理双面材质和纹理
	Mtl* maxMaterial = gameMaterial->GetMaxMaterial();
	Class_ID mtlClassID = maxMaterial->ClassID();
	if (mtlClassID == Class_ID(DMTL_CLASS_ID, 0))
	{
		StdMat2* maxStdMaterial = static_cast<StdMat2*>(maxMaterial);

		// 双面材质
		material->twoSided = maxStdMaterial->GetTwoSided() == TRUE;
		// 光照模型
		material->phongShading = !maxStdMaterial->IsFaceted();

		// 支持3dmax贴图: mix, normal, standard, ifl
		int numTexMaps = gameMaterial->GetNumberOfTextureMaps();
		for (int texMapIdx = 0; texMapIdx < numTexMaps; ++texMapIdx)
		{
			IGameTextureMap* gameTexMap = gameMaterial->GetIGameTextureMap(texMapIdx);
			int mapSlot = gameTexMap->GetStdMapSlot();
			/*
				  - ID_AM - Ambient (value 0)
				  - ID_DI - Diffuse (value 1)
				  - ID_SP - Specular (value 2)
				  - ID_SH - Shininess (value 3). In R3 and later this is called Glossiness.
				  - ID_SS - Shininess strength (value 4). In R3 and later this is called Specular Level.
				  - ID_SI - Self-illumination (value 5)
				  - ID_OP - Opacity (value 6)
				  - ID_FI - Filter color (value 7)
				  - ID_BU - Bump (value 8)
				  - ID_RL - Reflection (value 9)
				  - ID_RR - Refraction (value 10)
				  - ID_DP - Displacement (value 11)
			*/

			// 没有enable的slot不需要处理
			if (gameTexMap &&
				(mapSlot == ID_SS ||	// workaround: IDSS在检查MapEnabled无法通过
				maxStdMaterial->MapEnabled(mapSlot)))
			{
				// 得到Texmap和对应类型
				Texmap* texMap = gameTexMap->GetMaxTexmap();
				Class_ID texClassID = texMap->ClassID();
				std::vector<BitmapSlot> szBitmapSlots;

				// 混合贴图处理
				if (texClassID == mixClassID)
				{
					Mix* mix = static_cast<Mix*>(texMap);
					Texmap* layerMap0 = mix->GetSubTexmap(0);
					Texmap* layerMap1 = mix->GetSubTexmap(1);
					Texmap* mixMap = mix->GetSubTexmap(2);
					assert(layerMap0 && layerMap1 && mixMap);
					IParamBlock2* paramBlock = mix->GetParamBlock(0);
					if (paramBlock &&
						paramBlock->GetInt(Mix::mix_map1_on) && layerMap0 &&
						paramBlock->GetInt(Mix::mix_map2_on) && layerMap1 &&
						paramBlock->GetInt(Mix::mix_mask_on) && mixMap)
					{
						BitmapTex* bitmapLayer0 = static_cast<BitmapTex*>(layerMap0);
						BitmapTex* bitmapLayer1 = static_cast<BitmapTex*>(layerMap1);
						BitmapTex* bitmapMix = static_cast<BitmapTex*>(mixMap);

						// 混合图必须是使用alpha通道进行混合
						bool alphaAsMono = bitmapMix->GetAlphaAsMono(TRUE) == TRUE;
						if (alphaAsMono)
						{
							bool sameBitmap = (MSTR(bitmapMix->GetMapName()) == MSTR(bitmapLayer1->GetMapName())) != 0;
							// 如果混合图与第二层图相同, 并且是勾选的alphaAsMono, 则只用输出2张贴图
							if (sameBitmap)
							{
								BitmapSlot mixLayer0Map = { "mixLayer0Map", bitmapLayer0, 
									{ oiram::Material::Op_Source1, oiram::Material::Src_Texture, oiram::Material::Src_Current },
									{ oiram::Material::Op_Default, oiram::Material::Src_Texture, oiram::Material::Src_Current } };
								szBitmapSlots.push_back(mixLayer0Map);

								BitmapSlot mixLayer1Map = { "mixLayer1Map", bitmapLayer1, 
									{ oiram::Material::Op_Blend_Texture_Alpha, oiram::Material::Src_Texture, oiram::Material::Src_Current },
									{ oiram::Material::Op_Default, oiram::Material::Src_Texture, oiram::Material::Src_Current } };
								szBitmapSlots.push_back(mixLayer1Map);

								BitmapSlot mixOperationMap = { "mixOperation", nullptr,
									{ oiram::Material::Op_Modulate, oiram::Material::Src_Current, oiram::Material::Src_Diffuse },
									{ oiram::Material::Op_Modulate, oiram::Material::Src_Current, oiram::Material::Src_Diffuse } };
								szBitmapSlots.push_back(mixOperationMap);
							}
							else
							{
								BitmapSlot mixLayer0Map = { "mixLayer0Map", bitmapLayer0,
									{ oiram::Material::Op_Source1, oiram::Material::Src_Texture, oiram::Material::Src_Current },
									{ oiram::Material::Op_Default, oiram::Material::Src_Texture, oiram::Material::Src_Current } };
								szBitmapSlots.push_back(mixLayer0Map);

								BitmapSlot mixMap = { "mixMap", bitmapMix,
									{ oiram::Material::Op_Blend_Texture_Alpha, oiram::Material::Src_Texture, oiram::Material::Src_Current },
									{ oiram::Material::Op_Source1, oiram::Material::Src_Texture, oiram::Material::Src_Current } };
								szBitmapSlots.push_back(mixMap);

								BitmapSlot mixLayer1Map = { "mixLayer1Map", bitmapLayer1,
									{ oiram::Material::Op_Blend_Current_Alpha, oiram::Material::Src_Texture, oiram::Material::Src_Current },
									{ oiram::Material::Op_Default, oiram::Material::Src_Current, oiram::Material::Src_Current } };
								szBitmapSlots.push_back(mixLayer1Map);

								BitmapSlot mixOperationMap = { "mixOperation", nullptr,
									{ oiram::Material::Op_Modulate, oiram::Material::Src_Current, oiram::Material::Src_Diffuse },
									{ oiram::Material::Op_Modulate, oiram::Material::Src_Current, oiram::Material::Src_Diffuse } };
								szBitmapSlots.push_back(mixOperationMap);
							}
						}
						else
						{
							LogManager::getSingleton().logMessage(false, "warning: mono channel of mix amount map need output as alpha.");
						}
					}
				}
				else
				// NormalMap贴图处理
				if (texClassID == GNORMAL_CLASS_ID)
				{
					Gnormal* gnormal = static_cast<Gnormal*>(texMap);
					IParamBlock2* paramBlock = gnormal->GetParamBlock(0);
					if (paramBlock && paramBlock->GetInt(Gnormal::gn_map1on))
					{
						Texmap* normalMap = gnormal->GetSubTexmap(0);
						assert(normalMap);
						if (normalMap)
						{
							BitmapTex* bitmapTex = static_cast<BitmapTex*>(normalMap);
							assert(bitmapTex);
							if (bitmapTex)
							{
								BitmapSlot bitmapSlot = { "normalMap", bitmapTex,
									{ oiram::Material::Op_Default, oiram::Material::Src_Current, oiram::Material::Src_Texture },
									{ oiram::Material::Op_Default, oiram::Material::Src_Current, oiram::Material::Src_Texture } };
								szBitmapSlots.push_back(bitmapSlot);
							}
						}
					}
				}
				else
				// 普通贴图处理
				if (texClassID == Class_ID(BMTEX_CLASS_ID, 0))
				{
					BitmapTex* bitmapTex = static_cast<BitmapTex*>(texMap);
					assert(bitmapTex);
					if (bitmapTex)
					{
						BitmapSlot bitmapSlot = { "diffuseMap", bitmapTex,
							{ oiram::Material::Op_Default, oiram::Material::Src_Current, oiram::Material::Src_Texture },
							{ oiram::Material::Op_Default, oiram::Material::Src_Current, oiram::Material::Src_Texture } };
						szBitmapSlots.push_back(bitmapSlot);
					}
				}

				// 遍历所有位图
				for (auto& bitmapSlot : szBitmapSlots)
				{
					// 指针为nullptr代表这一层纹理仅作计算用
					if (bitmapSlot.bitmapTex == nullptr)
					{
						std::unique_ptr<oiram::Material::TextureSlot> textureSlot(new oiram::Material::TextureSlot);
						textureSlot->name = bitmapSlot.name;
						textureSlot->texunit = oiram::Material::TU_Operation;
						textureSlot->colourOpEx = bitmapSlot.colourOpEx;
						textureSlot->alphaOpEx = bitmapSlot.alphaOpEx;
						textureSlot->frames.clear();
						textureSlot->frameTime = 1.0f;
						material->textureSlots.push_back(std::move(textureSlot));
					}
					else
					{
						MSTR mstrTexturePath = bitmapSlot.bitmapTex->GetMapName();
						// 是否存在有贴图, 贴图文件定位
						if (getMapPath(mstrTexturePath))
						{
							std::unique_ptr<oiram::Material::TextureSlot> textureSlot(new oiram::Material::TextureSlot);

							textureSlot->frameTime = 1.0f;
							// 取得纹理的信息
							std::vector<std::string> frames;
							BitmapInfo bi;
							TheManager->GetImageInfo(&bi, mstrTexturePath);

							// 如果是序列帧纹理
							int idx = mstrTexturePath.first('.');
							MCHAR* ext = nullptr;
							if (idx != -1)
								ext = mstrTexturePath.data() + idx + 1;
							if (bi.NumberFrames() > 0 &&
								ext && _tcscmp(ext, _T("ifl")) == 0)
							{
								textureSlot->frameTime = config.framePerSecond / bitmapSlot.bitmapTex->GetPlaybackRate();

								// 得到所在目录
								MSTR path = mstrTexturePath.Substr(0, mstrTexturePath.last(_T('\\')) + 1);
								// ifl文件以\n为单位区分各帧纹理
								std::ifstream fs(mstrTexturePath);
								std::string line;
								while (std::getline(fs, line))
								{
									// 要求查找程序也在指定目录中搜索
									MSTR mstrFrame = Ansi2Mstr(line);
									getMapPath(mstrFrame);
									textureSlot->frames.push_back(Mstr2Ansi(mstrFrame));
								}
							}
							else
								textureSlot->frames.push_back(Mstr2Ansi(mstrTexturePath));

							textureSlot->texunit = oiram::Material::TU_Unknow;
							textureSlot->mapChannel = bitmapSlot.bitmapTex->GetMapChannel();
							textureSlot->colourOpEx = bitmapSlot.colourOpEx;
							textureSlot->alphaOpEx = bitmapSlot.alphaOpEx;

							// 记录uv变换矩阵
							{
								Texmap* texmap = gameTexMap->GetMaxTexmap();

								std::unique_ptr<oiram::Material::UVCoordinate> uvCoordinate(new oiram::Material::UVCoordinate);

								// UV镜像
								int textureTiling = texmap->GetTextureTiling();
								if (textureTiling & U_MIRROR)
									uvCoordinate->u_mode = oiram::Material::mirror;
								else
								if (textureTiling & U_WRAP)
									uvCoordinate->u_mode = oiram::Material::wrap;
								else
									uvCoordinate->u_mode = oiram::Material::clamp;

								if (textureTiling & V_MIRROR)
									uvCoordinate->v_mode = oiram::Material::mirror;
								else
								if (textureTiling & V_WRAP)
									uvCoordinate->v_mode = oiram::Material::wrap;
								else
									uvCoordinate->v_mode = oiram::Material::clamp;

								// 经验证IGameUVGen::GetUVTransform()有bug, 估计是做了swap(y, z); z = -z;的操作
								// 但实际上uvgen并不是像max坐标系那样z朝上和y朝里, 所以是不需要做上述变换的
								// 所以直接用sdk中的Texmap::GetUVTransform反而是正确的
								Matrix3 uvtrans(TRUE);
								texmap->GetUVTransform(uvtrans);
								uvCoordinate->transform = fromGMatrix(GMatrix(uvtrans));
								material->uvCoordinateMap.insert(std::make_pair(textureSlot->mapChannel, std::move(uvCoordinate)));
							}

							int alphaSource = bitmapSlot.bitmapTex->GetAlphaSource();
							switch (mapSlot)
							{
							case ID_DI: // Diffuse Map
								textureSlot->name = bitmapSlot.name;
								textureSlot->texunit = oiram::Material::TU_DiffuseMap;
								material->diffuseColourEnable = false;
								break;

							case ID_SP: // Specular Level Map/Specular Map, 因为specular = specular map color * specular level, 所以一视同仁
							case ID_SS:
								textureSlot->name = "specularMap";
								textureSlot->texunit = oiram::Material::TU_SpecularMap;
								material->specularColourEnable = false;
								break;

							case ID_SI: // Self Illumination Map
								textureSlot->name = "emissiveMap";
								textureSlot->texunit = oiram::Material::TU_EmissiveMap;
								material->emissiveColourEnable = false;
								break;

							case ID_OP: // Opacity Map
								// 透明贴图只设置渲染状态, 不必导出贴图(与diffuseMap重复了), 贴图必须有Alpha通道
								if (alphaSource == ALPHA_FILE)
								{
									// 移动平台上没有alphaTest, 而且使用alpha blend效率也远高于discard
									if (config.mobilePlatform)
										material->alphaBlend = true;
									else
									{
										// 根据"预乘Alpha"决定是AlphaBlend还是AlphaTest
										if (bitmapSlot.bitmapTex->GetPremultAlpha(TRUE))
										{
											material->alphaTest = true;
										}
										else
										{
											material->alphaBlend = true;
										}
									}
								}
								else if (alphaSource == ALPHA_RGB)
								{
									// 没有alpha通道, 认为是以RGB方式Add
									material->addBlend = true;
								}
								continue;

							case ID_BU:	// Bump/Normal Map
								textureSlot->name = "normalMap";
								textureSlot->texunit = oiram::Material::TU_NormalMap;
								break;

							case ID_RL:	// Reflection Map
								textureSlot->name = "reflectionMap";
								textureSlot->texunit = oiram::Material::TU_ReflectionMap;
								break;

							default:
								continue;
							}

							bool dumpTextureSlot = true;
							// 固定管线只导出diffuseMap
							if (config.renderingType == RT_FixedFunction)
								dumpTextureSlot = mapSlot == ID_DI;
							
							if (dumpTextureSlot)
								material->textureSlots.push_back(std::move(textureSlot));
						}
					}
				}
			}
		}
	}

	return material;
}
