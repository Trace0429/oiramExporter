#include "stdafx.h"
#include "Component.h"
#include <max.h>
#include <algorithm>
#include "requisites.h"
#include "rapidxml.hpp"
#include "rapidxml_print.hpp"
#include "strutil.h"
#include "serializer.h"
#include "rendersystem.h"
#include "OptionDialog.h"
#include "LogMessageDialog.h"

const MCHAR Component::msComponentDirectory[] = _T("plugins\\oiramExporter\\components\\");

Component::
Component()
:	mComponentModule(nullptr), mSerializer(nullptr), mCreateRenderSystem(nullptr), 
	mOiramImplModule(nullptr), mOiramExporter(nullptr), mSceneModified(false)
{
	LogMessageDialog::CreateLogMessageDialog(hInstance, GetCOREInterface()->GetMAXHWnd());
	LoadConfig();
}


Component::
~Component()
{
	UnloadComponent();
	LogMessageDialog::DestroyLogMessageDialog();
}


Component& Component::
getSingleton()
{
	static Component msComponent;
	return msComponent;
}


void Component::
OnMaxFileModified()
{
	// 得到max文件名称
	MSTR maxName;
	if (mRename.isNull())
		maxName = GetCOREInterface()->GetCurFilePath();
	else
		maxName = mRename;

	if (maxName.isNull())
		maxName = _T("Untitled");
	else
	{
		int pos = maxName.last(_T('\\'));
		if (pos != -1)
			maxName.remove(0, pos + 1);
		pos = maxName.last(_T('.'));
		if (pos != -1)
			maxName.remove(pos);
	}
	config.maxName = Mstr2Ansi(maxName);

	// 确保路径是以\结尾
	MCHAR backslash = *config.outputFolder.rbegin();
	if (backslash != _T('/') && backslash != _T('\\'))
		config.outputFolder += _T('\\');
	config.exportPath = config.outputFolder + config.maxName + '\\';
}


void Component::
OnSceneModified()
{
	mSceneModified = true;
}


bool Component::
OptionDialog()
{
	bool result = false;
	// 弹出导出界面
	if (OptionDialogImpl(hInstance, GetCOREInterface()->GetMAXHWnd(), (LPARAM)this))
	{
		result = LoadComponent();
		SaveConfig();
	}

	return result;
}


bool Component::
Export(bool exportSelected)
{
	bool result = false;
	// 空场景不导出
	int nodeCount = GetCOREInterface()->GetRootNode()->NumberOfChildren();
	if (nodeCount > 0)
	{
		if (mSceneModified &&
			LoadComponent() &&
			LoadImpl())
		{
			SendMessage(LogMessageDialog::mDialog, LogMessageDialog::WM_INITIALIZE, 0, 0);
			typedef bool(*OiramExporter)(const Config&, HINSTANCE, oiram::Serializer*, bool, HWND);
			result = mOiramExporter && static_cast<OiramExporter>(mOiramExporter)(config, hInstance, mSerializer, exportSelected, LogMessageDialog::mDialog);
			SendMessage(LogMessageDialog::mDialog, LogMessageDialog::WM_UNINITIALIZE, 0, 0);
			UnloadImpl();
		}
	}

	mSceneModified = false;

	return result;
}


void Component::
Rename(const MSTR& name)
{
	mRename = name;
	OnMaxFileModified();
}


oiram::RenderSystem*
Component::CreateRenderSystem()
{
	LoadComponent();

	if (mCreateRenderSystem)
		return mCreateRenderSystem();
	else
		return nullptr;
}

void Component::
DestroyRenderSystem(oiram::RenderSystem* rendersystem)
{
	// 销毁渲染对象
	if (rendersystem)
		rendersystem->destroy();

	if (mComponentModule)
	{
		typedef void (*DestroyRenderSystem)(oiram::RenderSystem*);
		DestroyRenderSystem destroyRenderSystem = reinterpret_cast<DestroyRenderSystem>(GetProcAddress(mComponentModule, "destroyRenderSystem"));
		if (destroyRenderSystem)
			destroyRenderSystem(rendersystem);
	}
}


