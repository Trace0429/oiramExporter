function wallworm_render_blend_mat mat filename:"" size:[256,256] overWrite:false= (
	bm = undefined 
	if filename	!= undefined AND doesFileExist filename == true AND overWrite == false then (
		--bm = BitmapTexture()
		--bm.filename = filename
		bm = openBitmap filename
	) else ( 	
		if classOf mat == Blend AND mat.map1 != undefined AND mat.map2 != undefined AND mat.map1.diffuseMap != undefined AND mat.map2.diffuseMap != undefined then (
			theMix = Mix()

			theMask = BitmapTexture()
			theMask.filename = "$scripts/WallWorm.com/assets/util/blend_mask.tga"

			theMask.alphasource = 2
			theMix.map1 = mat.map1.diffuseMap
			theMix.map2 = mat.map2.diffuseMap

			theMix.mask = theMask
			
			
			
			bm =rendermap theMix display:false  filename:filename size:size
			
			if filename != undefined AND filename != "" then (
				save bm
				--print ("saved t:"+bm.filename)
			)
		)
	)
	return bm
)
