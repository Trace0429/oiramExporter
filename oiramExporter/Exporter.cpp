// Exporter.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "Exporter.h"
#include <notify.h>
#include "ViewExtended.h"
#include "Component.h"

static oiramExporterClassDesc msExporterDesc;
ClassDesc2* GetExporterClassDesc() { return &msExporterDesc; }

//--- Exporter -------------------------------------------------------
Exporter::Exporter()
:	mViewExtended(nullptr)
{
}

Exporter::~Exporter() 
{
}


// 当3dsmax场景文件发生变化时及时响应更新
static void ModifyNotify(void* param, NotifyInfo* info)
{
	Component& component = Component::getSingleton();

	component.OnSceneModified();

	switch(info->intcode)
	{
		case NOTIFY_SYSTEM_POST_RESET:
		case NOTIFY_SYSTEM_POST_NEW:
		case NOTIFY_FILE_POST_MERGE:
		case NOTIFY_FILE_POST_OPEN:
		case NOTIFY_FILE_OPEN_FAILED:
		case NOTIFY_POST_IMPORT:
		case NOTIFY_IMPORT_FAILED:
			component.OnMaxFileModified();
			break;

		case NOTIFY_FILE_POST_SAVE:
		case NOTIFY_FILE_POST_SAVE_OLD:
			break;
	}
}

DWORD Exporter::
Start()
{
	Interface* maxInterface = GetCOREInterface();

	// 创建并注册extended view
	mViewExtended = new ViewExtended;
	maxInterface->RegisterViewWindow(mViewExtended);

	RegisterNotification(ModifyNotify, 0, NOTIFY_SYSTEM_POST_RESET);
	RegisterNotification(ModifyNotify, 0, NOTIFY_SYSTEM_POST_NEW);
	RegisterNotification(ModifyNotify, 0, NOTIFY_FILE_POST_OPEN);
	RegisterNotification(ModifyNotify, 0, NOTIFY_FILE_POST_MERGE);
	RegisterNotification(ModifyNotify, 0, NOTIFY_FILE_OPEN_FAILED);
	RegisterNotification(ModifyNotify, 0, NOTIFY_FILE_POST_SAVE);
	RegisterNotification(ModifyNotify, 0, NOTIFY_FILE_POST_SAVE_OLD);
	RegisterNotification(ModifyNotify, 0, NOTIFY_POST_IMPORT);
	RegisterNotification(ModifyNotify, 0, NOTIFY_IMPORT_FAILED);

	return GUPRESULT_KEEP;
}

void Exporter::Stop()
{
	UnRegisterNotification(ModifyNotify, nullptr);

	delete mViewExtended, mViewExtended = nullptr;
}


BOOL oiramActionCallback::
ExecuteAction(int id)
{
	return FALSE;
}
