#include "stdafx.h"
#include "ImageLoader.h"
#include "requisites.h"

ImageLoader::
ImageLoader()
: mDIB(0), mFormat(FIF_UNKNOWN)
{
	FreeImage_Initialise();
}


ImageLoader::
~ImageLoader()
{
	FreeImage_Unload(mDIB);
	FreeImage_DeInitialise();
}


ImageLoader& ImageLoader::
getSingleton()
{
	static ImageLoader msSingleton;
	return msSingleton;
}


inline unsigned int nextPowerOfTwo(unsigned int x)
{
	assert( x != 0 );
#if 1	// On modern CPUs this is supposed to be as fast as using the bsr instruction.
	x--;
	x |= x >> 1;
	x |= x >> 2;
	x |= x >> 4;
	x |= x >> 8;
	x |= x >> 16;
	return x + 1;	
#else
	unsigned int p = 1;
	while( x > p ) {
		p += p;
	}
	return p;
#endif
}

/// Return true if @a n is a power of two.
inline bool isPowerOfTwo(unsigned int n)
{
	return (n & (n - 1)) == 0;
}

// 1 -> 1, 2 -> 2, 3 -> 2, 4 -> 4, 5 -> 4, ...
inline unsigned int previousPowerOfTwo(unsigned int v)
{
	return nextPowerOfTwo(v + 1) / 2;
}

inline unsigned int nearestPowerOfTwo(unsigned int v)
{
	const unsigned int np2 = nextPowerOfTwo(v);
	const unsigned int pp2 = previousPowerOfTwo(v);

	if (np2 - v <= v - pp2)
	{
		return np2;
	}
	else
	{
		return pp2;
	}
}

inline unsigned int nearestMultiplesOfFour(unsigned int v)
{
	return ((v + 2) >> 2) << 2;
}

/// INPLACESWAP adopted from codeguru.com 
template <class T> void INPLACESWAP(T& a, T& b) {
	a ^= b; b ^= a; a ^= b;
}

bool ImageLoader::
load(const std::string& imageName, bool isNormalMap)
{
	// 载入图片
	FREE_IMAGE_FORMAT fif = FreeImage_GetFileType(imageName.c_str());
	if((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif))
	{
		if (mDIB)
			FreeImage_Unload(mDIB);
		mDIB = FreeImage_Load(fif, imageName.c_str());
		mFormat = fif;

		bool needScale = !oiram::fequal(config.imageScale, 1.0f);
		unsigned int newWidth = width(), newHeight = height(), newBpp = bpp();
		bool imagePowerOfTwo = config.imagePowerOfTwo;
		unsigned int imageMaxSize = config.imageMaxSize;

		// PVRTCII支持non-POT; ETC1和ETC2必须是POT, 最大尺寸限定在2048, 而且必须是正方形
		if (config.imageCompressionType == CT_ETC1 ||
			config.imageCompressionType == CT_ETC2)
		{
			imagePowerOfTwo = true;
			imageMaxSize = 2048;
		}

		// DXTC/PVRTC/ETCI有最小尺寸限制
		switch (config.imageCompressionType)
		{
		case CT_DXTC:
			if (newWidth < DXT_MIN_TEXWIDTH)
			{
				newWidth = DXT_MIN_TEXWIDTH;
				needScale = true;
			}
			if (newHeight < DXT_MIN_TEXHEIGHT)
			{
				newHeight = DXT_MIN_TEXHEIGHT;
				needScale = true;
			}
			// DXTC的尺寸必须是4的倍数
			{
				unsigned int	multiplesOfFourWidth = nearestMultiplesOfFour(newWidth),
								multiplesOfFourHeight = nearestMultiplesOfFour(newHeight);
				if (newWidth != multiplesOfFourWidth)
				{
					newWidth = multiplesOfFourWidth;
					needScale = true;
				}
				if (newHeight != multiplesOfFourHeight)
				{
					newHeight = multiplesOfFourHeight;
					needScale = true;
				}
			}
			break;

		case CT_ETC1:
		case CT_ETC2:
			if (newWidth < ETC_MIN_TEXWIDTH)
			{
				newWidth = ETC_MIN_TEXWIDTH;
				needScale = true;
			}
			if (newHeight < ETC_MIN_TEXHEIGHT)
			{
				newHeight = ETC_MIN_TEXHEIGHT;
				needScale = true;
			}
			break;

		case CT_PVRTC2_4BPP:
			if (newWidth < PVRTC4_MIN_TEXWIDTH)
			{
				newWidth = PVRTC4_MIN_TEXWIDTH;
				needScale = true;
			}
			if (newHeight < PVRTC4_MIN_TEXHEIGHT)
			{
				newHeight = PVRTC4_MIN_TEXHEIGHT;
				needScale = true;
			}
			break;
		}

		// 超出最大尺寸则按比例缩放
		if (imageMaxSize > 0 &&
			(newWidth > imageMaxSize || newHeight > imageMaxSize))
		{
			if (newWidth > newHeight)
			{
				float scale = static_cast<float>(newWidth) / newHeight;
				newWidth = imageMaxSize;
				newHeight = static_cast<unsigned int>(newWidth / scale);
			}
			else
			{
				float scale = static_cast<float>(newHeight) / newWidth;
				newHeight = imageMaxSize;
				newWidth = static_cast<unsigned int>(newHeight / scale);
			}
			needScale = true;
		}

		newWidth = static_cast<unsigned int>(newWidth * config.imageScale);
		newHeight = static_cast<unsigned int>(newHeight * config.imageScale);

		if (imagePowerOfTwo)
		{
			unsigned int potWidth = nearestPowerOfTwo(newWidth), potHeight = nearestPowerOfTwo(newHeight);
			if (newWidth != potWidth || newHeight != potHeight)
			{
				newWidth = potWidth;
				newHeight = potHeight;
				needScale = true;
			}
		}

		if (needScale)
		{
			FIBITMAP* rescaleDIB = FreeImage_Rescale(mDIB, newWidth, newHeight, FILTER_LANCZOS3);
			FreeImage_Unload(mDIB);
			mDIB = rescaleDIB;
		}

		return true;
	}

	return false;
}


