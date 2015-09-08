#include "stdafx.h"

#ifndef NO_VIEW_EXTENDED

#include "OgreRenderSystemComponent.h"
#include <Ogre.h>
#include <Overlay/OgreOverlaySystem.h>
#include <Overlay/OgreOverlayManager.h>
#include <Overlay/OgreOverlayElement.h>
#include <Overlay/OgreOverlay.h>

#ifdef _DEBUG
	#pragma comment(lib, "OgreMain_d.lib")
	#pragma comment(lib, "OgreOverlay_d.lib")
#else
	#pragma comment(lib, "OgreMain.lib")
	#pragma comment(lib, "OgreOverlay.lib")
#endif

namespace oiram
{
	OgreRenderSystem::
	OgreRenderSystem()
	:	mRenderWindow(nullptr), mSceneMgr(nullptr), mOverlaySystem(nullptr), mCamera(nullptr),
		mNeedRedraw(true)
	{
	}


	OgreRenderSystem::
	~OgreRenderSystem()
	{
	}


	bool OgreRenderSystem::
	create(HWND hWnd, const char* componentPath)
	{
		try
		{
			// 初始化ogre
			Ogre::Root* ogreRoot = OGRE_NEW Ogre::Root("");
			if (ogreRoot)
			{
				Ogre::String strComponentPath = componentPath;
				auto& resGroupMgr = Ogre::ResourceGroupManager::getSingleton();
				resGroupMgr.addResourceLocation(strComponentPath + "data/OgreCore.zip", "Zip", "Bootstrap");
				//resGroupMgr.addResourceLocation(strComponentPath + "data/effect", "FileSystem", "Effect");

				// 设置渲染系统
				//ogreRoot->loadPlugin(strComponentPath + "Plugin_CgProgramManager_d");
				ogreRoot->loadPlugin(strComponentPath + "RenderSystem_Direct3D9_d");
				const Ogre::RenderSystemList& availableRenderers = ogreRoot->getAvailableRenderers();
				if (!availableRenderers.empty())
				{
					Ogre::RenderSystem* renderSystem = availableRenderers[0];
					//renderSystem->setConfigOption("Allow DirectX9Ex", "Yes");
					ogreRoot->setRenderSystem(renderSystem);

					// 创建场景管理器
					mSceneMgr = ogreRoot->createSceneManager(Ogre::ST_GENERIC, "MainSceneMgr");
					// 创建OverlaySystem
					mOverlaySystem = OGRE_NEW Ogre::OverlaySystem;
					mSceneMgr->addRenderQueueListener(mOverlaySystem);

					ogreRoot->initialise(false);

					// 绑定渲染窗口
					Ogre::NameValuePairList miscParams;
					//miscParams["externalWindowHandle"]	= Ogre::StringConverter::toString(reinterpret_cast<size_t>(hWnd));
					RECT rect = {0};
					GetClientRect(hWnd, &rect);
					mRenderWindow = ogreRoot->createRenderWindow("View", 
						rect.right - rect.left + 1, rect.bottom - rect.top + 1, false, &miscParams);

					Ogre::TextureManager::getSingleton().setDefaultNumMipmaps(0);

					// 初始化资源
					resGroupMgr.initialiseAllResourceGroups();

					// 设置环境光
					mSceneMgr->setAmbientLight(Ogre::ColourValue(0.5f, 0.5f, 0.5f, 1.0f));

					// 创建摄像机
					mCamera = mSceneMgr->createCamera("DefaultCamera");
					mCamera->setFOVy(Ogre::Degree(45.0f));
					mCamera->setNearClipDistance(5.0f);
					mCamera->setFarClipDistance(5000.0f);
					mCamera->setAutoAspectRatio(true);
					mCamera->setProjectionType(Ogre::PT_PERSPECTIVE);

					Ogre::Viewport* vp = mRenderWindow->addViewport(mCamera);
					vp->setBackgroundColour(Ogre::ColourValue::Blue);
					
					// 创建显示面板
					Ogre::Overlay* statisticOverlay = Ogre::OverlayManager::getSingleton().getByName("Core/DebugOverlay");
					statisticOverlay->show();

					ogreRoot->addFrameListener(this);

					return true;
				}
			}
		}
		catch (const Ogre::Exception& ex)
		{
			const char* error = ex.what();
			destroy();
		}

		return false;
	}


	void OgreRenderSystem::
	destroy()
	{
		OGRE_DELETE mOverlaySystem, mOverlaySystem = nullptr;
		OGRE_DELETE Ogre::Root::getSingletonPtr();
	}


	bool OgreRenderSystem::
	loadScene(const char* sceneFileName)
	{
		return false;
	}


