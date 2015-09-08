// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include <SDKDDKVer.h>

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#if !defined(NOMINMAX) && defined(_MSC_VER)
#	define NOMINMAX // required to stop windows.h messing up std::min
#endif
#include <windows.h>
#include <commdlg.h>

// TODO: reference additional headers your program requires here
#include <max.h>
#include <modstack.h>
#include <CS/Phyexp.h>
#include <iskin.h>
#include <IGame/IGame.h>
#include <IGame/IGameType.h>
#include <IGame/IGameObject.h> 
#include <IGame/IGameModifier.h>
#if defined(MAX_RELEASE_R12_ALPHA) && MAX_RELEASE >= MAX_RELEASE_R12_ALPHA
	#include <IFileResolutionManager.h>
#else
	#include <IPathConfigMgr.h>
#endif

#include "normalrender.h"
#include "mix.h"
#include "fogatmos.h"

#include <map>
#include <hash_map>
#include <set>
#ifndef _RC_INVOKED
#include <string>
#endif
#include <vector>
#include <stdio.h>
#include <iterator>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <functional>

#include "rapidxml.hpp"
#include "rapidxml_print.hpp"

#include <d3d9.h>
#include <d3dx9.h>

#include "FreeImage/FreeImage.h"
#include <nvtt/nvtt.h>
#include "pvrtc/PVRTexture.h"
#include "pvrtc/PVRTextureUtilities.h"

#include <PxPhysicsAPI.h>
