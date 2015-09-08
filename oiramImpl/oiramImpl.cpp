#include "stdafx.h"
#include "Exporter.h"
#include "requisites.h"
#include "LogManager.h"
#include "serializer.h"
//#include "crashreport.h"

Config config;

__declspec(dllexport) bool oiramExport(const Config& exportConfig, HINSTANCE hInst, oiram::Serializer* serializer, bool exportSelected, HWND hLogDialog)
{
	//CrashInstall(_T("oiramExport"), _T("1.0"));

	config = exportConfig;

//	test
//	char* p = 0;
//	*p = 1;

	// 初始化Log
	LogManager& logMgr = LogManager::getSingleton();
	std::string logFileName = config.exportPath + config.maxName + ".log";
	logMgr.initialize(logFileName, hLogDialog);

	// 导出
	Exporter exporter(serializer);
	bool result = exporter.Export(exportSelected);

	logMgr.uninitialize();

	//CrashUninstall();

	return result;
}