	bool OgreRenderSystem::
	loadModel(const char* modelFileName)
	{
		Ogre::String strModelFileName = modelFileName;
		strModelFileName += ".mesh";

		try
		{
			mSceneMgr->clearScene();

			// 分离出路径和文件名
			Ogre::String directory, filename, name, ext;
			Ogre::StringUtil::splitFilename(strModelFileName, filename, directory);
			Ogre::StringUtil::splitBaseFilename(filename, name, ext);

			auto& resGroupMgr = Ogre::ResourceGroupManager::getSingleton();
			if (resGroupMgr.resourceGroupExists(name))
				resGroupMgr.destroyResourceGroup(name);

			// 将模型目录添加到资源搜索路径中
			resGroupMgr.addResourceLocation(directory, "FileSystem", name);
			resGroupMgr.initialiseResourceGroup(name);

			Ogre::Entity* entity = mSceneMgr->createEntity(filename, filename, name);
			Ogre::SceneNode* entityNode = mSceneMgr->getRootSceneNode()->createChildSceneNode();
			entityNode->attachObject(entity);

			Ogre::Light* light = mSceneMgr->createLight();
			light->setType(Ogre::Light::LT_SPOTLIGHT);
			light->setDirection(Ogre::Vector3::NEGATIVE_UNIT_Z);
			//light->setCastShadows(true);
			light->setDiffuseColour(Ogre::ColourValue::White);
			light->setSpotlightRange(Ogre::Degree(30), Ogre::Degree(50));
			Ogre::SceneNode* lightNode = mSceneMgr->getRootSceneNode()->createChildSceneNode();
			entityNode->_updateBounds();
			const Ogre::AxisAlignedBox& boundingBox = entityNode->_getWorldAABB();
			const Ogre::Vector3& vec3Max = boundingBox.getMaximum();
			lightNode->setPosition(Ogre::Vector3(vec3Max.x * 2 * 0, vec3Max.y * 2 * 0.1f, vec3Max.z * 2));
			lightNode->attachObject(light);
			lightNode->setAutoTracking(true, entityNode);

			return true;
		}
		catch (const Ogre::Exception&)
		{
		}

		return false;
	}


	void OgreRenderSystem::
	resize()
	{
		if (mRenderWindow)
		{
			mRenderWindow->windowMovedOrResized();
			notifyRedraw();
		}
	}


	bool OgreRenderSystem::
	renderOneFrame()
	{
		bool ret = false;
		if (mNeedRedraw)
		{
			ret = Ogre::Root::getSingletonPtr()->renderOneFrame();
			mNeedRedraw = false;
		}

		return ret && mNeedRedraw;
	}


	void OgreRenderSystem::
	setFrustum(bool isPerspectiveView, float yFOV, float nearClip, float farClip,
			int width, int height,
			const vec3& viewPosition, const vec4& viewOrientation)
	{
		if (mCamera)
		{
			mCamera->setProjectionType(isPerspectiveView ? Ogre::PT_PERSPECTIVE : Ogre::PT_ORTHOGRAPHIC);
			if (isPerspectiveView)
			{
				mCamera->setFOVy(Ogre::Radian(yFOV));
				mCamera->setNearClipDistance(nearClip);
				mCamera->setFarClipDistance(farClip);
			}
			else
			{
				mCamera->setOrthoWindow(static_cast<Ogre::Real>(width), static_cast<Ogre::Real>(height));
				mCamera->setNearClipDistance(0.1f);
				mCamera->setFarClipDistance(farClip);
			}

			mCamera->setPosition(viewPosition.x, viewPosition.y, viewPosition.z);
			mCamera->setOrientation(Ogre::Quaternion(viewOrientation.w, viewOrientation.x, viewOrientation.y, viewOrientation.z));
		}
	}


	bool OgreRenderSystem::
	frameStarted(const Ogre::FrameEvent &evt)
	{
		return true;
	}


	bool OgreRenderSystem::
	frameEnded(const Ogre::FrameEvent &evt)
	{
		// show fps
		const Ogre::String	currFps = "Current FPS: ",
							avgFps = "Average FPS: ",
							tris = "Triangle Count: ",
							batches = "Batch Count: ";

		// update stats when necessary
		auto guiAvg = Ogre::OverlayManager::getSingleton().getOverlayElement("Core/AverageFps");
		auto guiCurr = Ogre::OverlayManager::getSingleton().getOverlayElement("Core/CurrFps");

		auto stats = mRenderWindow->getStatistics();
		guiAvg->setCaption(avgFps + Ogre::StringConverter::toString(stats.avgFPS));
		guiCurr->setCaption(currFps + Ogre::StringConverter::toString(stats.lastFPS));

		auto guiTris = Ogre::OverlayManager::getSingleton().getOverlayElement("Core/NumTris");
		guiTris->setCaption(tris + Ogre::StringConverter::toString(stats.triangleCount));

		auto guiBatches = Ogre::OverlayManager::getSingleton().getOverlayElement("Core/NumBatches");
		guiBatches->setCaption(batches + Ogre::StringConverter::toString(stats.batchCount));

		return true;
	}
}

#endif
