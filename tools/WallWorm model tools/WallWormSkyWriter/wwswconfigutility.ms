include "config.ms"

try(destroyDialog wwsw_config)catch(
	
	   --there was not any open
	)


--wwswToolsConfigFloater = newRolloutFloater "Sky Writer Config" 130 280 10 10




rollout wwsw_config "Sky Writer Config" width:126 height:266
(
	button btn_expMatPath "Pick Material Root" pos:[9,58] width:101 height:40 toolTip:"Pick the root folder for your material exports. You probably want to choose your material source folder inside sourcesdk_content > yourmod > material_src."
	button btn_binDir "Bin Dir" pos:[9,10] width:100 height:40 toolTip:"Click Here to set the Bin Directory (your sdk bin folder for automatically compiling models and materials)"
	button btn_installWWMT "Install MacroScript" pos:[11,152] width:100 height:43 toolTip:"Click Here to install WWMT into your Max Preferences UI."
	
	button btn_addToMenu "Add to Menu" pos:[12,201] width:99 height:43 toolTip:"Adds a menu item in the menu bar after the Max Help."
	button btn_gameInfoDir "Game Info Dir" pos:[10,106] width:100 height:21 toolTip:"Choose the path to the game that you are working on to override Steam's current system-wide game path. Needed for games like Left 4 Dead."
	
	button btn_unsetGameInfo "Unset Game Info" pos:[11,130] width:99 height:15

		
		
	on btn_expMatPath pressed do
	(
			try (
				newPath = getSavePath caption:"Set Root Export Path" initialDir:wwmt_exportMats
				) catch(
				newPath = getSavePath caption:"Set Root Export Path"
				
				)
			if (newPath != undefined) do (
				wwmt_exportMats = newPath
				setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats
				
				btn_expMatPath.caption = wwmt_exportMats
			)
		)
	on btn_binDir pressed do
	(
			try( 
				newPath = getSavePath caption:"Set Root Export Path" initialDir: wwmt_binDir
				) catch (
				newPath = getSavePath caption:"Set Root Export Path"
				)
			if (newPath != undefined) do (
				 wwmt_binDir = newPath
				setINISetting wallworm_userIni "Directories" "binDir"  wwmt_binDir
				
				--wwmt_config.btn_expPath.caption = export
			)
		)
	on btn_installWWMT pressed do
	(
	
	if doesFileExist "$scripts\\WallWorm.com\\WallWormSkyWriter\\wwsw_mcr.mcr" then (
	
		fileIn "$scripts\\WallWorm.com\\WallWormSkyWriter\\wwsw_mcr.mcr"
		
		messagebox "You can now add a button or menu item for WWMT.\n\n*Click Customize > Customize User Interface\n\n*Select wallworm.com in the Categories drop-down menu\n\n*Drag Wall Worm Sky Writer to a menu bar or menu item."
		
		) else (
		
		messageBox "The installer only works if you have placed the Wall Worm Model Tools into the correct folder in the Max Scripts directory. Please read the installation instructions."
		)
	
	
	)
	on btn_addToMenu pressed do
	(
	
	if doesFileExist "$scripts\\WallWorm.com\\WallWormSkyWriter\\wwsw_mcr.mcr" then (
	
			fileIn "$scripts\\WallWorm.com\\WallWormSkyWriter\\wwsw_mcr.mcr"
		
			if menuMan.registerMenuContext 0x1ee76d8e then(
	
				-- Get the main menu bar
	
				local mainMenuBar = menuMan.getMainMenuBar()

				-- Create a new menu
	
				local subMenu = menuMan.createMenu "Wall Worm"
	
				 
	
				-- create a menu item that calls the sample macroScript
	
				local testItem = menuMan.createActionItem "WallWormSkyWriterMCR" "wallworm.com"
	
				 
	
				-- Add the item to the menu
	
				subMenu.addItem testItem -1
	
				 
	
				-- Create a new menu item with the menu as it's sub-menu
	
				local subMenuItem = menuMan.createSubMenuItem "Wall Worm" subMenu
	
				 
	
				-- compute the index of the next-to-last menu item in the main menu bar
	
				local subMenuIndex = mainMenuBar.numItems() - 1
	
				 
	
				-- Add the sub-menu just at the second to last slot
	
				mainMenuBar.addItem subMenuItem subMenuIndex
	
				 
	
				-- redraw the menu bar with the new item
	
				 
	
				menuMan.updateMenuBar()
				messagebox "There is now a Wall Worm item in the menu bar."
			) else (
				try (
				subMenu = menuMan.findMenu "Wall Worm"
				local testItem = menuMan.createActionItem "WallWormSkyWriterMCR" "wallworm.com"
	
				-- Add the item to the menu
	
				subMenu.addItem testItem -1
				-- Create a new menu item with the menu as it's sub-menu
	
				--local subMenuItem = menuMan.createSubMenuItem "Wall Worm" subMenu
					
				menuMan.updateMenuBar()
				messagebox "There is now a Sky Writer entry in your Wall Worm menu."
				) catch (
					 messagebox "There was a problem adding the menu."
					)
			)
	
		) else (
		
			messageBox "The installer only works if you have placed Wall Worm Sky Writer into the correct folder in the Max Scripts directory. Please read the installation instructions."
		)	
	
	
	
	)
	on btn_gameInfoDir pressed do
	(
			try( 
				
				if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
					newp = wwmt_gameInfoDir
					
					) else (
					
					newp = wwmt_binDir
					)
				
				newPath = getSavePath caption:"Set Game Info Path" initialDir: newp
				) catch (
				newPath = getSavePath caption:"Set Game Info Path"
				)
			if (newPath != undefined) do (
				 wwmt_gameInfoDir = newPath
				setINISetting wallworm_userIni "Directories" "gameInfoDir"  wwmt_gameInfoDir
				
				--wwmt_config.btn_expPath.caption = export
			)
		)
	on btn_unsetGameInfo pressed do
	(
			
			wwmt_gameInfoDir = ""
			setINISetting wallworm_userIni "Directories" "gameInfoDir"  ""
			
			
			)
)
	



	createDialog wwsw_config
