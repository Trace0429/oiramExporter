// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#if !defined(NOMINMAX) && defined(_MSC_VER)
#	define NOMINMAX // required to stop windows.h messing up std::min
#endif
#include <windows.h>

// TODO: reference additional headers your program requires here
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <sstream>
#include <math.h>

#ifndef NO_VIEW_EXTENDED
#include <Ogre.h>
#include <Overlay/OgreOverlaySystem.h>
#include <Overlay/OgreOverlayManager.h>
#include <Overlay/OgreOverlayElement.h>
#include <Overlay/OgreOverlay.h>
#endif
#define __TBB_NO_IMPLICIT_LINKAGE 1

#include <OgreMeshFileFormat.h>
#include <OgreSkeletonFileFormat.h>
#include <OgreHardwareVertexBuffer.h>
#include <OgreRenderOperation.h>

#include "zip.h"
#include "strutil.h"
