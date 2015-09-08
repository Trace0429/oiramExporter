rollout wallwormVMFImporter "VMF Importer" width:347 height:721
(
	--and MAP 
	local mustUseSlice = false
	
	button btnImport "Choose VMF or MAP to Import" pos:[11,160] width:223 height:37 toolTip:"Browse for your VMF or MAP file and import it."
	

	HyperLink lnkWW "Wall Worm" pos:[13,614] width:81 height:15 address:"http://dev.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	HyperLink lnkShawn "Shawn Olson" pos:[229,614] width:109 height:15 address:"http://www.shawnolson.net" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	label ver "Version " pos:[105,614] width:77 height:13
	
	HyperLink lnkLove "Donate to the Wall Worm Project" pos:[116,638] width:223 height:15 address:"http://dev.wallworm.com/topic/42/donate.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	label lbl7 "Love Wall Worm?" pos:[13,639] width:87 height:14
	
	button btnModels "Import Props from Scene Entities" pos:[24,259] width:300 height:33 enabled:true toolTip:"Import prop meshes for any entity with a MDL assigned to it. Only works if the model's QC and SMD files can be found in the modelsrc folders."
	
	
	HyperLink lnkHelp "Help Using This Tool and Other Tips" pos:[12,12] width:325 height:15 address:"http://dev.wallworm.com/document/124/vmf_importer.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	
	HyperLink lblBriscoe "Sponsored by Robert Briscoe" pos:[11,659] width:151 height:19 address:"http://www.littlelostpoly.co.uk" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	
	--defaultBitmapSize #("64","128","256","512","1024")
	dropdownList ddlDefaultBitmapSize "" pos:[223,44] width:113 height:21 items:#("64", "128", "256", "512", "1024") selection:4
	label lbl3 "Fallback Bitmap Size for Missing Textures" pos:[14,46] width:207 height:17
	button btnSaveLib "Save Imported Material Library" pos:[23,459] width:300 height:36 enabled:false
	spinner spnLimit "Parse Failure Retry Limit" pos:[23,79] width:313 height:16 range:[1,1024,20] type:#integer scale:1 toolTip:"Retry parsing the VMF this many times if there are failures. A high value could freeze Max for a significant period of time!"
	GroupBox grp1 "Prop Imports" pos:[11,204] width:322 height:148
	button btnTools "Tools to Hidden Layer" pos:[23,411] width:120 height:37 toolTip:"Find all objects with the word *Tools* in the material name and hide them in a layer called VMF_Tools."
	button btnDisDest "Displacements to Mesh" pos:[156,411] width:167 height:38 toolTip:"Convert Wall Worm displacements to standard Editable Poly objects."
	checkbox chkNoSlice "Use Default Brush Generation" pos:[18,113] width:172 height:18 checked:true toolTip:"Wall Worm has two methods for generating brushes. One is a fallback method when the default fails. Choose the fallback only if the default is giving you poor results."
	button btnRebuild "Delete Imported Objects and Rebuild" pos:[23,574] width:190 height:29 toolTip:"You may want to use this option if you want to rebuild the scene based on having added VMTs and other assets used to build UVs and Materials, or if you need to retry with the alternate brush option."
	spinner spnAngle "Rotation Angle" pos:[76,231] width:62 height:16 range:[-180,180,90] type:#integer scale:1 step:90 toolTip:"This is the default offset rotation for your models. This value is probably going to be 90 for SMD/QC exported before Wall Worm. It may be 0 or 180 for other versions."
	button btnRebuildSel "Rebuild Selected" pos:[220,574] width:103 height:30 toolTip:"Rebuild selected object with the current brush generation method. Only works on displacements and brush objects that are not tied to an entity."
	dropdownList ddlRotTarg "Apply Rotation To" pos:[152,214] width:170 height:40 items:#("WWMT Model", "Proxie Props") toolTip:"If re-exporting the VMF, choose the WWMT model option. Some props will be rotated incorrectly in scene if original SMD was not aligned to world. For getting props in scene with correct orientation, choose Proxie Props. Note that the WWMT model may need to be re-exported."
	button btnRotFix "Fix Bad Prop Rotation" pos:[25,302] width:299 height:34 toolTip:"Experimental.... use this to fix bad rotations which might happen if original prop was rotated incorrectly."
	button btnImportDetails "Import Prop Details" pos:[24,362] width:299 height:35 toolTip:"Import prop details for this scene."
	checkbox chkautoCheckGeometry "Validate Geometry" pos:[18,136] width:168 height:19 checked:false toolTip:"This will add some geometry validation to the importer. This will remove the possibility of missing brushes but can increase import times."
	button btnSelectWarningGeo "Select Imported Geometry that Needs Attention" pos:[24,499] width:238 height:29 toolTip:"Sometimes some of the geometry is imported incorrectly. Use this to select objects that may be incorrect."
	
	button btnRemCoplanar "Remove Coplanar Faces on Selection" pos:[144,541] width:180 height:23 toolTip:"Run this function on objects that have coplanar faces. Only works on Editable Poly objects."
	spinner spn3 "Threshhold" pos:[49,546] width:86 height:16 range:[0.01,15,10] scale:0.01 toolTip:"Set the threshhold for coplanar face angle detection. The importer uses 10."
	checkbox chkSaveCache "Auto Cache" pos:[249,122] width:84 height:17 checked:false toolTip:"Create a MAXScript cache of this import that can be opened again without parsing the scene."
	button btnCache "Open Cache" pos:[247,144] width:80 height:21 toolTip:"Open an import cache file."
	GroupBox grp3 "Caching" pos:[239,105] width:96 height:91
	button btn31 "Save Cache" pos:[247,170] width:80 height:19

	
	function enableButtons = (
			global theWallWormVMFImport

			if theWallWormVMFImport.materials.count > 0 then (
									
				btnSaveLib.enabled = true
									
			)
			

		
	)
	
	
	
	function buildScene started = (
					max create mode
					with redraw off undo off (
						theWallWormVMFImport.createBrushes()		
						theWallWormVMFImport.createEntities()
										
						set coordsys world
											
						wallworm_show_displacements()
						wallworm_hide_displacement_brushes()
										
						fileIn "$scripts/WallWorm.com/WallWormUtilities/DisplacementsMat2toMat.ms"
			
						enableButtons()										
										
						local ended = timestamp()
						seconds = ((ended - started) / 1000.0) 
						minutes = seconds / 60 			
						format "% Imported in % seconds (% minutes)\n" (theWallWormVMFImport.filename) seconds minutes 	
					)
	)
		
	
	function cacheimport = (
		if theWallWormVMFImport != undefined AND theWallWormVMFImport.filename != undefined AND theWallWormVMFImport.filename != "" then (

				newfilename = theWallWormVMFImport.filename +(timestamp() as string)+ ".wwimportmxs"
				cf = createFile newfilename
				tempDat = copy theWallWormVMFImport
				
				for b in tempDat.brushes do (
					
					for p in b.planes do (
						p.mat = undefined
						if p.dispinfo != undefined then (
							p.dispinfo.clearMatrices()
						)
						p.disp = undefined
					)
					b.nd = undefined
					
				)
				for en in tempDat.entities do (
					
					for b in en.brushes do (
						
						for p in b.planes do (
							p.mat = undefined
							if p.dispinfo != undefined then (
								/*Should never happen... but just in case.*/
								p.dispinfo.clearMatrices()
							)
							p.disp = undefined
						)
						b.nd = undefined
						
					)
					
				)
				
				tempDat.dotNetFile = undefined
				tempDat.rx = undefined
				tempDat.nodes = #()
				tempDat.pvGetVert = undefined
				tempDat.pvGetMapVert=undefined
				tempDat.pvGetMapFace=undefined
				tempDat.materials = undefined
				tempDat.filename = wallworm_bstofs tempDat.filename
				with printAllElements on (
					format (tempDat as string) to:cf
				)
				close cf						
		)
	)
		
	button btn14 "UV Fix" pos:[265,499] width:57 height:29
		
	on wallwormVMFImporter open do
	(
			
		
	
		
		
			global theWallWormVMFImport
			if theWallWormVMFImport == undefined then (
				theWallWormVMFImport = wallworm_vmf_import()
			)
			ver.text = ver.text + (theWallWormVMFImport.importVersion as string)
			
			if isProperty theWallWormVMFImport "removeEdgeThreshhold" then (
				spn3.value = theWallWormVMFImport.removeEdgeThreshhold
			)
		
			if nvpx == undefined then (
				mustUseSlice = true	
				chkNoSlice.checked = true
				chkNoSlice.toolTip = "This setting is required on your version of 3ds Max."
				chkNoSlice.enabled = false
				theWallWormVMFImport.sliceBrushes = true
				
	
			)
			
			enableButtons()
		)
	on btnImport pressed do
	(
		
		
		global wwmt_raw_mats
		
		if wwmt_raw_mats == undefined OR wwmt_raw_mats == "" OR doesFileExist wwmt_raw_mats == false then (
			
			messagebox "The VMF Importer needs you to set the root material folder for your Material Library Generator. Please set it Material Root in the following dialog then run the VMF importer again."
			
			macros.run "wallworm.com" "WallWormMaterialGeneratorMCR"
	
		) else (
			
				if objects.count == 0 OR (queryBox "There are objects already in the scene.\nAre you sure you want to import objects?" title:"Confirm Scene Import") == true then (
					
				--	fsource = GetOpenFileName types: "Valve Map File (*.vmf)|*.VMF|MAP (*.map)|*.MAP|All files (*.*)|*.*|" historyCategory:"Wall Worm VMF" caption:"VMF/MAP File Importer" 
					fsource = GetOpenFileName types: "Valve Map File (*.vmf)|*.VMF|Map File (*.map)|*.MAP|All files (*.*)|*.*|" historyCategory:"Wall Worm VMF" caption:"VMF File Importer" 
					
					
					if fsource != undefined then (
								clearListener()
						
								local started = timestamp()
						
								max create mode
								with redraw off (
									global theWallWormVMFImport
									theWallWormVMFImport = wallworm_vmf_import()
									
									theWallWormVMFImport.sliceBrushes = chkNoSlice.checked
									theWallWormVMFImport.autoCheckGeometry = chkautoCheckGeometry.checked
									theWallWormVMFImport.filename = fsource
									theWallWormVMFImport.generateMaterials = true
									
									theWallWormVMFImport.removeEdgeThreshhold = spn3.value
								
									
									
									
									theWallWormVMFImport.defaultBitmapSize = ddlDefaultBitmapSize.selected as integer
									
									if (theWallWormVMFImport.parse tryLimit:spnLimit.value) != false then (
										
										buildScene(started)
										
										if theWallWormVMFImport.errorCount > 0  then (
											
												format "NOTICE: Although the level imported, the parse function failed (%) times.\n\n" theWallWormVMFImport.errorCount
												--messagebox "Your scene imported... however there may be problems. Hit F11 for more information."
											
										)
										
										
	
										
									) else (
										
											messagebox "The import failed. Press F11 for possible hints."
										
											format "There is a common problem with parsing VMF files that causes an *unknown system exception*. This error seems to be random and may be due to a memory buffer overflow in Max.\n\n"
											format "Wall Worm defaults to trying 20 times to parse a VMF, but you can set this to your own preference.\n\nIf you get this failure, try running the import again and/or setting the retry limit higher. Repeated attempts will likely succeed eventually.\n\n"
									)
									
									
									
	
									
									
									redrawViews()
									
									
								if chkSaveCache.checked == true then (
									local doCache = false
									if pathIsNetworkPath fsource then (
										
										doCache = querybox "Write the cache? This is often very slow on a network."
										) else (
										
										doCache = true
									)
									if doCache then (
										cacheimport()
									)
								)									
	
									
									
								)
		
						
		
					) else (
						
							messagebox "Ooops... no map was imported."
						
					)
				
				)
				resumeEditing()
			)
		)
	on btnModels pressed do
	(
		
		--print "hi"
	
	
				
				--print edtFlags.text
				
	
				
		global qcFiles
		global wallworm_complete_model_list
				
		qcFiles = wwmt_getQCFilesRecursive wwmt_export "*" "*"
	
		for qc in qcFiles do (
			m = wallworm_mdlQCmap()
			m.qc = qc
			m.getMyMdl()
			append wallworm_complete_model_list m
		)
	
		if ddlRotTarg.selection == 1 then (
			mdls = true
			props = false
		) else (
			mdls = false
			props = true
		)
		
				
				wallworm_import_mdls ang:spnAngle.value mdls:mdls props:props
	
			
		)
	on btnSaveLib pressed do
	(
				fileName = getSaveFileName caption:"Save Material Library" filename:((getFileNameFile theWallWormVMFImport.filename ) + ".mat")  types: "Material Library (*.mat)|*.MAT" historyCategory:"Wall Worm Materials"
				if fileName != undefined then (
					saveTempMaterialLibrary theWallWormVMFImport.materials fileName
					
				)
		)
	on btnTools pressed do
	(
			
			local tools = for obj in objects WHERE obj.mat != undefined AND isProperty obj "wallworm_displacement" == false AND matchPattern obj.mat.name pattern:"*tools*" == true collect obj
			
			with redraw off (
				if tools.count > 0 then (
					toolsLayer = LayerManager.getLayerFromName "VMF_Tools"
					
					
					if toolsLayer == undefined then (
						
						toolsLayer = LayerManager.newLayerFromName "VMF_Tools"
					)
					toolsLayer.on = false	
					
					for obj in tools do (
							toolsLayer.addNode obj
					)
					
					
				)
			)
		)
	on btnDisDest pressed do
	(
			
				wallworm_displacement_to_poly()
			
	)
	on btnRebuild pressed do
	(
		if theWallWormVMFImport.nodes.count > 0 then (
			
			if (querybox "Are you sure? All imported objects will get deleted! The action cannot be undone.") == true then (
				theWallWormVMFImport.deleteAllNodes()
				local started = timestamp()
				buildScene(started)
			)
		) else (
				messagebox "There were no nodes in the scene to rebuild."
		)
	)
	on btnRebuildSel pressed do
	(
		if selection.count > 0 then (
			wallworm_rebuild_selected_objects sel:(selection as array) sliceBrushes:(chkNoSlice.checked )
		) else (
			messagebox "You must select an object in the scene to rebuild."
		)
	)
	on btnRotFix pressed do
	(
		if selection.count > 0 then (
		in coordsys local  (
			for obj in selection where isProperty obj "wallworm" == true AND isProperty obj "model" == true do (
				rotate obj (angleaxis -90 [0,0,1])
				rotate obj (angleaxis 90 [0,1,0])
			)
		)
		) else (
			messagebox "No objects selected. Select props in the scene with a bad rotation."
		)
	)
	on btnImportDetails pressed do
	(
	macros.run "wallworm.com" "WallWormImportVBSPMCR"
	)
	on btnSelectWarningGeo pressed do
	(
			global theWallWormVMFImport
			sel = theWallWormVMFImport.getQuestionableBrushes()
			if sel.count > 0 then (
				select sel
			)
		)
	on btnRemCoplanar pressed do
	(
	global theWallWormVMFImport
	for obj in selection WHERE classof obj.baseObject == Editable_Poly do (	
		theWallWormVMFImport.remCopEdges obj threshhold:spn3.value
	)
	)
	on spn3 changed val do
	(
			
			if theWallWormVMFImport != undefined AND isProperty theWallWormVMFImport "removeEdgeThreshhold" then (
				theWallWormVMFImport.removeEdgeThreshhold = spn3.value
			)
			
		)
	on btnCache pressed do
	(
			fileName = getOpenFileName caption:"Open Import Cache File"  types: "Wall Worm Import Cache (*.wwimportmxs)|*.wwimportmxs|All files (*.*)|*.*|" historyCategory:"Wall Worm VMF" caption:"VMF File Importer" 
			if fileName != undefined then (
				f = openFile fileName
				global theWallWormVMFImport
				theWallWormVMFImport = execute f
				
	
				theWallWormVMFImport.materials = MaterialLibrary()
				theWallWormVMFImport.dotNetFile = dotNetClass "System.IO.File"
				theWallWormVMFImport.rx = dotNetClass "System.Text.RegularExpressions.RegEx"
	
				theWallWormVMFImport.nodes=#()
	
				theWallWormVMFImport.pvGetVert = polyop.getVert
				theWallWormVMFImport.pvGetMapVert=polyop.getMapVert
				theWallWormVMFImport.pvGetMapFace=polyop.getMapFace
								
				buildScene((timestamp()))
				
			)
		
	)
	on btn31 pressed do
	(
	
	cacheimport()
	)
	on btn14 pressed  do
	(
	fileIn "$scripts\\WallWorm.com\\rollouts\\importuvfix.ms"
	global wallworm_brush_plane_fix
	try(
	destroyDialog wallworm_brush_plane_fix
	) catch ()
	createDialog wallworm_brush_plane_fix
	)
)
