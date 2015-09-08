#ifndef _Function_Publishing_hpp__
#define _Function_Publishing_hpp__

#include <max.h>
#include <ifnpub.h>

class MaxScriptExtendedInterface : public FPStaticInterface
{ 
public:
	enum { fidOptionDialog, fidExport, fidRename, fidGetMerge, fidSetMerge, fidGetResetNodeScale, fidSetResetNodeScale };

	DECLARE_DESCRIPTOR(MaxScriptExtendedInterface)
	BEGIN_FUNCTION_MAP
	FN_0(fidOptionDialog, TYPE_bool, OptionDialog);
	FN_1(fidExport, TYPE_bool, Export, TYPE_bool);
	VFN_1(fidRename, Rename, TYPE_STRING);
	PROP_FNS(fidGetMerge, GetMerge, fidSetMerge, SetMerge, TYPE_BOOL);
	PROP_FNS(fidGetResetNodeScale, GetResetNodeScale, fidSetResetNodeScale, SetResetNodeScale, TYPE_BOOL);
	END_FUNCTION_MAP

	bool	OptionDialog();
	bool	Export(bool selected);
	void	Rename(MSTR name);

	BOOL	GetMerge();
	void	SetMerge(BOOL merge);

	BOOL	GetResetNodeScale();
	void	SetResetNodeScale(BOOL reset);

private:
	BOOL	mMerge;
	BOOL	mResetNodeScale;
};

#endif
