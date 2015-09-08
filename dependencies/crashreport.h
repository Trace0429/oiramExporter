#ifndef _Crash_Report_hpp__
#define _Crash_Report_hpp__

#include "CrashRpt/CrashRpt.h"

int CALLBACK CrashCallback(CR_CRASH_CALLBACK_INFO* pInfo)
{
	MessageBox(0, "crash report call back", "", MB_OK);
	return CR_CB_DODEFAULT;
}

inline void CrashInstall(TCHAR* appName, TCHAR* appVersion)
{
	CR_INSTALL_INFO info;
	memset(&info, 0, sizeof(CR_INSTALL_INFO));
	info.cb = sizeof(CR_INSTALL_INFO);
	info.pszAppName = appName;
	info.pszAppVersion = appVersion;
	info.pszEmailSubject = _T("crash report");
	info.pszEmailTo = _T("oiramario@gmail.com");
	info.pszErrorReportSaveDir = _T("./");
	info.dwFlags = CR_INST_ALL_POSSIBLE_HANDLERS | CR_INST_SEND_QUEUED_REPORTS | CR_INST_SHOW_ADDITIONAL_INFO_FIELDS;

	// Install crash handlers
	int nInstResult = crInstall(&info);
	assert(nInstResult == 0);

	crSetCrashCallback(CrashCallback, 0);
//	crAddScreenshot2(CR_AS_MAIN_WINDOW | CR_AS_USE_JPEG_FORMAT, 95);
}

inline void CrashUninstall()
{
	int nUninstRes = crUninstall();
	assert(nUninstRes == 0);
}

#endif
