/*
Wall Worm
Overview Creation Script

http://dev.wallworm.com

Copyright (c) 2012 by Shawn Olson
http://www.shawnolson.net

All Rights Reserved

*/
include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
try (
	destroydialog WallWormOverviewExporter
	) catch ()

(	
	  wallworm_StartingLayout = viewport.getLayout()
	  wallworm_StartingView = viewport.getType()
	  wallworm_StartingRenderLevel = viewport.GetRenderLevel()
	  wallworm_StartingrenderWidth  = renderWidth  
	  wallworm_StartingrenderHeight  = renderHeight  
	  wallworm_oldComment1 = Targa.getComment1()
	  wallworm_oldComment2 = Targa.getComment2()
	  wallworm_oldComment3 = Targa.getComment3()
	  wallworm_oldAlphaSplit = Targa.getAlphaSplit()
	  wallworm_oldAlphaPre = Targa.getPreMultAlpha()
	
		try (
			
			wallwormNitrous = NitrousGraphicsManager.GetActiveViewportSetting()
			wallworm_oldNitrousSetting = wallwormNitrous.VisualStyleMode
			) catch ()


rollout WallWormOverviewExporter "Wall Worm Overview Exporter v1.0" width:314 height:312
(
	
	local bm1, bm2

	
	button btnRender "Render" pos:[9,228] width:132 height:43 toolTip:"Render the overview. You should have the Safe Frame turned on!"
	dropdownList ddlDimension "Overview Bitmap Size" pos:[16,58] width:112 height:40 items:#("512", "1024", "2048") selection:2
	button btnSF "Safe Frame Toggle" pos:[10,193] width:131 height:29 toolTip:"Display the Safe Frame Toggle for aligning your overview."
	edittext edtMapName "Map Name" pos:[12,9] width:286 height:20
	button btn13 "Compile" pos:[146,193] width:149 height:43 toolTip:"Compile the VTFs from the rendered TGA files."
	HyperLink overlink "Help, Tips and Tricks" pos:[13,281] width:101 height:15 address:"http://dev.wallworm.com/topic/59/overview_exporter.html" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	dropdownList ddlRadarSize "Radar Bitmap Size" pos:[164,96] width:121 height:40 enabled:false items:#("128", "256", "512", "1024", "2048") selection:2
	checkbox chkRadar "Make Alternate Radar" pos:[164,75] width:128 height:15
	checkbox clamp "Clamp S/T" pos:[17,114] width:76 height:16 checked:true
	checkbox chkTranslucent "$translucent" pos:[17,136] width:89 height:16 checked:true
	GroupBox grp1 "Radar Image" pos:[152,44] width:145 height:140
	button btnViewRadar "View Radar TGA" pos:[164,145] width:123 height:26
	button btnViewOverview "View Overview TGA" pos:[18,155] width:108 height:23 toolTip:"Open the TGA that matches the Map Name above."
	button btnOpenOverviewFolder "Open Overview Folder" pos:[148,242] width:148 height:27 toolTip:"Open the folder where the overview text files go, as well as DDS files for CSGO."
	
	groupBox grp6 "Default Overview" pos:[9,41] width:131 height:144
	
	
	
	
	
	
	
	
	
	on WallWormOverviewExporter open do
	(
		
	 
	  
	  viewport.setLayout #layout_1
	  viewport.setType #view_top
	  viewport.SetRenderLevel #smoothhighlights	
		
		
	   renderWidth  = (ddlDimension.selected as number)
	   renderHeight  = (ddlDimension.selected as number)
		
	
		try (
			wallwormNitrous.VisualStyleMode #Realistic
		) catch (
			--failed because not nitrous
			)
		
		
		local wallwormMapNameIndex = fileProperties.findProperty #custom "wallwormMapName"
	
		if wallwormMapNameIndex != 0 then (
			edtMapName.text =fileProperties.getPropertyValue #custom wallwormMapNameIndex
		) else (
			edtMapName.text = getFilenameFile maxFileName
		)
		
		
			Targa.setComment1 "overview"
			Targa.setComment2 "hdr"
			Targa.setComment3 "wallworm.com overview creator"
			Targa.setAlphaSplit false
			Targa.setPreMultAlpha true
			Targa.setColorDepth 32
		
		/*
			if wwmt_def_fgd != undefined AND wwmt_def_fgd != "" AND (doesFileExist wwmt_def_fgd) == true then (
	
					fileIn "$scripts/WallWorm.com/common/mse/parseFGD.mse"
					global wallworm_mapsize
					if wallworm_mapsize != undefined then (
						
						
						local modMapsize = formattedPrint ( (abs wallworm_mapsize[1]) + (abs wallworm_mapsize[1]) )
						
						local index = findItem cbxMapDimension.items (modMapsize)
						
						if index == 0 then (
							--print modMapsize
							local newItems = cbxMapDimension.items
							append newItems (modMapsize )
							cbxMapDimension.items = newItems
							--print (cbxMapDimension.items as string)
							cbxMapDimension.selection = findItem cbxMapDimension.items (modMapsize as string)
						) else (
							cbxMapDimension.selection = index
							
						)
						
						
					)
				
				
				
			)
		
		*/
		
		
			local expRadar = getINISetting wallworm_userIni "Exporters" "wwmt_overview_export_radar"
			if expRadar != undefined AND expRadar == "true" then (
				ddlRadarSize.enabled = true
				
				chkRadar.checked = true
			)
			
			local overDim =	getINISetting wallworm_userIni "Exporters" "wwmt_overview_dimension"	
			if overDim != undefined then (
				
				ddlDimension.selection = findItem ddlDimension.items overDim
				
				) else ()
			
			local radarDim = getINISetting wallworm_userIni "Exporters" "wwmt_radar_dimension"	
			if radarDim != undefined then (
				
				ddlRadarSize.selection = findItem ddlRadarSize.items radarDim 
				) else ()
			
			
			
	)
	on WallWormOverviewExporter close do
	(
		viewport.setLayout wallworm_StartingLayout
		viewport.setType wallworm_StartingView
	   
		viewport.SetRenderLevel wallworm_StartingRenderLevel
		
		
		renderWidth  = wallworm_StartingrenderWidth
		renderHeight = wallworm_StartingrenderHeight    
		
		Targa.setComment1 wallworm_oldComment1
		Targa.setComment2 wallworm_oldComment2
		Targa.setComment3 wallworm_oldComment3
		Targa.setAlphaSplit wallworm_oldAlphaSplit
		Targa.setPreMultAlpha wallworm_oldAlphaPre
		try (
			wallwormNitrous.VisualStyleMode wallworm_oldNitrousSetting
		) catch (
			--failed because not nitrous
		)
	)
	on btnRender pressed do
	(
		
		
		local initialdisplaySafeFrames = displaySafeFrames
		
		--local mapsize = (cbxMapDimension.text as number)
		if edtMapName.text != ""  then (
		local dimension = (ddlDimension.selected as number)	
		local radarDimension = (ddlRadarSize.selected as number)
	/*			
			--aspect = (getViewSize()).x / (getViewSize()).y
			
			local vpTransform = viewport.getTM()
			--local vpTransform = inverse (viewport.getTM())
			--local vpTransform = 	mapScreenToCP [0,0]
			outX = vpTransform[4].y * -1
			outY = vpTransform[4].x * -1
	
			local vpTransform = mapScreenToView [0,0]  dimension
						
			--local outX = vpTransform.x / aspect   --/ aspect
			--local outY = vpTransform.y / aspect
				
			local outX =  (vpTransform.x )
			local outY = (vpTransform.y  )
	
	
			--local outScale = mapsize / (gw.getVPWorldWidth [0,0,0] )
	
	
							
				
			local outScale = formattedPrint ((getScreenScaleFactor [0,0,0]) / dimension)
				*/
							
			local vpTransform = viewport.getTM()
			/*
			 Returns a Matrix like: (matrix3 [1,0,0] [0,1,0] [0,0,1] [-560.076,1419.73,0])
			*/
	
	
	
	
			local outScale =(getScreenScaleFactor [0,0,0]) / dimension
			
			
			
		local areadimension = (dimension*outScale)
	
		local tempPlane = Plane pos:[(vpTransform[4].x * -1) ,(vpTransform[4].y * -1),0] lengthsegs:1 widthsegs:1 width:areadimension length:areadimension
	
	
				
			outX = tempPlane.min.x
			outY = tempPlane.max.y
				
			delete tempPlane
			
			
			
		/*	local outX = vpTransform[4].x + ((vpTransform[4].x*outScale)/2)
			local outY = vpTransform[4].y	*/
				
				--local outScale = formattedPrint (((getScreenScaleFactor [0,0,0]) / dimension) * aspect )
			
				
				--format "pos_x\t%\npos_y\t%\nscale\t%\n" outX outY outScale
	/*			 
	local aspect = (getViewSize()).x / (getViewSize()).y
	
	local size_y = dimension * outScale -- scale factor, 1024 = OVERVIEW_MAP_SIZE
	local  size_x = size_y * aspect -- standard screen aspect 
	outX += size_x / 2;
	outY -= size_y / 2;
	
	*/
				
				
	
			/*
			--local vpRay = (mapScreenToWorldRay [vpX,vpY])
			--local vpRay = mapScreenToWorldRay (getViewSize() / 2)
			local vpTransform = (mapScreenToWorldRay [0,0]).pos / outScale
			local outX = vpTransform.y
			local outY = vpTransform.x
			
			*/
			
			--local outScale = getViewFOV() / 100 
			
			
			--local outScale = gw.nonScalingObjectSize() * (gw.getVPWorldWidth [0,0,0]) / 360.0
			
			--local outScale = mapsize / (viewport.GetScreenScaleFactor [0,0,0] )
			
			
			
	
		
		    local tgafile = wwmt_exportMats + "\\overviews\\"+edtMapName.text+".tga"
			local tgafile2 = wwmt_exportMats + "\\overviews\\"+edtMapName.text+"_radar.tga"
		    local preffile = wwmt_exportMats + "\\overviews\\"+edtMapName.text+".txt"
			local preffile2 = wwmt_exportMats + "\\overviews\\"+edtMapName.text+"_radar.txt"
			local bat = wwmt_exportMats + "\\overviews\\"+edtMapName.text+".bat"
			
			if doesFileExist (getFileNamePath (preffile)) == false then (
				makeDir (getFileNamePath (preffile)) all:true
			)
			
			local overviewpath = wwmt_gameInfoDir + "\\resource\\overviews\\"+edtMapName.text+".txt"
			local overviewpath2 = wwmt_gameInfoDir + "\\resource\\overviews\\"+edtMapName.text+"_radar.txt"
			if doesFileExist (getFileNamePath (overviewpath)) == false then (
				makeDir (getFileNamePath (overviewpath)) all:true
			)
			
			
			local  tga = bitmap dimension dimension HDR:true PixelAspect:1  colorDepth:32 filename:tgafile
			displaySafeFrames = false
			render  outputwidth:dimension outputheight:dimension quiet:true vfb:on outputHDRbitmap:true  to:tga
			save tga
			
			displaySafeFrames = initialdisplaySafeFrames
			if chkRadar.checked  ==true then (
				local  tga2 = bitmap radarDimension radarDimension HDR:true PixelAspect:1  colorDepth:32 filename:tgafile2
				copy tga tga2
				save tga2
				close tga2	
			)
			close tga
			
			clampline = ""
			if clamp.checked == true then (
				
				clampline = "\"clamps\" \"1\"\n\"clampt\" \"1\"\n"
				)
			
			
			if doesFileExist preffile == true then (
				local paramfile = OpenFile preffile mode:"w"	
			) else (
				local paramfile = CreateFile(preffile)		
			)			
			format (clampline+"\"nocompress\" \"1\"\n\"nomip\" \"1\"") to:paramfile
			close paramfile
			
			if chkRadar.checked  ==true then (
				if doesFileExist preffile2 == true then (
					local paramfile = OpenFile preffile2 mode:"w"	
				) else (
					local paramfile = CreateFile(preffile2)		
				)			
				format (clampline+"\"nocompress\" \"1\"\n\"nomip\" \"1\"") to:paramfile
				close paramfile
			)
			
			
			if doesFileExist overviewpath == true then (
				local overview = OpenFile overviewpath mode:"w"	
			) else (
				local overview = CreateFile(overviewpath)		
			)		
			format ("//\tOverview Created by Wall Worm\n//\thttp://dev.wallworm.com\n") to:overview
			
			format (edtMapName.text+"\n{\n") to:overview
			format	("material	overviews/"+edtMapName.text+" \n") to:overview
			format	("pos_x		"+(formattedPrint outX)+" \n") to:overview
			format ("pos_y		"+(formattedPrint outY )+" \n") to:overview
			format	("scale		"+(formattedPrint outScale)+" \n") to:overview
			format	("rotate		0 \n") to:overview
			format	("zoom		1 \n") to:overview
			format ("}") to:overview
			close overview
			
			if chkRadar.checked  == true then (
				if doesFileExist overviewpath2 == true then (
					local overview = OpenFile overviewpath2 mode:"w"	
				) else (
					local overview = CreateFile(overviewpath2)		
				)		
				format (edtMapName.text+"\n{\n") to:overview
				format	("material	overviews/"+edtMapName.text+"_radar \n") to:overview
				format	("pos_x		"+(outX as string)+" \n") to:overview
				format ("pos_y		"+(outY as string)+" \n") to:overview
				format	("scale		"+(outScale as string)+" \n") to:overview
				format	("rotate		0 \n") to:overview
				format	("zoom		1 \n") to:overview
				format ("}") to:overview
				close overview
			)
			
			
			
			if doesFileExist bat == true then (
				local newBatch = OpenFile bat mode:"w"	
			) else (
				local newBatch = CreateFile(bat)		
			)	
			
			
			
			if chkRadar.checked  == true then (
				--print "yes"
				 tgafile = tgafile + ("\" \""+tgafile2+"")
				
			) else (
				--print "no"
				)
			
			local transline = ""
			if chkTranslucent.checked == true then (
				
				transline = " -vmtparam $translucent 1"
				) else ()
			
			Format "@echo on\n" to:newBatch		
			local bt = "cd \""+wwmt_binDir+">\"\n" 
			Format bt to:newBatch
			bt = "vtex.exe  -game \""+wwmt_gameInfoDir+"\" -mkdir -shader UnlitGeneric"+transline+" -vmtparam $vertexalpha 1 -vmtparam $no_fullbright 1 -vmtparam  $ignorez 1 \""+tgafile+"\"\n"
			Format bt to:newBatch
			
			close newBatch
			display tga
			
			) else (
			
				messagebox "You must enter a map name."
			)
		)
	on ddlDimension selected sel do
	(
		
	
		   renderWidth  = (ddlDimension.selected as number)
		   renderHeight  = (ddlDimension.selected as number)
		
		
			setINISetting wallworm_userIni "Exporters" "wwmt_overview_dimension"	(ddlDimension.selected as string)
	
	)
	on btnSF pressed do
	(
		max safeframe toggle
	)
	on edtMapName entered text do
	(
	
				local wallwormMapNameIndex = fileProperties.findProperty #custom "wallwormMapName"
	
				if wallwormMapNameIndex != 0 then (
					fileProperties.deleteProperty #custom "wallwormMapName"
				)
	
				fileProperties.addProperty #custom "wallwormMapName" text
	
	
	
	)
	on btn13 pressed do
	(
	
		 bat = wwmt_exportMats + "\\overviews\\"+edtMapName.text+".bat"
		 if doesFileExist bat == true then (
			 shellLaunch bat ""
			 
		) else (
			 messagebox "The batch file to compile hasn't been made. Run the Render function."
			 )
	)
	on ddlRadarSize selected sel do
	(
		
	/*
		   renderWidth  = (ddlDimension.selected as number)
		   renderHeight  = (ddlDimension.selected as number)
		*/
			setINISetting wallworm_userIni "Exporters" "wwmt_radar_dimension"	(ddlRadarSize.selected as string)
		
	
	)
	on chkRadar changed state do
	(
	
	
	ddlRadarSize.enabled = state
	
	setINISetting wallworm_userIni "Exporters" "wwmt_overview_export_radar"	(state as string)
	
	
	)
	on btnViewRadar pressed do
	(
	
	
		local tgafile = wwmt_exportMats + "\\overviews\\"+edtMapName.text+"_radar.tga"
		if doesFileExist tgafile == true then (
	
	
		local  tga = openbitmap tgafile 
		display tga
		
		) else (
			
			messagebox "Ooops... the tgafile for this level hasn't been rendered yet or you don't have the correct level name above."
			)
	
	
	
	)
	on btnViewOverview pressed do
	(
	
	
		local tgafile = wwmt_exportMats + "\\overviews\\"+edtMapName.text+".tga"
		if doesFileExist tgafile == true then (
	
	
		local  tga = openbitmap tgafile 
		display tga
		
		) else (
			
			messagebox "Ooops... the tga file for this level hasn't been rendered yet or you don't have the correct level name above."
			)
	
	
	
	)
	on btnOpenOverviewFolder pressed do
	(
	
	
	 local ovp =  wwmt_gameInfoDir + "\\resource\\overviews\\"
	
	
	ShellLaunch "explorer.exe" ovp 
	
	)
)
createDialog WallWormOverviewExporter      
)
