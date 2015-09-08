rootPath = getSavePath()
if rootPath != undefined do
(
	if rootPath[rootPath.count] != "\\" do
		append rootPath "\\"
	batchFileName = rootPath + "batch_file_list.txt"

	dirs = getDirectories(rootPath + "*")
	append dirs rootPath

	maxFiles = #()
	for d in dirs do
	(
		dmax = d + "*.max"
		files = getFiles dmax
		for f in files do (append maxFiles f)
	)
	makeUniqueArray maxFiles
	
	ret = true
	while maxFiles.count > 0 and ret == true do
	(
		try
		(
			ret = loadmaxfile maxFiles[1] quiet:true
			if ret == true do
			(
				geom = for obj in Geometry as array where (not obj.ishidden) collect obj
				for i = 1 to geom.count do
				(
					g = geom[i]
					if classof g.material == Shell_Material then
					(
						f = "WH01_01_dx_" + (getFilenameFile maxFileName) + "Lightingmap.tga"
						g.material.bakedMaterial.materialList[1].diffuseMap.fileName = f
					)
				)
				saveMaxFile maxFiles[1] quiet:true

				deleteItem maxFiles 1
				batchFileStream = openFile batchFileName mode:"wt"
				for f in maxFiles do (format "%\n" f to:batchFileStream)
				close batchFileStream
			)
		)
		catch (ret = false)
	)
		
	if ret == true then
		messagebox "Mission is completed." title:"Mission is completed."
	else
		messagebox maxFiles[1] title:"Mission is canceled." beep:true
)
