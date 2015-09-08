(
	
	
	include "$scripts/WallWorm.com/common/config.ms"
	
	filename = getOpenFileName filename:(wwdt_mapsrc+"\\")  caption:"Leak File:" types:"Source Leak File (*.lin)|*.lin" historyCategory:"Wall Worm VMF"
	if filename != undefined then (

		f = openFile filename
		if f != undefined then (

			knot_positions = #()


			while not eof f do
			 (
				 l = readline f
				 lf = filterString l " " 
				 if lf.count > 0 then (
					append knot_positions ([lf[1] as Float, lf[2] as Float, lf[3] as Float])
				 )
			 )

			close f


			s = splineshape()
			 
			 idx = addNewSpline s
			 
			 for k in knot_positions do addKnot s idx #corner #line k
			 

			 updateShape s
			 
			 s.baseobject.renderable = true
			 s.thickness = 16
			 s.wirecolor = color 255 0 0 
			 
			 s.displayrendermesh = true
			 
			 s.name = uniqueName "Map Leak Line "
			 select s

			 
			 setTransformLockFlags s #all
			max zoomext sel
			 
		)
	)
)
 