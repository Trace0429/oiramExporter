--(
	/*
	writePFM creates portable float map images from MaxScript bitmaps
	img	this is the bitmap
	flip	0 = don't mirror bitmap, 1 = mirror bitmap horizontally, 2 = mirror bitmap vertically, 3 = mirror both directions
	
	Written by Fabian Groﬂ of 48Design.de for Wall Worm Sky Writer
	http://www.zwischendrin.com
	*/
	function wallwormWritePFM img flip filename:undefined =
	(
	 
		-- insert the ouptut filename here
		
		if filename == undefined then (
			filename = getSaveFileName types: "Portable Floatmap (*.pfm) |*.pfm|" filename:"c:\\"
		)
		
		local out_file = fopen filename "wb"
	 
		WriteString out_file "PF"
		fseek out_file -1 #seek_cur
		--WriteByte out_file 10
		--WriteString out_file "# pfm created with MaxScript by 48design"
		--fseek out_file -1 #seek_cur
		WriteByte out_file 10
		WriteString out_file (img.width as string)
		fseek out_file -1 #seek_cur
		WriteByte out_file 10
		WriteString out_file (img.height as string)
		fseek out_file -1 #seek_cur
		WriteByte out_file 10
		WriteString out_file "-1.0000"
		fseek out_file -1 #seek_cur
		WriteByte out_file 10
	 
		local startY = 1
		local endY = img.height
		local byVal = 1
		
		if flip == 2 or flip == 3 do
		(
			startY = img.height
			endY = 1
			byVal = -1
		)
		
		for y = startY to endY by byVal do
		(
			pixels = getPixels img [0,y-1] (img.width)
			if flip == 1 or flip == 3 then pixels = (for i = pixels.count to 1 by -1 collect pixels[i])
			for x = 1 to  img.width do
			(
				-- write bytes
				WriteFloat out_file (pixels[x].r/255 as float)
				WriteFloat out_file (pixels[x].g/255 as float)
				WriteFloat out_file (pixels[x].b/255 as float)
			)
		)
	 
		fflush out_file
		fclose out_file
	)
/*
	-- img is the bitmap you rendered
	local img = copy (selectBitMap caption:"Please choose an HDRI")

	-- run function to write a PFM
	writePFM img 0
)*/