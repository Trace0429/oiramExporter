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

rollout fl_specialFunctions "特殊功能" width:240 height:123
(
	button btn_freeMemory "释放内存" pos:[4,4] width:55 height:16 toolTip:"释放场景中所有贴图使用的内存并清除撤消保存的操作"
	button btn_selectMissUVObjs "找丢失UV的物体" pos:[61,4] width:96 height:16
	button btn_selectOutSceneObj "选择当前视图看不到的物体" pos:[4,22] width:154 height:16 toolTip:"选择当前激活视图看不到的geometry和shapes"
	button btn_selectOutCameraObj "选择动画像机看不到的物体" pos:[4,41] width:154 height:16 toolTip:"选择动画摄像机看不到的geometry和shapes"
	button btn_setRegionRect "找回渲染框" pos:[162,4] width:73 height:16 toolTip:"将移到屏幕外面的渲染框找回"
	dropdownList ddl_region "" pos:[162,27] width:70 height:22 items:#("Region", "Blowup")
	GroupBox grp2 "关联功能" pos:[3,59] width:233 height:57
	pickbutton btn_pickTarget "拾取目标物体" pos:[6,77] width:100 height:30 message:"请选择一个物体作为关联的参照物" toolTip:"单击并选择一个物体作为关联的参照物" autoDisplay:true
	button btn_selectInstance "选择关联物体" pos:[109,72] width:104 height:16 toolTip:"选择与目标物体相关联的物体"
	button btn_instanceSelection "关联选择物体" pos:[109,94] width:104 height:16 toolTip:"将选择的物体与目标物体关联"
	button btn_instanceHelp "?" pos:[217,82] width:15 height:16
	local fl_tips01="场景助手提示"
	--Judge if the node was hidden or frozen
	fn fl_notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen)

	on btn_freeMemory pressed do
	(	freeSceneBitmaps()
		clearUndoBuffer()
	)
	on btn_selectMissUVObjs pressed do
	(	local objs=for i in geometry where ((classof i)==Editable_Poly or (classof i)==Editable_mesh)  collect i
		missUVObjd=for obj in objs where (not (meshop.getMapSupport obj.mesh 1) and fl_notHiddenOrFrozen obj) collect obj
		if missUVObjd.count==0 then 
			messagebox "场景中没有丢失UV的物体 ！" title:fl_friendllytips
		else select missUVObjd
	)
	on btn_selectOutSceneObj pressed do
	(	
		objs = for o in geometry collect o --collect geometry 
		objShapes = for s in shapes collect s --collect shapes
		join objs objShapes
		local a = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])
		select a
		max select invert
		currentSel = getCurrentSelection()
		selObj = for k in currentSel where finditem objs k != 0 and fl_notHiddenOrFrozen k collect k --exculde not geometry and shapes
		select selObj
		if selection.count == 0 then messagebox "物体都看得到，没得选了：（" title:fl_friendllytips
	
	)
	on btn_selectOutCameraObj pressed do
	(	if selection.count == 1 and superclassof $ == camera then
		(	
			objs = for o in geometry collect o --collect geometry 
			objShapes = for s in shapes collect s --collect shapes
			join objs objShapes 
			viewport.setType #view_camera --set current view to camera
			pickObj = #()
			for i in animationRange.start to animationRange.end do --count each frame
			(	
				sliderTime = i
				a = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])
				for j in a where findItem pickObj j == 0 do append pickObj j
			)
			select pickObj
			max select invert
			currentSel = getCurrentSelection()
			selObj = for k in currentSel where finditem objs k != 0 and fl_notHiddenOrFrozen k collect k --exculde not geometry and shapes
			select selObj
		)
		else messagebox "请先选择一个摄像机！" title:fl_friendllytips
	)
	on btn_setRegionRect pressed do
	(	--get the activeViewport index
		index = viewport.activeViewport
		if index == 0 then messagebox "请先激活一个三维视图！" title:fl_tips01
		else
		(	
			viewSize = getViewSize()
			X = (viewSize[1]/3) as integer
			Y = (viewSize[2]/3) as integer
			case ddl_region.selection of
			(	--set Blowup 
				1: viewport.setRegionRect index (box2 X Y X Y)
				2: viewport.setBlowupRect index (box2 X Y X Y)
			)
			max views redraw
		)--end else
	) -- end setRegionRect button
	on btn_selectInstance pressed do
	(
		if (obj = btn_pickTarget.object) != undefined and not isDeleted obj then
		(	--get instances
			InstanceMgr.GetInstances obj &instances
			myInstances = for i in instances where fl_notHiddenOrFrozen i collect i
			if myInstances.count != 1 then select myInstances
			else messagebox "没有找到与目标相关联的物体！" title:fl_tips01
		)
		else messagebox "没有拾取目标物体或者拾取物体不存在，请重新拾取！" title:fl_tips01
	)
	on btn_instanceSelection pressed do
	(	s = getCurrentSelection()
		if (obj = btn_pickTarget.object) != undefined and not isDeleted obj then
		(	
			if s.count != 0 then
			(	idx = findItem s obj
				if idx != 0 then deleteItem s idx --delete the target object
				if s.count != 0 then
				undo on
				(
					for i in s do
					( 	tempV=i.pos
						instanceReplace i obj
						CenterObject i
						i.pos=tempV
					)
				)--end undo on
				else messagebox "物体自己跟自己不能关联：）" title:fl_tips01
			)
			else messagebox "请选择要关联的物体！" title:fl_tips01
		)
		else messagebox "没有拾取目标物体或者拾取物体不存在，请重新拾取！" title:fl_tips01
	) --end instanceSelection button
	on btn_instanceHelp pressed do
	(
		tips = "1、单击“拾取目标物体”，再选中场景中一物体作为参照。\n"
		tips += "2、“选择关联物体”是将与拾取物体相关联的物体全部选中，包括拾取的物体。\n"
		tips += "3、“关联选择物体”是将选择的物体与刚才拾取的物体相关联，注意这里的关联\n      是绝对关联，你可以将一个灯光关联到一个BOX，那么灯光也变成了BOX。\n"
		tips += "4、关联可撤销。"
		messagebox tips title: ("关联物体 - "+fl_tips01) beep:off
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild fl_specialFunctions width:234
else createdialog fl_specialFunctions
