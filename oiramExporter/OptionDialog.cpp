#include "stdafx.h"
#include "OptionDialog.h"
#include <max.h>
#include <shlobj.h>
#include <commdlg.h>
#include <sstream>
#include <tchar.h>
#include "res/resource.h"
#include "requisites.h"
#include "strutil.h"
#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include "Component.h"
#include "serializer.h"

extern TCHAR *GetString(int id);

INT_PTR CALLBACK OptionDialogFunction(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	static Component* msComponent = 0;
	MSTR maxPluginCfgDirectory = GetCOREInterface()->GetDir(APP_PLUGCFG_DIR);
	MSTR configPath = maxPluginCfgDirectory + _T("/oiramConfig.xml");
	switch(message)
	{
		case WM_INITDIALOG:
			{
				// 初始化数据
				msComponent = (Component*)lParam;

				// 窗口居中
				CenterWindow(hWnd, GetParent(hWnd));

				// 显示标题
				TCHAR szTitle[128] = {0};
				_stprintf(szTitle, _T("oiramExporter - %s"), GetString(IDS_VERSION));
				SetWindowText(hWnd, szTitle);

				// Option
				{
					CheckDlgButton(hWnd, IDC_SCENE, (config.exportObject & EO_Scene) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_GEOMETRY, (config.exportObject & EO_Geometry) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_LIGHT, (config.exportObject & EO_Light) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_CAMERA, (config.exportObject & EO_Camera) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_HELPER, (config.exportObject & EO_Helper) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_SPLINE, (config.exportObject & EO_Spline) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_TARGET, (config.exportObject & EO_Target) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_PHYSX, (config.exportObject & EO_PhysX) ? BST_CHECKED : BST_UNCHECKED);
					CheckDlgButton(hWnd, IDC_APEX, (config.exportObject & EO_APEX) ? BST_CHECKED : BST_UNCHECKED);
				}
				CheckDlgButton(hWnd, IDC_DOT_SCENE_UTF8, config.dotSceneUTF8 ? BST_CHECKED : BST_UNCHECKED);
				CheckDlgButton(hWnd, IDC_PREPEND_RENAMING, config.prependRenaming ? BST_CHECKED : BST_UNCHECKED);
				CheckDlgButton(hWnd, IDC_FULL_SKELETAL, config.fullSkeletal ? BST_CHECKED : BST_UNCHECKED);
				CheckRadioButton(hWnd, IDC_FIXED_FUNCTION, IDC_PROGRAMMABLE, config.renderingType + IDC_FIXED_FUNCTION);
				
				// 设置每个batch最大的骨骼数, 受寄存器数量影响, 例如sm2.0只有256个寄存器, 什么都不做也只有64个matrix4x4可用
				SendMessage(GetDlgItem(hWnd, IDC_SKELETON_MAX_BONES_SPIN), UDM_SETRANGE, 0, MAKELPARAM(512, 0)); 
				SetDlgItemText(hWnd, IDC_SKELETON_MAX_BONES, ToString(config.skeletonMaxBones).c_str());

				// 优化的精度(精度越小动画帧越少, 文件越小, 反之越多越大)
				HWND hOptimizationEpsilon = GetDlgItem(hWnd, IDC_OPTIMIZATION_EPSILON);
				SendMessage(hOptimizationEpsilon, TBM_SETRANGE, (WPARAM)FALSE, (LPARAM)MAKELONG(MIN_PRECISION, MAX_PRECISION));
				SendMessage(hOptimizationEpsilon, TBM_SETPOS, (WPARAM)TRUE, (LPARAM)config.optimizationEpsilon);


				// Image
				CheckRadioButton(hWnd, IDC_ORIGINAL, IDC_PVRTC2_4BPP, config.imageCompressionType + IDC_ORIGINAL);
				CheckRadioButton(hWnd, IDC_QUALITY_LOW, IDC_QUALITY_HIGH, config.imageCompressionQuality + IDC_QUALITY_LOW);
				CheckDlgButton(hWnd, IDC_IMAGE_GENERATION_MIPMAPS, config.imageGenerationMipmaps ? BST_CHECKED : BST_UNCHECKED);
				CheckRadioButton(hWnd, IDC_BILINEAR, IDC_ANISOTROPIC_16, config.imageTextureFiltering + IDC_BILINEAR);
				CheckDlgButton(hWnd, IDC_IMAGE_POWER_OF_TWO, config.imagePowerOfTwo ? BST_CHECKED : BST_UNCHECKED);

				// 填充图像最大尺寸列表
				{
					HWND hImageMaxSize = GetDlgItem(hWnd, IDC_IMAGE_MAX_SIZE);
					size_t szSize[] = { 0, 128, 256, 512, 1024, 2048 };
					size_t index = 0;
					for (size_t n = 0; n < sizeof(szSize) / sizeof(szSize[0]); ++n)
					{
						if (config.imageMaxSize == szSize[n])
							index = n;
						MSTR str;
						str.printf(_T("%d"), szSize[n]);
						SendMessage(hImageMaxSize, CB_ADDSTRING, 0, (LPARAM)str.data());
					}
					SendMessage(hImageMaxSize, CB_SETCURSEL, index, 0);
				}

				// 填充图像缩放比例列表
				{
					HWND hImageScale = GetDlgItem(hWnd, IDC_IMAGE_SCALE);
					float szScale[] = { 1.0f, 0.75f, 0.5f, 0.25f };
					size_t index = 0;
					for (size_t n = 0; n < sizeof(szScale) / sizeof(szScale[0]); ++n)
					{
						if (oiram::fequal(config.imageScale, szScale[n]))
							index = n;
						MSTR str;
						str.printf(_T("%.2f"), szScale[n]);
						SendMessage(hImageScale, CB_ADDSTRING, 0, (LPARAM)str.data());
					}
					SendMessage(hImageScale, CB_SETCURSEL, index, 0);
				}


				// Output
				SetDlgItemText(hWnd, IDC_EXPORT_DIRECTORY, Ansi2Mstr(config.outputFolder));
				CheckDlgButton(hWnd, IDC_PACKAGE, config.package ? BST_CHECKED : BST_UNCHECKED);


				// LOD
				SendMessage(GetDlgItem(hWnd, IDC_LOD_REDUCTION_SPIN), UDM_SETRANGE, 0, MAKELPARAM(100, 0)); 
				SetDlgItemText(hWnd, IDC_LOD_REDUCTION, _T("100"));

				{
					HWND hLODs = GetDlgItem(hWnd, IDC_LIST_LODS);
					Rect rect;
					GetClientRect(hLODs, &rect);
					LVCOLUMN lvc;
					ZeroMemory(&lvc, sizeof(LVCOLUMN));
					lvc.mask = LVCF_TEXT | LVCF_WIDTH;
					lvc.cx = static_cast<int>(rect.w() * 0.4f);
					lvc.pszText = _T("Reduction");
					ListView_InsertColumn(hLODs, 0, &lvc);
					lvc.cx = static_cast<int>(rect.w() * 0.3f);
					lvc.pszText = _T("Value1");
					ListView_InsertColumn(hLODs, 1, &lvc);
					lvc.cx = static_cast<int>(rect.w() * 0.3f);
					lvc.pszText = _T("Value2");
					ListView_InsertColumn(hLODs, 2, &lvc);
				}


				// 搜索所有组件
				HWND hComponents = GetDlgItem(hWnd, IDC_COMPONENT_LIST);
				MSTR maxRootDirectory = GetCOREInterface()->GetDir(APP_MAX_SYS_ROOT_DIR);
				MSTR componentPath = maxRootDirectory + Component::msComponentDirectory + _T("*.*");
				WIN32_FIND_DATA findFileData = {0};
				HANDLE hFindFile = FindFirstFile(componentPath, &findFileData);
				if (hFindFile != INVALID_HANDLE_VALUE)
				{
					do
					{
						if ((findFileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) &&
							(findFileData.cFileName[0] != '.'))
							SendMessage(hComponents, CB_ADDSTRING, 0, (LPARAM)findFileData.cFileName);
					}while (FindNextFile(hFindFile, &findFileData));
					FindClose(hFindFile);
				}
				// 默认选择第1个
				SendMessage(hComponents, CB_SETCURSEL, 0, 0);
				SendMessage(hComponents, CB_GETLBTEXT, SendMessage(hComponents, CB_GETCURSEL, 0, 0), 
					(LPARAM)(msComponent->GetComponentName().c_str()));
			}
			return TRUE;

		case WM_COMMAND:
			switch (LOWORD(wParam))
			{
			case IDC_CMD_ADD_LOD:
				{
					HWND hLODs = GetDlgItem(hWnd, IDC_LIST_LODS);

					TCHAR buf[256] = {0};
					// 得到简化mesh百分比
					SendMessage(GetDlgItem(hWnd, IDC_LOD_REDUCTION), WM_GETTEXT, 256, (LPARAM)buf);
					int reduction = std::min(100, std::max(0, _tstoi(buf)));
					// 得到lod value
					SendMessage(GetDlgItem(hWnd, IDC_LOD_VALUE1), WM_GETTEXT, 256, (LPARAM)buf);
					int value1 = _tstoi(buf);
					SendMessage(GetDlgItem(hWnd, IDC_LOD_VALUE2), WM_GETTEXT, 256, (LPARAM)buf);
					MSTR value2 = buf;

					// 确定数据有效, 填入列表框
					LVITEM lvi;
					ZeroMemory(&lvi, sizeof(LVITEM));

					_stprintf(buf, _T("%d"), reduction);
					lvi.mask = LVIF_TEXT;
					lvi.pszText = buf;
					lvi.iItem = 10000;
					int idx = ListView_InsertItem(hLODs, &lvi);

					lvi.iItem = idx;
					lvi.iSubItem = 1;
					_stprintf(buf, _T("%d"), value1);
					lvi.pszText = buf;
					ListView_SetItem(hLODs, &lvi);
					lvi.iSubItem = 2;
					_stprintf(buf, _T("%s"), value2);
					lvi.pszText = buf;
					ListView_SetItem(hLODs, &lvi);

					SetFocus(GetDlgItem(hWnd, IDC_LOD_VALUE1));
				}
				return TRUE;

			case IDC_CMD_DELETE_LOD:
				{
					HWND hLODs = GetDlgItem(hWnd, IDC_LIST_LODS);

					// 删除选中的LOD信息
					int idx;
					while ((idx = ListView_GetNextItem(hLODs, -1, LVNI_SELECTED)) != -1)
						ListView_DeleteItem(hLODs, idx);
					SetFocus(GetDlgItem(hWnd, IDC_LOD_VALUE1));
				}
				break;

			case IDC_CMD_CLEAR_LOD:
				{
					HWND hLODs = GetDlgItem(hWnd, IDC_LIST_LODS);

					// 删除所有LOD信息
					ListView_DeleteAllItems(hLODs);
					SetFocus(GetDlgItem(hWnd, IDC_LOD_VALUE1));
				}
				break;

			case IDC_EXPORT_DIRECTORY_BROWSER:
				{
					BROWSEINFO bi;
					memset(&bi, 0, sizeof(BROWSEINFO) );
					bi.hwndOwner = hWnd;
					bi.ulFlags = BIF_RETURNONLYFSDIRS | BIF_STATUSTEXT;
					LPITEMIDLIST idl = SHBrowseForFolder(&bi);
					if (idl)
					{
						TCHAR selectFolder[MAX_PATH + 1] = {0};
						SHGetPathFromIDList(idl, selectFolder);
						SetDlgItemText(hWnd, IDC_EXPORT_DIRECTORY, selectFolder);
					}
				}
				break;

			case IDOK:
				{
					// Option
					config.exportObject = 0;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_SCENE))
						config.exportObject |= EO_Scene;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_GEOMETRY))
						config.exportObject |= EO_Geometry;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_LIGHT))
						config.exportObject |= EO_Light;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_CAMERA))
						config.exportObject |= EO_Camera;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_HELPER))
						config.exportObject |= EO_Helper;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_SPLINE))
						config.exportObject |= EO_Spline;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_TARGET))
						config.exportObject |= EO_Target;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PHYSX))
						config.exportObject |= EO_PhysX;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_APEX))
						config.exportObject |= EO_APEX;

					config.dotSceneUTF8 = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_DOT_SCENE_UTF8));
					config.prependRenaming = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PREPEND_RENAMING));
					config.fullSkeletal = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_FULL_SKELETAL));

					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_FIXED_FUNCTION))
						config.renderingType = RT_FixedFunction;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PROGRAMMABLE))
						config.renderingType = RT_Programmable;

					TCHAR szSkeletonMaxBones[32] = {0};
					GetDlgItemText(hWnd, IDC_SKELETON_MAX_BONES, szSkeletonMaxBones, 32);
					config.skeletonMaxBones = _tstoi(szSkeletonMaxBones);

					HWND hOptimizationEpsilon = GetDlgItem(hWnd, IDC_OPTIMIZATION_EPSILON);
					config.optimizationEpsilon = static_cast<int>(SendMessage(hOptimizationEpsilon, TBM_GETPOS, 0, 0));


					// Image
					config.imageCompressionType = CT_Original;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PNG))
						config.imageCompressionType = CT_PNG;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_TGA))
						config.imageCompressionType = CT_TGA;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_DXTC))
						config.imageCompressionType = CT_DXTC;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_ETC1))
						config.imageCompressionType = CT_ETC1;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_ETC2))
						config.imageCompressionType = CT_ETC2;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PVRTC2_4BPP))
						config.imageCompressionType = CT_PVRTC2_4BPP;

					config.imageCompressionQuality = CQ_Normal;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_QUALITY_LOW))
						config.imageCompressionQuality = CQ_Low;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_QUALITY_HIGH))
						config.imageCompressionQuality = CQ_High;

					config.imageGenerationMipmaps = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_IMAGE_GENERATION_MIPMAPS));

					config.imageTextureFiltering = TF_Bilinear;
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_BILINEAR))
						config.imageTextureFiltering = TF_Bilinear;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_TRILINEAR))
						config.imageTextureFiltering = TF_Trilinear;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_ANISOTROPIC_8))
						config.imageTextureFiltering = TF_Anisotropic_8;
					else
					if (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_ANISOTROPIC_16))
						config.imageTextureFiltering = TF_Anisotropic_16;

					config.imagePowerOfTwo = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_IMAGE_POWER_OF_TWO));

					{
						TCHAR szImageMaxSize[32] = { 0 };
						HWND hImagMaxSize = GetDlgItem(hWnd, IDC_IMAGE_MAX_SIZE);
						LRESULT curSel = SendMessage(hImagMaxSize, CB_GETCURSEL, 0, 0);
						SendMessage(hImagMaxSize, CB_GETLBTEXT, curSel, (LPARAM)szImageMaxSize);
						config.imageMaxSize = _tstoi(szImageMaxSize);
					}

					{
						TCHAR szImageScale[32] = { 0 };
						HWND hImagScale = GetDlgItem(hWnd, IDC_IMAGE_SCALE);
						LRESULT curSel = SendMessage(hImagScale, CB_GETCURSEL, 0, 0);
						SendMessage(hImagScale, CB_GETLBTEXT, curSel, (LPARAM)szImageScale);
						config.imageScale = static_cast<float>(_tstof(szImageScale));
					}


					// Output
					TCHAR selectFolder[MAX_PATH + 1] = {0};
					GetDlgItemText(hWnd, IDC_EXPORT_DIRECTORY, selectFolder, MAX_PATH);
					if (*selectFolder)
					{
						// 更新路径信息
						config.outputFolder = Mchar2Ansi(selectFolder);
						msComponent->OnMaxFileModified();
					}
					else
					{
						SetFocus(GetDlgItem(hWnd, IDC_EXPORT_DIRECTORY));
						MessageBox(hWnd, _T("Export directory cannot be empty."), _T("Warning"), MB_ICONEXCLAMATION);
						return FALSE;
					}
					config.package = (BST_CHECKED == IsDlgButtonChecked(hWnd, IDC_PACKAGE));

					// 判断是否为移动平台
					if (config.imageCompressionType == CT_ETC1 ||
						config.imageCompressionType == CT_ETC2 ||
						config.imageCompressionType == CT_PVRTC2_4BPP)
						config.mobilePlatform = true;

					// LOD
					HWND hLODs = GetDlgItem(hWnd, IDC_LIST_LODS);
					int lodCount = ListView_GetItemCount(hLODs);
					TCHAR str[256] = {0};

					config.lodDescs.clear();
					config.lodDescs.resize(lodCount);
					for (int n = 0; n < lodCount; ++n)
					{
						LODesc& lodDesc = config.lodDescs[n];
						ListView_GetItemText(hLODs, n, 0, str, sizeof(str));
						lodDesc.reduction = _tstoi(str);
						ListView_GetItemText(hLODs, n, 1, str, sizeof(str));
						lodDesc.value1 = _tstoi(str);
						ListView_GetItemText(hLODs, n, 2, str, sizeof(str));
						lodDesc.value2 = Mchar2Ansi(str);
					}
				}

				EndDialog(hWnd, 1);
				return TRUE;

			case IDCANCEL:
				EndDialog(hWnd, 0);
				return TRUE;
			}
			break;
	}

	return FALSE;
}


bool OptionDialogImpl(HINSTANCE hInstance, HWND hWndParent, LPARAM dwInitParam)
{
	return IDOK == DialogBoxParam(hInstance, MAKEINTRESOURCE(IDD_EXPORT), hWndParent, OptionDialogFunction, dwInitParam);
}
