//-----------------------------------------------------------------------------
// ---------------------------
// File ....: maxnet_archive.h
// ---------------------------
// Author...: Gus J Grubba
// Date ....: February 2000
// O.S. ....: Windows 2000
//
// History .: Feb, 15 2000 - Created
//
// 3D Studio Max Network Rendering - Archival (The "*.maz" file)
// 
//-----------------------------------------------------------------------------

#pragma once

#if !defined( DOXYGEN ) && !defined( DOTNET_WRAPPER_GENERATOR )
//! \deprecated Deprecated in 3ds max 2013. There is no replacement for this file
#error Deprecated in 3ds max 2013. There is no replacement for this file

#include <WTypes.h>
#include "maxheap.h"
#include "strbasic.h"

//-----------------------------------------------
//-- Archives

#define NET_ARCHIVE_SIG			0x6612FE10
#define NET_ARCHIVE_SIG2		0x6612FE11
#define NET_ARCHIVE_EXT			_M(".zip")
#define NET_ARCHIVE_MAX_NAME	128

struct NET_ARCHIVE_HEADER: public MaxHeapOperators {
	DWORD	sig;
	int		count;
	MCHAR	reserved[64];
};

struct NET_ARCHIVE_LIST: public MaxHeapOperators {
	MCHAR	name[NET_ARCHIVE_MAX_NAME];
	DWORD	comp;
	DWORD	size,orig_size;
};
#endif


//-- EOF: maxnet_archive.h ----------------------------------------------------

