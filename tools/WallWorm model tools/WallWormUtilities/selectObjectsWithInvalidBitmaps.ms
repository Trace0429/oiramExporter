objs = for obj in objects WHERE obj.mat != undefined  collect obj
	

invalidObjects = #()

	for obj in objs do (
		
		theMat = wallworm_getMaterial obj.mat
		
		if theMat != undefined AND theMat.diffuseMap != undefined AND classOf theMat.diffuseMap == BitmapTexture then (
			
			try (
				
				if theMat.diffuseMap.bitmap == undefined then (
					
					append invalidObjects obj
					
					)
				
				
				) catch (
				
				append invalidObjects obj
				
				)
			
			
			)
		
		
		)
		
		
		
		
select  invalidObjects 