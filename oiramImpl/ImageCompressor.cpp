#include "stdafx.h"
#include "ImageCompressor.h"
#include <nvtt/nvtt.h>
#include "pvrtc/PVRTexture.h"
#include "pvrtc/PVRTextureUtilities.h"
#include "ImageLoader.h"

#pragma comment(lib, "PVRTexLib.lib")
#pragma comment(lib, "nvtt.lib")

namespace ImageCompressor
{
	bool compressorNVTT(const std::string& compressionImageName, unsigned int width, unsigned int height, unsigned char* data, 
		bool hasAlpha, bool isNormalMap, bool isLightMap, int compressionQuality, bool generationMipmaps)
	{
		nvtt::InputOptions			inputOptions;		// 输入选项
		nvtt::OutputOptions			outputOptions;		// 输出选项
		nvtt::CompressionOptions	compressionOptions;	// 压缩选项
		nvtt::Compressor			compressor;			// 压缩器

		// 最多的加速, 合适的质量
		nvtt::Quality quality = nvtt::Quality_Normal;
		switch (compressionQuality)
		{
		case 0:
			quality = nvtt::Quality_Fastest;
			break;

		default:
		case 1:
			quality = nvtt::Quality_Normal;
			break;

		case 2:
			quality = nvtt::Quality_Highest;
			break;
		}
		// 选择压缩精度
		compressionOptions.setQuality(quality);

		inputOptions.setTextureLayout(nvtt::TextureType_2D, width, height);
		inputOptions.setMipmapData(data, width, height);
		inputOptions.setNormalMap(isNormalMap);
		inputOptions.setNormalizeMipmaps(isNormalMap);

		// 生成mipmaps
		if (generationMipmaps)
		{
			inputOptions.setMipmapFilter(nvtt::MipmapFilter_Kaiser);
			inputOptions.setMipmapGeneration(true);
		}

		outputOptions.setFileName(compressionImageName.c_str());

		// 默认dxt1
		nvtt::Format nvttDxtFormat = nvtt::Format_DXT1;
		// normalMap使用dxt5n, a和g的bits分别是8和6
		if (isNormalMap)
			nvttDxtFormat = nvtt::Format_DXT5n;
		else
		{
			// 有alpha并且不是lightmap就使用dxt5, 否则使用dxt1
			if (hasAlpha && !isLightMap)
				nvttDxtFormat = nvtt::Format_DXT5;
			else
				nvttDxtFormat = nvtt::Format_DXT1;
		}
		compressionOptions.setFormat(nvttDxtFormat);

		// 尝试开启CUDA加速
		compressor.enableCudaAcceleration(true);

		// 压缩纹理
		if (compressor.process(inputOptions, compressionOptions, outputOptions))
			return true;

		return false;
	}


	bool compressorPVRT(const std::string& compressionImageName, unsigned int width, unsigned int height, unsigned char* data, 
		CompressionType compressionType, bool hasAlpha, bool isNormalMap, bool isLightMap, int compressionQuality, bool generationMipmaps)
	{
		pvrtexture::ECompressorQuality eQuality;
		EPVRTPixelFormat ePixelFormat;
		switch (compressionType)
		{
		case CT_PVRTC2_4BPP:
			switch (compressionQuality)
			{
			case 0:
				eQuality = pvrtexture::ePVRTCFast;
				break;

			default:
			case 1:
				eQuality = pvrtexture::ePVRTCNormal;
				break;

			case 2:
				eQuality = pvrtexture::ePVRTCBest;
				break;
			}
			ePixelFormat = ePVRTPF_PVRTCII_4bpp;
			break;

		case CT_ETC1:
		case CT_ETC2:
			switch (compressionQuality)
			{
			case 0:
				eQuality = pvrtexture::eETCFast;
				break;

			default:
			case 1:
				eQuality = pvrtexture::eETCFast;
				break;

			case 2:
				eQuality = pvrtexture::eETCSlow;
				break;
			}
			if (compressionType == CT_ETC1)
			{
				ePixelFormat = ePVRTPF_ETC1;
			}
			else if (compressionType == CT_ETC2)
			{
				if (isLightMap)
				{
					ePixelFormat = ePVRTPF_ETC2_RGB;
				}
				else
				{
					if (isNormalMap)
						ePixelFormat = ePVRTPF_EAC_RG11;
					else
						ePixelFormat = hasAlpha ? ePVRTPF_ETC2_RGBA : ePVRTPF_ETC2_RGB;
				}
			}
			break;

		default:
			break;
		}

		pvrtexture::CPVRTextureHeader header(pvrtexture::PVRStandard8PixelType.PixelTypeID, height, width);
		pvrtexture::CPVRTexture texture(header, data);

		// PVRTC的rgb模式下r和g的bits最大, 分别是5和5, 使用swizzle技法: xy = rg, ETC1没有alpha
		if (isNormalMap &&
			compressionType != CT_ETC1)
		{
			pvrtexture::CPVRTexture swizzleTexture(header);
			pvrtexture::EChannelName	szChannel[2] = { pvrtexture::eRed, pvrtexture::eGreen }, 
										szChannelSource[2] = { pvrtexture::eRed, pvrtexture::eGreen };
			pvrtexture::CopyChannels(swizzleTexture, texture, 2, szChannel, szChannelSource);
			texture = swizzleTexture;
		}

		// 生成mipmaps
		bool result = false;
		if (generationMipmaps)
			result = pvrtexture::GenerateMIPMaps(texture, pvrtexture::eResizeCubic, PVRTEX_ALLMIPLEVELS);

		if (result)
		{
			pvrtexture::PixelType ptFormat(ePixelFormat);
			if (pvrtexture::Transcode(texture, ptFormat, ePVRTVarTypeUnsignedByteNorm, ePVRTCSpacelRGB, eQuality, false))
				result = texture.saveFile(compressionImageName.c_str());
		}

		return result;
	}


	bool compress(CompressionType compressionType, const std::string& srcImageName, const std::string& dstImageName, 
		bool isNormalMap, bool isLightMap, int compressionQuality, bool generationMipmaps)
	{
		ImageLoader& imageLoader = ImageLoader::getSingleton();
		if (imageLoader.load(srcImageName, isNormalMap))
		{
			imageLoader.compatible();

			unsigned int	width = imageLoader.width(), 
							height = imageLoader.height();
			unsigned char*	data = imageLoader.data();
			bool hasAlpha = imageLoader.hasAlpha();
			// 设置输出的图片后缀
			std::string compressionImageName = dstImageName;

			if (compressionType == CT_DXTC)
			{
				compressionImageName += ".dds";
				return compressorNVTT(compressionImageName, width, height, data, hasAlpha, isNormalMap, isLightMap, compressionQuality, generationMipmaps);
			}
			else
			{
				if (compressionType == CT_ETC1 || compressionType == CT_ETC2)
					compressionImageName += ".ktx";
				else if (compressionType == CT_PVRTC2_4BPP)
					compressionImageName += ".pvr";

				return compressorPVRT(compressionImageName, width, height, data, compressionType, hasAlpha, isNormalMap, isLightMap, compressionQuality, generationMipmaps);
			}
		}

		return false;
	}
}
