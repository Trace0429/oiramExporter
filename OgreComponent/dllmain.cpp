#include "stdafx.h"
#include "requisites.h"
#include "OgreSerializerComponent.h"
#include "OgreRenderSystemComponent.h"

HINSTANCE hInstance;

BOOL APIENTRY DllMain(HANDLE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	hInstance = (HINSTANCE)hModule;

	return TRUE;
}


extern "C" oiram::Serializer* createSerializer()
{
	return new oiram::OgreSerializer();
}

extern "C" void destroySerializer(oiram::Serializer* s)
{
	delete s;
}


extern "C" oiram::RenderSystem* createRenderSystem()
{
#ifdef NO_VIEW_EXTENDED
	return 0;
#else
	return new oiram::OgreRenderSystem();
#endif
}

extern "C" void destroyRenderSystem(oiram::RenderSystem* rs)
{
	delete rs;
}


extern "C" const char* componentName()
{
	static char name[] = "OgreComponent";
	return name;
}
