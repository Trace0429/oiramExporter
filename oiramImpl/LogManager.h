#ifndef _LogManager_hpp__
#define _LogManager_hpp__

#include <string>
#include <Windows.h>

// 日志信息
class LogManager
{
public:
	static LogManager& getSingleton();

	~LogManager();
	
	void initialize(const std::string& logFileName, HWND hDlg);
	void uninitialize();
	
	void logMessage(bool critical, const char* format, ...);
	void setProgress(int progress);

private:
	LogManager() {}
	
private:
	HWND			mDialog;		// 对话框句柄
	std::string		mLogFileName;	// 文件名
	unsigned long	mUsedTime;		// 消耗的时间
};

#endif
