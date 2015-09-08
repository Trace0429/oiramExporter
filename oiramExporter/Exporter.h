#ifndef _Exporter_hpp__
#define _Exporter_hpp__

#include <max.h>
#include <iparamb2.h>
#include <guplib.h>

class ViewExtended;

class Exporter : public GUP
{
public:
	// GUP Methods
	DWORD		Start();
	void		Stop();
	DWORD_PTR	Control(DWORD parameter) { return 0; }

	// Loading/Saving
	IOResult	Save(ISave *isave) { return IO_OK; }
	IOResult	Load(ILoad *iload) { return IO_OK; }

	//Constructor/Destructor
	Exporter();
	~Exporter();

public:
	static HWND hParams;

private:
	ViewExtended*	mViewExtended;
};


extern TCHAR *GetString(int id);
extern HINSTANCE hInstance;

#define oiramExporter_CLASS_ID	Class_ID(0x569de60d, 0xa9e8e757)
class oiramExporterClassDesc : public ClassDesc2
{
public:
	int 			IsPublic() { return TRUE; }
	void *			Create(BOOL loading = FALSE) { return new Exporter(); }
	const TCHAR *	ClassName() { return _T("oiramExporter"); }
	SClass_ID		SuperClassID() { return GUP_CLASS_ID; }
	Class_ID		ClassID() { return oiramExporter_CLASS_ID; }
	const TCHAR* 	Category() { return _T("oiramExporter Category"); }

	const TCHAR*	InternalName() { return _T("oiramExporter"); }
	HINSTANCE		HInstance() { return hInstance; }
};


class oiramActionCallback : public ActionCallback
{
public:
	BOOL ExecuteAction(int id);
};

#endif