void Component::
LoadConfig()
{
	// 默认值
	config.exportObject				= EO_All;
	config.dotSceneUTF8				= false;
	config.prependRenaming			= false;
	config.fullSkeletal				= false;
	config.onlyPhysX				= false;
	config.renderingType			= RT_FixedFunction;
	config.skeletonMaxBones			= 50;
	config.optimizationEpsilon		= DEFAULT_PRECISION;

	config.imageCompressionType		= CT_Original;
	config.imageCompressionQuality	= CQ_Normal;
	config.imageGenerationMipmaps	= false;
	config.imageTextureFiltering	= TF_Bilinear;
	config.imagePowerOfTwo			= false;
	config.imageMaxSize				= 0;
	config.imageScale				= 1.0f;

	config.package					= false;

	// 基本信息
	config.mobilePlatform	= false;
	config.unitMultiplier	= 1.0f;// UnitsConversion();
	config.ticksPerFrame	= GetTicksPerFrame();
	config.framePerSecond	= 1.0f / GetFrameRate();
	config.lodDescs.clear();
		
	// 解析文件
	MSTR maxPluginCfgDirectory = GetCOREInterface()->GetDir(APP_PLUGCFG_DIR);
	MSTR configPath = maxPluginCfgDirectory + _T("\\oiramConfig.xml");
	FILE* fp = _tfopen(configPath, _T("rt"));
	if (fp)
	{
		fseek(fp, 0, SEEK_END);
		std::vector<char> text(ftell(fp));
		fseek(fp, 0, SEEK_SET);
		fread(&text[0], text.size(), 1, fp);
		fclose(fp);

		using namespace rapidxml;
		xml_document<> doc;
		doc.parse<0>(&text[0]);

		auto configs = doc.first_node("configs");
		if (!configs)
		{
			configs = doc.allocate_node(node_element, "configs");
			doc.append_node(configs);
		}

		// option
		auto option = configs->first_node("option");
		if (option)
		{
			auto attrExportObject = option->first_attribute("exportObject");
			if (attrExportObject)
				config.exportObject = std::stoi(attrExportObject->value());

			auto attrDotSceneUTF8 = option->first_attribute("dotSceneUTF8");
			if (attrDotSceneUTF8)
				config.dotSceneUTF8 = strcmp(attrDotSceneUTF8->value(), "true") == 0;

			auto attrPrependRenaming = option->first_attribute("prependRenaming");
			if (attrPrependRenaming)
				config.prependRenaming = strcmp(attrPrependRenaming->value(), "true") == 0;

			auto attrFullSkeletal = option->first_attribute("fullSkeletal");
			if (attrFullSkeletal)
				config.fullSkeletal = strcmp(attrFullSkeletal->value(), "true") == 0;

			auto attrOnlyPhysX = option->first_attribute("onlyPhysX");
			if (attrOnlyPhysX)
				config.onlyPhysX = strcmp(attrOnlyPhysX->value(), "true") == 0;

			auto attrRenderingType = option->first_attribute("renderingType");
			if (attrRenderingType)
				config.renderingType = static_cast<RenderingType>(std::stoi(attrRenderingType->value()));

			auto attrSkeletonMaxBones = option->first_attribute("skeletonMaxBones");
			if (attrSkeletonMaxBones)
				config.skeletonMaxBones = std::stoi(attrSkeletonMaxBones->value());

			auto attrOptimizationEpsilon = option->first_attribute("optimizationEpsilon");
			if (attrOptimizationEpsilon)
				config.optimizationEpsilon = std::stoi(attrOptimizationEpsilon->value());
		}

		// Image
		auto image = configs->first_node("image");
		if (image)
		{
			auto attrCompressionType = image->first_attribute("compressionType");
			if (attrCompressionType)
				config.imageCompressionType = static_cast<CompressionType>(std::stoi(attrCompressionType->value()));

			auto attrCompressionQuality = image->first_attribute("compressionQuality");
			if (attrCompressionQuality)
				config.imageCompressionQuality = static_cast<CompressionQuality>(std::stoi(attrCompressionQuality->value()));

			auto attrGenerationMipmaps = image->first_attribute("generationMipmaps");
			if (attrGenerationMipmaps)
				config.imageGenerationMipmaps = strcmp(attrGenerationMipmaps->value(), "true") == 0;

			auto attrTextureFiltering = image->first_attribute("textureFiltering");
			if (attrTextureFiltering)
				config.imageTextureFiltering = static_cast<TextureFiltering>(std::stoi(attrTextureFiltering->value()));

			auto attrPowerOfTwo = image->first_attribute("powerOfTwo");
			if (attrPowerOfTwo)
				config.imagePowerOfTwo = strcmp(attrPowerOfTwo->value(), "true") == 0;

			auto attrMaxSize = image->first_attribute("maxSize");
			if (attrMaxSize)
				config.imageMaxSize = std::stoi(attrMaxSize->value());

			auto attrScale = image->first_attribute("scale");
			if (attrScale)
				config.imageScale = std::stof(attrScale->value());
		}

		// Output
		auto output = configs->first_node("output");
		if (output)
		{
			// folder
			auto attrFolder = output->first_attribute("folder");
			if (attrFolder)
				config.outputFolder = attrFolder->value();

			// Package
			auto attrPackage = output->first_attribute("package");
			if (attrPackage)
				config.package = strcmp(attrPackage->value(), "true") == 0;
		}

		// LOD
		auto lod = configs->first_node("lod");
		if (lod)
		{
			auto level = lod->first_node("level");
			while (level)
			{
				auto reduction = level->first_attribute("reduction");
				auto value1 = level->first_attribute("value1");
				auto value2 = level->first_attribute("value2");
				LODesc lodDesc = {
					std::stoi(reduction->value()),
					std::stoi(value1->value()),
					value2->value(),
				};
				config.lodDescs.push_back(lodDesc);

				level = level->next_sibling("level");
			}
		}

		// Components
		auto components = configs->first_node("components");
		if (components)
		{
			auto attrSelect = components->first_attribute("select");
			if (attrSelect)
				mComponentName = attrSelect->value();
		}
	}

	// 总是保证config.outputFolder有效
	if (config.outputFolder.empty())
		config.outputFolder = Mchar2Ansi(GetCOREInterface()->GetDir(APP_EXPORT_DIR));
}


