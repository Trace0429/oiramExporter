(
	local scriptDir = (getDir #scripts) + "\\oiramExporter\\"
	fileIn (scriptDir + "Merge.ms")
	fileIn (scriptDir + "ResetNodeScale.ms")
)

fn oiramBatchList =
(
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
		
		batchFileStream = openFile batchFileName mode:"wt"
		for f in maxFiles do (format "%\n" f to:batchFileStream)
		close batchFileStream
		
		return rootPath
	)
	
	return undefined
)

fn oiramBatchExportResumePath rootPath =
(
	if rootPath != undefined and oiram.optionDialog() do
	(
		if rootPath[rootPath.count] != "\\" do
			append rootPath "\\"
		batchFileName = rootPath + "batch_file_list.txt"
		batchFileStream = openFile batchFileName mode:"rt"
		maxFiles = #()
		while not (eof batchFileStream) do (append maxFiles (readLine batchFileStream))
		close batchFileStream
		
		ret = true
		while maxFiles.count > 0 and ret == true do
		(
			try
			(
				ret = loadmaxfile maxFiles[1] quiet:true
				if ret == true do
				(
					oiramResetNodeScale();
					oiramMerge()
					oiram.export(false)

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
)

fn oiramBatchExport =
(
	oiramBatchExportResumePath(oiramBatchList())
)

fn oiramBatchExportResume =
(
	oiramBatchExportResumePath(getSavePath())
)
