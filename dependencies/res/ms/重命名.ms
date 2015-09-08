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

global SP4_rename,SP4_renameManager
global spRootPath=getdir #scripts +"\\ScenePromoter4"
global spInifilepath=spRootPath+"\\ScenePromoter4.ini"

try destroydialog SP4_rename catch() 
try destroydialog SP4_renameManager catch() 
rollout SP4_rename "重命名" width:234 height:93
(
	local renameScreenNum = 0
	button btn_renameObj "重命名" pos:[148,5] width:40 height:16 
	edittext Obj_base_name "" pos:[2,5] width:141 height:16
	radiobuttons rdo_mtlRenameScale "重命名范围：" pos:[108,42] width:128 height:46 enabled:false labels:#("场景所有材质   ", "编辑器中材质   ") default:2 columns:1
	radiobuttons rdo_renameMethod "重命名方式：" pos:[10,42] width:100 height:46 labels:#("全部名称   ", "作为前缀   ") default:1 columns:1 
	radiobuttons rdo_objORmtl "" pos:[9,25] width:228 height:16 labels:#("物体重命名     ", "材质重命名   ") columns:2
	button btn_manager "常用名" pos:[191,5] width:40 height:16
	button btn_help06 "?" pos:[213,25] width:15 height:16
	on btn_renameObj pressed do		--rename selected objects
	(	
		if Obj_base_name.text != "" then 
		case rdo_objORmtl.state of
		(
			1:	( --if  object rename
					if rdo_renameMethod.state == 1 then
			       		for i in selection do i.name = uniquename Obj_base_name.text
					else 
						for i in selection do i.name = Obj_base_name.text  + i.name
				)
			2:	( --if material rename
					if rdo_mtlRenameScale.state == 1 then
					(	if rdo_renameMethod.state ==1 then
						(	for i in 1 to scenematerials.count do
								scenematerials[i].name = Obj_base_name.text  + i as string
						)
						else
						(	for i in 1 to scenematerials.count do
								scenematerials[i].name = Obj_base_name.text  + scenematerials[i].name
						)
					) -- end off rename in scenematerials
					else 
					(	
							if rdo_renameMethod.state == 1 then
							(	for i in 1 to 24 do
									meditmaterials[i].name = Obj_base_name.text  + i as string
							)
							else
							(	for i in 1 to 24 do
									meditmaterials[i].name = Obj_base_name.text  + meditmaterials[i].name
							)
			
					) -- end off rename in meditmaterials
				)
		)
		else messagebox "请先输入名称！" title:fl_tips01
	)
	on rdo_objORmtl changed stat do
	(	
		case stat of
		(
			1: rdo_mtlRenameScale.enabled = false
			2: rdo_mtlRenameScale.enabled = true
		)

	)
	on btn_manager pressed do
	(
		try destroydialog SP4_renameManager catch()
		thepos=GetDialogPos SP4_rename
		thepos.x+=240
		createdialog SP4_renameManager pos:thepos
	)
	on btn_help06 pressed do
	(
		tips = "1、物体重命名对选择物体重命名。\n2、材质重命名对所有或者编辑器中材质重命名。\n"
		tips += "3、你可以自己添加或者删除常用名，常用名可以自动保存。"
		messagebox tips title:(fl_fun_tips + " - 重命名") beep:off

	)
	on SP4_rename moved p do (
		if SP4_renameManager.open do 
		(
			p.x+=240
			SetDialogPos SP4_renameManager p
		)
	)
)


rollout SP4_renameManager "常用名管理" width:228 height:209
(
	listbox lbx_pre "双击选择常用名：" pos:[7,4] width:216 height:10
	edittext edt3 "" pos:[5,165] width:175 height:16
	button btn_add "添加" pos:[188,165] width:36 height:17
	button btn_delete "删除选择" pos:[49,185] width:60 height:20
	button btn_exit "退 出" pos:[122,185] width:60 height:20
	
	--add rename preference
	fn fl_addRenamePre str =
	(
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if classof prenames != array then prenames=#()
		if finditem prenames str == 0 then
		(    append prenames str
			setinisetting spInifilepath "Rename" "PreNames" (prenames as string)
		)
		else messagebox "此名称已经存在！"  title:fl_tips01 beep:off
	)
	--delete rename preference
	fn fl_deleteRenamePre idx =
	(
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if idx != 0 then deleteItem prenames idx
		setinisetting spInifilepath "Rename" "PreNames" (prenames as string)
	)

	on SP4_renameManager open do
	(	
		if not doesfileexist spInifilepath then
		(	makedir spRootPath
			f=createfile spInifilepath
			close f
		)
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if classof prenames == array then lbx_pre.items = prenames
	)
	on lbx_pre doubleClicked sel do
	(
		if sel != 0 then ( fl_rename.Obj_base_name.text = lbx_pre.items[sel];destroydialog SP4_renameManager)
		else destroydialog SP4_renameManager
	)
	on btn_add pressed do
	(
		if edt3.text != "" then fl_addRenamePre edt3.text
		destroydialog SP4_renameManager
		createdialog SP4_renameManager
	)
	on btn_delete pressed do
	(
		fl_deleteRenamePre lbx_pre.selection
		destroydialog SP4_renameManager
		createdialog SP4_renameManager
	)
	on btn_exit pressed do
	(
		destroydialog SP4_renameManager
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild SP4_rename width:234
else createdialog SP4_rename
