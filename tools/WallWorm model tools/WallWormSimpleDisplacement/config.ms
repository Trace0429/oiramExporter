scriptPath= symbolicPaths.getPathValue "$userScripts"
userIni = scriptPath + "\WallWorm.com\config\wwmt.ini"



if (doesFileExist wallworm_userIni == false) do (
	
    wwmtinifolder = scriptPath + "\WallWorm.com\config"
	if (makeDir wwmtinifolder all:true == false ) do (
		print "Config Directory doesn't exist"
		messagebox "There is no config directory for Wall Worm Tools... and MAXScript does not have permission to write to the appropriate directory."
		)
	
	
	
	)

wwdt_mapsrc = GetINISetting wallworm_userIni "Directories" "exportMaps"

if wwdt_mapsrc == undefined do (
	
	wwdt_mapsrc = ""
	
	)