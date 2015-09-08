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
#include <iparamb2.h>
#include <guplib.h>
#include <notify.h>
#include <ifnpub.h>

#undef fmax
#undef fmin
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <algorithm>
#include <iomanip>
#include <sstream>

#include <string>
#include <map>
#include <vector>

#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include "strutil.h"

#include <atomic>
#include <thread>
