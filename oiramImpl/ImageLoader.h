#ifndef _Image_Loader_hpp__
#define _Image_Loader_hpp__

#include "FreeImage/FreeImage.h"

// FreeImageÕºœÒ‘ÿ»Î
class ImageLoader
{
public:
	~ImageLoader();

	static ImageLoader& getSingleton();

	bool			load(const std::string& imageName, bool isNormalMap);
	bool			save(const std::string& imageName);
	unsigned int	width()const;
	unsigned int	height()const;
	unsigned int	bpp()const;
	unsigned char*	data()const;
	bool			hasAlpha()const;

	void			compatible();

	void			saveAsPNG();
	void			saveAsTGA();

private:
	ImageLoader();

private:
	FIBITMAP*			mDIB;
	FREE_IMAGE_FORMAT	mFormat;
};

#endif
