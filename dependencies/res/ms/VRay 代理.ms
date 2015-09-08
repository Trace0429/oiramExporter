-- VRay代理管理2.0
-- 作者：飞浪 
-- 2011.04.06
--http://www.cgplusplus.com/

--VRay代理管理器1.0
--作者：飞浪 
--2008-11-3

--------------------------------------------------
--欢迎使用场景助手4.0 

----开源奉献----

---------------------------------------------------
--场景助手4.0		2011-04-01
--场景助手3.0		2009-08-01
--场景助手2.6		2009-03-30
--场景助手2.0		2008-08-06
--场景助手1.0		2008-05-27

try destroydialog fl_vrayproxyMgr2 catch()
global fl_vrayproxyMgr2,fl_collectVRayProxies
rollout fl_vrayproxyMgr2 "VRay代理管理2.0" width:457 height:396
(
	multiListBox lbx_vrayProxyPaths "VRay代理路径列表：" pos:[4,65] width:450 height:12
	radiobuttons rdo_area "显示场景中" pos:[8,5] width:135 height:46 labels:#("所有VRay代理    ", "丢失VRay代理    ") default:1 columns:1
	button btn_setPath "设置路径" pos:[5,252] width:95 height:18
	radiobuttons rdo_display "Display (选中代理的显示形式)：" pos:[176,3] width:408 height:62 labels:#("bounding box(边界框)                  ", "preview from file(从文件预览)                          ", "point(点)           ") columns:1
	button btn_select "选择代理物体" pos:[106,252] width:95 height:18

	GroupBox grp1 "打包列表选择的代理" pos:[4,279] width:447 height:108
	edittext edt_output "打包路径：" pos:[14,298] width:365 height:20 
	button btn_begin "开始打包" pos:[320,335] width:126 height:40 
	button btn_browse "选择" pos:[387,299] width:60 height:18
	checkbox colmap "顺便打包代理所用到的贴图" pos:[15,343] width:209 height:18 checked:true
	checkbox updvr "更新VRay代理路径" pos:[15,322] width:133 height:16 checked:true
	checkbox updmap "更新代理所用贴图路径" pos:[15,362] width:197 height:18 checked:true
	--收集所有VRay代理
	fn fl_collectAllVrayProxies = 
	(	allVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem allVP f == 0 then append allVP f
		)
		if allVP.count != 0 then lbx_vrayProxyPaths.items = allVP --Defined the listbox
		else lbx_vrayProxyPaths.items =#( "没有找到VRay代理")
	)
	--收集丢失VRay代理
	fn fl_collectMissVrayProxies =
	(
		missVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem missVP f == 0 and not doesfileexist f then append missVP f
		)
		if missVP.count != 0 then lbx_vrayProxyPaths.items = missVP --Defined the listbox
		else lbx_vrayProxyPaths.items = #( "没有找到丢失VRay代理")
	)
	--根据所给路径收集VRay代理
	fn fl_collectGivenVP arr =
	(	colVP = #()
		for i in geometry while not isDeleted i where classof i == VRayProxy do
		( 	
			f = i.filename
			if finditem arr f != 0 then append colVP i
		)
		colVP
	)
	--判断文件名
	fn fl_ifVrmesh thepath = if getFilenameType thepath == ".vrmesh" then return true else return false
	fn fl_getTheInstanceVP thepath =
	(	local tempObj=#();i = 1
		if fl_ifVrmesh thepath then while i <= geometry.count and not isDeleted geometry[i] do 
		(
			if classof geometry[i] == VRayProxy and geometry[i].filename == thepath then 
			(	append tempObj geometry[i]
			)
			i = i + 1
		)
		tempObj
	)
	--列表单个路径的显示方式
	fn fl_firstDisplay =
	(
		s=lbx_vrayProxyPaths.selection as array
		if s.count != 0 then (
		thepath = lbx_vrayProxyPaths.items[s[1]]
		tempState = 1
 		obj = fl_getTheInstanceVP thepath
		if obj[1] != undefined then tempState = obj[1].display + 1
		rdo_display.state = tempState --设置显示方式
		)
	)
	--刷新列表
	fn fl_refeshListbox stat =
	(
		case stat of
		(
			1: (		fl_collectAllVrayProxies() --显示所有VRay代理
					fl_firstDisplay() --第一个的显示方式
				)
			2: (		fl_collectMissVrayProxies() --显示丢失VRay代理
					fl_firstDisplay() --第一个的显示方式
				)
		)
	)
	--打包
	fn fl_copyVP arr newDir colmap:true updvr:true updmap:true =
	(	--arr ,代理路径
 		for a in arr do (
			--打包代理
			colVP = fl_getTheInstanceVP a
			if colVP[1] != undefined then
			(	
				VPfileName = colVP[1].filename
				newFilename = newDir + "\\" + getfilenamefile VPfileName + getfilenametype VPfileName
				copyFile VPfileName newFilename
			)
			--更新代理路径
			if updvr then 
			(
				for c in colVP do c.filename = newDir + "\\" + getfilenamefile c.filename + getfilenametype c.filename
			)
			--打包贴图
			themaps=#()
			for c in colVP where c.material!=undefined do
			(	temp=getclassinstances bitmaptexture target:c.material
				for t in temp where finditem themaps t == 0 do append themaps t
			)
			if colmap then
			(	
				for b in themaps do
				(	oldName=b.filename
					newName= newDir + "\\" + getfilenamefile oldName + getfilenametype oldName
					copyFile oldName newName
				)
			)
			--更新贴图路径
			if updmap then for b in themaps do b.filename = newDir + "\\" + getfilenamefile b.filename + getfilenametype b.filename
		)--end for
	)

	--收集没有丢失的VRay代理
	fn fl_notMissingFile =
	(
		allVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem allVP f == 0 and doesfileexist f then append allVP f
		)
		allVP
	)

	on fl_vrayproxyMgr2 open do
	(
		fl_collectAllVrayProxies()
		fl_firstDisplay ()
	)
	on lbx_vrayProxyPaths selected sel do
	(
		fl_firstDisplay()
	)
	on rdo_area changed stat do
	(
		fl_refeshListbox stat
	)
	on btn_setPath pressed do
	(
		newPath = getsavepath caption:"设置VRay代理路径"
		if newPath != undefined then
		(	--设置新路径
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
			colVP = fl_collectGivenVP selPath
			undo on (
				if colVP.count != 0 then for v in colVP do
				(	v.filename = newPath + "\\" + getfilenamefile v.filename + getfilenametype v.filename
			--		CenterObject v --轴心归坐标中心
				)
			) --end undo on
			--刷新显示方式
			fl_refeshListbox rdo_area.state
		) --end if
	)
	on rdo_display changed stat do
	(	
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
			colVP = fl_collectGivenVP selPath
			undo on (
			case stat of
			(
				1: for i in colVP do i.display = 0 --bounding box
				2: for i in colVP do i.display = 1 --preview from file
				3: for i in colVP do i.display = 2 --point
			)
			) --end undo on
	)
	on btn_select pressed do
	(
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
		colVP = fl_collectGivenVP selPath
		undo on ( select colVP )
	)
	on btn_begin pressed do
	(
		if edt_output.text!="" then (
		fl_copyVP lbx_vrayProxyPaths.items edt_output.text colmap:colmap.checked updvr:updvr.checked updmap:updmap.checked
		)
		else messagebox "请先选择路径!"
		max views redraw
	)
	on btn_browse pressed do
	(
		collectPath = getSavePath caption: "选择保存路径"
		if collectPath != undefined then	edt_output.text = collectPath
	)
)

if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild fl_vrayproxyMgr2 width:457
else createdialog fl_vrayproxyMgr2
