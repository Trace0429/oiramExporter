--作者：飞浪
--Author:Feilang
--www.cgplusplus.com
--------------------------------------------------
--欢迎使用场景助手4.0 

----开源奉献----

---------------------------------------------------
--场景助手4.0		2011-04-01
--场景助手3.0		2009-08-01
--场景助手2.6		2009-03-30
--场景助手2.0		2008-08-06
--场景助手1.0		2008-05-27
try destroydialog SP4mtlConverter catch() 
rollout SP4mtlConverter "材质转换" width:132 height:110
(
	local clickStdmat=0,clickVraymat=0,clickSpemat=0,sceneObjs=#(),selectedMtls=#()
	button btn_standard_2_vraymtl "Standard--->>VRayMtl" pos:[5,4] width:120 height:18 toolTip:"将Standard材质转为VRayMtl"
	button btn_vraymtl_2_standard "VRayMtl--->>Standard" pos:[5,28] width:120 height:18 toolTip:"将VRayMtl材质转为Standard"
	radiobuttons rdo_convertScale "材质范围：" pos:[12,52] width:93 height:46 labels:#("场景所有  ", "编辑器  ") default:1 columns:1
	button btn29 "?" pos:[108,88] width:20 height:18
	local fl_friendllytips="场景助手提示"
	--modify vraymtl
	--Judge if it is VRay renderer
	fn fl_ifVRayRenderer =
	(	local r=renderers.current as string
		if matchPattern r pattern:"V_ray*" then true
		else false
	)
	--minus the first array from the second
fn fl_minusArr arrAll arrExclude  =
(	local a=arrAll.count
 	local b=arrExclude.count
	for i=1 to b do
	(	
		for j=arrAll.count to 1 by -1 do
		(		
			if arrAll[j]==arrExclude[i] do deleteItem arrAll j
		)
	) 
	arrAll
)

--Convert materials:
--Convert standard to vraymtl
fn fl_StandardToVRayMtl origMtl = 
(
	local r=VRayMtl()
	r.name=origMtl.name
	
	if origMtl.bumpMap != undefined then
	(
		r.texmap_bump=origMtl.bumpMap
		r.texmap_bump_on=origMtl.bumpMapEnable
		r.texmap_bump_multiplier=origMtl.bumpMapAmount
	)
 
 	if origMtl.displacementMap != undefined then
	(	r.texmap_displacement=origMtl.displacementMap
		r.texmap_displacement_on=origMtl.displacementMapEnable
		r.texmap_displacement_multiplier=origMtl.displacementMapAmount
	)
	
	r.diffuse=origMtl.diffuse
	if origMtl.diffuseMap != undefined then
	(
		r.texmap_diffuse=origMtl.diffuseMap
		r.texmap_diffuse_on=origMtl.diffuseMapEnable
		r.texmap_diffuse_multiplier=origMtl.diffuseMapAmount
	)
	
	if origMtl.opacityMap != undefined then
	(
		r.texmap_opacity=origMtl.opacityMap
		r.texmap_opacity_on=origMtl.opacityMapEnable
		r.texmap_opacity_multiplier=origMtl.opacityMapAmount
	)
	
	r
)
--Convert vraymtl to standard
fn fl_VRayMtlToStandard origMtl =
(
	local s=Standard ()
	s.name=origMtl.name
	
	if origMtl.texmap_bump != undefined then
	(
		s.bumpMap = origMtl.texmap_bump
		s.bumpMapEnable = origMtl.texmap_bump_on
		s.bumpMapAmount=origMtl.texmap_bump_multiplier
	)
	
	if origMtl.texmap_displacement != undefined then
	(
		s.displacementMap=origMtl.texmap_displacement
		s.displacementMapEnable=origMtl.texmap_displacement_on
		s.displacementMapAmount=origMtl.texmap_displacement_multiplier
	)

	s.diffuse=origMtl.diffuse
	if origMtl.texmap_diffuse != undefined then
	(
		s.diffuseMap=origMtl.texmap_diffuse
		s.diffuseMapEnable=origMtl.texmap_diffuse_on
		s.diffuseMapAmount=origMtl.texmap_diffuse_multiplier
	)
	
	if origMtl.texmap_opacity != undefined then
	(
		s.opacityMap=origMtl.texmap_opacity
		s.opacityMapEnable=origMtl.texmap_opacity_on
		s.opacityMapAmount=origMtl.texmap_opacity_multiplier
	)
	s
)

--Create VRayMtl
fn fl_CreateVRaymtl origMtl =
(	if classof origMtl == Standardmaterial then origMtl = fl_StandardToVRayMtl origMtl
	if classof origMtl == Multimaterial then
	(	num = getNumSubMtls origMtl
		for i=1 to num do (
			setSubMtl origMtl i (fl_CreateVRaymtl (getSubMtl origMtl i))
		)
	)
	origMtl
)
--Create Standard
fn fl_CreateStandard origMtl =
(	if classof origMtl == VRayMtl then origMtl = fl_VRayMtlToStandard origMtl
	if classof origMtl == Multimaterial then
	(	num = getNumSubMtls origMtl
		for i=1 to num do (
			setSubMtl origMtl i (fl_CreateStandard (getSubMtl origMtl i))
		)
	)
	origMtl
)
--Convert materials from objects
fn fl_AllVrayMtlsToStandard convertobjs mtlLibrary =
(	local tempMtl,tempObjs=#()
	for i in mtlLibrary do
	(	tempMtl = fl_CreateStandard i
		for o in convertobjs do
		(	if o.material==i then
			( 	o.material = tempMtl
 				append tempObjs o
			)
		)
		convertobjs = fl_minusArr convertobjs tempObjs 
		tempObjs=#()
	)
)
fn fl_AllStandardToVraymtl convertobjs mtlLibrary =
(	local tempMtl ,tempObjs=#()
	for i in mtlLibrary do
	(	tempMtl = fl_CreateVRaymtl i
		for o in convertobjs do
		(	if o.material==i then
			( 	o.material = tempMtl
				append tempObjs o
			)
		)
		convertobjs = fl_minusArr convertobjs tempObjs 
		tempObjs=#()
	)
)
	on btn_standard_2_vraymtl pressed do
	(	
		if fl_ifVRayRenderer() then
		(	case rdo_convertScale.state of
			(	1:	(	sceneObjs=for i in objects where i.material!=undefiend collect i
						mtlslib = for m in scenematerials where classof m == Standardmaterial or classof m == Multimaterial collect m
						if mtlslib.count != 0 then
						(
							fl_AllStandardToVraymtl sceneObjs mtlslib
						)
						else messagebox "场景中没有材质！" title:fl_friendllytips
					)
				2: 	(	sceneObjs=for i in objects where i.material!=undefiend collect i
						mtlslib = #();mtlNum = #()
						for i in meditmaterials do
						(	Idx = findItem scenematerials i
							if Idx != 0 then 
							(	append mtlslib scenematerials[Idx]
								append mtlNum Idx
							)
						) 
						if mtlslib.count != 0 then
						(	fl_AllStandardToVraymtl sceneObjs mtlslib
						)
						else
						(	for  m in 1 to 24 do
							(	meditmaterials[m] = fl_CreateVRaymtl meditmaterials[m]
							)
						)
					)
			)-- end case
		)
		else messagebox "当前渲染器不是VRay渲染器，请调整下先！"
	)
	on btn_vraymtl_2_standard pressed do
	(	
		if fl_ifVRayRenderer() then
		(	case rdo_convertScale.state of
			(	1:	(	sceneObjs=for i in objects where i.material!=undefiend collect i
						mtlslib = for m in scenematerials where classof m == VRayMtl or classof m == Multimaterial collect m
						if mtlslib.count != 0 then
						(
							fl_AllVrayMtlsToStandard sceneObjs mtlslib
						)
						else messagebox "场景中没有材质！" title:fl_friendllytips
					)
				2: 	(	sceneObjs=for i in objects where i.material!=undefiend collect i
						mtlslib = #();mtlNum = #()
						for i in meditmaterials do
						(	Idx = findItem scenematerials i
							if Idx != 0 then 
							(	append mtlslib scenematerials[Idx]
								append mtlNum Idx
							)
						)  
						if mtlslib.count != 0 then
						(	fl_AllVrayMtlsToStandard sceneObjs mtlslib
						)
						else
						(	for  m in 1 to 24 do
							(	meditmaterials[m] = fl_CreateStandard meditmaterials[m]
							)
						)
					)
			)-- end case
		)
		else messagebox "当前渲染器不是VRay渲染器，请调整下先！"
	)
	on btn29 pressed do
	(
		tips= "转换材质功能只适用于：Standard, VRayMtl, Muti/Sub-Object"
		messagebox tips title:("材质转换") beep:off
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild SP4mtlConverter width:132
else createdialog SP4mtlConverter