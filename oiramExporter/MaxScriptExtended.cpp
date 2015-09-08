#include "stdafx.h"
#include "MaxScriptExtended.h"
#include "Component.h"

// interface ID
#define MAXSCRIPT_EXTENDED_INTERFACE Interface_ID(0x7ef553, 0x151232)

static MaxScriptExtendedInterface msMaxScriptExtendedInterfaceDesc(
	MAXSCRIPT_EXTENDED_INTERFACE, _T("oiram"), 0, NULL, FP_CORE, 

	MaxScriptExtendedInterface::fidOptionDialog,	_T("optionDialog"),		0, TYPE_bool, 0, 0,
	MaxScriptExtendedInterface::fidExport,			_T("export"),			0, TYPE_bool, 0, 1,
													_T("selected"),			0, TYPE_bool,
	MaxScriptExtendedInterface::fidRename,			_T("rename"),			0, TYPE_VOID, 0, 1,
													_T("name"),				0, TYPE_STRING,

	properties,
		MaxScriptExtendedInterface::fidGetMerge, MaxScriptExtendedInterface::fidSetMerge, _T("merge"), 0, TYPE_BOOL,
		MaxScriptExtendedInterface::fidGetResetNodeScale, MaxScriptExtendedInterface::fidSetResetNodeScale, _T("resetNodeScale"), 0, TYPE_BOOL,

	end);


bool MaxScriptExtendedInterface::
OptionDialog()
{
	return Component::getSingleton().OptionDialog();
}


bool MaxScriptExtendedInterface::
Export(bool selected)
{
	Component& component = Component::getSingleton();
	component.OnSceneModified();
	return component.Export(selected);
}


void MaxScriptExtendedInterface::
Rename(MSTR name)
{
	Component::getSingleton().Rename(name);
}


BOOL MaxScriptExtendedInterface::
GetMerge()
{
	return mMerge;
}


void MaxScriptExtendedInterface::
SetMerge(BOOL merge)
{
	mMerge = merge;
}


BOOL MaxScriptExtendedInterface::
GetResetNodeScale()
{
	return mResetNodeScale;
}


void MaxScriptExtendedInterface::
SetResetNodeScale(BOOL reset)
{
	mResetNodeScale = reset;
}
