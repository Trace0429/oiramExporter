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


--这个的原理是创建一个box塌陷,然后attach目标物体后,把box去掉,这样目标物体的单位就和box一致了
--refesh unit
	fn fl_refeshObjUnit obj =
	(	
		--get the pros
		tempP = obj.pivot
		tempN = obj.name
		tempC = obj.wirecolor
		--bigin refesh
		b = convertToPoly(box())
		newName = uniquename (b.name as string)
		polyOp.attach b obj
		b.EditablePoly.SetSelection #Face #{1}
		b.selectElement()
		TargetElement = polyop.getFaceSelection b
		polyop.detachFaces b TargetElement asNode:true name:newName
		b.pivot = tempP
		b.name = tempN
		b.wirecolor = tempC
		select b
		NewObj = getnodebyname newName
		delete NewObj
	)
	(
		if selection.count != 0 then
		(	with redraw off
			undo on (
			sel=getcurrentselection()
			for s in sel do (
				if classof s == Editable_Poly then fl_refeshObjUnit $
				else if classof s == Editable_Mesh then
				(	convertToPoly s
					fl_refeshObjUnit s
					convertToMesh s
				)--end else
			)--end for
			) --end undo on
			max views redraw
		)
		else messagebox "请选择EPoly或者EMesh,可多选!" title:"助手提示" beep:off
	)
