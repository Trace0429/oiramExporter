#ifndef _Image_Compressor_hpp__
#define _Image_Compressor_hpp__

#include "requisites.h"

//  π”√NVTT—πÀıDXTC, PVRTexLib—πÀıETC/PVRTC
namespace ImageCompressor
{
	bool compress(CompressionType compressionType, const std::string& srcImageName, const std::string& dstImageName, 
		bool isNormalMap, bool isLightMap, int compressionQuality, bool generationMipmaps);
};

#endif
