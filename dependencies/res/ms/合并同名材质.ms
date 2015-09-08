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

--calculate the same item
fn fl_sameItemNum arr =
(	
	local c,i=1,j,k
	local newArr=#(),newSameArr=#()
	sort arr					--sort the array
	while i<=arr.count do
	(	
		k=0
		j=i+1
		while j<=arr.count do
		(	
			if arr[j]==arr[i] do 
			(	
				if (findItem newSameArr arr[i])==0	do 
				(	
					append newSameArr arr[i]
						--collect the same value
				)
				append newArr j		--collect the same item
				k=k+1	
			)
			j=j+1
		) 
		i=i+k+1
	)
	--return the same item numbers and the same value
	#(newArr.count,newSameArr)	
)
	(	
		allMtls=for i in sceneMaterials collect i.name	
		theSameMtls=(fl_sameItemNum allMtls)[2]
		m=theSameMtls.count
		if m==0 then messagebox "没有同名材质！" title:"助手提示"
		else		--merge
		(	with redraw off
			undo off
			(
			sceneObjs=objects as array
			for i=1 to m do
				(	sameMtlObjs=#()
					temp_mtl=sceneMaterials[theSameMtls[i]]
					--collect the same name mat
					for j in sceneObjs do
					( 	if (classof j.material)!=UndefinedClass then
							if j.material.name==temp_mtl.name then
								append sameMtlObjs j
					)
					--merge
					for l in sameMtlObjs do
					(	l.material = temp_mtl
						obj_number = findItem sceneObjs l
						deleteItem sceneObjs obj_number
					)
				)
			)--end undo off
			max views redraw
		)	--end else
	)--end 
