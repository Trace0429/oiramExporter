
		



		if doesFileExist "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms" then (
			
			include "$scripts/WallWorm.com/WallWormUtilities/addWWtoMaxMenu.ms."
			global wallwormInstallation = true
			include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
			
			include "$scripts/WallWorm.com/common/version_funcs.ms"
			
			versions = wallworm_getMaxVersion()
			
			if ((versions[1] == 14 OR versions[1] == 15) AND versions[2] <= 2) then (
			
			
				messagebox "You are using a version of Max that requires an update to properly use Wall Worm. Please install the latest service pack for your 3ds Max to avoid problems with Wall Worm."
			
			)
 
			macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
			
			messageBox "Wall Worm now installed.\n\nNow please set up your paths."
					
		) else (
		
			messageBox "The installer only works if you have placed the Wall Worm Model Tools into the correct folder in the Max Scripts directory. Please read the installation instructions."
		)