iniPath = getdir #plugcfg + "\\oiramExport.ini"
rootPath = getSavePath()
if rootPath != undefined do
(
	append rootPath "\\"
	dirs = getDirectories(rootPath + "*")
	append dirs rootPath
	oiram.openDialog()
	for d in dirs do
	(
		dmax = d + "*.max"
		files = getFiles dmax
		for f in files do
		(
			fname = getFilenameFile f
			recDate = getINISetting iniPath d fname
			modDate = getFileModDate f
			--if recDate != modDate do
			(
				setINISetting iniPath d fname modDate
				loadmaxfile f quiet:true
				oiram.export()
				freeSceneBitmaps()
				gc()
			)
		)
	)
	
	messagebox "Mission Completed."
)
