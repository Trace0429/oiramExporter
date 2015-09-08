#include "stdafx.h"
#if !defined(NOMINMAX) && defined(_MSC_VER)
#	define NOMINMAX // required to stop windows.h messing up std::min
#endif
#include "LogMessageDialog.h"
#include <winutil.h>
#include <richedit.h>
#include "res/resource.h"

namespace LogMessageDialog
{
	HWND mDialog = 0;

	INT_PTR CALLBACK LogMessageDialogFunction(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
	{
		switch(message)
		{
			case WM_INITDIALOG:
				{
					mDialog = hWnd;

					// 窗口居中, 初始化
					CenterWindow(hWnd, GetParent(hWnd));

					HWND hProgressbar = GetDlgItem(hWnd, IDC_PROGRESS);
					SendMessage(hProgressbar, PBM_SETRANGE, 0, MAKELPARAM(0, 100));
					SendMessage(hProgressbar, PBM_SETSTEP, (WPARAM)1, 0);
					EnableWindow(GetDlgItem(hWnd, IDOK), FALSE);
					SetFocus(GetDlgItem(hWnd, IDC_INFORMATION));
				}
				return TRUE;

			case WM_COMMAND:
				{
					if (LOWORD(wParam) == IDOK)
						EndDialog(hWnd, 1);
				}
				return TRUE;

			case WM_LOG_MESSAGE:
				{
					BOOL critical = (BOOL)wParam;
					HWND hMsg = GetDlgItem(hWnd, IDC_INFORMATION);
					CHARFORMAT2 cf2;
					ZeroMemory(&cf2, sizeof(CHARFORMAT2));
					cf2.cbSize = sizeof(CHARFORMAT2);
					cf2.yHeight = 188;
					cf2.dwMask = CFM_COLOR | CFM_BACKCOLOR | CFM_SIZE | CFM_BOLD;
					if (critical)
					{
						cf2.crTextColor = RGB(255, 255, 255);
						cf2.crBackColor = RGB(255, 0, 0);
					}
					else
					{
						cf2.crTextColor = RGB(0, 0, 0);
						cf2.crBackColor = RGB(255, 255, 255);
					}
					SendMessage(hMsg, EM_SETCHARFORMAT, SCF_SELECTION, (LPARAM)&cf2);
	
					// 添加消息
					SendMessage(hMsg, EM_SETSEL, -1, -1);
					SendMessage(hMsg, EM_REPLACESEL, FALSE, lParam); 
					SendMessage(hMsg, EM_REPLACESEL, FALSE, (LPARAM)"\r\n");
					SendMessage(hMsg, EM_SCROLL, 0, 0);
					SendMessage(hMsg, WM_PAINT, 0, 0);
				}
				break;

			case WM_SET_PROGRESS:
				{
					HWND hProgressbar = GetDlgItem(hWnd, IDC_PROGRESS);
					SendMessage(hProgressbar, PBM_SETPOS, wParam, lParam);
				}
				break;

			case WM_INITIALIZE:
				{
					SendMessage(GetDlgItem(hWnd, IDC_INFORMATION), WM_SETTEXT, NULL, (LPARAM)"");
					EnableWindow(GetDlgItem(hWnd, IDOK), FALSE);
					ShowWindow(hWnd, SW_SHOW);
				}
				break;

			case WM_UNINITIALIZE:
				{
					// 进度设置为100
					SendMessage(GetDlgItem(hWnd, IDC_PROGRESS), PBM_SETPOS, (WPARAM)100, 0);
					// 激活OK按钮
					EnableWindow(GetDlgItem(hWnd, IDOK), TRUE);
				}
				break;
		}

		return FALSE;
	}


	void CreateLogMessageDialog(HINSTANCE hInstance, HWND hWndParent)
	{
		mDialog = CreateDialogParam(hInstance, MAKEINTRESOURCE(IDD_INFORMATION), hWndParent, LogMessageDialogFunction, 0);
	}

	void DestroyLogMessageDialog()
	{
		DestroyWindow(mDialog);
		mDialog = 0;
	}
}