bool ImageLoader::
save(const std::string& imageName)
{
	return FreeImage_Save(mFormat, mDIB, imageName.c_str()) == TRUE;
}


unsigned int ImageLoader::
width()const
{
	return FreeImage_GetWidth(mDIB);
}


unsigned int ImageLoader::
height()const
{
	return FreeImage_GetHeight(mDIB);
}


unsigned int ImageLoader::
bpp()const
{
	return FreeImage_GetBPP(mDIB);
}


unsigned char* ImageLoader::
data()const
{
	return FreeImage_GetBits(mDIB);
}


bool ImageLoader::
hasAlpha()const
{
	return FreeImage_GetColorType(mDIB) == FIC_RGBALPHA;
}


void ImageLoader::
compatible()
{
	// BITMAP数据是从下往上的, 需要翻转
	FreeImage_FlipVertical(mDIB);

	// FreeImage是BGR顺序, 与NVTT要求的一致, 而PVRT需要RGB顺序, 两者都需要32bits数据
	if (config.imageCompressionType != CT_DXTC)
	{
		// 将BGR改为RGB, 交换R channel和B channel
		const unsigned bytesperpixel = FreeImage_GetBPP(mDIB) / 8;
		const unsigned height = FreeImage_GetHeight(mDIB);
		const unsigned pitch = FreeImage_GetPitch(mDIB);
		const unsigned lineSize = FreeImage_GetLine(mDIB);

		BYTE* line = FreeImage_GetBits(mDIB);
		for (unsigned y = 0; y < height; ++y, line += pitch) {
			for (BYTE* pixel = line; pixel < line + lineSize; pixel += bytesperpixel) {
				INPLACESWAP(pixel[0], pixel[2]);
			}
		}
	}

	if (FreeImage_GetBPP(mDIB) != 32)
	{
		FIBITMAP* convertDIB = FreeImage_ConvertTo32Bits(mDIB);
		FreeImage_Unload(mDIB);
		mDIB = convertDIB;
	}
}


void ImageLoader::saveAsPNG()
{
	mFormat = FIF_PNG;
}


void ImageLoader::saveAsTGA()
{
	mFormat = FIF_TARGA;
}
