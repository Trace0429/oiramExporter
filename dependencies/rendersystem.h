#ifndef _Render_System_hpp__
#define _Render_System_hpp__

#include "type.h"
#include <Windows.h>

namespace oiram
{
	class RenderSystem
	{
	public:
		RenderSystem() {}
		virtual ~RenderSystem() {}

		virtual bool create(HWND hWnd, const char* componentPath) = 0;
		virtual void destroy() = 0;

		virtual bool loadScene(const char* sceneFileName) = 0;
		virtual bool loadModel(const char* modelFileName) = 0;

		virtual void resize() {}
		virtual bool renderOneFrame() { return true; }
		virtual void notifyRedraw() {}

		virtual void setFrustum(bool isPerspectiveView, float yFOV, float nearClip, float farClip,
			int width, int height,
			const vec3& viewPosition, const vec4& viewOrientation) {}
	};
}

#endif
