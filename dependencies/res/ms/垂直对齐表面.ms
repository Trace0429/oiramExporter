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
try destroydialog alignToTheGround catch()
rollout alignToTheGround "垂直对齐表面" width:118 height:82
(
	pickbutton Btn_pick "拾取物体" pos:[7,7] width:100 height:18 toolTip:"单击并选择一个物体作为表面" autoDisplay:true
	button btn_align "对齐表面" pos:[8,55] width:80 height:18
	checkbox chk_norm "法线对齐" pos:[9,31] width:86 height:16 checked:true
	button btn49 "?" pos:[94,57] width:16 height:15
	on btn_align pressed do
	(	obj=Btn_pick.object
		if obj!=undefined and not isdeleted obj then
		(	if chk_norm.checked then
			( 
			undo on (
			for i in selection do 
			  (	  dirn=-1
			  	  if i.pos.z <0 then dirn = 1
			  	  r= ray i.pos [0,0,dirn]
			 	  d=intersectray obj r
			 	  if d!=undefined do 
			 	  ( 	  i.pos=d.pos
				  	  i.dir=d.dir
			    ))
			))
			else
			(	undo on (
				for i in selection do 
			  ( 	  dirn=-1
			  	  if i.pos.z <0 then dirn = 1  
			       r= ray i.pos [0,0,dirn]
			 	  d=intersectray obj r
			 	  if d!=undefined do 
			 	  ( 	  i.pos=d.pos
			    		)
			  ))
			)
		)
		
	)
	on btn49 pressed do
	(
			str = "1 .此功能只对齐Z轴。先拾取一个物体作为表面\n2 .选择其他物体，单击“对齐表面”按钮，则选择的物体都对齐到了拾取的物体。\n"
			str +="3 .勾选“法线”则物体对齐时Z轴方向按拾取表面法线，不勾选时改变Z轴方向。\n"
		str+="4 .拾取的表面物体要在需要对齐的物体下方才有效。\n"	
		str+="5 .此功能部代码由CG++会员ys172提供。"
			messagebox str title:"助手提示"
	)

)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild alignToTheGround width:118
else createdialog alignToTheGround
