#ifndef _Log_Message_Dialog_hpp__
#define _Log_Message_Dialog_hpp__

#include <windows.h>

namespace LogMessageDialog
{
	const DWORD WM_LOG_MESSAGE = WM_USER + 1,
				WM_SET_PROGRESS = WM_USER + 2,
				WM_INITIALIZE = WM_USER + 3,
				WM_UNINITIALIZE = WM_USER + 4;

	extern HWND mDialog;

	void CreateLogMessageDialog(HINSTANCE hInstance, HWND hWndParent);
	void DestroyLogMessageDialog();
}

#endif
