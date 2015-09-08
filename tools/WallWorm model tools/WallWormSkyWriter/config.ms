scriptPath= symbolicPaths.getPathValue "$userScripts"
wallworm_userIni = scriptPath + "\WallWorm.com\config\wwmt.ini"



if (doesFileExist wallworm_userIni == false) do (
	
    wwmtinifolder = scriptPath + "\WallWorm.com\config"
	if (makeDir wwmtinifolder all:true == false ) do (
		print "Config Directory doesn't exist"
		messagebox "There is no config directory for the WW Model Tools... and MAXScript does not have permission to write to the appropriate directory."
		)
	
	
	
	)

wwmt_exportMats = GetINISetting wallworm_userIni "Directories" "exportMats"

wwmt_binDir = GetINISetting wallworm_userIni "Directories" "binDir"

wwmt_gameInfoDir = GetINISetting wallworm_userIni "Directories" "gameInfoDir"

		