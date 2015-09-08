--VRayMtl Modification
--by:feilang
--2008-07-30

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

try destroydialog fl_modifyVrayMtl catch()
rollout fl_modifyVrayMtl "VRayMtl Modification" width:166 height:189
(
--Adjust the vraymtl reflection subdivs
fn fl_reflSubdivs origMtl subdivs =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.reflection_subdivs = subdivs
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_reflSubdivs i subdivs
	)
	else if tempClass == VRayMtlWrapper then
		fl_reflSubdivs origMtl.baseMtl subdivs
	else if tempClass == VRayOverrideMtl then
	(
		fl_reflSubdivs origMtl.baseMtl subdivs
		fl_reflSubdivs origMtl.giMtl subdivs
		fl_reflSubdivs origMtl.reflectMtl subdivs
		fl_reflSubdivs origMtl.refractMtl subdivs
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_reflSubdivs origMtl.baseMtl subdivs
		fl_reflSubdivs origMtl.coatMtl[1] subdivs
		fl_reflSubdivs origMtl.coatMtl[2] subdivs
		fl_reflSubdivs origMtl.coatMtl[3] subdivs
		fl_reflSubdivs origMtl.coatMtl[4] subdivs
		fl_reflSubdivs origMtl.coatMtl[5] subdivs
		fl_reflSubdivs origMtl.coatMtl[6] subdivs
		fl_reflSubdivs origMtl.coatMtl[7] subdivs
		fl_reflSubdivs origMtl.coatMtl[8] subdivs
		fl_reflSubdivs origMtl.coatMtl[9] subdivs
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_reflSubdivs origMtl.frontMtl subdivs
		fl_reflSubdivs origMtl.backMtl subdivs	
	)
	else if tempClass == Blend then
	(
		fl_reflSubdivs origMtl.map1 subdivs
		fl_reflSubdivs origMtl.map2 subdivs
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_reflSubdivs i subdivs
	)
	else if tempClass == DoubleSided then
	(
		fl_reflSubdivs origMtl.material1 subdivs
		fl_reflSubdivs origMtl.material2 subdivs
	)
	else if tempClass == TopBottom then
	(
		fl_reflSubdivs origMtl.topMaterial subdivs
		fl_reflSubdivs origMtl.bottomMaterial subdivs
	)
	else if tempClass == Shell_Material then
	(
		fl_reflSubdivs origMtl.originalMaterial subdivs
		fl_reflSubdivs origMtl.bakedMaterial subdivs
	)
)
--Adjust the vraymtl refraction subdivs
fn fl_refrSubdivs origMtl subdivs =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.refraction_subdivs = subdivs
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_refrSubdivs i subdivs
	)
	else if tempClass == VRayMtlWrapper then
		fl_refrSubdivs origMtl.baseMtl subdivs
	else if tempClass == VRayOverrideMtl then
	(
		fl_refrSubdivs origMtl.baseMtl subdivs
		fl_refrSubdivs origMtl.giMtl subdivs
		fl_refrSubdivs origMtl.reflectMtl subdivs
		fl_refrSubdivs origMtl.refractMtl subdivs
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_refrSubdivs origMtl.baseMtl subdivs
		fl_refrSubdivs origMtl.coatMtl[1] subdivs
		fl_refrSubdivs origMtl.coatMtl[2] subdivs
		fl_refrSubdivs origMtl.coatMtl[3] subdivs
		fl_refrSubdivs origMtl.coatMtl[4] subdivs
		fl_refrSubdivs origMtl.coatMtl[5] subdivs
		fl_refrSubdivs origMtl.coatMtl[6] subdivs
		fl_refrSubdivs origMtl.coatMtl[7] subdivs
		fl_refrSubdivs origMtl.coatMtl[8] subdivs
		fl_refrSubdivs origMtl.coatMtl[9] subdivs
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_refrSubdivs origMtl.frontMtl subdivs
		fl_refrSubdivs origMtl.backMtl subdivs	
	)
	else if tempClass == Blend then
	(
		fl_refrSubdivs origMtl.map1 subdivs
		fl_refrSubdivs origMtl.map2 subdivs
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_refrSubdivs i subdivs
	)
	else if tempClass == DoubleSided then
	(
		fl_refrSubdivs origMtl.material1 subdivs
		fl_refrSubdivs origMtl.material2 subdivs
	)
	else if tempClass == TopBottom then
	(
		fl_refrSubdivs origMtl.topMaterial subdivs
		fl_refrSubdivs origMtl.bottomMaterial subdivs
	)
	else if tempClass == Shell_Material then
	(
		fl_refrSubdivs origMtl.originalMaterial subdivs
		fl_refrSubdivs origMtl.bakedMaterial subdivs
	)
)
--Turn the vraymtl reflection interpolation on
fn fl_reflInterOn origMtl =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.reflection_useInterpolation = on
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_reflInterOn i 
	)
	else if tempClass == VRayMtlWrapper then
		fl_reflInterOn origMtl.baseMtl 
	else if tempClass == VRayOverrideMtl then
	(
		fl_reflInterOn origMtl.baseMtl 
		fl_reflInterOn origMtl.giMtl 
		fl_reflInterOn origMtl.reflectMtl 
		fl_reflInterOn origMtl.refractMtl 
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_reflInterOn origMtl.baseMtl 
		fl_reflInterOn origMtl.coatMtl[1] 
		fl_reflInterOn origMtl.coatMtl[2] 
		fl_reflInterOn origMtl.coatMtl[3] 
		fl_reflInterOn origMtl.coatMtl[4] 
		fl_reflInterOn origMtl.coatMtl[5] 
		fl_reflInterOn origMtl.coatMtl[6] 
		fl_reflInterOn origMtl.coatMtl[7] 
		fl_reflInterOn origMtl.coatMtl[8] 
		fl_reflInterOn origMtl.coatMtl[9] 
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_reflInterOn origMtl.frontMtl 
		fl_reflInterOn origMtl.backMtl 	
	)
	else if tempClass == Blend then
	(
		fl_reflInterOn origMtl.map1 
		fl_reflInterOn origMtl.map2 
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_reflInterOn i 
	)
	else if tempClass == DoubleSided then
	(
		fl_reflInterOn origMtl.material1 
		fl_reflInterOn origMtl.material2 
	)
	else if tempClass == TopBottom then
	(
		fl_reflInterOn origMtl.topMaterial 
		fl_reflInterOn origMtl.bottomMaterial 
	)
	else if tempClass == Shell_Material then
	(
		fl_reflInterOn origMtl.originalMaterial 
		fl_reflInterOn origMtl.bakedMaterial 
	)
)
--Turn the vraymtl reflection interpolation off
fn fl_reflInterOff origMtl =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.reflection_useInterpolation = off
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_reflInterOff i 
	)
	else if tempClass == VRayMtlWrapper then
		fl_reflInterOff origMtl.baseMtl 
	else if tempClass == VRayOverrideMtl then
	(
		fl_reflInterOff origMtl.baseMtl 
		fl_reflInterOff origMtl.giMtl 
		fl_reflInterOff origMtl.reflectMtl 
		fl_reflInterOff origMtl.refractMtl 
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_reflInterOff origMtl.baseMtl 
		fl_reflInterOff origMtl.coatMtl[1] 
		fl_reflInterOff origMtl.coatMtl[2] 
		fl_reflInterOff origMtl.coatMtl[3] 
		fl_reflInterOff origMtl.coatMtl[4] 
		fl_reflInterOff origMtl.coatMtl[5] 
		fl_reflInterOff origMtl.coatMtl[6] 
		fl_reflInterOff origMtl.coatMtl[7] 
		fl_reflInterOff origMtl.coatMtl[8] 
		fl_reflInterOff origMtl.coatMtl[9] 
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_reflInterOff origMtl.frontMtl 
		fl_reflInterOff origMtl.backMtl 	
	)
	else if tempClass == Blend then
	(
		fl_reflInterOff origMtl.map1 
		fl_reflInterOff origMtl.map2 
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_reflInterOff i 
	)
	else if tempClass == DoubleSided then
	(
		fl_reflInterOff origMtl.material1 
		fl_reflInterOff origMtl.material2 
	)
	else if tempClass == TopBottom then
	(
		fl_reflInterOff origMtl.topMaterial 
		fl_reflInterOff origMtl.bottomMaterial 
	)
	else if tempClass == Shell_Material then
	(
		fl_reflInterOff origMtl.originalMaterial 
		fl_reflInterOff origMtl.bakedMaterial 
	)
)
--Turn the vraymtl refraction interpolation on
fn fl_refrInterOn origMtl =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.refraction_useInterpolation = on
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_refrInterOn i 
	)
	else if tempClass == VRayMtlWrapper then
		fl_refrInterOn origMtl.baseMtl 
	else if tempClass == VRayOverrideMtl then
	(
		fl_refrInterOn origMtl.baseMtl 
		fl_refrInterOn origMtl.giMtl 
		fl_refrInterOn origMtl.reflectMtl 
		fl_refrInterOn origMtl.refractMtl 
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_refrInterOn origMtl.baseMtl 
		fl_refrInterOn origMtl.coatMtl[1] 
		fl_refrInterOn origMtl.coatMtl[2] 
		fl_refrInterOn origMtl.coatMtl[3] 
		fl_refrInterOn origMtl.coatMtl[4] 
		fl_refrInterOn origMtl.coatMtl[5] 
		fl_refrInterOn origMtl.coatMtl[6] 
		fl_refrInterOn origMtl.coatMtl[7] 
		fl_refrInterOn origMtl.coatMtl[8] 
		fl_refrInterOn origMtl.coatMtl[9] 
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_refrInterOn origMtl.frontMtl 
		fl_refrInterOn origMtl.backMtl 	
	)
	else if tempClass == Blend then
	(
		fl_refrInterOn origMtl.map1 
		fl_refrInterOn origMtl.map2 
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_refrInterOn i 
	)
	else if tempClass == DoubleSided then
	(
		fl_refrInterOn origMtl.material1 
		fl_refrInterOn origMtl.material2 
	)
	else if tempClass == TopBottom then
	(
		fl_refrInterOn origMtl.topMaterial 
		fl_refrInterOn origMtl.bottomMaterial 
	)
	else if tempClass == Shell_Material then
	(
		fl_refrInterOn origMtl.originalMaterial 
		fl_refrInterOn origMtl.bakedMaterial 
	)
)
--Turn the vraymtl refraction interpolation off
fn fl_refrInterOff origMtl =
(	
	local tempClass = classof origMtl --Get the class of the origMtl
	if tempClass == VRayMtl then
		origMtl.refraction_useInterpolation = off
	else if tempClass == Multimaterial then
	(
		for i in origMtl.materialList do
			fl_refrInterOff i 
	)
	else if tempClass == VRayMtlWrapper then
		fl_refrInterOff origMtl.baseMtl 
	else if tempClass == VRayOverrideMtl then
	(
		fl_refrInterOff origMtl.baseMtl 
		fl_refrInterOff origMtl.giMtl 
		fl_refrInterOff origMtl.reflectMtl 
		fl_refrInterOff origMtl.refractMtl 
	)
	else if tempClass == VRayBlendMtl then
	(
		fl_refrInterOff origMtl.baseMtl 
		fl_refrInterOff origMtl.coatMtl[1] 
		fl_refrInterOff origMtl.coatMtl[2] 
		fl_refrInterOff origMtl.coatMtl[3] 
		fl_refrInterOff origMtl.coatMtl[4] 
		fl_refrInterOff origMtl.coatMtl[5] 
		fl_refrInterOff origMtl.coatMtl[6] 
		fl_refrInterOff origMtl.coatMtl[7] 
		fl_refrInterOff origMtl.coatMtl[8] 
		fl_refrInterOff origMtl.coatMtl[9] 
	)
	else if tempClass == VRay2SidedMtl then
	(
		fl_refrInterOff origMtl.frontMtl 
		fl_refrInterOff origMtl.backMtl 	
	)
	else if tempClass == Blend then
	(
		fl_refrInterOff origMtl.map1 
		fl_refrInterOff origMtl.map2 
	)
	else if tempClass == compositematerial then
	(
		for i in origMtl.materialList do
		fl_refrInterOff i 
	)
	else if tempClass == DoubleSided then
	(
		fl_refrInterOff origMtl.material1 
		fl_refrInterOff origMtl.material2 
	)
	else if tempClass == TopBottom then
	(
		fl_refrInterOff origMtl.topMaterial 
		fl_refrInterOff origMtl.bottomMaterial 
	)
	else if tempClass == Shell_Material then
	(
		fl_refrInterOff origMtl.originalMaterial 
		fl_refrInterOff origMtl.bakedMaterial 
	)
)
    --Rollout interface
	spinner spn_subRefl "Subdivs" pos:[29,31] width:70 height:16 range:[0,1000,8] type:#integer
	GroupBox grp1 "Reflection" pos:[6,10] width:152 height:65
	button btn_reflSubdivs "OK" pos:[105,30] width:30 height:18
	label lbl1 "Use interpolation" pos:[15,55] width:125 height:17
	button btn_reflOff "Off" pos:[127,53] width:25 height:18
	button btn_reflOn "On" pos:[99,53] width:25 height:18
	spinner spn_subRefr "Subdivs" pos:[29,119] width:70 height:16 range:[0,1000,8] type:#integer
	GroupBox grp2 "Refraction" pos:[6,98] width:152 height:65
	button btn_refrSubdivs "OK" pos:[105,118] width:30 height:18
	label lbl2 "Use interpolation" pos:[15,143] width:125 height:17
	button btn_refrOff "Off" pos:[127,141] width:25 height:18
	button btn_refrOn "On" pos:[99,141] width:25 height:18
	radiobuttons rdoScale "" pos:[13,78] width:150 height:16 labels:#("Whole", "Mtl Editor") default:1 columns:2
	HyperLink hplbs "www.cgplusplus.com" pos:[9,170] width:104 height:15 color:(color 255 127.5 0) hovercolor:(color 0 0 255) visitedcolor:(color 0 0 255) address:"http://www.cgplusplus.com/bbs"
	button btn21 "?" pos:[138,168] width:20 height:18
	local reflSubdivs = 8,refrSubdivs = 8
	--Reflection modify
	-- Refraction mofify

	on spn_subRefl changed val do --Get the reflection subdivs number
	(
		reflSubdivs = val 
	)
	on btn_reflSubdivs pressed do --Set the reflection subdivs number
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_reflSubdivs i reflSubdivs
			2: for i in meditmaterials do fl_reflSubdivs i reflSubdivs
		)
	)
	on btn_reflOff pressed do --Turn off the reflection interploation
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_reflInterOff i
			2: for i in meditmaterials do fl_reflInterOff i
		)
	)
	on btn_reflOn pressed do --Turn on the reflection interploation
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_reflInterOn i
			2: for i in meditmaterials do fl_reflInterOn i
		)
	)
	on spn_subRefr changed val do --Get the refraction subdivs number
	(
		refrSubdivs = val
	)
	on btn_refrSubdivs pressed do --Set the refraction subdivs number
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_refrSubdivs i refrSubdivs
			2: for i in meditmaterials do fl_refrSubdivs i refrSubdivs
		)
	)
	on btn_refrOff pressed do --Turn off the refraction interploation
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_refrInterOff i
			2: for i in meditmaterials do fl_refrInterOff i
		)
	)
	on btn_refrOn pressed do --Turn on the refraction interploation
	(
		case rdoScale.state of
		(
			1: for i in scenematerials do fl_refrInterOn i
			2: for i in meditmaterials do fl_refrInterOn i
		)
	)
	on btn21 pressed  do
	(
		tips =  "场景VRayMtl修改，对场景VRayMtl材质整体的控制，可以选择Whole（整个场景所有材质）\n和MtlEditor（材质编辑器）两种范围，能够修改的复合材质包括："
		tips += "Blend,Composite,Double Dided,\nMulti/sub-Object,Shell Material,TopBottom,VRay2SidedMtl,VRayBlendMtl,VRayMtlWrapper,VRayOverrideMtl，\n"
		messagebox tips title:("材质转换") beep:off
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild fl_modifyVrayMtl width:166
else createdialog fl_modifyVrayMtl
