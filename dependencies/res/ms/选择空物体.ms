	(
		clearSelection()
		s = #()
		for i in geometry do (f = (getPolygonCount i)[1] ; if f == 0 then append s i)
		for j in shapes do (if numKnots j == 0 then append s j)
		if s.count != 0 then select s else messagebox "没有空物体!" title:"场景助手提示" beep:off
	)
