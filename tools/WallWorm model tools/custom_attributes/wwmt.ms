/*
Wall Worm Model Tools Custom Attribute
Copyright (c) 2014 by Shawn Olson
http://www.shawnolson.net

A Wall Worm Project
http://www.wallworm.com

This CA requires that Wall Worm is installed in order to be used correctly.
attribID:#(0xcee389b, 0x2fe761bd) 
*/

global wallworm_model_tools_CA
wallworm_model_tools_CA = attributes "Wallworm Model Tools"
version:15
(

	
	
	local wallworm = true --used by many WW scene utilities
	local wwmt_ca = true --lets external functions know this is a WWMT helper
	local wwmt --used to store the ww_LOD_wrapper object. Gets set with the getWWMT() method.
	local thisNode --stores pointer to the node this CA is applied to.
	function getNode = (
		if thisNode == undefined then (
			thisNode = refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
		)
		thisNode
	)
	
	function getWWMT refresh:false = (
		
		if wwmt == undefined OR classOf wwmt != ww_LOD_wrapper OR thisNode==undefined OR  refresh == true then (
			getNode()
			global ww_LOD_wrapper
			if ww_LOD_wrapper == undefined AND doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\ww_structs.ms" then (
				filein "$scripts\\WallWorm.com\\WallWormModelTools\\ww_structs.ms"
			)
			if ww_LOD_wrapper != undefined then (

				if thisNode != undefined then (
					local wwmt = ww_LOD_wrapper()
					wwmt.init()					
					wwmt.setTargetModel thisNode wwmt
				)
				
			)
		) else (
		)
	
		if wwmt != undefined AND isProperty wwmt "isset" then (
			wwmt.isset = false
		)

		wwmt
	)
	

	
	function updateWWMTGUIFromWWMT openWWMT:false sendToGlobal:false= (
		
		getWWMT refresh:true
		if wwmt != undefined then (
			global ww_scene_lods
			if (ww_scene_lods != undefined AND (ww_scene_lods == wwmt))  OR sendToGlobal == true then (
					global wwToolsFloater
				
					if sendToGlobal == true then (
						global wallworm_reset_wwmt
						wallworm_reset_wwmt = true
						ww_scene_lods = wwmt
					)		
					
					if (wwToolsFloater == undefined ) AND openWWMT == true then (
						

						
						macros.run "wallworm.com" "WallWormModelToolsMCR"
						
					)
				

					global wwToolsFloater
					if wwToolsFloater != undefined AND  sendToGlobal then (
						global wallworm_setWWMUI
						wallworm_setWWMUI()
					)
					
					
					
			)
			
			true
		) else (
			false
		)
	)

	
	local mainrollout,hullrollout,propdatarollout,sanitize

	parameters main rollout:mainrollout (

		targets type:#nodeTab  tabSizeVariable:true --ui:listNodes
		proxies type:#nodeTab  tabSizeVariable:true
		bonelist type:#nodeTab tabSizeVariable:true
		hullbonelist type:#nodeTab tabSizeVariable:true
		sequences type:#stringTab tabSizeVariable:true
		alwayscollapse type:#boolean default:false ui:chk_alwayscollapse
		
		lods type:#nodeTab tabSizeVariable:true
		--attachments type:#nodeTab  tabSizeVariable:true
		--bodygroups type:#nodeTab  tabSizeVariable:true
		
		modelName type:#string default:"modelname"  ui:edt_ModelName
		locked type:#boolean default:false ui:chk_lockQC
		modelPath type:#string default:"" ui:edt1_modelPath
		materialPath type:#string default:"" ui:edt2_materialFolder
		surfaceprop type:#string default:"" ui:ddl_surfaceprop
		staticprop type:#boolean default:false ui:chk_staticprop
		opaque type:#boolean default:false ui:chk_opaque
		mostlyopaque type:#boolean default:unsupplied ui:chk_mostlyopaque

		mscale type:#float default:1.0 ui:spn_scale
		useLocalOrigin type:#boolean default:true ui:chk_localOrigin
		internalOrigin type:#boolean default:true ui:chkInternalOrigin
		rotateRefsystem type:#boolean default:true ui:chkRotateOrigin
		lockInitialOrigin type:#boolean default:false ui:chk_lock_origin
		altOrigin type:#boolean default:false ui:chk_altOrigin


		shaderType type:#string ui:ddl_shader default:"VertexLitGeneric"
		mapChannel type:#integer default:0 ui:spn_mapChannel 
		compression type:#string default:"DXT5" ui:ddl_compression
		normalMethod type:#integer default:3 ui:ddlNormals
		
		on modelname set val do (
			getNode()
			if thisNode != undefined AND classof thisNode.baseobject == Text then (
				thisNode.baseobject.text = ("WWMT: "+ val)
			)
		)
		
		on mapChannel set val do (
			if wwmt != undefined then (
				wwmt.mapChannel = mapChannel
			)
		)


	)

	parameters otherParams rollout:otherParamsRollout (
		ambientboost type:#boolean default:false ui:chk_ambientboost
		constantdirectionallight type:#float ui:spn_constantdirectionallight	
		illumorigin type:#node ui:illumpickbuton
		morphasvta type:#boolean default:true ui:chk_morphasvta
		cam type:#node
		camMode type:#boolean default:false
		
	)
	

	parameters hullparams rollout:hullrollout (
		hulls type:#nodeTab  tabSizeVariable:true
		massorigin type:#node ui:pckMassOrigin
		autoHull type:#boolean default:false ui:chk_autoHull
		mass type:#float default:unsupplied ui:spn_mass
		automass type:#boolean default:false ui:chk_automass
		concave type:#boolean default:unsupplied ui:chk_concave
		contents type:#string default:"solid" --ui:ddl_contents
		inertia type:#float default:unsupplied ui:spn_inertia
		damping type:#float default:unsupplied ui:spn_Damping
		rotDamping type:#float default:unsupplied ui:spn_rotDamping
		jointConstraints type:#boolean default:unsupplied ui:chk_jointrestrain
		phdrag type:#float default:unsupplied ui:spn_phdrag
		animatedfriction  type:#string default:"" ui:edt_animatedfriction
		noselfcollisions type:#boolean default:false ui:chk_noselfcollisions
		
		
		on autoHull set val do (
			hullrollout.listHulls.enabled=(NOT autoHull)	
		)
		
		on automass set val do (
			hullrollout.spn_mass.enabled=(NOT automass)	
		)
		on concave set val do (
			if wwmt != undefined then (
				wwmt.concave = concave
			)
		)

	)
	
	
	
	parameters propdataparams rollout:propdatarollout (
		gibs type:#nodeTab  tabSizeVariable:true
		base type:#string default:""  ui:ddl_base
		health type:#integer ui:spn_health default:unsupplied
		allowstatic type:#boolean ui:chk_allowstatic  default:unsupplied
		
		physicsmode type:#integer  default:1 ui:ddl_physicsmode
		multiplayer_break type:#string default:"client" --ui:ddl_multiplayer_break
		breakable_model type:#string default:"" --ui:ddl_breakable_model
		
		
		blockLOS type:#boolean ui:chk_blockLOS
		AIWalkable type:#boolean ui:chk_AIWalkable
		dmg_bullets type:#float ui:spn_dmg_bullets default:0.0
		dmg_club type:#float ui:spn_dmg_club default:0.0
		dmg_explosive type:#float ui:spn_dmg_explosive default:0.0
		ignite type:#boolean ui:chk_ignite default:unsupplied
		explosive_resist type:#boolean ui:chk_explosive_resist  default:unsupplied
		flammable type:#boolean ui:chk_flammable  default:unsupplied
		explosive_damage type:#float ui:spn_explosive_damage default:unsupplied

		breakable_count type:#integer ui:spn_breakable_count default:unsupplied
		breakable_skin type:#integer ui:spn_breakable_skin default:0

		explosive_radius type:#integer ui:spn_explosive_radius default:unsupplied
		fadetime type:#integer default:15 ui:spn_fadetime
		motiondisabled type:#boolean ui:chk_motiondisabled default:false
		

		on breakable_model set val do (
			
			propdatarollout.btn_compileGibsVTFs.enabled = (breakable_model=="CustomGibs")
			propdatarollout.btn_compileGibs.enabled = (breakable_model=="CustomGibs")
			propdatarollout.cmb_gibslist.enabled = (breakable_model=="CustomGibs")
			propdatarollout.btn_removeGibs.enabled = (breakable_model=="CustomGibs")
			propdatarollout.btn_custGibs.enabled = (breakable_model=="CustomGibs")
			
		)
		
	/*
		on multiplayer_break set val do (
			if multiplayer_break != unsupplied AND multiplayer_break != undefined  then (
				--propdatarollout.ddl_multiplayer_break.selection = findItem propdatarollout.ddl_multiplayer_break.items multiplayer_break
			)

		)
*/


	)
	
	
	parameters vmfparams rollout:vmfparamsrollout (
		exclude_vmf type:#boolean ui:chk_exclude_vmf default:false
		skybox type:#boolean ui:chk_skybox default:false
		
		on exclude_vmf set val do (
			
			getNode()
			if thisNode != undefined then (
				setUserProp thisNode "wallworm_exclude_vmf" exclude_vmf
			)
		)
			
		on skybox set val do (
			getNode()
			if thisNode != undefined then (
				setUserProp thisNode "wwdt_skybox_export" skybox
			)
		)

	)
	
	

	
	function updateWWMTFromThis = (
		
		getWWMT()
		if wwmt != undefined then (
			
			/*nodeTabs*/
			wwmt.targets = targets as array
			wwmt.proxies = proxies as array
			wwmt.hulls = hulls as array
			wwmt.gibs = gibs as array
			wwmt.lods = #()
			
			if lods.count > 0 then (
				for l in lods WHERE isValidNode l do (
					local ld = l.get_lod refresh:true
					if ld != undefined then (
						append wwmt.lods ld
					)
				)
			)
			
			
			/*Nodes*/
			wwmt.massorigin = massorigin
			wwmt.illumorigin = illumorigin
			wwmt.cam = cam
			
			/*Other Params*/
			
			wwmt.autoHull = autoHull
			wwmt.mass = mass
			wwmt.automass = automass
			wwmt.concave = concave
			wwmt.contents = contents
			wwmt.inertia = inertia
			wwmt.damping = damping
			wwmt.rotDamping = rotDamping
			wwmt.jointConstraints = jointConstraints
			wwmt.phdrag = phdrag
			wwmt.animatedfriction = animatedfriction
			wwmt.noselfcollisions = noselfcollisions

			wwmt.normalMethod = normalMethod
			wwmt.compression = compression
			wwmt.mapChannel = mapChannel
			wwmt.shaderType = shaderType
			wwmt.morphasvta = morphasvta
			wwmt.camMode = camMode
			wwmt.cam = cam
			wwmt.altOrigin = altOrigin
			wwmt.lockInitialOrigin = lockInitialOrigin
			wwmt.rotateRefsystem = rotateRefsystem
			wwmt.internalOrigin = internalOrigin
			
			
			
			wwmt.modelName = modelName
			wwmt.locked = locked
			wwmt.modelPath = modelPath
			wwmt.materialPath = materialPath
			wwmt.concave = concave
			wwmt.contents = contents
			wwmt.surfaceprop = surfaceprop
			wwmt.staticprop = staticprop
			wwmt.opaque = opaque
			wwmt.mostlyopaque = mostlyopaque

			wwmt.mscale = mscale
			wwmt.useLocalOrigin = useLocalOrigin
			
			
			wwmt.ambientboost = ambientboost
			wwmt.constantdirectionallight = constantdirectionallight



			wwmt.dmg_bullets = dmg_bullets
			wwmt.AIWalkable = AIWalkable
			wwmt.blockLOS = blockLOS
			wwmt.physicsmode = physicsmode
			wwmt.allowstatic = allowstatic
			wwmt.health = health
			wwmt.base = base
			wwmt.dmg_club = dmg_club
			wwmt.dmg_explosive = dmg_explosive
			wwmt.ignite = ignite
			wwmt.explosive_resist = explosive_resist
			wwmt.flammable = flammable
			wwmt.explosive_damage = explosive_damage
			wwmt.breakable_model = breakable_model
			wwmt.breakable_count = breakable_count
			wwmt.breakable_skin = breakable_skin
			wwmt.multiplayer_break = multiplayer_break
			wwmt.explosive_radius = explosive_radius
			wwmt.fadetime = fadetime
			wwmt.motiondisabled = motiondisabled
			wwmt.alwayscollapse = alwayscollapse
		)
		
	)
	
	function sanitize = (
		tc = targets.count
		if tc > 0 then (
			targets = for t in targets WHERE isValidNode t collect t
		)
		
		tc = hulls.count
		if tc > 0 then (
			hulls = for t in hulls WHERE isValidNode t collect t
		)
		tc = gibs.count
		if tc > 0 then (
			gibs = for t in gibs WHERE isValidNode t collect t
		)
		
		

		
		tc = lods.count
		if tc > 0 then (
			lods = for t in lods WHERE isValidNode t collect t
		)
		
		getWWMT()		
		
		if wwmt != undefined then (
			wwmt.targets = targets as array
			wwmt.hulls = hulls as array
			wwmt.gibs = gibs as array
		)
		
	)
	
	function updateNames = (
		mainrollout.listNodes.items = for obj in targets WHERE obj != undefined AND isValidNode obj collect obj.name
	)
	function updateHullListNames = (
		hullrollout.listHulls.items = for obj in hulls WHERE obj != undefined AND isValidNode obj collect obj.name	
	)
	
	function updateSurfacePropselection = (
			if findItem mainrollout.ddl_surfaceprop.items surfaceprop == 0 then (
				templ = mainrollout.ddl_surfaceprop.items
				append templ surfaceprop
				sort templ
				mainrollout.ddl_surfaceprop.items = templ
			)
			mainrollout.ddl_surfaceprop.selection = findItem mainrollout.ddl_surfaceprop.items surfaceprop
	)

	
	
	function updateModelPathselection = (
			if findItem mainrollout.edt1_modelPath.items modelPath == 0 then (
				templ = mainrollout.edt1_modelPath.items
				append templ modelPath
				sort templ
				mainrollout.edt1_modelPath.items = templ
			)
			mainrollout.edt1_modelPath.selection = findItem mainrollout.edt1_modelPath.items modelPath
	)
	

	function updateMaterialPathselection = (
		
			if findItem mainrollout.edt2_materialFolder.items materialPath == 0 then (
				
				templ = mainrollout.edt2_materialFolder.items
				append templ materialPath
				sort templ
				mainrollout.edt2_materialFolder.items = templ
			)
			mainrollout.edt2_materialFolder.selection = findItem mainrollout.edt2_materialFolder.items materialPath
	)
	
	function allowed_wwmt_obj obj = (((superclassof obj == GeometryClass OR (superclassof obj == shape AND isProperty obj "render_useViewportSettings" AND obj.render_useViewportSettings == true)) AND (NOT (isproperty obj "ww_displacement_brush")) AND (NOT (isproperty obj "ww_displacement")) AND (NOT (isProperty obj "wallworm_edit_mesh")) AND ( getUserProp obj "wwdt_brush_geometry_export"==undefined  OR getUserProp obj "wwdt_brush_geometry_export"==false ) AND (NOT isProperty obj "isWorldGeometry" OR ( obj.isWorldGeometry==false)))  AND findItem targets obj == 0  AND findItem (#("Convexity Walls","Convexity Floors","Convexity Library Shapes")) obj.layer.name == 0)

	rollout mainrollout "WWMT Functions" (
		pickbutton addModel "+"  across:4 toolTip:"Add Meshes to the WWMT Helper." filter:allowed_wwmt_obj
		button btn_removeSelFromTargets "-"  toolTip:"Remove selected objects from the model." offset:[-10,0]
		button btnShowModel "Show"  toolTip:"Unhide the model if it is hidden." offset:[-10,0]
		button btnHideModel "Hide"  toolTip:"Hide the model."
		listbox listNodes "Meshes"	 height:3
		combobox ddl_surfaceprop "Surface Property" items:#(surfaceprop) height:3

		button btn15 "Dir"  toolTip:"Open the folder where the final MDL files get compiled." across:4
		button btn48 "QC"  toolTip:"Open the QC file in Notepad." offset:[-3,0]
		button btnCust "QCI"  toolTip:"Open the custom QCI file in Notepad." offset:[-3,0]
		button btn_open_model_folder "Mdlsrc"  toolTip:"Click here to open the model folder."
		label lbl1 "Model Folder Path" align:#left toolTip:"Enter a path that is relative to the Mod's Model folder."
		combobox edt1_modelPath ""  toolTip:"Enter the folder path relative to the SDK model folder without starting or ending slashes." items:#(modelPath) height:3

		
		button btn31 "VMT Dir"  toolTip:"Open the folder where the final VMTs for this model export to."  across:2	
		button btn_open_mat_folder "Raw"  toolTip:"Click here to open the material folder."
		label lbl2 "Material Folder Path" align:#left toolTip:"Enter a path that is relative to the Mod's Material folder."
		combobox edt2_materialFolder ""  toolTip:"Enter the folder path relative to the SDK material folder without starting or ending slashes."   items:#(materialPath) height:3

	  

		checkbox chk_staticprop "$staticprop"  toolTip:"Check here is this is a static prop with no animations."
		checkbox chk_alwayscollapse "$alwayscollapse Mesh Nodes" tooltip:"Always collapse the mesh nodes. This will reduce overhead if you are using a skinned model."
		checkbox chk_opaque "$opaque"  toolTip:"Check this to tell the compiler this is an opaque model. Also forces VMTs for this model to exclude any translucency if your WWMT Settings force this."
		checkbox chk_mostlyopaque "$mostlyopaque"
		
		label lbl3 "Sky Scales" across:3
		button btn_setSkyScale "1/16"  toolTip:"Set to Skybox Scale ( 1/16 )"
		button btn_setSkyScale2 "1/32"  toolTip:"Set to L4D Skybox Scale ( 1/32 )"
		spinner spn_scale "Model Scale" range:[0.01,100,1] scale:0.1	

		pickbutton btn_illum "Illumination" images:#("$scripts\Wallworm.com\assets\wwmt_illum_icon_buttons.png", undefined, 2, 1, 1, 2, 1, false) toolTip:"Click Here to select the Illumination Origin"
		

		
		
		checkbox chk_localOrigin "Use Local Origin" offset:[0,20] toolTip:"Click here if you want the origin of the model's world set to the model's origin. This might be necessary if you are creating models inside of scenes instead of their own files."
		checkbox chk_lock_origin  "Lock Origin State"  toolTip:"Check this option if the root node is animated in its own space."
		checkbox chkInternalOrigin "Calculate Origin in SMD"   toolTip:"When on, the Origin is calculated in the SMD. When off, calculated in the QC. Some mods do not compile the QC $origin anymore. Also, this option only works with the WW SMD Exporter."
		checkbox chkRotateOrigin "Rotate Origin" across:2  toolTip:"Rotate the Z-Axis of the model so that it exports in same system as the Max world (and brush geometry). You may want to turn this off with some animated models."
		checkbox chk_altOrigin "Flip"  toolTip:"Click here if the model should be flipped (mirrored)." offset:[20,0]
		HyperLink custAltHelp "Origin Offset" address:"http://dev.wallworm.com/document/56/model__basic_qc_rollout.html#uselocalorigin" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		GroupBox grp_Origin "$origin" height:120 width:146	offset:[-6,-120]


		spinner spn_mapChannel "Map Channel"  range:[-1,99,1] type:#integer scale:1 toolTip:"Enter the UVW Mapping Channel to use at export or 0 for fast auto detect from diffuse bitmap or -1 for slower but possibly more accurate auto-detect. Only available if using the WWMT SMD Exporter. Otherwise, only channel one is used."
		dropdownList ddlNormals "Normals"  items:#("Face Render Normals", "Explicit Normals", "Auto") toolTip:"Choose the method for determining vertex normals. Defaults to Face Render Normals. But you can also choose other options."
		label mdlenamelabel "Model Name" align:#left toolTip:"Enter the name for this model (only use letters, numbers and underscore. Avoid spaces, periods or any special characters)."
		edittext edt_modelName ""  
		button exportWWMT "Export QC & Model" tooltip:"Run the Exporter"			
		checkbox chk_lockQC "Lock QC"  toolTip:"Click here if you do not want to overwrite the QC for this model after it has been generated. When locked, the export process will only overwrite SMDs when you export."

		
		
		group "Materials" (
			
			dropdownList ddl_shader ""  items:#("VertexLitGeneric", "UnlitGeneric") selection:(findItem ddl_shader.items shaderType)
			dropdownList ddl_compression "Compression"  items:#("", "DXT5", "nocompress") selection:(findItem ddl_compression.items compression)
			button btn_tex "Export VMT and VTF"  toolTip:"Click here to compile the textures in your model to VMTs and VTFs."
		
		)
		
		button btn_upenwwmt "Send to WWMT UI" 
		
		on btn_upenwwmt pressed do (
			updateWWMTGUIFromWWMT openWWMT:true sendToGlobal:true
		)

		
		on listNodes rightClick sel do (
			select (targets[listNodes.selection])
		)
		on listNodes selected sel do (
			nds = #(targets[listNodes.selection])
			flashNodes nds
			forceCompleteredraw()
		)

		on btnShowModel pressed do (
			unhide (targets as array)
		)
		on btnHideModel pressed do (
			hide (targets as array)
		)
			
			
		on btn15 pressed do
		(
		

			local m = ""


			if modelPath != "" then (
				m = wwmt.FsToBs modelPath
			) else (
				global wwmt_def_model_path
				m = wwmt.FsToBs wwmt_def_model_path
			)

			global wwmt_gameInfoDir
			wwDir = wwmt_gameInfoDir + "\\models\\"+m		
		
			try (
				if doesFileExist wwDir == false then (
					makeDir wwDir all:true
				)
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
			) catch(
				
					print (getCurrentException())
				
			)
		
		)
		on btn31 pressed do
		(
		
		
			local m = ""
			global wwmt_def_material_path

				
			if materialPath != "" then (
				m = wwmt.FsToBs materialPath
			) else (
				m = wwmt.FsToBs wwmt_def_material_path
			)
			global wwmt_gameInfoDir
			wwDir = wwmt_gameInfoDir + "\\materials\\"+m		

			try (
				if doesFileExist wwDir == false then (
					makeDir (wwDir all:true)
				)
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
			) catch()
			
				
		)
		on btn48 pressed do
		(
			global wallworm_text_editor
			if wallworm_text_editor == undefined then (
				wallworm_text_editor = "notepad.exe"
			)
		
			local m = ""


			if modelPath != "" then (
				m = wwmt.FsToBs modelPath
			) else(
				
				m = wwmt.FsToBs wwmt_def_model_path
			)
			if m == undefined do (
				m = ""
			)
			global wwmt_export
			wwDir = wwmt_export + "\\"+m+"\\"+modelName+".qc"	
				

			if doesFileExist wwDir == true then (
				folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+wwDir+"\""
				execute folderOpen
			) else (
				
				messagebox "Oops... the QC doesn't exist yet. Export the model first."
			)
		)
		
		on btnCust pressed do
		(
			
			
			global wallworm_text_editor
			if wallworm_text_editor == undefined then (
				wallworm_text_editor = "notepad.exe"
			)
		
			local m = ""


			if modelPath != "" then (
				m = wwmt.FsToBs modelPath
			) else(
				
				m = wwmt.FsToBs wwmt_def_model_path
			)
			if m == undefined do (
				m = ""
			)
			global wwmt_export
			wwDir = wwmt_export + "\\"+m+"\\"+modelName+"_wwmt_custom.qci"	
		
			if doesFileExist wwDir == false then (
				
				wwmt.createCustomQCI()
				
			)

			if doesFileExist wwDir == true then (
				folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+wwDir+"\""
				execute folderOpen
			) else (
				
				messagebox "Oops... the QCI doesn't exist yet and WWMT can only create/edit it once the model name has been set."
			)
		)
		
		on btn_open_model_folder pressed do (
			local m = ""
			if modelPath != "" then (
				m = wwmt.FsToBs modelPath
			) else(
				global wwmt_def_model_path
				m = wwmt.FsToBs wwmt_def_model_path
			)
			global wwmt_export
			wwDir = wwmt_export + "\\"+m		
			try (
				if doesFileExist wwDir == false then (
					makeDir (wwDir all:true)
				)
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
			) catch()

		)
		
		on btn_open_mat_folder pressed do (
		
			local m = ""


			if materialPath != "" then (
				m = wwmt.FsToBs materialPath
			) else (
				global wwmt_def_material_path
				m = wwmt.FsToBs wwmt_def_material_path
			)

			global wwmt_exportMats
			wwDir = wwmt_exportMats + "\\"+m		
			if m == undefined do (
					m = ""
			)
			try (
				
				if doesFileExist wwDir == false then (
					makeDir (wwDir all:true)
				)
				
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
			) catch()
				
				
		)
			
			
			
		on btn_tex pressed do (
				ers = wwmt.checkForProblems()
				if ers.count == 0 then (
					global ww_scene_lods
					if ww_scene_lods != wwmt then (
						global wwToolsFloater
						if wwToolsFloater != undefined then (
							try(closeRolloutFloater  wwToolsFloater)catch()							
						)
						ww_scene_lods = wwmt
					)
					
					fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\textureExport.ms"
				) else (
					message = "There were problems you need to address:\n\n"
					for em in ers do (
						
						append message ("\t* "+em+"\n")
					)
					messageBox message
				)
		)
		
		

		on ddl_compression selected sel do (
			compression = ddl_compression.selected
			if wwmt == undefined then getWWMT()
			wwmt.compression = compression
		)
		
		on ddl_shader selected sel do (
			shaderType = ddl_shader.selected
			if wwmt == undefined then getWWMT()
			wwmt.shaderType = shaderType
		)
		
		on btn_setSkyScale pressed do
		(
				
			spn_scale.value = 0.0625
			if wwmt == undefined then getWWMT()
			wwmt.setScale(spn_scale.value)	
				
		)
		on btn_setSkyScale2 pressed do
		(
				
			spn_scale.value = 0.03125
			if wwmt == undefined then getWWMT()
			wwmt.setScale(spn_scale.value)	
				
		)
		on mainrollout open do (
			sanitize()
			getWWMT()
			updateNames()
			global wwmt_surfaceprop_list
			if wwmt_surfaceprop_list != undefined then (
				
				if findItem wwmt_surfaceprop_list surfaceprop == 0 then (
					append wwmt_surfaceprop_list surfaceprop
					sort wwmt_surfaceprop_list

				)
				ddl_surfaceprop.items = wwmt_surfaceprop_list
			)
			updateSurfacePropselection()
			
			global wwmt_current_model_Paths
			

			if wwmt_current_model_Paths != undefined then (
				
				if findItem wwmt_current_model_Paths modelPath == 0 then (
					append wwmt_current_model_Paths modelPath
					sort wwmt_current_model_Paths

				)
				edt1_modelPath.items = wwmt_current_model_Paths
			)
			
			updateModelPathselection()
			
			global wwmt_current_material_Paths
			

			if wwmt_current_material_Paths != undefined then (
				
				if findItem wwmt_current_material_Paths materialPath == 0 then (
					append wwmt_current_material_Paths materialPath
					sort wwmt_current_material_Paths

				)
				edt2_materialFolder.items = wwmt_current_material_Paths
			)
			
			updateMaterialPathselection()
			
			
			
		)
		
		
		on addModel picked obj do (
			wwmt.addObjToObjects obj
			updateNames()
		)
		
		on btn_removeSelFromTargets pressed do
		(
			if listNodes.selection > 0 then (
				wwmt.removeItemsFromTargets targets[listNodes.selection]
				updateNames()
			)
		)
		
		
		on exportWWMT pressed do (
			getWWMT()
			if wwmt != undefined then (
				sanitize()
				updateWWMTFromThis()
				wwmt.outputModelQC()		
			) else (
				messagebox "The model could not export. Perhaps WWMT is not installed."
			)
		)
		
	on ddl_surfaceprop selected sel do (
		
		surfaceprop = ddl_surfaceprop.selected
		if wwmt == undefined then getWWMT()
		wwmt.surfaceprop = surfaceprop
	)
	on ddl_surfaceprop entered tex do (
		
		surfaceprop = tex
		if wwmt == undefined then getWWMT()
		wwmt.surfaceprop = surfaceprop
		updateSurfacePropselection()
	)

	on edt2_materialFolder selected sel do (
		materialPath = edt2_materialFolder.selected
		if wwmt == undefined then getWWMT()
		wwmt.materialPath = materialPath
	)
	on edt2_materialFolder entered tex do (
		materialPath = tex
		if wwmt == undefined then getWWMT()
		wwmt.materialPath = materialPath
		updateMaterialPathselection()
	)
	
	on edt1_modelPath selected sel do (
		modelPath = edt1_modelPath.selected
		if wwmt == undefined then getWWMT()
		wwmt.modelPath = modelPath
	)
	on edt1_modelPath entered tex do (
		modelPath = tex
		wwmt.modelPath = modelPath
		if wwmt == undefined then getWWMT()
		updateMaterialPathselection()
	)
	
	
	)
	

	
	rollout hullrollout "Collision Model" (
		group  "Hull Options"  (
			checkbox chk_autoHull "Auto Hull"  toolTip:"Use the root model SMD for generating a Collision Hull. Should not be used with animated models." align:#right
			listbox listHulls "Hulls" items:(for obj in hulls WHERE obj != undefined AND isValidNode obj collect obj.name) enabled:(NOT autoHull) offset:[0,-20]
			pickbutton addPhys "+" toolTip:"Pick a collision model you have already made for this model." across:3 align:#left width: 20
			button btn_deleteHulls "-"  toolTip:"Remove Selected Items from the Collision Hull List of this model."  align:#left width: 20 offset:[-20,0]
			button createPhys "Quick Hull"   offset:[-40,0]  align:#left toolTip:"Create a Collision Model from the model. This will automatically make a convex mesh for each element of the picked object. If there is only one element, the collision model may not be very realistic." 
			spinner spn_max_verts "Max Verts Hulls" type:#integer scale:1 toolTip:"Maximum vertices per hull in generated hull." default:44 range:[4,4096,44]
			label grp1 "Hull Count" across:3
			label lbl_hullcount "?" 
			button btn_update_count "^"  toolTip:"Press to update the Hull Count."
		)
		
		
		on listHulls rightClick sel do (
			select (hulls[listHulls.selection])
		)
		on listHulls selected sel do (
			nds = #(hulls[listHulls.selection])
			flashNodes nds
			forceCompleteredraw()
		)
		
			
		on btn_deleteHulls pressed do
		(
			if listHulls.selection != 0 then (
				deleteItem hulls listHulls.selection
				if wwmt == undefined then getWWMT()
				wwmt.hulls = hulls as array
				updateHullListNames()
			)
		)
		on addPhys picked obj do
		(
			if wwmt == undefined then getWWMT()
			if (wwmt.addPhysModel obj ) then (
				
				--wwmt.setHullNameChangeHandler()

			) else (
				messagebox "The action failed. Do not use Grouped geometry."
			)
			updateHullListNames()
		)
		on createPhys pressed do
		(
			if wwmt == undefined then getWWMT()
			if (wwmt.createHull maxVerts:spn_max_verts.value) == true then (
				autoHull = false		
				if wwmt.hulls.count > 1 OR wwmt.concave == true do (
					concave = true
				)

				updateHullListNames()
				
				getNode()
				select thisNode
				
			) else (
					messagebox "There was a problem:\n\n The Wall Worm Hull Helper only works if you have either:\n\n *The nVidia PhysX Plugin or MassFX (Integrated into 3ds Max 2013+)\n*Convexity 1.17+.\n\nIf you meet one of these requirements, please submit a bug report.\n\n*Unfortunately, some versions of PhysX/MassFX have broken the hull function."
			)
		)
				
		on btn_update_count pressed do
		(
			
			
			if NOT autoHull  then (
				try (
				
					local hullcount = 0
				
					if hulls.count > 0 then (
				

						if concave == true then (
							hullcount = wwmt_count_hulls wwmt.hulls concave
						) else (
							hullcount = 1
						)
				) else (
					hullcount = 0
					)
					
					
					if hullcount != undefined AND hullcount <= 20 then (
						--wwToolsFloater.rollouts[2].ddl_hullcount.enabled = false
							if hullcount == 0 do (
								 hullcount = "0"
								)
							lbl_hullcount.caption = ((hullcount as string))
						) else(
						--wwToolsFloater.rollouts[2].ddl_hullcount.enabled = true
							lbl_hullcount.caption = ((hullcount as string)	+"!")
						)
					
					
					
					
					
					
					
				) catch (
					messagebox "There was a problem. Fress F11 for more details."
					print (getCurrentException())
				)
			) else (
				messagebox "This function only works when Auto Hull is not checked; you have to create your own hulls or use the Quick Hull or Adv Hull functions."
			)
			
			
			
		)


	
		checkbox chk_concave "$concave"
		
		group "Physical Properties" (
			pickbutton pckMassOrigin "Mass Origin"
			spinner spn_mass "Mass"  toolTip:"Set a value for the mass of this object. This value will not be used if $automass is checked." width:100 across:2 enabled:(NOT automass)
			checkbox chk_automass "Auto"  toolTip:"Calculate mass of object based on volume and the type of material defined by Surface Property. This will override values entered into the mass field." align:#right
			
			dropdownList ddl_contents "Contents"  items:#("solid", "notsolid", "monster", "ladder", "grate") selection:(findItem ddl_contents.items contents)
			spinner spn_rotDamping "Rot Damping"  
			spinner spn_inertia "Inertia"  range:[0,1e+009,1] toolTip:"Inertial Scale"
			spinner spn_Damping "Damping"  range:[0,1e+009,1] toolTip:"Damping Scale"
			spinner spn_phdrag "Drag"  range:[0,1e+009,1] toolTip:"Drag Scale"
		)

		group "Advanced" (
			checkbox chk_jointrestrain "$jointconstrain"   toolTip:"Add $jointconstrain limits to the joints of this model based off of the bone IK info"
			checkbox chk_noselfcollisions "No Self Collisions"  toolTip:"Do not allow collision hulls in same model collide with each other."
			label anfrlabel "Animated Friction" tooltip:"<float|FrictionTimeIn> <float|FrictionTimeOut> <float|FrictionTimeHold> <float|MinAnimatedFriction> <float|MaxAnimatedFriction> Used to animate the amount of friction on joints over time.  "
			editText edt_animatedfriction ""  
		)
		group "Functions" (
			button btn_SelectHulls "Select Collision Hulls"  toolTip:"Select in viewport all meshes belonging to the collision hull."
			button btnHideCM "Hide CM"  toolTip:"Hide all meshes belonging to the collision hull." across:2
			button btnShowCM "Show CM"  toolTip:"Unhide all meshes belonging to the collision hull."
			button btn_processCM "Process CM"  toolTip:"Click here to give each element in the Hull a unique smoothing group."
			button btn_hull_helper "WW Hull Helper"  toolTip:"Open the Hull Helper Utility Floater; provides tools for quickly and efficiently making complex hulls from your meshes."
			

		)

		on ddl_contents selected sel do (
			contents = ddl_contents.selected
		)
		

		on hullrollout open do (
			updateHullListNames()
		)
		
		
		on btnHideCM pressed do (
			hide (hulls as array)
		)
		
		on btnShowCM pressed do (
			unhide (hulls as array)
		)
		
		on btn_SelectHulls pressed do (
			select (hulls as array)
		)
		
		on btn_hull_helper pressed do (
			macros.run "wallworm.com" "WallWormHullHelperMCR"
		)
		
	)

	
	rollout propdatarollout "Prop Data & Gibs" (
		HyperLink hyperlinkgibs "Prop Data Help" align:#right address:"http://dev.wallworm.com/topic/28/prop_data_and_custom_gibs.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		combobox ddl_base "Base" offset:[0,-20] items:#("", "Cardboard.Small", "Cardboard.Medium", "Cardboard.Large", "Cardboard.break", "Cardboard.Indestructable", "Cardboard.breakclient", "Cloth.Small", "Cloth.Medium", "Cloth.Large", "Cloth.Object", "Flesh.Tiny", "Flesh.Small", "Glass.Small", "Glass.Window", "Glass.picture", "Glass.CSWindow", "Glass.CSWindow2", "Glass.WindowStrong", "Item.Small", "Item.Medium", "Item.Large", "Door.Standard", "Metal.Small", "Metal.Medium", "Metal.Large", "Metal.break", "Metal.break2", "Metal.MediumClient", "Wooden.Tiny", "Wooden.Small", "Wooden.chair", "Wooden.MediumNobreak", "Wooden.Large", "Wooden.Huge", "Wooden.sticks", "Wooden.Barrel", "Wooden.Small2", "Wooden.Barrel2", "Metal.Large", "Plastic.Small", "Plastic.Medium", "Plastic.Large", "Plastic.break", "PlasticSmall.break", "Plastic.Small2", "Pottery.Small", "Pottery.Medium", "Pottery.Large", "Pottery.Huge", "Pottery.break", "Pottery.Plant", "Pottery.break2", "Pottery.PlantBreak", "Stone.Small", "Stone.Medium", "Stone.Large", "Stone.Huge", "Stone.Gigantic", "Wooden.Tiny", "Wooden.Small", "Wooden.Medium", "Wooden.Large", "Wooden.ExtraLarge", "Wooden.Huge")
		spinner spn_health "Health" range:[0,10000,0] type:#integer scale:1
		checkbox chk_allowstatic "Allow Static "
		dropdownList ddl_physicsmode "Physics Mode"  items:#("Auto", "Solid, pushes the player away.", "Non-solid, but gets pushed away by the player.", "Non-solid, clientside simulated only.")
		checkbox chk_blockLOS "Block Line of Sight" 
		checkbox chk_AIWalkable "AI Walkable" 
		
		Group  "Damage Modifiers" (
			spinner spn_dmg_bullets "dmg.bullet" range:[0,10000,1] 
			spinner spn_dmg_club "dmg.club" range:[0,100,1]
			spinner spn_dmg_explosive "dmg.explosive"  range:[0,10000,1]
		)
		
		Group  "Flammable Prop" (
			checkbox chk_ignite "Ignite"  
			
			checkbox chk_explosive_resist "Explosive Resist" 
			
			checkbox chk_flammable "Flammable" 
		)
		Group  "Exploding Prop" (
		
			spinner spn_explosive_damage "Exp. Dmg" range:[0,10000,0] 
			
			spinner spn_explosive_radius "Exp. Radius" range:[0,10000,0]
		
		)

		dropdownList ddl_multiplayer_break "Multiplayer Break"  items:#("client", "server", "both") --selection:(ddl_multiplayer_break.items[(findItem ddl_multiplayer_break.items multiplayer_break)])
		checkbox chk_motiondisabled "motiondisabled" tooltip:"To spawn non-moving gibs (in some mods)."
		group "Gibs Settings" (
			dropdownList ddl_breakable_model "Gibs Model Class"  items:#("", "WoodChunks", "GlassChunks", "ConcreteChunks", "MetalChunks", "CustomGibs") --selection:(findItem ddl_breakable_model.items breakable_model)
			spinner spn_breakable_count "Count"  type:#integer scale:1
			spinner spn_breakable_skin "Skin #"  type:#integer scale:1			
			spinner spn_fadetime "Fade Time" range:[0,10000,0] type:#integer scale:1
			pickbutton btn_custGibs "+" toolTip:"Click here to selected a mesh as Gibs models for this model." enabled:(breakable_model=="CustomGibs") across:2 align:#left
			button btn_removeGibs "Remove Selected" toolTip:"Click to remove all selected items from the gibs list for this model." enabled:(breakable_model=="CustomGibs") offset:[-20,0] 
			combobox cmb_gibslist "Custom Gibs List" enabled:(breakable_model=="CustomGibs") items:(for obj in gibs collect obj.name) 
			button btn_compileGibs "Compile Gibs" toolTip:"Click here to compile all gibs models." enabled:(breakable_model=="CustomGibs")
			button btn_compileGibsVTFs "Compile Gibs VTFs" toolTip:"Click here to compile all textures belonging to gibs." enabled:(breakable_model=="CustomGibs")
		)
		
		on btn_compileGibs pressed  do (
			
			if gibs.count > 0 then (
				wwmt.gibs = gibs as array
				wwmt.exportGibs()
				select (getNode())
			) else (
				messagebox "There are no CustomGibs models assigned."
			)
		)
		
		
		on btn_custGibs picked obj do (
			wwmt.addGibs (#(obj))
			cmb_gibslist.items = (for obj in gibs collect obj.name)
		)
		
		on btn_removeGibs pressed do (
			deleteItem gibs cmb_gibslist.selection
			wwmt.gibs = gibs as array
			cmb_gibslist.items = (for obj in gibs collect obj.name)
		)
		
		
		
		on ddl_breakable_model selected sel do (
			breakable_model = ddl_breakable_model.selected
			
			cmb_gibslist.enabled = (breakable_model=="CustomGibs") 
			
		)

		on ddl_multiplayer_break selected sel do (
			multiplayer_break = ddl_multiplayer_break.selected
		)
		
		on ddl_physicsmode selected sel do (
			physicsmode = sel
		)
		
		on ddl_base selected arg do (
			base = ddl_base.selected
		)
		
		function addToBase = (
			if findItem ddl_base.items base == 0 then (
				oldItems = ddl_base.items
				append oldItems base
				ddl_base.items = oldItems
			)
			ddl_base.selection =  findItem ddl_base.items base
		)
		on ddl_base entered tex do (
			base = tex
			addToBase()
		)
			
		on propdatarollout open do (
			if multiplayer_break != undefined then (
				ddl_multiplayer_break.selection = findItem ddl_multiplayer_break.items multiplayer_break
			)
			if breakable_model != undefined then (
				ddl_breakable_model.selection = findItem ddl_breakable_model.items breakable_model
			)
			if base != undefined then (
				addToBase()
			)
			
		)
		
	)
	
	
	rollout otherParamsRollout "Lighting and Other" (
		checkbox chk_ambientboost "Ambient Boost"
		spinner spn_constantdirectionallight "$constantdirectionallight" width:150 align:#right
		pickbutton illumpickbuton "Illumination Origin"
		checkbutton chk_morphasvta "Morph as VTA"
	)
	
	
	rollout proxrollout "Proxy Functions" (

			
		button addProx "Create Proxy"
		button updateProxies "Update Proxy Meshes"
		button selectAllProxies "Select All Proxies"
		button collectSkins "Collect Skins from Proxies"
		button moreProxTools "More Proxy Tools"

		
		
		on updateProxies pressed do (
			if  wwmt != undefined then (
				wwmt.update_proxies_in_scene()
			) else (
				messagebox "The WWMT struct is missing. Perhaps Wall Worm is not installed correctly."
			)
			
		)
		on addProx pressed do (

			if wwmt != undefined then (
				append proxies (wwmt.createProxy())
			) else (
				messagebox "The WWMT struct is missing. Perhaps Wall Worm is not installed correctly."
			)
		)
		
		on selectAllProxies pressed do (

			if wwmt != undefined then (
				wwmt.getProxies()
				if proxies.count > 0 then (
					select (proxies as array)
				)
			) else (
				messagebox "The WWMT struct is missing. Perhaps Wall Worm is not installed correctly."
			)
		)
		on collectSkins pressed do (

			if wwmt != undefined then (
				wwmt.gatherMySkins()
			) else (
				messagebox "The WWMT struct is missing. Perhaps Wall Worm is not installed correctly."
			)
		)
		
		on moreProxTools pressed do (
			macros.run "wallworm.com" "WallWormModelToolsProxyToolsMCR"
		)
		
		
		
		
	)
	
	rollout vmfparamsrollout "VMF Settings" (
		checkbox chk_exclude_vmf "Exclude from VMF"
		checkbox chk_skybox "Export in Skybox"
	)
	
	
	on update do (
		
		if version < 12 AND lods.count == 0 then (
			getWWMT refresh:true
			if wwmt != undefined then (
				wwmt.getLegacyLODS()
						
				if  wwmt.lods.count > 0 then (
					
					for l in wwmt.lods do (
						l.wrapper = wwmt
						l.setCustomAttributes()
					)
					
					lods = for l in wwmt.lods collect l.helperTape
				)
			
			)
		)
	)

)