void Component::
SaveConfig()
{
	using namespace rapidxml;
	xml_document<> doc;

	auto configs = doc.allocate_node(node_element, "configs");
	doc.append_node(configs);

	// option
	auto option = doc.allocate_node(node_element, "option");
	configs->append_node(option);
	{
		auto exportObject = doc.allocate_attribute("exportObject", doc.allocate_string(std::to_string(config.exportObject).c_str()));
		option->append_attribute(exportObject);

		auto dotSceneUTF8 = doc.allocate_attribute("dotSceneUTF8", config.dotSceneUTF8 ? "true" : "false");
		option->append_attribute(dotSceneUTF8);

		auto prependRenaming = doc.allocate_attribute("prependRenaming", config.prependRenaming ? "true" : "false");
		option->append_attribute(prependRenaming);

		auto fullSkeletal = doc.allocate_attribute("fullSkeletal", config.fullSkeletal ? "true" : "false");
		option->append_attribute(fullSkeletal);

		auto onlyPhysX = doc.allocate_attribute("onlyPhysX", config.onlyPhysX ? "true" : "false");
		option->append_attribute(onlyPhysX);

		auto renderingType = doc.allocate_attribute("renderingType", doc.allocate_string(std::to_string(config.renderingType).c_str()));
		option->append_attribute(renderingType);

		auto skeletonMaxBones = doc.allocate_attribute("skeletonMaxBones", doc.allocate_string(std::to_string(config.skeletonMaxBones).c_str()));
		option->append_attribute(skeletonMaxBones);

		auto attrOptimizationEpsilon = doc.allocate_attribute("optimizationEpsilon", doc.allocate_string(std::to_string(config.optimizationEpsilon).c_str()));
		option->append_attribute(attrOptimizationEpsilon);
	}

	// Image
	auto image = doc.allocate_node(node_element, "image");
	configs->append_node(image);
	{
		auto compressionType = doc.allocate_attribute("compressionType", doc.allocate_string(std::to_string(config.imageCompressionType).c_str()));
		image->append_attribute(compressionType);

		auto compressionQuality = doc.allocate_attribute("compressionQuality", doc.allocate_string(std::to_string(config.imageCompressionQuality).c_str()));
		image->append_attribute(compressionQuality);

		auto generationMipmaps = doc.allocate_attribute("generationMipmaps", config.imageGenerationMipmaps ? "true" : "false");
		image->append_attribute(generationMipmaps);

		auto textureFiltering = doc.allocate_attribute("textureFiltering", doc.allocate_string(std::to_string(config.imageTextureFiltering).c_str()));
		image->append_attribute(textureFiltering);

		auto powerOfTwo = doc.allocate_attribute("powerOfTwo", config.imagePowerOfTwo ? "true" : "false");
		image->append_attribute(powerOfTwo);

		auto maxSize = doc.allocate_attribute("maxSize", doc.allocate_string(std::to_string(config.imageMaxSize).c_str()));
		image->append_attribute(maxSize);

		auto scale = doc.allocate_attribute("scale", doc.allocate_string(std::to_string(config.imageScale).c_str()));
		image->append_attribute(scale);
	}

	// Output
	auto output = doc.allocate_node(node_element, "output");
	configs->append_node(output);
	{
		auto folder = doc.allocate_attribute("folder", doc.allocate_string(config.outputFolder.c_str()));
		output->append_attribute(folder);

		auto package = doc.allocate_attribute("package", config.package ? "true" : "false");
		output->append_attribute(package);
	}

	// LOD
	auto lod = doc.allocate_node(node_element, "lod");
	configs->append_node(lod);
	{
		for (auto& lodDesc : config.lodDescs)
		{
			auto level = doc.allocate_node(node_element, "level");
			lod->append_node(level);
			{
				auto reduction = doc.allocate_attribute("reduction", doc.allocate_string(std::to_string(lodDesc.reduction).c_str()));
				level->append_attribute(reduction);
				auto value1 = doc.allocate_attribute("value1", doc.allocate_string(std::to_string(lodDesc.value1).c_str()));
				level->append_attribute(value1);
				auto value2 = doc.allocate_attribute("value2", doc.allocate_string(lodDesc.value2.c_str()));
				level->append_attribute(value2);
			}
		}
	}

	// Components
	auto components = doc.allocate_node(node_element, "components");
	configs->append_node(components);
	{
		std::string componentModuleName = GetComponentName().data();
		auto selectComponent = doc.allocate_attribute("select", doc.allocate_string(componentModuleName.c_str()));
		components->append_attribute(selectComponent);

		auto component = doc.allocate_node(node_element, doc.allocate_string(componentModuleName.c_str()));
		components->append_node(component);
	}

	std::stringstream osConfig;
	osConfig << doc;

	// 保存文件
	MSTR maxPluginCfgDirectory = GetCOREInterface()->GetDir(APP_PLUGCFG_DIR);
	MSTR configPath = maxPluginCfgDirectory + _T("\\oiramConfig.xml");
	FILE* fp = _tfopen(configPath, _T("wt"));
	if (fp)
	{
		fwrite(osConfig.str().c_str(), static_cast<size_t>(osConfig.tellp()), 1, fp);
		fclose(fp);
	}
}


