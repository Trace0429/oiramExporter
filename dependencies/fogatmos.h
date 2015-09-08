#ifndef __FOGATMOS__H
#define __FOGATMOS__H

/**********************************************************************
 *<
	FILE: fog.cpp	

	DESCRIPTION: Simple fog atmospheric effect

	CREATED BY: Rolf Berteig

	HISTORY: 11/21/95

 *>	Copyright (c) 1994, All Rights Reserved.
 **********************************************************************/

#include "imtl.h"
#include "render.h"  
#include <bmmlib.h>
#include "iparamm.h"
#include "texutil.h"
#include "stdmat.h"

#define fogClassID Class_ID(FOG_CLASS_ID,0)
#define FOG_CLASSNAME _T("")//GetString(IDS_RB_FOG)

//--- Parameter Maps ----------------------------------------------------

#define PB_COLOR	0
#define PB_USEMAP	1
#define PB_USEOPAC	2
#define PB_FOGBG	3
#define PB_TYPE		4
#define PB_NEAR		5
#define PB_FAR		6
#define PB_TOP		7
#define PB_BOTTOM	8
#define PB_DENSITY	9
#define PB_FALLOFF	10
#define PB_HNOISE	11
#define PB_SCALE	12
#define PB_ANGLE	13
#define PB_PHASE	14
#define PB_EXP		15


class FogDlgProc;

class FogAtmos : public StdFog {
	public:
		// Parameters
		IParamBlock *pblock;
		Texmap *map, *opac;
		CRITICAL_SECTION csect;
		
		// Caches
		Color fogColor;
		float nearF, farF, top, bottom, density, far_minus_near, fog_range;
		float scale, angle, phase;
		int type, falloff, useMap, useOpac, hnoise, fogBG, exponential;
		Interval valid;		

		static FogDlgProc *dlg;

		FogAtmos();
		~FogAtmos() { 	DeleteCriticalSection(&csect);		}
		void UpdateCaches(TimeValue t);

		// Methods from StdFog:
		void SetColorMap(Texmap *tex) {	ReplaceReference(1,tex); tex->InitSlotType(MAPSLOT_ENVIRON); }
		void SetOpacMap(Texmap *tex) {	ReplaceReference(2,tex); tex->InitSlotType(MAPSLOT_ENVIRON); }
		void SetColor(Color c, TimeValue t){ pblock->SetValue(PB_COLOR,t,c); }		
		void SetUseMap(BOOL onoff){ pblock->SetValue(PB_USEMAP,0,onoff); }		
		void SetUseOpac(BOOL onoff){ pblock->SetValue(PB_USEOPAC,0,onoff); }		
		void SetFogBackground(BOOL onoff) { pblock->SetValue(PB_FOGBG,0,onoff); }		
		void SetType(int type) { pblock->SetValue(PB_TYPE,0,type); }		
		void SetNear(float v, TimeValue t) { pblock->SetValue(PB_NEAR,t,v); }		
		void SetFar(float v, TimeValue t){ pblock->SetValue(PB_FAR,t,v); }		
		void SetTop(float v, TimeValue t) { pblock->SetValue(PB_TOP,t,v); }		
		void SetBottom(float v, TimeValue t) { pblock->SetValue(PB_BOTTOM,t,v); }		
		void SetDensity(float v, TimeValue t) { pblock->SetValue(PB_DENSITY,t,v); }		
		void SetFalloffType(int tp) { pblock->SetValue(PB_FALLOFF,0,tp); }		
		void SetUseNoise(BOOL onoff)  { pblock->SetValue(PB_HNOISE,0,onoff); }		
		void SetNoiseScale(float v, TimeValue t){ pblock->SetValue(PB_SCALE,t,v); }		
		void SetNoiseAngle(float v, TimeValue t) { pblock->SetValue(PB_ANGLE,t,v); }		
		void SetNoisePhase(float v, TimeValue t) { pblock->SetValue(PB_PHASE,t,v); }		

		Color GetColor(TimeValue t) { return pblock->GetColor(PB_COLOR,t); }
		BOOL GetUseMap() { return pblock->GetInt(PB_USEMAP,0); }
		BOOL GetUseOpac() { return pblock->GetInt(PB_USEOPAC,0); }
		Texmap *GetColorMap() { return map; } 
		Texmap *GetOpacMap() { return opac; }
		BOOL GetFogBackground() { return pblock->GetInt(PB_FOGBG,0); }
		int GetType() { return pblock->GetInt(PB_TYPE,0); }
		float GetNear(TimeValue t) { return pblock->GetFloat(PB_NEAR,t); }
		float GetFar(TimeValue t) { return pblock->GetFloat(PB_FAR,t); }
		float GetTop(TimeValue t) { return pblock->GetFloat(PB_BOTTOM,t); }
		float GetBottom(TimeValue t) { return pblock->GetFloat(PB_TOP,t); }
		float GetDensity(TimeValue t) { return pblock->GetFloat(PB_DENSITY,t); }
		int GetFalloffType() { return pblock->GetInt(PB_FALLOFF,0); }
		BOOL GetUseNoise() { return pblock->GetInt(PB_HNOISE,0); }
		float GetNoiseScale( TimeValue t) { return pblock->GetFloat(PB_SCALE,t); }
		float GetNoiseAngle( TimeValue t) { return pblock->GetFloat(PB_ANGLE,t); }
		float GetNoisePhase( TimeValue t) { return pblock->GetFloat(PB_PHASE,t); }


		// Animatable/Reference
		int NumSubs() {return 3;}
		Animatable* SubAnim(int i);
		TSTR SubAnimName(int i);
		int NumRefs() {return 3;}
		RefTargetHandle GetReference(int i);
		void SetReference(int i, RefTargetHandle rtarg);
		Class_ID ClassID() {return fogClassID;}
		void GetClassName(TSTR& s) {s=FOG_CLASSNAME;}
		void DeleteThis() {delete this;}
		RefResult NotifyRefChanged(Interval changeInt, RefTargetHandle hTarget, 
	         PartID& partID,  RefMessage message);

		void RescaleWorldUnits(float f);
		IOResult Load(ILoad *iload);

		// Atmospheric
		TSTR GetName() {return FOG_CLASSNAME;}
		AtmosParamDlg *CreateParamDialog(IRendParams *ip);
		int RenderBegin(TimeValue t, ULONG flags);
		int RenderEnd(TimeValue t);
		void Update(TimeValue t, Interval& valid);
		void Shade(ShadeContext& sc,const Point3& p0,const Point3& p1,Color& color, Color& trans, BOOL isBG=FALSE);		
	};

#endif