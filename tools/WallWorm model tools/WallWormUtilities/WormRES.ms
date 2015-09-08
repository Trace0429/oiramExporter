/*
Source Level RES Maker
Copyright (c) 2011-2013 by Shawn Olson
http://www.shawnolson.net

Created for the Wall Worm Model Tools
http://www.wallworm.com

This script will output a RES file for the currently open file.

The tool is not guaranteed to get every file for this map since it
can only access the materials and models in the scene... but it can
expedite the creation of a RES file

*/	
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
fileIn "$scripts/WallWorm.com/common/packing_funcs.ms"
fileIn "$scripts/WallWorm.com/common/mse/wallwormVMF.mse"	

try (destroyDialog wallwormRESUI) catch ()

rollout wallwormRESUI "Wall Worm Res Maker  and Asset Tools | Version 1.3" width:466 height:244
(
	checkbox chkEmbedWWMT "WWMT Models" pos:[28,28] width:92 height:14 toolTip:"PAK the MDL files for WWMT models and proxies in this scene."
	checkbox chkEmbeddWWMTTex "WWMT Textures" pos:[132,28] width:103 height:14 toolTip:"Embed all VMT and VTF files associated with your WWMT models and proxies."
	checkbox chkEmbedSky "Sky Textures" pos:[246,28] width:88 height:15 toolTip:"Embed your Sky textures. Only works with Skywriter."
	checkbox chkEmbedCVXProps "Entity Assets" pos:[28,50] width:80 height:15 toolTip:"Collect assets from scene entities."
	checkbox chkEmbedWorldTex "World Textures" pos:[132,51] width:100 height:16 toolTip:"Embed VMT and VTF files from the world geometry. The materials must be named properly for this function to work. This option not yet fully tested."
	GroupBox grp6 "Include These Files" pos:[4,7] width:449 height:72
	button btnGenerate "Generate RES File" pos:[277,87] width:168 height:30
	label lbl1 "Save Res to your mod's maps folder." pos:[9,126] width:198 height:15
	HyperLink linkWW "WallWorm.com" pos:[12,209] width:96 height:17 address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	HyperLink donate "Donate & Support Wall Worm" pos:[122,209] width:143 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"	
	

	HyperLink help "Help" pos:[394,209] width:43 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/21/res_maker.html"	
	

	checkbox chkSound "Soundscapes" pos:[246,52] width:86 height:16 toolTip:"Collect sound files in the map's soundscape and sound script file."
	
	function getVMF = (
		global wallworm_file_vmf_presets
		
		if isProperty rootNode "DetailVBSP" then ( 
			wallworm_file_vmf_presets = wallwormVMF()
			rootNode.setVMFFromthis &wallworm_file_vmf_presets
		) else (
			wallwormVMFSettingsIndex = fileProperties.findProperty #custom "wallwormVMFSettings"
			if wallwormVMFSettingsIndex != 0 then (
				wallwormVMFSettings1=fileProperties.getPropertyValue #custom wallwormVMFSettingsIndex
				wallwormVMFSettings = "global wallworm_file_vmf_presets = ("+wallwormVMFSettings1+")"
				execute wallwormVMFSettings
				--print wallworm_file_vmf_presets

			) 			
		)
		

		if wallworm_file_vmf_presets == undefined then (
			
			wallworm_file_vmf_presets = wallwormVMF()
			
		)
		
	)
	
	
	edittext edtMapName "Map Name" pos:[10,89] width:255 height:26
	button btnSoundManifest "Create Sound Manifest" pos:[278,124] width:168 height:27 toolTip:"Create a sound manifest file for this level from soundscape and entity sounds."
	
	
	
	button btnRar "ZIP From Res" pos:[279,161] width:166 height:30 toolTip:"Create a ZIP file from the contents listed in a RES file. WinRAR required."
	edittext edtWinRARPath "WinRAR Path" pos:[9,162] width:262 height:29
	checkbox chkDetails "Detail Materials" pos:[349,53] width:95 height:16 tooltip:"Collect the detail.VMT and detail models based on the detail objects in the scene. Note that this function works with the detail objects that are part of an external plugin developed by Wall Worm."
	
	
	
	
	
	
	on wallwormRESUI open do
	(
		getVMF()
		
		local mapFileName = "MyMap"
	
		
		local mapDir = wwmt_gameInfoDir
		
		
		global wallworm_file_vmf_presets
		if wallworm_file_vmf_presets.filename != undefined then (
			
			
			mapFileName = getFilenameFile wallworm_file_vmf_presets.filename
			--mapDir = getFilenamePath wallworm_file_vmf_presets.filename
			) else (
			
				local sfn = maxFileName
		
				if sfn != undefined AND sfn != "" then (
				mapFileName = getFileNameFile sfn
				) else (
					
	
				)
		
			
			)
		
		
		
		
		
		
		
		edtMapName.text = mapFileName
		
		
		winrarpath = getINISetting wallworm_userIni "Directories" "winrar_path"
		if winrarpath != undefined AND winrarpath != "" then (
				edtWinRARPath.text = winrarpath ) else (
				edtWinRARPath.text = "C:\Program Files\WinRAR"
			)
	)
	on btnGenerate pressed do
	(
			
		
		if edtMapName.text == "" then (
			
			messagebox "You must enter the map name into the map field."
			
			return false
			)
		
		
			local wwmt_used_materials = #()
	
	
		--get all wwmt models
		
	
		global wwmt_gameInfoDir
		local mapDir = wwmt_gameInfoDir+"\\maps"
		
		
	
	
	
	
		local wwmt_res_list = wallworm_collect_assets_from_scene isRes:true vbsp:chkDetails.state wwmt:chkEmbedWWMT.state soundscape:chkSound.state wwmtMaterials:chkEmbeddWWMTTex.state cvxModels:chkEmbedCVXProps.state sky:chkEmbedSky.state worldMaterials:chkEmbedWorldTex.state mapname:edtMapName.text vmfsettings:wallworm_file_vmf_presets
	
						 
						 
						 
		if wwmt_res_list.count > 0 then (
			
	
			
			if wwmt_gameInfoDir != undefined then (
				
				
				) else (
				
				
				
				)
			
			
			local fname = mapDir + "/"+edtMapName.text+".res"
			
			
			
			filename = getSaveFileName caption:"Save RES File into your Maps folder." filename:fname types:"RES File (*.res)|*.RES"  historyCategory:"Wall Worm BSP"
	
	
			if filename != undefined do(
				local resFile = openFile filename mode:"w+"
	
			)
			if filename == undefined OR resFile == undefined then (
			
	
				messagebox "The Res File was not saved."
			
			
			) else (
	
	
				
				str = "\"resources\"\n{\n"
				format str to: resFile
				
				for item in wwmt_res_list  do (
					localFile = wallworm_safe_local(wwmt_gameInfoDir+"\\"+item)
					if doesFileExist (localFile) then (
	
					str = ("\""+item+"\" \"file\"\n")
					
					format str to: resFile
					) else (
						
						print ("File Not Found: RES Skipping "+localFile)
						)
					--print str
				)
				
				str = "\n}"
				format str to: resFile
				
			close resFile
			
					try (
					
					folderOpen ="ShellLaunch \"notepad.exe\" @\""+filename+"\""
					execute folderOpen
					
					) catch(
					
					
					
					)			
				
			)
	
			
		) else (
				messagebox "No assets (WWMT models, valid materials, sounds, etc) were found in the scene.\n\nNote that at the moment, the res generator doesn't work on WWMT helpers in XRef scenes."
		)
			
			
		)
	on btnSoundManifest pressed do
	(
			
		
		if edtMapName.text == "" then (
			
			messagebox "You must enter the map name into the map field."
			
			return false
			)
		
		
			local wwmt_used_materials = #()
	
	
		--get all wwmt models
		
		global wwmt_gameInfoDir
		local mapDir = wwmt_gameInfoDir+"\\maps"
		
		
		/*
		if mapDir == undefined or mapDir == "" then (
			mapDir = (dotnetclass "System.Environment").GetEnvironmentVariable("VProject")
			
		
		) 
		if mapDir == undefined or mapDir == "" then (
			mapDir = wwdt_mapsrc
			
		
		) else (
			mapDir = ""
			mapDir = mapDir + "\\maps"
			
		)
	
	*/
	
	
		local wwmt_res_list = wallworm_collect_assets_from_scene isRes:true wwmt:false soundscape:true wwmtMaterials:false cvxModels:true sky:false worldMaterials:false mapname:edtMapName.text vmfsettings:wallworm_file_vmf_presets
	
						 
						 
						 
		if wwmt_res_list.count > 0 then (
			
	
			
			if wwmt_gameInfoDir != undefined then (
				
				
				) else (
				
				
				
				)
			
			
			local fname = mapDir + "/soundcache/"+edtMapName.text+".manifest"
			
			
			--print fname
			filename = getSaveFileName caption:"Save MANIFEST File into your Maps\soundcache folder." filename:fname types:"MANIFEST File (*.manifest)|*.MANIFEST"  historyCategory:"Wall Worm Sound Manifest"
	
	
			if filename != undefined do(
				local resFile = openFile filename mode:"a+"
	
			)
			if filename == undefined OR resFile == undefined then (
			
	
				messagebox "The Manifest File was not saved."
			
			
			) else (
	
	
			while not eof resFile  do (
			
	
			
			--try (
			--fLines[lineNum] = filePos theVMT
					local theLine = readLine resFile
					theLine = trimleft theLine
					theLine = trimRight theLine
					theLine = substituteString theLine "\t" ""
					theLine = substituteString theLine " " ""
					theLine = substituteString theLine "\"" ""
					--lines to ignore until support for these features are added (to speed gneeration up)		
					if (theLine == "" OR theLine == undefined OR ( (substring theLine 1 2) == "//") ) do continue	
				
					appendIfUnique wwmt_res_list theLine
				
			)
	
				
				sounditems = #(".wav",".mp3")
				for item in wwmt_res_list WHERE findItem sounditems (toLower( getFileNameType item)) != 0 do (
					localFile = wallworm_safe_local(wwmt_gameInfoDir+"\\"+item)
					if doesFileExist (localFile) then (
	
					str = ("\""+item+"\"\n")
					
					format str to: resFile
					) else (
						
						--print ("File Not Found: MANIFEST Skipping "+localFile)
					)
					--print str
				)
				
	
			close resFile
			
					try (
					global wallworm_text_editor
					folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+filename+"\""
					execute folderOpen
					
					) catch(
					
					
					
					)			
				
			)
	
			
		) else (
				messagebox "No sound assets were found in the scene or listed in your soundscape file."
		)
			
			
		)
	on btnRar pressed do
	(
			
		
		if doesFileExist (edtWinRARPath.text+"\WinRAR.exe") then (
		
		
			global wwmt_gameInfoDir
			local mapDir = wwmt_gameInfoDir+"\\maps"
			local fname = mapDir + "/"+edtMapName.text+".res"
				
				
				
				filename = getOpenFileName  caption:"Open a Res File to RAR" filename:fname types:"RES File (*.res)|*.RES"  historyCategory:"Wall Worm BSP"
		
		
				if filename == undefined  then (
				
		
					messagebox "The Res File was not found. No Zip Archive created."
				
				
				) else (
					
					mpname = getFileNameFile filename
					filenameb = getFileNamePath filename + "\\"+mpname+"_zip.bat"
					
					local sv
					if doesFileExist filenameb == false then (
						sv = openFile filenameb mode:"w+"
					) else (
						sv = createFile filenameb
								
					)
					
					rarname = wwmt_gameInfoDir+"\\maps\\"+mpname+".zip"
					
					local theAssets = wallworm_res_to_array filename
					
					format "@echo on\n" to:sv
					
					if theAssets.count > 0 then (
						
						for asset in theAssets do (
							Format  ("cd \""+(wwmt_gameInfoDir+"\\"+(getFileNamePath asset))+"\"\n")  to:sv
							--cmd = "\"C:\Program Files\WinRAR\\\"rar.exe  a -ap"+(getFileNamePath asset)+" -ep1 \""+wwmt_gameInfoDir+"\\maps\\"+mpname+".rar\" \""+wwmt_gameInfoDir+"\\"+(getFileNamePath asset)+(getFileNameFile asset) +(getFileNameType asset)+"\"\n"
							
							cmd = "\""+edtWinRARPath.text +"\"\WinRAR.exe  a -ap"+(getFileNamePath asset)+" -m5  -ep1 \""+rarname+"\" \""+(getFileNameFile asset) +(getFileNameType asset)+"\"\n"
							--hiddendoscommand cmd 
							--startpath:(wwmt_gameInfoDir+"\\"+(getFileNamePath asset))
							--print cmd
							format cmd to:sv
						)
	
					)
					
					close sv
					
					if theAssets.count > 0   then (
						shellLaunch filenameb ""
						/*
						if  doesFileExist rarname == true  then (
							--folderOpen ="ShellLaunch \"C:\Program Files\WinRAR\\\"WinRAR.exe\" @\""+rarname+"\""
							--folderOpen ="ShellLaunch \"C:\Program Files\WinRAR\WinRAR.exe\" @\""+rarname+"\""
							--print folderOpen
							--execute folderOpen
							--shellLaunch rarname ""
							execute ("ShellLaunch \"explorer.exe\" @\""+(wwmt_gameInfoDir+"\\maps\\")+"\"")
							
							
						)*/
						
						execute ("ShellLaunch \"explorer.exe\" @\""+(wwmt_gameInfoDir+"\\maps\\")+"\"")
					)
				)
			
			
			
			
			) else (
				messagebox "WinRAR was not found in the specified directory. Please download WinRAR or point the WinRAR path to the correct location."	
					)
			
			)
	on edtWinRARPath entered text do
	(
	
	setINISetting wallworm_userIni "Directories" "winrar_path" text	
	
	
	)
)


createDialog wallwormRESUI