bool Component::
LoadImpl()
{
	// 载入代理导出的接口
	MSTR directory = MSTR(GetCOREInterface()->GetDir(APP_MAX_SYS_ROOT_DIR)) + _T("plugins\\oiramExporter\\");
	::SetCurrentDirectory(directory);
	mOiramImplModule = LoadLibrary(_T("oiramImpl.dll"));
	if (mOiramImplModule != nullptr)
	{
		mOiramExporter = GetProcAddress(mOiramImplModule, "oiramExport");
		return mOiramExporter != nullptr;
	}

	return false;
}


void Component::
UnloadImpl()
{
	if (mOiramImplModule)
	{
		FreeLibrary(mOiramImplModule);
		mOiramExporter = nullptr;
		mOiramImplModule = nullptr;
	}
}


bool Component::
LoadComponent()
{
	// 如果序列化对象为空; 或者序列化对象已存在, 但名称与当前指定的组件名称不同时
	if (!mSerializer ||
		(mSerializer && mComponentName != mSerializer->getName()))
	{
		// 选择序列化插件
		mComponentDirectory = std::string(Mchar2Ansi(GetCOREInterface()->GetDir(APP_MAX_SYS_ROOT_DIR))) + Mchar2Ansi(msComponentDirectory) + mComponentName + '\\';
		::SetCurrentDirectory(Ansi2Mstr(mComponentDirectory));
		std::string componentPath = mComponentDirectory + mComponentName + ".dll";
		mComponentModule = ::LoadLibrary(Ansi2Mstr(componentPath));
		if (mComponentModule != nullptr)
		{
			// 创建序列化对象
			typedef oiram::Serializer*(*CreateSerializer)();
			CreateSerializer createSerializer = reinterpret_cast<CreateSerializer>(GetProcAddress(mComponentModule, "createSerializer"));
			if (createSerializer)
			{
				mSerializer = createSerializer();
				if (mSerializer)
				{
					// 获得组件名称
					mComponentName = mSerializer->getName();
				}
			}

			// 保存创建渲染对象的接口函数
			typedef oiram::RenderSystem*(*CreateRenderSystem)();
			mCreateRenderSystem = reinterpret_cast<CreateRenderSystem>(GetProcAddress(mComponentModule, "createRenderSystem"));
		}
	}

	if (mSerializer)
	{
		// 更新配置信息
		mSerializer->setConfig(config);
		return true;
	}

	return false;
}


