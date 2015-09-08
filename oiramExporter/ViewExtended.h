#ifndef _View_Extended_hpp__
#define _View_Extended_hpp__

#include <maxapi.h> 
#include <atomic>
#include <thread>

namespace oiram
{
	class RenderSystem;
}

class ViewExtended : public ViewWindow
{
public:
	ViewExtended();
	virtual ~ViewExtended();

	HWND					GetHwnd()const { return mWnd; }

	oiram::RenderSystem*	GetRenderSystem()const { return mRenderSystem; }
	void					RefreshScene();
	void					SetEnableTracing(bool enable) { mEnableTracing = enable; }
	void					TraceActiveViewport();

	void					RenderScene();
	void					ExportScene();

private:
	TCHAR*					GetName() { return _T("oiramExport Viewport"); }
	HWND					CreateViewWindow(HWND hParent, int x, int y, int w, int h);
	void					DestroyViewWindow(HWND hWnd);
	BOOL					CanCreate() { return TRUE; }
	int						NumberCanCreate() { return -1; }

private:
	HWND					mWnd;
	HINSTANCE				mInstance;

	std::thread				mRenderThread;
	std::atomic<bool>		mRenderThreadRunning;
	std::atomic<oiram::RenderSystem*>	mRenderSystem;

	std::thread				mExportThread;
	std::atomic<bool>		mSceneUpdated;

	std::atomic<bool>		mEnableTracing;
};

#endif
