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
--get random color
fn fl_getRandomcolor  =
(	
	local randomcolor = random black white
	randomcolor
)
	(	ifcontinue=queryBox "此操作将场景所有材质转为彩色通道，并且不可逆，是否继续？" title:"助手提示"	
		if ifcontinue then (
		sceneObjs=#();s=sceneMaterials.count
		sceneObjs=for i in objects where i.material!=undefiend collect i
		if sceneObjs.count!=0 then
		(		max create mode
				with redraw off
				timestart=timestamp()
				format "%\n" "正在转材质..." 
				randomColor=fl_getRandomcolor()
				temp_Mtl=standardmaterial()
				temp_Mtl.name=sceneMaterials[1].name
				temp_Mtl.Diffuse =randomColor
				temp_Mtl.ambient =randomColor
				temp_Mtl.Specular =randomColor
				temp_Mtl.selfIllumAmount = 100
				tempObjs = #()
				for j in sceneObjs  do
				(	if j.material==sceneMaterials[1] then
					(	j.material=temp_Mtl
						append tempObjs j
					)
				)
				sceneObjs=fl_minusArr sceneObjs tempObjs
				tempObjs = #()
				for i=2 to s do
				(	ifMod2=mod i 2 as Integer
					if ifMod2==0 then
					(	randomColor=fl_getRandomcolor()
						temp_Mtl=standardmaterial()
						temp_Mtl.name=sceneMaterials[i].name
						temp_Mtl.Diffuse =randomColor
						temp_Mtl.ambient =randomColor
						temp_Mtl.Specular =randomColor
						temp_Mtl.selfIllumAmount = 100
						for j in sceneObjs do
						(	if j.material==sceneMaterials[i] then
							(	j.material=temp_Mtl
								append tempObjs j
							)
						)
						sceneObjs=fl_minusArr sceneObjs tempObjs
						tempObjs = #()
					)--end  ifMod2==0
					else
					(	randomColor=white-randomColor
						temp_Mtl=standardmaterial()
						temp_Mtl.name=sceneMaterials[i].name
						temp_Mtl.Diffuse =randomColor
						temp_Mtl.ambient =randomColor
						temp_Mtl.Specular =randomColor
						temp_Mtl.selfIllumAmount = 100
						for j in sceneObjs do
						(	if j.material==sceneMaterials[i] then
							(	j.material=temp_Mtl
								append tempObjs j
							)
						)
						sceneObjs=fl_minusArr sceneObjs tempObjs
						tempObjs = #()
					)--end 	ifMod2==1
				)--end for i=2 to s
				max views redraw
				timeend=timestamp()
				format "%%秒\n" "材质转化用时" ((timeend-timestart)/1000.0)
		)--end if sceneObjs.count!=0
		else 
		(	format "%\n" "场景中没有材质！"
			messagebox "场景中没有材质！"
		)
		)--end if continue
	)	--end colorMtl 
