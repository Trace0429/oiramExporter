#ifndef _Component_hpp__
#define _Component_hpp__

#include <windows.h>
#include <string>
#include <map>

namespace oiram
{
	class Serializer;
	class RenderSystem;
}

class Component
{
public:
	~Component();

	static Component& getSingleton();

	// max文件发生变化, 更新配置信息
	void					OnMaxFileModified();
	// 场景发生变化, 需要重新导出
	void					OnSceneModified();

	// 配置对话框
	bool					OptionDialog();
	// 导出
	bool					Export(bool exportSelected);
	// 重命名
	void					Rename(const MSTR& name);

	oiram::RenderSystem*	CreateRenderSystem();
	void					DestroyRenderSystem(oiram::RenderSystem* rendersystem);
	const std::string&		GetComponentName()const { return mComponentName; }
	const std::string&		GetComponentDirectory()const { return mComponentDirectory; }

private:
	Component();

	friend INT_PTR CALLBACK OptionDialogFunction(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

	void					LoadConfig();
	void					SaveConfig();

	bool					LoadImpl();
	void					UnloadImpl();

	bool					LoadComponent();
	void					UnloadComponent();

	float					GetUnitValue(int unitType);
	float					ConvertToMeter(int metricDisp, int unitType);
	float					UnitsConversion();

public:
	static const MCHAR		msComponentDirectory[];

private:
	HMODULE					mComponentModule;
	std::string				mComponentName;
	std::string				mComponentDirectory;

	oiram::Serializer*		mSerializer;

	typedef oiram::RenderSystem*(*oiramCreateRenderSystem)();
	oiramCreateRenderSystem	mCreateRenderSystem;

	HMODULE					mOiramImplModule;
	void*					mOiramExporter;

	bool					mSceneModified;
	MSTR					mRename;
};

#endif
