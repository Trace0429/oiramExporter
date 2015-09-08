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

try destroydialog SPrandomSelect catch() 

--Right click munu
	rcmenu SPrandomSelectMenu
	(
		menuItem selectHelp "Help" checked:false
		separator selectButtonHelp
		menuItem selectVertex "Vertex" checked:false
		menuItem selectEdge "Edge" checked:false
		menuItem selectPolygon "Polygon" checked:false
		menuItem selectElement "Element" checked:false
	/*	on SPrandomSelectMenu open do
		( 	tempType = fl_JudgeTheSelection ()
			if tempType == 0 then
			(	selectVertex .enabled = false
				selectEdge .enabled = false
				selectPolygon .enabled = false
				selectElement .enabled = false
			)
			else 
			(	selectVertex .enabled = true
				selectEdge .enabled = true
				selectPolygon .enabled = true
				selectElement .enabled = true
			)
		
		)--end off open
	*/
		on selectHelp picked do
		(	tips = "1、如果没有选择物体，则“选择物体”按照视图中物体的百分比选择物体。\n"
			tips += "2、如果选择物体个数大于1，则按选择物体百分比选择物体。\n"
			tips += "3、如果选择了一个EPoly，则“点”，“线”，“面”，“元素”按照点、线、面、元素的百分比选择。\n"
			tips += "      “总量”显示点，线，面或元素的总个数，“选择”显示选择点，线，面或元素的个数。\n"
			tips += "4、单击刷新可显示场景物体或单个EPoly的子层级个数。"
			messagebox tips title:("随机选择") beep:off
		)
		on selectVertex picked do
		(	subobjectLevel = 1
			SPrandomSelect.SPrandomSelectSub 1 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectEdge picked do
		(	subobjectLevel = 2
			SPrandomSelect.SPrandomSelectSub 2 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectPolygon picked do
		(	subobjectLevel = 4
			SPrandomSelect.SPrandomSelectSub 4 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectElement picked do
		(	subobjectLevel = 5
			SPrandomSelect.SPrandomSelectSub 5 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)	
	)
rollout SPrandomSelect "随机操作" width:240 height:241
(
	GroupBox grp_sublevel "随机选择" pos:[3,5] width:232 height:83
	spinner spn_percent "百分比： " pos:[34,23] width:80 height:16 range:[0,100,30]
	edittext edt_total "总量：" pos:[103,45] width:122 height:16 readOnly:true
	edittext edt_select "选择：" pos:[103,64] width:122 height:16 readOnly:true
	button btn_refesh "刷新" pos:[177,23] width:32 height:16 toolTip:"重新计算选择物体个数或点线面体数量"
	GroupBox grp_randomTransform "随机变形" pos:[3,88] width:232 height:87
	GroupBox grp_minAndMax "最小：    最大：" pos:[12,107] width:148 height:62
	spinner spn_scaleMin "%" pos:[26,124] width:55 height:16 range:[0,500,80]
	spinner spn_scaleMax "%" pos:[99,124] width:55 height:16 range:[0,500,120]
	spinner spn_rotateMin "度" pos:[24,145] width:57 height:16 range:[-180,180,-180]
	spinner spn_rotateMax "度" pos:[97,145] width:57 height:16 range:[-180,180,180]
	button btn_randomScale "缩放" pos:[170,125] width:55 height:16 toolTip:"选择物体整体随机缩放,右键归位"
	button btn_randomRotate "旋转" pos:[170,148] width:55 height:16 toolTip:"选择物体沿Z轴随机旋转,右键归位"
	GroupBox grp7 "轴心变换" pos:[3,178] width:232 height:58
	button btn_centerPivot "轴心归中" pos:[8,196] width:68 height:16 toolTip:"将物体轴心移到物体中心"
	button btn_bottomPivot "轴心归底" pos:[79,196] width:68 height:16 toolTip:"将物体轴心移到物体正底部"
	button btn_centerObject "归坐标中心" pos:[150,196] width:80 height:16 toolTip:"将物体移动到轴心位置"
	button btn_zeroMin "最低点归零" pos:[8,216] width:90 height:16 toolTip:"将物体的最低点Z轴坐标归0"
	checkbox chk_groupFirst "打组物体优先" pos:[105,217] width:110 height:16
	button btn_selectObj "选择物体" pos:[120,23] width:55 height:16 toolTip:"随机选择物体"
	button btn_vertex "点" pos:[18,45] width:35 height:16 toolTip:"随机选择点"
	button btn_edge "线" pos:[58,44] width:35 height:16 toolTip:"随机选择线"
	button btn_polygen "面" pos:[18,64] width:35 height:16 toolTip:"随机选择面"
	button btn_element "元素" pos:[58,64] width:35 height:16 toolTip:"随机选择元素"
	button btn_help "?" pos:[210,23] width:15 height:16
	button btn_scaleHelp "?" pos:[208,103] width:15 height:16
	button btn15 "?" pos:[214,216] width:15 height:16
	local fl_tips01="场景助手提示"
	--Judge the number of selection
fn fl_JudgeTheSelection = 
(	local type
	if selection.count == 1 then
	(	tempClass = classof (modPanel.getCurrentObject())
		if tempClass == Editable_Poly then
		(
			type = 1
			
			)
		else type = 0
	)
	else type = 0
)
fn fl_ifSelectPoly =
	(
		if fl_JudgeTheSelection() == 1 then return true
		else (
		messagebox "请选择一个EPoly物体并设置当前修改器在Editable Poly下！" title:fl_tips01 beep:off
		return false
		)
	)
	--Get element numbers
	fn fl_getElementItem SourceOBJ =
	(	
		tempSel = polyop.getFaceSelection SourceOBJ
		elementFirstFlags = #()
		faceCount = polyOp.getNumFaces SourceOBJ
		faceFlags = #{1..faceCount}
		for i in 1 to faceCount where not faceFlags.isempty do
		(	--start element count loop
			if faceFlags[i] then
			(	append elementFirstFlags i
				SourceOBJ.EditablePoly.SetSelection #Face #{i}
				SourceOBJ.selectElement()
				TargetElement = polyop.getFaceSelection SourceOBJ
				faceFlags -= TargetElement
			)
			else()
		)
		polyOp.setFaceSelection SourceOBJ tempSel
		elementFirstFlags
	)
	-- Random select objects
	fn fl_randomselectObjs vP =
	(
		objNum = selection.count
		if objNum == 0 then
		(
			objs = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])--collect scene objects
			n = objs.count 
			if n != 0 then --If there are no objects selected
			(	sObj = #() 
				--Select objects by percent
				while sObj.count as float/n*100 < vP do  --collect select objects
				(
					tN = random 1 n
					if finditem sObj objs[tN] == 0 then
					(
						append sObj objs[tN]
					)
				) --end while
				select sObj
			)
			else messagebox "当前视图中没有看得见的物体:)" title:fl_tips01
		)
		else if objNum > 0 then --If there are objects selected
		(
			objs = getCurrentSelection()
			n = objs.count
				--Select objects by percent
				sObj = #() 
				while (sObj.count/n as float)*100 < vP do  --collect select objects
				(
					tN = random 1 n
					if finditem sObj objs[tN] == 0 then
					(
						append sObj objs[tN]
					)
				) --end while
				select sObj
		)
		else()
	)
	--Random select subobject level
	fn SPrandomSelectSub subNum vP =
	(
		case subNum of 
		(
			--random select vertexs
			1: (
					tV = polyOp.getNumVerts $  --total vertexs
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select vertexs
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setVertSelection $ (sB as bitarray)
					max views redraw
				)
			--random select edges
			2: (
					tV = polyOp.getNumEdges $ --total edges
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select edges
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setEdgeSelection $ (sB as bitarray)
					max views redraw
				)
		/*	3: (
					tV = polyOp.getOpenEdges $
					polyOp.setEdgeSelection $ (tV as bitarray)
					max views redraw
				)
		*/
			4: (
					tV = polyOp.getNumFaces $ --total faces
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select faces
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setFaceSelection $ (sB as bitarray)
					max views redraw
				)
			5: (
					fV = fl_getElementItem $ --get Element flags
					tV = fV.count
					sV = #()
					sB = #()
					while sB.count/tV as float*100 < vP do
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)
					if sB.count != 0 then
						for j in sB do append sV fV[j]
					polyOp.setFaceSelection $ (sV as bitarray)
					$.selectElement()
					max views redraw
				)
			default: ()
			)
	
	)
	--Get Subobject numbers
	fn fl_getSubojectNum obj subNum =
	(	num = case subNum of
		(
			1:	 polyOp.getNumVerts obj
			2:	 polyOp.getNumEdges obj
			--3:	 (polyOp.getOpenEdges obj).numberSet
			4:	 polyOp.getNumFaces obj
			5:	(fl_getElementItem obj).count
			default:	 0
		)
	)
	fn fl_getSubojectSel obj subNum =
	(
		num = case subNum of
		(
			1:	 (polyOp.getVertSelection obj).numberSet
			2:	 (polyOp.getEdgeSelection obj).numberSet
			--3:	 (polyOp.getEdgeSelection obj).numberSet
			4:	 (polyOp.getFaceSelection obj).numberSet
			5:	(
					tempSel = polyop.getFaceSelection obj
					sel = copy tempSel
					elementFirstFlags = #()
					faceCount = tempSel.numberSet
					for i in tempSel where not tempSel.isempty do
					(	--start element count loop
						if tempSel[i] then
						(	append elementFirstFlags i
							obj.EditablePoly.SetSelection #Face #{i}
							obj.selectElement()
							TargetElement = polyop.getFaceSelection obj
							tempSel -= TargetElement
						)
						else()
					)
					polyOp.setFaceSelection obj sel
					elementFirstFlags.count
				)
			default:	 0
		)
	)
	fn CommaNumbers numberstring divstring:"," = 
	(	numCount=numberstring.count 
			for i = (numCount- 3) to 1 by -3 do
			(	numberstring = replace numberstring i 1 (numberstring[i]+divstring)
			 )
			numberstring
	)

	on btn_refesh pressed do
	(	
		tempSelectObj = selection.count
		tempType = fl_JudgeTheSelection ()
		if tempSelectObj == 1 then --One object selected
		(	if tempType == 1 then
			(	--Modifier supported
				subNum = fl_getSubojectNum $ subObjectlevel
				subSel = fl_getSubojectSel $ subObjectlevel
				edt_total.text = CommaNumbers (subNum as string)
				edt_select.text = CommaNumbers (subSel as string)
			)
			else --No modifier supported
			(	edt_total.text = "1"
				edt_select.text = "1"
				)
		)
		else if tempSelectObj == 0 then --No objects selected
		( 	objs = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])--collect scene objects
			edt_total.text = CommaNumbers (objs.count as string)
			edt_select.text = "0"
		)
		else --Objects selected
		(	edt_total.text = CommaNumbers (tempSelectObj as string)
			edt_select.text = edt_total.text
		)
	)
	on btn_randomScale pressed do
	(	
		undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			scaleV = (random spn_scaleMin.value spn_scaleMax.value)/100
			i.scale=[scaleV,scaleV,scaleV]
		)
		) --end undo on
	)
	on btn_randomScale rightClick do
	(	undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			i.scale=[1,1,1]
		)
		) --end undo on
	)
	on btn_randomRotate pressed do
	(
		undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(	rotateV = random spn_rotateMin.value spn_rotateMax.value
			i.rotation.z_rotation = rotateV
		)
		) --end undo on
	)
	on btn_randomRotate rightClick do
	(	undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			i.rotation.z_rotation = 0
		)
		) --end undo on
	)
	on btn_centerPivot pressed do
	(	if selection.count == 0 then messagebox "请先选择物体！" title:fl_tips01
		else 
		(	
			undo on (
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do CenterPivot i 
			)--end undo on
		)
	)
	on btn_bottomPivot pressed do
	(	if selection.count == 0 then messagebox "请先选择物体！" title:fl_tips01
		else 
		(	undo on(
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do
			(	CenterPivot i
				i.pivot.z = i.min.z
			)
			)--end undo on
		)
	)
	on btn_centerObject pressed do
	(	if selection.count == 0 then messagebox "请先选择物体！" title:fl_tips01
		else 
		(	if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			undo on (
			for i in selectObj do
				CenterObject i 
			)--end undo on
		)
	)
	on btn_zeroMin pressed do
	(	if selection.count == 0 then messagebox "请先选择物体！" title:fl_tips01
		else 
		(	undo on(
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do
			(	tempZ = i.pos.z
				tempMinZ = i.min.z
				i.pivot.z = i.min.z
				i.pos.z = 0
				i.pivot.z = tempZ - tempMinZ
			)
			)--end undo on
		)
	
	)
	on btn_selectObj pressed do
	(
		fl_randomselectObjs spn_percent.value
		btn_refesh.pressed()
	)
	on btn_vertex pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectVertex.picked()
		)
		else()
	)
	on btn_edge pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectEdge.picked()
		)
		else()	
	)
	on btn_polygen pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectPolygon.picked()
		)
		else()	
	)
	on btn_element pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectElement.picked()
		)
		else()
	)
	on btn_help pressed do
	(
		SPrandomSelectMenu.selectHelp.picked()
		)
	on btn_scaleHelp pressed do
	(
		tips = "1、缩放按照原物体的百分比进行，每个物体缩放大小取最大与最小百分\n      比一个随机值，单击右键可将选择物体都调到原始大小，可撤销！\n"
		tips += "2、旋转按原始方向进行，每个物体旋转角度取最大最小角度一个随机值，\n      单击右键可将选择物体角度都调到原始角度，可撤销！"
		messagebox tips title: fl_tips01 beep:off
	)
	on btn15 pressed  do
	(
		str = "轴心归中：将选择的物体轴心归中，相当于Hierarchy面板的Pivot/Affect Pivot Only -\n"
		str +="Center to Object。遵循“打组物体优先”。\n"
		str +="轴心归底：将选择的物体轴心归到底部中心位置。遵循“打组物体优先”。\n"
		str +="归坐标中心：将物体移到轴心位置，相当于Hierarchy面板的Pivot/Affect Object Only - \n"
		str +="Center to Pivot.遵循“打组物体优先”。\n"
		str +="最低点归零：将选择物体以最低点为准移到X，Y轴水平面上。遵循“打组物体优先”。\n"
		str +="打组物体优先：如果勾选，只对打组物体的最外层组别进行轴心操作，不勾选对选择\n物体所有子物体操作。"
		messagebox str title: fl_tips01 beep:off
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild SPrandomSelect width:240
else createdialog SPrandomSelect