void Component::
UnloadComponent()
{
	if (mComponentModule)
	{
		// 销毁序列化对象
		if (mSerializer)
		{
			typedef void(*DestroySerializer)(oiram::Serializer*);
			DestroySerializer destroySerializer = reinterpret_cast<DestroySerializer>(GetProcAddress(mComponentModule, "destroySerializer"));
			if (destroySerializer)
				destroySerializer(mSerializer);
			mSerializer = nullptr;
		}

		mCreateRenderSystem = nullptr;

		FreeLibrary(mComponentModule);
		mComponentModule = 0;
	}
}


// Units conversion
#define M2MM 0.001f
#define M2CM 0.01f
#define M2M  1.0f
#define M2KM 1000.0f
#define M2IN 0.0393701f
#define M2FT 0.00328084f
#define M2ML 0.000621371192f

float Component::
GetUnitValue(int unitType)
{
	float value = 1.0f;

	switch(unitType)
	{
	case UNITS_INCHES:
		value = M2IN;
		break;

	case UNITS_FEET:
		value = M2FT;
		break;

	case UNITS_MILES:
		value = M2ML;
		break;

	case UNITS_MILLIMETERS:
		value = M2MM;
		break;

	case UNITS_CENTIMETERS:
		value = M2CM;
		break;

	case UNITS_METERS:
		value = M2M;
		break;

	case UNITS_KILOMETERS:
		value = M2KM;
		break;
	}

	return value;
}

float Component::
ConvertToMeter(int metricDisp, int unitType)
{
	float scale = 1.0f * GetUnitValue(unitType);

	switch(metricDisp)
	{
	case UNIT_METRIC_DISP_MM:
		scale = 1000.0f * GetUnitValue(unitType);
		break;

	case UNIT_METRIC_DISP_CM:
		scale = 100.0f * GetUnitValue(unitType);
		break;

	case UNIT_METRIC_DISP_M:
		scale = 1.0f * GetUnitValue(unitType);
		break;

	case UNIT_METRIC_DISP_KM:
		scale = 0.001f * GetUnitValue(unitType);
		break;
	}

	return scale;
}


float Component::
UnitsConversion()
{
	// 记录max的单位比例设置
	int unitType = 0;
	float unitScale = 0;
	GetMasterUnitInfo(&unitType, &unitScale);
	DispInfo unitsInfo;
	GetUnitDisplayInfo(&unitsInfo);
	
	return ConvertToMeter(unitsInfo.metricDisp, unitType) * unitScale;
}
