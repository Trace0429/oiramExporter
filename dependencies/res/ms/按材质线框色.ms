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



--get random color
fn fl_getRandomcolor  =
(	
	local randomcolor = random black white
	randomcolor
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
	(	sceneObjs=#();s=sceneMaterials.count
		for i in objects do
		(	if i.material!=undefined then
				append sceneObjs i
		)
		if sceneObjs.count!=0 then
		(		max create mode
				with redraw off
				temp_objs=#()
				randomColor=fl_getRandomcolor()
				tempMtl=sceneMaterials[1]
				for j in sceneObjs where j.material==tempMtl do
				(		j.wirecolor=randomColor
						append temp_objs j
				)
				sceneObjs=fl_minusArr sceneObjs temp_objs
				temp_objs=#()
				for i=2 to s do
				(	ifMod2=mod i 2 as Integer
					if ifMod2==0 then
					(	randomColor=fl_getRandomcolor()
						tempMtl =sceneMaterials[i]
						for j in sceneObjs where j.material==tempMtl do
						(		j.wirecolor=randomColor
								append temp_objs j
						)
						sceneObjs=fl_minusArr sceneObjs temp_objs
						temp_objs=#()
					)--end  ifMod2==0
					else
					(	randomColor=white-randomColor
						tempMtl =sceneMaterials[i]
						for j in sceneObjs where j.material==tempMtl do
						(		j.wirecolor=randomColor
								append temp_objs j
						)
						sceneObjs=fl_minusArr sceneObjs temp_objs
						temp_objs=#()
					)--end 	ifMod2==1
				)--end for i=2 to s
				max views redraw
		)--end if sceneObjs.count!=0
		else messagebox "场景中没有材质！" title:"助手提示"
	)
