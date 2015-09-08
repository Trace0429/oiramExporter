#ifndef _Ogre_Render_System_hpp__
#define _Ogre_Render_System_hpp__

#include "rendersystem.h"
#ifndef NO_VIEW_EXTENDED
#include <OgreFrameListener.h>

namespace Ogre {
class OverlaySystem;
}

namespace oiram
{
	class OgreRenderSystem : public RenderSystem, public Ogre::FrameListener
	{
	public:
		OgreRenderSystem();
		~OgreRenderSystem();

		bool create(HWND hWnd, const char* componentPath) override;
		void destroy() override;

		bool loadScene(const char* sceneFileName) override;
		bool loadModel(const char* modelFileName) override;

		void resize() override;
		bool renderOneFrame() override;
		void setFrustum(bool isPerspectiveView, float yFOV, float nearClip, float farClip,
			int width, int height,
			const vec3& viewPosition, const vec4& viewOrientation) override;
		void notifyRedraw() override { mNeedRedraw = true; }

	private:
		bool frameStarted(const Ogre::FrameEvent &evt) override;
		bool frameEnded(const Ogre::FrameEvent &evt) override;

	private:
		Ogre::RenderWindow*		mRenderWindow;
		Ogre::SceneManager*		mSceneMgr;
		Ogre::OverlaySystem*	mOverlaySystem;
		Ogre::Camera*			mCamera;
		bool					mNeedRedraw;
	};
}

#endif

#endif
