/*
Wall Worm Model Tools Source Model Struct
Copyright (c) 2010-2014 by Shawn Olson
http://www.shawnolson.net

A Wall Worm Project
http://www.wallworm.com

*/

fileIn "$scripts/WallWorm.com/common/config.ms"
fileIn "$scripts/WallWorm.com/common/ww_common_funcs.ms"			
fileIn "$scripts/WallWorm.com/WallWormModelTools/Maple3DLayerFns.ms"
fileIn "$scripts/WallWorm.com/common/mse/wallwormSMD.mse"	
fileIn "$scripts/WallWorm.com/common/ww_struct_mat.ms"
fileIn "$scripts/WallWorm.com/common/mse/wallwormHullFuncs.mse"
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_lod.ms"
fileIn "$scripts/WallWorm.com/common/bone_funcs.ms"
fileIn "$scripts\\WallWorm.com\\custom_attributes\\wwmt.ms"		

global wallworm_wwmt_pick_fast
if wallworm_wwmt_pick_fast == undefined then (
	wallworm_wwmt_pick_fast = false
)


function wallworm_allowed_wwmt_obj obj = (
	global wallworm_wwmt_pick_fast
	local sc = superclassof obj
	if wallworm_wwmt_pick_fast then (
		(sc == GeometryClass OR sc == Shape) 
	) else (
		 if (sc == GeometryClass )   then (
			if isProperty obj "wallworm"  then (
				if ( (NOT (isproperty obj "ww_displacement_brush")) AND (NOT (isproperty obj "ww_displacement")) AND (NOT (isProperty obj "wallworm_edit_mesh")) AND ( (NOT classof obj == CorVex) OR ( obj.isWorldGeometry==false))) then (
					true
				) else (
					false
				)
			) else (
				
				if (( getUserProp obj "wwdt_brush_geometry_export"==undefined  OR getUserProp obj "wwdt_brush_geometry_export"==false )) then (

					if findItem (#("Convexity Walls","Convexity Floors","Convexity Library Shapes")) obj.layer.name == 0 then (
						true
					) else (
						false
					)


				) else (
					false	
				)
				
			)
		) else (
			if  sc == Shape AND (isProperty obj "wwmt_ca" OR getUserProp obj "wwmt_source_helper"==true OR (isProperty obj "render_useViewportSettings" AND obj.render_useViewportSettings == true)) then (
				true
			) else (
				false
			)
		)
	)

)

function wwmt_CallbackLODCamMove obj = ()
global wwmt_vertexPercentages = #(75,56.25,42.1875,31.6406,23.73,17.7975,13.348,10.0111,7.5083,5.6312)
--Structs used in the Wall Worm Model Tools MaxScript
Struct ww_LOD_wrapper (
	modelName="modelname",
	isset=false,
	alwayscollapse=false,
	target,
	targets = #(),
	hulls = #(),
	bonesarray = #(),
	hullbonesarray = #(),
	autoHull=false,
	modelSetName,
	physSetName,
	lods=#(),
	locked=false,
	layer,
	phys,
	lodgroup,
	modelPath,
	materialPath,
	surfaceprop,
	staticprop,
	illumposition,
	ambientboost,
	constantdirectionallight,
	opaque,
	mostlyopaque,
	illumorigin,
	mass,
	automass,
	concave,
	contents,
	inertia, 
	damping,
	rotDamping,
	jointConstraints,
	phdrag,
	animatedfriction,
	masscenter,
	massorigin,
	mscale,
	noselfcollisions=false,
    useLocalOrigin,
	refSystem,
	altOrigin=false,
	collapsebones=false,
	shadowlod,
	expHL1Format=0,
	idleSequence = true,
	sequences=#(),
	sequencelist=#(),
	weightlistnames=#(),
	weightlists=#(),
	particlesystems=#(),
	origin,
	bitmaps=#(),
	materials=#(),
	cam,
	camMode=false,
	attachmentlist=#(),
	attachments=#(),
	base="",
	health,
	allowstatic,
	physicsmode,
	blockLOS,
	AIWalkable,
	dmg_bullets,
	dmg_club,
	dmg_explosive,
	ignite,
	explosive_resist,
	flammable,
	explosive_damage,
	breakable_model,
	breakable_count,
	breakable_skin,
	multiplayer_break,
	explosive_radius,
	fadetime=15,
	motiondisabled,
	gibs=#(),
	bodygroups=#(),
	morphasvta=true,
	shaderType = "VertexLitGeneric",
	mapChannel = 1,
	range=#(0),
	compression="DXT5",
	referenceNode = undefined,
	offsetFaces = false,
	lockInitialOrigin = false,
	normalMethod=3,
	internalOrigin = true,
	rotateRefsystem=true,
	alreadyExported=#(),--used to avoid infinite loops
	dmx=false,
	proxies=#(),
	isXref = false,
	
	function makeSequenceListFromCust getFromOld:false= (
		
		global wwmt_sequence		
		if wwmt_sequence == undefined then (
			fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_sequence.ms"
		)


		
		if target.sequences.count > 0 then (
			sequencelist = #()
			sequences = #()
			for seqstr in target.sequences do( 
				try (
				seq = execute seqstr
				append sequences seq
				append sequencelist seq.sequence
				) catch (
					/*Oops... bad sequence*/
				)
			)
		) else if sequencelist.count > 0 AND getFromOld then (
			for word in sequencelist do( 
				s = wwmt_sequence()
				s.sequence = word
				s.getSequenceFromCust target
				append sequences s
			)
		)
		
		
	),
	function setSeqListCust = (
      if isValidNode target do (

			setUserProp target "wwmt_sequencelist"  undefined

			with printAllElements on (
				target.sequences = #()
				
				for s in sequences do (
					
						local sasstr = (s as string)
						append target.sequences sasstr
				)
				
				--print target.sequences
				--target.sequences = sequences as string
			)
		)
		

	),	


	function setWWMTAttribFromThis = (
		if isValidNode target  then (

			if NOT isProperty target "wwmt_ca" then (
				global wallworm_model_tools_CA
				custAttributes.add target  wallworm_model_tools_CA
			)
			
			
			target.targets = targets as array
			target.hulls = hulls as array
			target.gibs = gibs as array
			target.proxies = proxies as array
			
			if lods.count > 0 then (
				
				for l in lods do (
					l.wrapper = this
					l.setCustomAttributes()
				)
				
				
			)
			
			
			if isValidNode massorigin  AND isProperty target "massorigin" then (
				target.massorigin = massorigin
			)
			if isValidNode illumorigin AND isProperty target "illumorigin" then (
				target.illumorigin = illumorigin
			)
			if autoHull != undefined then (
				target.autoHull = autoHull
			)
			if mass != undefined then (
				target.mass = mass
			)
			if automass != undefined then (
				target.automass = automass
			)
			if concave != undefined then (
				target.concave = concave
			)
			if contents != undefined then (
				target.contents = contents
			)
			if inertia != undefined then (
				target.inertia = inertia
			)
			if damping != undefined then (
				target.damping = damping
			)
			if rotDamping != undefined then (
				target.rotDamping = rotDamping
			)
			if jointConstraints != undefined then (
				target.jointConstraints = jointConstraints
			)
			if phdrag != undefined then (
				target.phdrag = phdrag
			)
			if animatedfriction != undefined then (
				target.animatedfriction = animatedfriction
			)
			if noselfcollisions != undefined then (
				target.noselfcollisions = noselfcollisions
			)
			
			--target.attachments = attachments as array
			--bodygroups = bodygroups as array

			if normalMethod != undefined then (
				target.normalMethod = normalMethod
			)
			if compression != undefined then (
				target.compression = compression
			)
			if mapChannel != undefined then (
				target.mapChannel = mapChannel
			)
			target.shaderType = shaderType
			if morphasvta != undefined then (
				target.morphasvta = morphasvta
			)
			if camMode != indefined then (
				target.camMode = camMode
			)
			if cam != undefined then (
				target.cam = cam
			)
			if altOrigin != undefined then (
				target.altOrigin = altOrigin
			)
			if lockInitialOrigin != undefined then (
				target.lockInitialOrigin = lockInitialOrigin
			)
			if rotateRefsystem != undefined then (
				target.rotateRefsystem = rotateRefsystem
			)
			if internalOrigin != undefined then (
				target.internalOrigin = internalOrigin
			)
			
			if modelName != undefined then (
				target.modelName = modelName
			)
			if locked != undefined then (
				target.locked = locked
			)
			if modelPath != undefined then (
				target.modelPath = modelPath
			)
			if materialPath != undefined then (
				target.materialPath = materialPath
			)
			if concave != undefined then (
				target.concave = concave
			)
			if contents != undefined then (
				target.contents = contents
			)
			if surfaceprop != undefined AND surfaceprop != "undefined" then (
				target.surfaceprop = surfaceprop
			)
			if staticprop != undefined then (
				target.staticprop = staticprop
			)
			
			if alwayscollapse != undefined then (
				target.alwayscollapse = alwayscollapse
			)
			
			if opaque != undefined then (
				target.opaque = opaque
			)
			if mostlyopaque != undefined then (
				target.mostlyopaque = mostlyopaque
			)

			if mscale != undefined then (
				target.mscale = mscale
			)
			if useLocalOrigin != undefined then (
				target.useLocalOrigin = useLocalOrigin
			)
			if dmg_bullets != undefined AND dmg_bullets as float != undefined then (
				target.dmg_bullets = dmg_bullets
			)
			if AIWalkable != undefined AND AIWalkable  != "undefined"  then (
				target.AIWalkable = AIWalkable
			)
			if blockLOS != undefined AND blockLOS != "undefined" then (
				target.blockLOS = blockLOS
			)
			
			if physicsmode != undefined then (
				target.physicsmode = physicsmode
			)
			if allowstatic != undefined AND allowstatic != "undefined" then (
				target.allowstatic = allowstatic
			)
			if health != undefined AND health as float != undefined then (
				target.health = health
			)
			if base != undefined then (
				target.base = base
			)
			if dmg_club != undefined AND dmg_club != "undefined" then (
				target.dmg_club = dmg_club
			)
			if dmg_explosive != undefined AND dmg_explosive != "undefined" then (
				target.dmg_explosive = dmg_explosive
			)
			if ignite != undefined AND ignite != "undefined" then (
				target.ignite = ignite
			)
			if explosive_resist != undefined AND explosive_resist != "undefined" then (
				target.explosive_resist = explosive_resist
			)
			if flammable != undefined AND flammable != "undefined" then (
				target.flammable = flammable
			)
			if explosive_damage != undefined AND explosive_damage as float != undefined then (
				target.explosive_damage = explosive_damage
			)
			if breakable_model != undefined AND breakable_model != "undefined" then (
				target.breakable_model = breakable_model
			)
			if breakable_count != undefined AND breakable_count as integer != undefined then (
				target.breakable_count = breakable_count
			)
			if breakable_skin != undefined AND breakable_skin != "undefined" then (
				target.breakable_skin = breakable_skin
			)
			if multiplayer_break != undefined AND multiplayer_break != "undefined" then (
				target.multiplayer_break = multiplayer_break
			)
			if explosive_radius != undefined AND explosive_radius as float != undefined  then (
				target.explosive_radius = explosive_radius
			)
			if fadetime != undefined  AND fadetime as float != undefined then (
				target.fadetime = fadetime
			)
			if motiondisabled != undefined AND motiondisabled != "undefined" then (
				target.motiondisabled = motiondisabled
			)
			
			setSeqListCust()


		)
		
	),
	
	function getParamsFromWWMTAttrib= (
		if target != undefined AND NOT isDeleted target AND  isProperty target "targets" then (
			
			
			target.getWWMT()
			
			if isProperty target "sanitize" then (
				target.sanitize()
			)
			targets = target.targets as array
			hulls = target.hulls as array
			gibs = target.gibs as array
			proxies = target.proxies as array

			
			if isProperty target "lods"  then (

				if target.lods.count > 0 then (
					lods  = #()
					for l in target.lods where isValidNode l  do (
						ld = l.get_lod refresh:true
						
						if ld != undefined then (
							append lods ld
						)
					)
					
					
				)
			)
			
			massorigin = target.massorigin
			autoHull = target.autoHull
			
			mass = target.mass
			automass = target.automass
			concave = target.concave
			contents = target.contents
			inertia = target.inertia
			damping = target.damping
			rotDamping = target.rotDamping
			jointConstraints = target.jointConstraints
			phdrag = target.phdrag
			animatedfriction = target.animatedfriction
			noselfcollisions = target.noselfcollisions
			
			--attachments = target.attachments as array
			--bodygroups = target.bodygroups as array

			normalMethod = target.normalMethod
			compression = target.compression
			mapChannel = target.mapChannel
			shaderType = target.shaderType
			morphasvta = target.morphasvta
			camMode = target.camMode
			cam = target.cam
			altOrigin = target.altOrigin
			lockInitialOrigin = target.lockInitialOrigin
			rotateRefsystem = target.rotateRefsystem
			internalOrigin = target.internalOrigin
			
			
			
			modelName = target.modelName
			locked = target.locked
			modelPath = target.modelPath
			materialPath = target.materialPath
			concave = target.concave
			contents = target.contents
			surfaceprop = target.surfaceprop
			staticprop = target.staticprop
			opaque = target.opaque
			mostlyopaque = target.mostlyopaque
			illumorigin = target.illumorigin
			mscale = target.mscale
			useLocalOrigin = target.useLocalOrigin
			dmg_bullets = target.dmg_bullets
			AIWalkable = target.AIWalkable
			blockLOS = target.blockLOS
			physicsmode = target.physicsmode
			allowstatic = target.allowstatic
			health = target.health
			base = target.base
			dmg_club = target.dmg_club
			dmg_explosive = target.dmg_explosive
			ignite = target.ignite
			explosive_resist = target.explosive_resist
			flammable = target.flammable
			explosive_damage = target.explosive_damage
			breakable_model = target.breakable_model
			breakable_count = target.breakable_count
			breakable_skin = target.breakable_skin
			multiplayer_break = target.multiplayer_break
			explosive_radius = target.explosive_radius
			fadetime = target.fadetime
			motiondisabled = target.motiondisabled
			
			if isProperty target "alwayscollapse" then (
				alwayscollapse = target.alwayscollapse
			)
			
			makeSequenceListFromCust()

		)
		
	),
	
	
	function init = (
	
		global wallworm_userIni
		global wwmt_def_fgd
		global wwmt_raw_mats 
		global wwdt_mapsrc 
		global wwmt_current_material_Paths
		global wwmt_current_model_Paths
		global wwmt_mappingChannel 
		global wwmt_FOV 
		global wwmt_verticalRes 
		global wwmt_horizontalRes 
		global wwmt_LODOptimize 
		global wwmt_hull_limit_handling 
		global wwmtExporter 
		global wwmt_hull_tool 
		global wwmt_lodLimit 
		global wwmt_createLayers 
		global wwmt_copyTarget 
		global wwmtAutoOpenFolder
		global wwmt_autoMaterialNewModel 
		global wwmt_mappingChannel 
		global wwmt_overWriteQC 
		global wwmt_makeHullsNonRenderable 
		global wwmt_refLOD 
		global wwmt_default_staticprop 
		global wwmt_use_local_origin 
		global wwmt_exportNonRenderableMeshAsBone 
		global wwmt_forceOpaqueFromModel 
		global wwmt_translucentOnlyIfOpacityMap 
		global wwmtCompileMessage 
		global wwmtAutoCompile 
		global wwmt_gameInfoDir 
		global wwmt_binDir 
		global wwmt_def_material_path 
		global wwmt_def_model_path 
		global wwmt_exportMats
		global wwmt_export 
		global wwmt_allow_psd
		global wwmt_rotateRefsystem

		
		lods = #()
		hulls = #()
		bonesarray = #()
		hullbonesarray = #()
		attachmentlist=#()
		attachments=#()
		gibs=#()
		bodygroups=#()
		sequences=#()
		sequencelist=#()	
		weightlistnames=#()
		weightlists=#()
		targets=#()
		idleSequence = true
		proxies=#()
	
	
	
		global wwmt_sequence	
		if wwmt_sequence == undefined then (
			fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_sequence.ms"
		)
		global wwmt_weightlist

		
		if wwmt_use_local_origin == "true" then (
					useLocalOrigin = true
		) else (
				useLocalOrigin = false
			
		)
		
		if wwmt_rotateRefsystem != undefined AND (wwmt_rotateRefsystem == true OR wwmt_rotateRefsystem == "true") then (
				rotateRefsystem = true
		) else (
				rotateRefsystem = false
			
		)
		
		
		
		
		
		
		
		mapChannel = wwmt_mappingChannel as integer
			

		mscale = 1
		layer = "WW Model Tools Layer"
		
	--reset everything to defaults	
		modelName="modelname"
		shaderType = "VertexLitGeneric"
		isset=false
		target=undefined
		autoHull=false
		locked=false
		noselfcollisions=false
		modelSetName=undefined
		physSetName=undefined
		phys=undefined
		lodgroup=undefined
		modelPath=undefined
		materialPath=undefined
		surfaceprop=undefined
		lockInitialOrigin=false
		collapsebones = false
		normalMethod = 3
		animatedfriction = undefined
		if wwmt_default_staticprop == "true" then (
			staticprop = true
		) else (
			staticprop=false
		)
		

		
		illumposition=undefined
		ambientboost=undefined
		constantdirectionallight=undefined
		opaque=undefined
		mostlyopaque=undefined
		illumorigin=undefined
		mass=undefined
		automass=undefined
		concave=undefined
		contents=undefined
		inertia=undefined 
		damping=undefined
		rotDamping=undefined
		jointConstraints=undefined
		phdrag=undefined
		masscenter=undefined
		massorigin=undefined
		altOrigin=false
		shadowlod=undefined
		expHL1Format=0
		origin=undefined
		cam=undefined
		camMode=false
		base=""
		particlesystems=#()
		health=undefined
		allowstatic=undefined
		physicsmode=undefined
		blockLOS=undefined
		AIWalkable=undefined
		dmg_bullets=undefined
		dmg_club=undefined
		dmg_explosive=undefined
		ignite=undefined
		explosive_resist=undefined
		flammable=undefined
		explosive_damage=undefined
		breakable_model=undefined
		breakable_count=undefined
		breakable_skin=undefined
		multiplayer_break=undefined
		explosive_radius=undefined
		motiondisabled = undefined
		fadetime=15
		morphasvta=true
		internalOrigin = true

	),




	function writeBonesArray = (
		
		if isValidNode target  do (
		s = ""
		iteration = 1
		
		for so in bonesarray where (isValidNode so == true) do (

			if iteration > 1 do (
				append s ","
				)
			
				append s so.name
				iteration = iteration + 1
				appendifUnique bonesarray so
				if findItem target.bonelist so == 0 then (
					append target.bonelist so
				)
				
				
		)
		
		setUserProp target "wwmt_bonelist"  s
			
		)
		
	),
	
	function addToBones bonelist = (
		
		
		bonelist = bonelist as array
		if bonelist != undefined AND bonelist.count > 0 then (
			join bonesarray bonelist 
			makeUniqueArray bonesarray
			writeBonesArray()
		)
	),
	
	
	function removeFromBones bonelist = (
		bonelist = bonelist as array
		if bonelist != undefined AND bonelist.count > 0 then (
			
			for bin = bonelist.count to 1 do (
				b = bonelist[bin]
				local bi = findItem bonesarray  b while bi > 0 do (
					if  bi > 0 then (
						
						deleteItem bonesarray bi
					)
				

				)
				local bi2 = findItem target.bonelist b 
				
				if bi2 != 0 then (
					deleteItem target.bonelist bi2
				)
				
				
				
			)


			writeBonesArray()
		)
	),
	
	
function checkForRenderableMesh = (
	global wwmt_exportNonRenderableMeshAsBone
	if wwmt_exportNonRenderableMeshAsBone == false OR wwmt_exportNonRenderableMeshAsBone == "false" then (
		return true
		) else (
	
			for ob in targets do (
		
				if (ob.renderable == on) then (
					return true
					) else ()
			)
			return false
		)
			return true
),

function setRefNode n:undefined = (
/*	if useLocalOrigin == true AND n==undefined then (
			referenceNode = undefined
	) else (
	*/
	if n==undefined then (
		referenceNode = targets[1]
	) else (
		
		if isValidNode n then (
			referenceNode = n
			) else (
				referenceNode = targets[1]
			)
		
		)
	--)
	return referenceNode
),
function getRefNode = (
	
	--if useLocalOrigin == true then (
		if isValidNode referenceNode  then (
			return referenceNode
			)else (
			return targets[1]
		) 
	/*) else (
		return undefined
	)*/
		
),
	
	
	function getRefOrientation t:0= (
			
			getRefNode()
			refSystem = matrix3 1
			
			if isValidNode referenceNode AND useLocalOrigin == true then (
				
				if lockInitialOrigin == true then (
					refSystem = at time 0 ((matrix3 [1,0,0] [0,1,0] [0,0,1] referenceNode.transform.translation))  
				) else (
					refSystem = at time t ((matrix3 [1,0,0] [0,1,0] [0,0,1] referenceNode.transform.translation))  
				)				
			)
			
			
			if rotateRefsystem == true then (
				
				refSystem = rotateZMatrix 90 *  refSystem
				
			)
			
			return refSystem
		),
	
function checkForUVWData = (
	
	
	local missinguvw = #()
	
								if wwmtExporter=="1" then (	
								
									try(
										pluginManager.loadClass SMDExporter
									) catch(
											--Wunderboy SMD Exporter not installed
									)
					
 									    local uvchannelcheck = mapChannel
										if WBSMDExportVersionNum() < 1701 then (
											uvchannelcheck = 1
										) else (
										
										)

										
										objsToCheck = #()
										join objsToCheck targets
										join objsToCheck hulls
									  --  if WBSMDExportVersionNum() < 1700 then () else ()
									--format "Objects to Check: %\n\n" (objsToCheck)
									for obj in objsToCheck do (
										
										tempObj = copy obj
										--format "Object Name: % ; Object Class: %" tempObj.name (classOf tempObj)
										convertToPoly tempObj
										if (polyop.getMapSupport tempObj uvchannelcheck) == false then (
											append missinguvw obj
										)
										
										
										delete tempObj
										)
										
									objsToCheck = undefined
									
								)
	
	return missinguvw
	),
	
function canBePropType type:"prop_static" = (
	local er = #()

	if (base != undefined and base != "" ) and type != "prop_physics"  and type != "prop_physics_multiplayer" AND type!="prop_ragdoll"  then (

		append er  (modelName+" could not be set as "+type+" because it has Prop Data.")

	)

	if (base == undefined or base == "" ) and type == "prop_physics"  then (

		append er    (modelName+" could not be set as "+type+" because it has no Prop Data.")

	)
	
	if  (type=="prop_ragdoll" OR type=="prop_physics") and (hulls.count == 0) then (
		append er   (modelName+" could not be set as a "+type+" because it has no Collision Hull.")
	)
	
	if ((type=="prop_detail" OR type=="prop_static") AND (staticprop==undefined OR staticprop == false)) then (

		append er (modelName+" could not be set as "+type+" because it does not have the $staticprop setting.")
		)
	/*
	if er.count > 0 then (
		
		local msg = ""
		
		for m in er do (
			 append msg (""+m+"\n\n")
			)
		
		return msg
		) else (
		return ""
		)
		*/
		return er
	),	
	
function getProxies = (
		proxies = for proxy in objects WHERE (getUserProp proxy "wwmt_proxie_source" == target.name) collect proxy
		target.proxies = proxies
		return proxies
	),
function setCoreCVXEntityValue type:"prop_static" = (
	

	
	wallworm_setPropDefaults target type:type mdl:(modelPath+"/"+modelName+".mdl")
	/*
	needed in past for convexity entities and XRef... probably not needed now.
	if classOf target == text then (
		
		addModifier target (Extrude amount:8)
		target.renderable = off
		
		)
	*/
	for proxy in objects WHERE (getUserProp proxy "wwmt_proxie_source" == target.name) do (
		wallworm_setPropDefaults proxy type:type  mdl:(modelPath+"/"+modelName+".mdl")
		 --proxy.name = (uniqueName ("PE "+type))
	)
	
	return ""
),		
		
function FsToBs s = (
		
	return (wallworm_FsToBs s)
),

function bsToFs s = (
		
		return (wallworm_bsToFs s)
),

function areMorphs = (
	for m in targets WHERE isValidNode m do (

		for mods in m.modifiers do (
			
			if classOf mods == Morpher OR classOf mods == Morph_O_Matic  do (
				
				return true
				)
			)
		)

	return false
	),
		
	function getVTAFlexnames = (
				
				nameArray = #()
				if targets.count > 1 do (
						return nameArray
				)

				local notFound = true
				local i = 1

			   local obj = targets[1]
							

				for i=1 to obj.modifiers.count while notFound do (
					if classOf obj.modifiers[i] == Morpher OR classOf obj.modifiers[i]  == Morph_O_Matic do (
						notFound = false
					) 
				)
				
				
				
				if notFound == false then (
					
					
					if classOf obj.modifiers[i] == Morpher then (
					  --do morpher code
						
						local usedChannels = #()
						for uc = 1 to 100 do (
							
							if WM3_MC_HasData obj.modifiers[i] uc do (
								append usedChannels uc
								)
								
							)
								local f = 1


									for c  in usedChannels do (
										
										append	nameArray #((WM3_MC_GetName obj.modifiers[i] c), f)
										
										
										f = f+1
									)





						
						
					) else if classOf obj.modifiers[i] == Morph_O_Matic then (
						--do morph-o-matic code
						MOM_HoldLicense()   
						local channels = MOM_GetNumChannels obj.modifiers[i]



						--print channels
						for c = 1 to (channels) do (
						--print (classOf (obj.modifiers[i][c]))
							--print (c as string + " : "+(MOM_MC_TARG_GetName obj.morphomatic[1] c))

							--try(
							append	nameArray #((obj.modifiers[i][c].name), c)
							--) catch()

						)
								




					)   else ()
					
					
				)
				
				if nameArray.count > 0 then (
					
					for c = 1 to 100 do (
						
						case (classOf obj.modifiers[i]) of (
							
							Morpher: (
								if (obj.modifiers[i][c] != undefined) AND (at time c obj.modifiers[i][c].value == 100) then (
							
								append range c	
								)else()
							)
							Morph_O_Matic:(
								
								if obj.modifiers[i][c] != undefined AND (at time c obj.modifiers[i][c].progressive == 100) then (
									
									append range c	
									
								) else ()		
								
							)
							
							
						)
						
						
						


						

						
						
						
						
					)
					
				) else()
				
				
				return nameArray
				
				
			),

			function exportVTAs exportNonRenderableMeshAsBone = (
				
				local vtaSelection = #()
				local vtaObjects = 0
				
				local notFound = true
				for m in targets while notFound do (
					if isValidNode m == true do (


						for mods in m.modifiers do (
							
								if classOf mods == Morpher OR classOf mods == Morph_O_Matic  do (
									notFound = false

								)
									
						)
						
					)
				)	


					if notFound == false do (

						
						


					
						local mp = FsToBs modelPath
						local wwDir = wwmt_export + "\\"+mp		
						
						local fname = wwDir +"\\"+modelName + "_flex.vta"
						

						if wwmtExporter=="3" then (	
							
							
							

				
								explist = #()
								join explist (targets as array)
								
								if bonesarray.count > 0 do (
									join explist  (bonesarray as array)
								) 
				
				
		
							
								
								--use WWMT MXS SMD Exporter
								smd = 	wallwormSMD()
								smd.uvwchannel = mapChannel
								smd.makeNodeList explist
								smd.type="VTA"
								smd.range = range
								smd.nonRenderableAsBone=exportNonRenderableMeshAsBone
								smd.origin = useLocalOrigin
								smd.staticprop = staticprop
								smd.refNode = getRefNode()
								smd.normalMethod = normalMethod
								smd.internalOrigin = internalOrigin
								smd.rotateRefsystem = rotateRefsystem
								smd.flip = altOrigin
								--smd.refNode = targets[1]
								if range.count > 1 then (
								--smd.boneweights = false
									status = smd.exportSMD fname
									if status == false then (
									 messagebox "The flex file was not properly exported."	
									) else()
								) else (
									--print range
									return false
									)
								return status
								
							) else (
						

						if wwmtExporter=="2"  then (
							
							
							
							try (
									--if is64bitApplication() then (
										--messagebox "Canonfodder's VTA exporter currently doesn't work with 64bit Max. You may have to try the Wunderboy SMD and VTA exporters."
									--) else 
									
									if (ExportVTA == undefined) then (
										messagebox "Canonfodder's VTA exporter needs to be updated in order to export VTAs with WWMT."
									) else (
									
											ExportVTA fname true
											return true
									)
									return false
							) catch (
								messagebox "There was a problem with the VTA export."
								return false
								)
						) else (
							--write Wunderboy's export
							
								try (
									exportFile fname #noPrompt  selectedOnly:true using:VTAExporter
									return true
								) catch (
									messagebox "There was a problem with the VTA export."
									return false
								)
							)
						)
						) 
						
						return false
				
	),
	function setShaderType mp = (
		shaderType = mp
		if isValidNode target  do (
			
			target.shaderType = mp
			setUserProp target "wwmt_shader"  mp
		) 
	),
	function setCompression mp = (
		compression = mp
		if isValidNode target do (
			target.compression = mp
			setUserProp target "wwmt_compression"  mp
		) 
	),	
	function setParticleSystems = (
			if isValidNode target  do (
				setUserProp target "wwmt_particlesystems" particlesystems
			)
		),	
	
	function removeParticleSystem ind = (
		
		deleteItem particlesystems ind
		setParticleSystems()
		),
	
		function addParticleSystem ps = (
			appendIfUnique particlesystems ps
			setParticleSystems()
		),
	

	
		function getParticleSystems = (
			
			local ps = (getUserProp target "wwmt_particlesystems")
			
			if ps != undefined  do (

				--ps = (ps as array)

				global wwmt_temporary_value
				
				thestr = "wwmt_temporary_value = "+ps
				execute thestr
				if (wwmt_temporary_value as array).count > 0 do (
					
					--include "$scripts/WallWorm.com/common/wwmt_particles.ms"
					/*					
					for sys in ps do (
						--local part = wwmt_particles()
						--part.getParticleProperties sys
						append particlesystems sys
						
						
						)
					

					
					--particlesystems = ps
					*/
					particlesystems = wwmt_temporary_value
					)
	
				wwmt_temporary_value = undefined
					--print particlesystems
				)
			
		),
	
	function deleteWWMT = (
		try(
			if isValidNode target then (
				delete target
			)
			if illumorigin != undefined AND isDeleted illumorigin == false do (
				delete illumorigin
			)
			if massorigin != undefined AND isDeleted massorigin == false do (
				delete massorigin
			)
			
			if lods.count > 0 do (
				
				for l in lods do (
					
						if  isValidNode  l.helperGizmo then  (
							 delete l.helperGizmo
						)
						if isValidNode l.helperTape  do (
							 delete l.helperTape
						)	
					)
				)
				if cam != undefined AND isDeleted cam == false do (
					delete cam
				)
			) catch(
				print "There was an error deleting the WWMT info."
			)
	),
	
			
	function setAnimatedfriction  m = (
		animatedfriction = trimLeft  (trimRight m)
		target.animatedfriction = animatedfriction
		setUserProp target "wwmt_animatedfriction" animatedfriction
	),
			
	function lodcount = (
		return lods.count
	),
		
	function setBase m = (
			if m == undefined then m = ""
			base = m
			target.base = m
			setUserProp target "wwmt_base" m
		),	
	function setPhysicsmode m = (
			physicsmode = m
			target.physicsmode = m
			setUserProp target "wwmt_physicsmode" m
		),	
	function setMultiplayer_break m = (
			multiplayer_break = m
			target.multiplayer_break = multiplayer_break
			setUserProp target "wwmt_multiplayer_break" m
		),	
	function setBreakable_model m = (
			breakable_model = m
			target.breakable_model = m
			setUserProp target "wwmt_breakable_model" m
		),	
	function setBreakable_count m = (
			breakable_count = m
			target.breakable_count = m
			setUserProp target "wwmt_breakable_count" m
		),		
	function setHealth m = (
			health = m
			if m != undefined then (
				target.health = m
			)
			setUserProp target "wwmt_health" m
		),		
	function setDmg_bullets m = (
			dmg_bullets = m
			if m != undefined then (
				target.dmg_bullets = m
			)
			setUserProp target "wwmt_dmg_bullets" m
		),		
	function setDmg_club m = (
			dmg_club = m
			if m != undefined then (
				target.dmg_club = m
			)
			setUserProp target "wwmt_dmg_club" m
		),		
	function setDmg_explosive m = (
			dmg_explosive = m
			if m != undefined then (
				target.dmg_explosive = m
			)
			setUserProp target "wwmt_dmg_explosive" m
		),		
	function setExplosive_damage m = (
			explosive_damage = m
			if m != undefined then (
				target.explosive_damage = m
			)
			setUserProp target "wwmt_explosive_damage" m
		),		
	function setExplosive_radius m = (
			explosive_radius = m
			if m != undefined then (
				target.explosive_radius = m
			)
			setUserProp target "wwmt_explosive_radius" m
		),		
	function setBreakable_skin m = (
			breakable_skin = m
			if m != undefined then (
				target.breakable_skin = m
			)
			setUserProp target "wwmt_breakable_skin" m
		),		
	function setFadetime m = (
			fadetime = m
			if m != undefined then (
				target.fadetime = m
			)
			setUserProp target "wwmt_fadetime" m
		),		
		
	function setAllowstatic mp = (
			if target != undefined then (
				allowstatic = mp
				target.allowstatic = mp
				if mp == true then (
					setUserProp target "wwmt_allowstatic"  "true"
				) else (
					setUserProp target "wwmt_allowstatic"  "false"
				)
			) 
		),
	function setBlockLOS mp = (
			if target != undefined then (
				blockLOS = mp
				target.blockLOS = mp
				if mp == true then (
					setUserProp target "wwmt_blockLOS"  "true"
				) else (
					setUserProp target "wwmt_blockLOS"  "false"
				)
			) 
		),
	function setMotiondisabled mp = (
			if target != undefined then (
				motiondisabled = mp
				if mp != undefined then (
					target.motiondisabled = mp
				)
				if mp == true then (
					setUserProp target "wwmt_motiondisabled"  "true"
				) else (
					setUserProp target "wwmt_motiondisabled"  "false"
				)
			) 
		),
		
		
	function setAIWalkable mp = (
			if target != undefined then (
				AIWalkable = mp
				if mp != undefined then (
					target.AIWalkable = mp
				)
				if mp == true then (
					setUserProp target "wwmt_AIWalkable"  "true"
				) else (
					setUserProp target "wwmt_AIWalkable"  "false"
				)
			) 
		),
	function setCollapsebones mp = (
			if target != undefined then (
				collapsebones = mp
				--target.collapsebones = mp
				if mp == true then (
					setUserProp target "wwmt_collapsebones"  "true"
				) else (
					setUserProp target "wwmt_collapsebones"  "false"
				)
			) 
		),
	function setIdleSequence mp = (
			if target != undefined then (
				idleSequence = mp
				if mp == true then (
					setUserProp target "wwmt_idleSequence"  "true"
				) else (
					setUserProp target "wwmt_idleSequence"  "false"
				)
			) 
		),
		
		
	function setIgnite mp = (
			if target != undefined then (
				ignite = mp
				target.ignite = mp
				if mp == true then (
					setUserProp target "wwmt_ignite"  "true"
				) else (
					setUserProp target "wwmt_ignite"  "false"
				)
			) 
		),
	function setExplosive_resist mp = (
			if target != undefined then (
				explosive_resist = mp
				target.explosive_resist = mp
				if mp == true then (
					setUserProp target "wwmt_explosive_resist"  "true"
				) else (
					setUserProp target "wwmt_explosive_resist"  "false"
				)
			) 
		),
		
		function setMorphasvta mp = (
			
			if target != undefined then (
				morphasvta = mp
				target.morphasvta = mp
				if mp == true then (
					setUserProp target "wwmt_morphasvta"  "true"
				) else (
					setUserProp target "wwmt_morphasvta"  "false"
				)
			) 
		),
	function setLockOrigin mp = (

			if target != undefined then (
				lockInitialOrigin = mp
				target.lockInitialOrigin = mp
				if mp == true then (
					setUserProp target "wwmt_lockInitialOrigin"  "true"
				) else (
					setUserProp target "wwmt_lockInitialOrigin"  "false"
				)
			) 
		),

	function setFlammable mp = (
			if target != undefined then (
				flammable = mp
				target.flammable = mp
				if mp == true then (
					setUserProp target "wwmt_flammable"  "true"
				) else (
					setUserProp target "wwmt_flammable"  "false"
				)
			) 
		),

	function setTargetCust = (
		if target != undefined AND isDeleted target==false do (
		s = ""
		iteration = 1
		
		for so in targets where isValidNode so do (

			if iteration > 1 do (
				append s ","
			)
			
			append s so.name
			iteration = iteration + 1
			
			local ti = findItem target.targets so
			if ti == 0 then (
				append target.targets so
			)
			
		)
		
		setUserProp target "wwmt_targetslist"  s
			

			
			
		)
	),	
	function getMainMaterial matname:undefined= (
			
				if targets.count > 0 AND targets[1].mat != undefined then (
					return targets[1].mat
				) else (
						local newmat
						local newmat = Standard()
						if matname == undefined then (
							matname = ("VMT_"+modelName+"_")
							)
						newmat.name = uniqueName matname
						newmat.Diffuse = color 203 37 5
						newmat.ambient = color 203 37 5
							
						wallworm_give_mat_ww newmat	
						newmat.valveShader = shaderType
						newmat.forModel = true
						if materialPath != undefined then (
							newmat.cdmaterials = materialPath
						)
						if surfaceprop != undefined then (
							newmat.surfaceproperty = surfaceprop	
						)
						newmat.keywords = #("wallworm",modelName)
						
						return newmat
				)
						

		),
	
		
		function getAllNodesFromGroup &nodes gr= (
			
			
			for obj in gr do (
				if isGroupHead obj then (
					getAllNodesFromGroup nodes obj.children
				) else (
						appendIfUnique nodes obj
						if findItem target.targets obj == 0 then (
							append target.targets obj
						)
					
				)
				
			)
			
		),

		
	function addObjToObjects obj recurse:false= (
		
		local added = true
		
		local startingCount = targets.count
		

		
		
			if classOf obj == ObjectSet then (
				
				for i in obj WHERE isGroupHead i == false do (

					addObjToObjects i 
				)
				
				
				) else (

				
						if wwmt_autoMaterialNewModel == "true" AND superClassOf obj == GeometryClass AND obj.mat == undefined AND isGroupHead obj ==false do (
							obj.mat = getMainMaterial()
							
						)
						
						--appendIfUnique targets obj
						if findItem target.targets obj == 0 then (
							append target.targets obj
						)
				
				
						if isGroupMember obj then (
							
							getAllNodesFromGroup target.targets obj.parent.children
							
							
						) 
							
							

						for i = targets.count to 1 by -1 do (
						
							if getUserProp targets[i] "wwmt_source_helper" != undefined OR isProperty targets[i] "wwmt_ca" then (
								
									deleteItem target.targets i
							)
							
						)
						
						
						
							

					targets = target.targets as array
					
					setTargetCust()



			)
			




		local endingCount = targets.count


		if endingCount <= startingCount then (
			added = false
		) else (
			added = true
		)


		return added

	),
		
		function setCamChangeHandler = (
			
								when transform cam changes id:#wwmtLODCamHandler handleAt:#redrawViews obj do (
								if isDeleted obj == false then (wwmt_CallbackLODCamMove obj)
								)

			
			),
	

	function setGibsCust = (
		s = ""
		iteration = 1
		
		for so in gibs do (

			if iteration > 1 do (
				append s ","
				)
			
				append s so.name
				iteration = iteration + 1
				
				/*if findItem target.gibs so == 0 then (
					append target.gibs so
				)*/
			)
			

			
		setUserProp target "wwmt_gibslist"  s
	),		
	function appendGibs obj = (
		
			if (superClassOf obj == GeometryClass) then (
				appendIfUnique gibs obj
			) else (
				
				if (superClassOf obj == shape AND obj != target) do (
					
					
					isWWMTSource = getUserProp obj "wwmt_source_helper"
					--wwmt_source_helper
					if (isWWMTSource != undefined AND isWWMTSource==true) do (
						appendIfUnique gibs obj
						)
					
					)
				
				
				)
				
				if breakable_count == undefined OR gibs.count > breakable_count then (

						breakable_count = gibs.count
						setBreakable_count breakable_count
				)
				
			if findItem target.gibs obj == 0 then (
				append target.gibs obj
			)	
					
		),
		
		function setChildGibs tempWWMT = (
			
			
			tempWWMT.setMaterialPath(materialPath)
			tempWWMT.setModelPath(modelPath)
	
			tempWWMT.setConcave(false)
			tempWWMT.setAutoHull(true)
			tempWWMT.setStaticprop(true)	
			
	
			newModelName = "GibsModel_"+tempWWMT.modelName
	 
			tempWWMT.setModelName(newModelName)
	
			
			if base == undefined then (			
				base = ""
			)
				tempWWMT.setBase(base)

			tempWWMT.setSurfaceProperty(surfaceprop)

			tempWWMT.setDmg_bullets(dmg_bullets)
			tempWWMT.setDmg_club(dmg_club)
			tempWWMT.setDmg_explosive(dmg_explosive)
			tempWWMT.setFadetime(fadetime)
			tempWWMT.setMotiondisabled(motiondisabled)
			
			tempWWMT.setTargetCust()
			
			if referenceNode != undefined then (
				tempWWMT.referenceNode = referenceNode
			)
								
						--	t = "break\n	{\n	\"model\" \""+tempWWMT.modelPath+"/"+tempWWMT.modelName+".mdl\"\n	\"fadetime\" \""+(fadetime as string)+"\"	}\n"
							--append gibsText t
								
			
	),
		
	function addGibs sel = (

			if sel.count > 0 do (

				for obj in sel do (
					
					if isDeleted obj == false do (
						local tempWWMT = ww_LOD_wrapper()
						tempWWMT.init()					
						tempWWMT.setTargetModel obj tempWWMT
				 
						if tempWWMT.target != undefined then (
							--this will exclude the gib WWMT from exporting in the VMF
							
							--setUserProp tempWWMT.target "wallworm_exclude_vmf" "true"
							tempWWMT.target.exclude_vmf = true
							
						)

						 if (tempWWMT.isset == true) then (
								setChildGibs tempWWMT
						 ) else (
							 
							 
						)

						appendGibs tempWWMT.target
						
					)
				
				)
			)
		
			setGibsCust()
		

		),
		
	function removeGibs sel = (
		
			for obj in sel do (
				local gindex = findItem target.gibs obj
				if gindex != 0 then (
					deleteItem target.gibs gindex
				)
			)
			

			gibs = target.gibs as array
			
			setGibsCust()
		
		
		),
		
	function removeItemFromTargets obj = (
		ind = findItem target.targets obj
		
		if ind>0 do (
			
			deleteItem target.targets ind
			targets = target.targets as array
			setTargetCust()
			)
		
	),
	function removeItemsFromTargets sel =(
			for obj in sel do (
				removeItemFromTargets(obj)
				
				)
			
			
	),
	
	function makeWeightListFromCust = (
		
		fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_sequence.ms"
		global wwmt_weightlist
		for word in weightlistnames do( 

			
			s = wwmt_weightlist()
			s.name = word
			
			s.getWeightListFromObj target
			
			append weightlists s
			)
		
	),

	
	function setWeightListCust = (
      if target != undefined do (
		s = ""
		iteration = 1
		
		for so in weightlists do (

			if iteration > 1 do (
				append s ","
				)
			
				append s so.name
				iteration = iteration + 1
			)
		
		setUserProp target "wwmt_weightlists"  s
		)
	),	
	
	function addToWeightLists so = (

			add = true
			for s in weightlists while add do (
				
				if s.name == so.name do (
					add = false

					
				)
				

			)
			
			
			if add == true do (
				append weightlists so
				setWeightListCust()
			)
			
	),
	function addToSequences so = (

			add = true
			for s in sequences while add do (
				
				if s.sequence ==so.sequence do (
					add = false

					
				)
				

			)
			
			
			if add == true do (
				append sequences so
				setSeqListCust()
			)
			
	),
			

		function removeSequence t = (
			ind = findItem sequencelist t
			if ind > 0 do (
				deleteItem sequencelist ind
			)
			
			ind = 1
			for s in sequences do (
				
				if s.sequence == t do (
					s = undefined
					deleteItem sequences ind
					
				)
				
				  ind = ind + 1
			)
			setSeqListCust()
		),

		function removeWeightlist t = (
			ind = findItem weightlistnames t
			if ind > 0 do (
				deleteItem weightlistnames ind
			)
			
			ind = 1
			for s in weightlists do (
				
				if s.name == t do (
					s = undefined
					deleteItem weightlists ind
					
				)
				
				  ind = ind + 1
			)
			setWeightListCust()
		),
		
	function makeAttachmentListFromCust = (
		
		fileIn "$scripts/WallWorm.com/WallWormModelTools/wwmt_struct_attachment.ms"
		global wwmt_attachment
		for word in attachmentlist do( 

			
			s = wwmt_attachment()
			s.attachment = word
			
			s.getAttachmentFromCust target
			
			append attachments s
			)
		
		),
		function setAttListCust = (
      if target != undefined do (
		s = ""
		iteration = 1
		
		for so in attachments do (

			if iteration > 1 do (
				append s ","
				)
			
				append s so.attachment
				iteration = iteration + 1
			)
		
		setUserProp target "wwmt_attachmentlist"  s
		)
	),	
	function addToAttachments so = (

			add = true
			for s in attachments while add do (
				
				if s.attachment ==so.attachment do (
					add = false

					
				)
				

			)
			
			
			if add == true do (
				append attachments so
				setAttListCust()
			)
			
	),
			

		
	function addToAttachmentList s = (
		
			ind = findItem attachmentlist t
			if ind > 0 do (
				append attachments s
			)
		
		
		
		),
		
		function removeAttachment t = (
			ind = findItem attachmentlist t
			if ind > 0 do (
				deleteItem attachmentlist ind
			)
			
			ind = 1
			for s in attachments do (
				
				if s.attachment == t do (
					s = undefined
					deleteItem attachments ind
					
				)
				
				  ind = ind + 1
			)
			setAttListCust()
		),	
	function setAttAbsolute t mp = (
		
		--expType = mp
		
		notf = true
		for s in attachments while notf do (
				
			if s.attachment ==t do (
					s.absolute = mp
					s.setAttachment target
					notf=false
					
				)
				

		)	
		
		),	
		
		function setAttRigid t mp = (
		
		--expType = mp
		
		notf = true
		for s in attachments while notf do (
				
			if s.attachment ==t do (
					s.rigid = mp
					s.setAttachment target
					notf=false
					
				)
				

		)	
		
		),	

		function setAttBone t bn = (
			
		notf = true
		for s in attachments while notf do (
				
			if s.attachment ==t do (
					s.pb = bn

				
				
				
			if t == "" then (
				
				s.atPoint.parent = targets[1]
				s.setAttachment target
				notf=false
				) else (
				
				b = getNodeByName s.pb 
				if b != undefined AND isDeleted b ==false then (
					
					s.atPoint.parent = b
					--print b.name
					) else (
					
					s.atPoint.parent = targets[1]
					--print (" to root because "+t+" is missing")
					)
				
				
				)
					s.setAttachment target
				
					notf=false
					
				)
				

		)	
			
			
			),

		

		
		
	
		
	function setExpType t mp = (
		
		--expType = mp
		
		notf = true
		for s in sequences while notf do (
				
			if s.sequence ==t do (
					s.type = mp
					setSeqListCust()
					notf=false
					
				)
				

		)	
		

		),
		function setExpStart t mp = (
		
		--expStart = mp
		notf = true
		for s in sequences while notf do (
				
			if s.sequence ==t do (
					s.start = mp
					--setSeqListCust()
					setSeqListCust()
					notf=false
					
				)
				

		)	
			

		),	
		function setExpEnd t mp = (
		
		notf = true
		for s in sequences while notf do (
				
			if s.sequence == t do (
					s.end = mp
					--setSeqListCust()
					setSeqListCust()
				
					notf=false
					
				)
				

		)	
			
		),	
		function setExpReverse t mp = (
		
		notf = true
		for s in sequences while notf do (
				
			if s.sequence ==t do (
					s.expReverse = mp
					setSeqListCust()
					notf=false
					
				)
				

		)	
			
		),	
		function setLoop t mp = (
		
		notf = true
		for s in sequences while notf do (
				
			if s.sequence ==t do (
					s.loop = mp
					setSeqListCust()
					notf=false
					
				)
				

		)	
			
		),	
		function setModelName mn = (
			if mn != "" then (
				modelName = mn
				
				modelName = wallworm_makeStringSafe modelName
				--add check for invalid characters
				if target != undefined then (
					setUserProp target "wwmt_modelname"  modelName
					
					target.modelName = modelName
					
					if hasProperty target "text" == true then (
						target.text = ("WWMT: "+modelName)
					)
				) 
				) else (
				  messagebox "This model has no name. Please give the model a name."
				
				)
			
			
			),
		function setExpHL1Format mp = (
		
		expHL1Format = mp
		if target != undefined then (
			setUserProp target "wwmt_expHL1Format"  mp
		) 
		),	
		function setExpSequenceName t mp = (

		),	
		
	function setModelPath mp = (
		
		modelPath = wallworm_remove_last_slash (wallworm_safe_path mp)
		if target != undefined then (
			target.modelPath = modelPath
			setUserProp target "wwmt_modelPath"  modelPath
		) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),
		
	function setMaterialPath mp = (
		
		materialPath = wallworm_remove_last_slash (wallworm_safe_path mp)
		
		
		
		if target != undefined then (
			target.materialPath = materialPath
			setUserProp target "wwmt_materialPath"  materialPath
		) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),

		function setInertia m = (
			inertia = m as float
			target.inertia = inertia
			setUserProp target "wwmt_inertia" m
		),	
		function setRotDamping m = (
			rotDamping = m as float
			target.rotDamping = rotDamping
			setUserProp target "wwmt_rotDamping" m
		),			
		function setdamping m = (
			damping = m as float
			target.damping = damping
			setUserProp target "wwmt_damping" m
		),	
		function setPhdrag m = (
			phdrag = m as float
			target.phdrag = phdrag
			setUserProp target "wwmt_phdrag" m
		),	
	    function setContents m = (
			contents = m
			target.contents = m
			setUserProp target "wwmt_contents" m
		),		
		
	    function setMass m = (
			mass = m as float
			target.mass = mass
			setUserProp target "wwmt_mass" m
		),
		function setScale m = (
			mscale = m as float
			target.mscale = mscale
			setUserProp target "wwmt_scale" m
		),
		
		function setUVW m = (
			if m == undefined then (
					global wwmt_mappingChannel
					m = wwmt_mappingChannel as integer
			)
			mapChannel = m
			target.mapChannel = m as integer
			setUserProp target "wwmt_mapChannel" m
		),
		function setConstantdirectionallight m = (
			constantdirectionallight = m
			target.constantdirectionallight = m
			setUserProp target "wwmt_constantdirectionallight" m
		),	
		function setAmbientboost mp = (
				ambientboost = mp
				target.ambientboost = mp
				if mp == true then (

					setUserProp target "wwmt_ambientboost"  "true"
				) else (
					setUserProp target "wwmt_ambientboost"  "false"
				)
				

		),
		
		function setLock mp = (
			if target != undefined then (
					locked = mp	
				target.locked = mp
				if mp == true then (

					setUserProp target "wwmt_lock"  "true"
				) else (

					setUserProp target "wwmt_lock"  "false"
				)
			) 
		),
		
		function setNoselfcollisions mp = (
			noselfcollisions = mp	
			if isValidNode target  then (		
				target.noselfcollisions = mp
				if mp == true then (
					setUserProp target "wwmt_noselfcollisions"  "true"
				) else (
					setUserProp target "wwmt_noselfcollisions"  "false"
				)
			) 
		),
		function setAutoHull mp = (
			autoHull = mp
			if  isValidNode target  then (
				target.autoHull = mp
				if mp == true then (

					setUserProp target "wwmt_autoHull"  "true"
				) else (

					setUserProp target "wwmt_autoHull"  "false"
				)
			) 
		),
		
		function setLocalOrigin mp = (
			useLocalOrigin = mp
			
			if isValidNode target  then (
				
				target.useLocalOrigin = mp
				if mp == true then (

					setUserProp target "wwmt_useLocalOrigin"  "true"
				) else (

					setUserProp target "wwmt_useLocalOrigin"  "false"
				)
			) 
		),
		
		
		function setRotateRefsystem mp = (
			if target != undefined then (
				rotateRefsystem = mp
				if isValidNode target then (
					target.rotateRefsystem = mp
					if mp == true then (

						setUserProp target "wwmt_rotateRefsystem"  "true"
					) else (

						setUserProp target "wwmt_rotateRefsystem"  "false"
					)
				)	
			) 
		),
		


		function setinternalOrigin mp = (
			if target != undefined then (
				internalOrigin = mp
				target.internalOrigin = mp
				if mp == true then (

					setUserProp target "wwmt_internalOrigin"  "true"
				) else (

					setUserProp target "wwmt_internalOrigin"  "false"
				)
			) 
		),
		
		
		
		
		
		function setJointConstraints mp = (
			if target != undefined AND (mp == true OR mp == false) then (
				jointConstraints = mp
				target.jointConstraints = mp

			) 
		),	
		function setConcave mp = (
			if target != undefined then (
				concave = mp
				target.concave = mp
				if mp == true then (
					setUserProp target "wwmt_concave"  "true"
				) else (
					setUserProp target "wwmt_concave"  "false"
				)
			) 
		),
		
	function setNormalMethod sp = (
		
			normalMethod = sp
			if isValidNode target then (
		
				target.normalMethod = sp
			
				setUserProp target "wwmt_normalmethod"  (sp as string)
			) else (
			  --messagebox "Please choose a model before changing any export settings."
			)

	),
	
	function setSurfaceProperty sp = (
		

			if sp == undefined then (
				sp = ""
			)
			surfaceprop = sp
			target.surfaceprop = sp
			if target != undefined then (
				setUserProp target "wwmt_surfaceprop"  sp
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)

		
	),
		function setStaticprop mp = (
			if target != undefined then (
				staticprop = mp
				target.staticprop = mp
				if mp == true then (
					setUserProp target "wwmt_staticprop"  "true"
				) else (
					setUserProp target "wwmt_staticprop"  "false"
				)
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),
		
		function setShadowlod mp = (
			if target != undefined then (
				shadowlod = mp
				--target.shadowlod = shadowlod
				if mp == true then (
					setUserProp target "wwmt_shadowlod"  "true"
				) else (
					setUserProp target "wwmt_shadowlod"  "false"
				)
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),		
		
		function setOpaque mp = (
			if target != undefined then (
			opaque = mp
			target.opaque = opaque
			if mp == true then (
				setUserProp target "wwmt_opaque"  "true"
			) else (
				setUserProp target "wwmt_opaque"  "false"
			)
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),
		function setAltOrigin mp = (
			if target != undefined then (
			altOrigin = mp
			target.altOrigin = altOrigin
			if mp == true then (
				setUserProp target "wwmt_altOrigin"  "true"
			) else (
				setUserProp target "wwmt_altOrigin"  "false"
			)
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),

		function setAutomass mp = (
			if target != undefined then (
			automass = mp
			target.automass = automass
			if mp == true then (
				setUserProp target "wwmt_automass"  "true"
			) else (
				setUserProp target "wwmt_automass"  "false"
			)
			) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),
		
		function setMostlyOpaque mp = (
			if target != undefined then (
			mostlyopaque = mp
			target.mostlyopaque = mostlyopaque
			if mp == true then (
				setUserProp target "wwmt_mostlyopaque"  "true"
			) else (
				setUserProp target "wwmt_mostlyopaque"  "false"
			)
					) else (
			  messagebox "Please choose a model before changing any export settings."
			)
		),
		
	function fetchFromTarget obj = (
		
		
		
		),	
		function createSelectionSets=(
			modelSetName = "wwmt_Models_"+target.name
			--selectionSets[modelSetName] = targets
		
		   -- setUserProp target "wwmt_modelSetName"  modelSetName
			
			--physSetName = "wwmt_Phys_"+target.name
				
		    --setUserProp target "wwmt_physSetName"  physSetName
		),
		
		function remakeHullNames = (
				s = ""
					
				if hulls != undefined do (
				
				iteration = 1
				
				for so in hulls do (
					
					if isDeleted so then(
						deleteItem hulls (findItem hulls so)


					) else(
						if iteration > 1 do (
							append s ","
						)
			
						append s so.name
						iteration = iteration + 1

						)
						if findItem target.hulls so then (
							append target.hulls so
						)
				)
				--if hulls.count > 0 do (
					--selectionSets[physSetName] = hulls	
				--)
			)
			setUserProp target "wwmt_hulllist"  s

		),
	function makeLOD i obj percent rename &wwmt updateui:true= (
		disableSceneRedraw()
		--include "$scripts/WallWorm.com/WallWormModelTools/ww_struct_lod.ms"


			global wwmt_LODOptimize 
			global wwmt_lodLimit 
			global wwmt_refLOD 

		
		
		--try(
		
		--llayer = ww_CreateLayer layer	
		
			newLod = ww_lod();
					
			newLod.wrapper = wwmt
					
					

					--setTransformLockFlags newLod.item #all

					
					--wire the new LOD's position/rotation to the original
					--tieToTargetPosition newLod.item
					--WHERE I LEFT OFF
					--select newLod.items
					--modPanel.addModToSelection (MultiRes ()) ui:on
					--newLod.items.modifiers[#MultiRes].reqGenerate = off
					
					
					--Set the LOD's MultiRes vertexPercentage to the value mapped in the array vertexPercentages
					--You can tweak it to your needs later by selecting newLod in viewport
					


					
					--assign the LOD level to the LOD for use later in functions to find the right LOD
					newLod.level = i
					newLod.newMR makeNew:true

					if obj == target then (
						for sr in targets do (
						
							--if sr == target then (
								--newitem = newLod.item
								--) else(
								--
							if wwmt_refLOD == "true"  then (
							
							
								newItem = reference sr
							) else (
								
								newItem = copy sr

							)
							
							setUserPropBuffer newItem ""
							
							global wwmt_LODOptimize
							
							
							if wwmt_LODOptimize != 3 AND newLod.mr != undefined then (
								addModifier newItem newLod.mr
							)
							
								--)
							
						if rename == undefined do (
						 newItem.name = sr.name + "_LOD"+i as string
						)





						--lock LOD transforms
						setTransformLockFlags newItem #all

					newItem.position.controller = sr.position.controller
					newItem.rotation.controller = sr.rotation.controller
					newItem.scale.controller = sr.scale.controller
					
					

					append newLod.items newItem	


					--create the gizmo that sets the LOD distance


					)
					
					
					
					
				) else (
					append newLod.items obj
					--newLod.appendItem obj
					newLod.findFirstMod()
				)
				
				newLod.setGizmo(toValue)
				
				newLod.res = percent
				newLod.setCustomAttributes()
				

				ww_SetObjLayer newItem layer	
					
				
				

					
					
					/*
					if wwmt_createLayers == true then (
						selectionSets[slName] = newLod.items
						select selectionSets[slName]
					)*/
					--freeze selection
					hide selection		

						

					


					--if llayer != undefined do (
					--llayer.addNode 
					ww_SetObjLayer newLod.helperGizmo layer	
					--)
					newLod.helperGizmo.radius = 50 * i
		
				
		
		        if( lods.count >= i ) then (
					lods[i] = newLod
				) else (
					lods = append lods newLod
				)
		
				
				if updateui then (
					select newLod.helperTape
					
					--itemName = "pickLOD"+i as string
					try (
					selStr = "wwToolsFloater.rollouts[4].pickLOD"+i as string+".caption = ww_scene_lods.lods["+i as string+"].item.name"
					execute selStr as string
					) catch ()
					try (
					selStr = "wwToolsFloater.rollouts[4].btnPickLOD"+i as string+"Helper.enabled = true"
					execute selStr as string
					selStr = "wwToolsFloater.rollouts[4].btnViewLOD"+i as string+".enabled = true"
					execute selStr as string
					
					selStr = "wwToolsFloater.rollouts[4].spnLOD"+i as string+".enabled = true"
					execute selStr as string
						
						
					selStr = "wwToolsFloater.rollouts[4].addSelLOD"+i as string+".enabled = true"
					execute selStr as string

					selStr = "wwToolsFloater.rollouts[4].appendLOD"+i as string+".enabled = true"
					execute selStr as string						
						
				
			n = i+1
			if n < wwmt_lodLimit do (

				
				selStr = "wwToolsFloater.rollouts[4].pickLOD"+n as string+".enabled = true"
					execute selStr as string
				
				
			)	


					
					
			
			
			
			
					) catch()
		)
					
					enableSceneRedraw()
					return newLod
				--) catch()
				--
		
		),

	function selectItems = (
		
		
		for so in items do (
			
			
			)
		
		),
		
	function getLegacyLODS = (
		/*
			Used to get LOD values from before WW 2.05
		*/
				for lodl = 1 to wwmt_lodLimit do (
					
					local lodstr = "wwmt_LOD" + lodl as string
					local lodname = getUserProp target lodstr	
					if  ( lodname != undefined ) then (
						local lodObject = getNodeByName  lodname
						if isValidNode lodObject  do (
							lods[lodl] = ww_lod()
							lods[lodl].wrapper = wwmt
							lods[lodl].level = lodl
							--lods[lodl].items[1] = lodObject
							templist = getUserProp lodObject "wwmt_lodlist"
							if templist != undefined do (
								for word in (filterString templist ",") do( 
									n = getNodeByName word
									if (n != undefined AND isDeleted n == false) do (
										append lods[lodl].items n
										--print n.name
									)
								)
							)
							
							
							local lodhelperPoint = getUserProp lodObject "wwmt_LOD_Point_Helper"	
								if lodhelperPoint != undefined do (
								    helperObj = getNodeByName lodhelperPoint
									if helperObj != undefined do (
									
										lods[lodl].helperTape = helperObj
										--print "helper pointer assigned"
									)
								)
								
							local lodGizmo = getUserProp lodObject "wwmt_LOD_Gizmo"	
							if lodGizmo != undefined do (
								gizmoObj = getNodeByName lodGizmo
								if gizmoObj != undefined AND classOf gizmoObj == Sphere do (
									lods[lodl].helperGizmo = gizmoObj
									paramWire.disconnect lods[lodl].helperGizmo.baseObject[#Radius]
								)
							)
							
							modName = target.name+"_LOD_"+lodl as string+"_MultiRes"	
							for m in lodObject.modifiers do (
								if (classof m == MultiRes OR classof m == ProOptimizer) AND m.name == modName do (
									--print m.vertexPercent as string
									lods[lodl].mr = m
									--print lods[lodl].mr.name
									lods[lodl].res = lods[lodl].mr.vertexPercent
									
									) 
							)
							
							if lods[lodl].res == undefined do (
								--try (
								lods[lodl].res = wwmt_vertexPercentages[lodl]
								--) catch ()
							)		
							
							if lods[lodl].helperGizmo == undefined OR lods[lodl].helperTape == undefined then (
								 lods[lodl].setGizmo lodl
							) else (
								lods[lodl].makeMatShell()
							)
							

							lods[lodl].setCustomAttributes()
					)	

					
					) else (
						
						--deleteItem lods lodl
					)
					
				)
	),	
		
		
	function setTargetModel obj &wwmt recurse:false skipSequencesIfPresent:true= (
		
			
		/*
			if (wwmt_valid_geometry obj ==false) do (
				--return false
			) 
		*/
		
		
				local startObj = obj

				if classof obj == XRefObject then (
					obj = obj.GetSourceObject true
					isXref = true
				)
		

					init()
				    createWWMT = false
			
					
		
		
		
					if isProperty obj "wwmt_ca" then (
						/*This is a WWMT 2.0 object*/
						createWWMT = false
						target = obj
						

					) else (
						
						
						
						
						
							sname = getUserProp obj "wwmt_proxie_source"
							if sname != undefined then (
								target = getNodeByName sname
								if (target == undefined OR target==obj) then (
									createWWMT = true
								) else (
									/*This is a WWMT Proxie*/
									createWWMT = false
								)
							) else (	
									
								helperVal = getUserProp obj "wwmt_source_helper"
								if helperVal != undefined then (
									/*This is a WWMT 1.0 object*/
									target = obj
									createWWMT = false
									
								) else (
									/*
										sname = getUserProp obj "wwmt_source"
										if sname != undefined then (
											target = getNodeByName sname
											if (target == undefined OR target==obj) then (
												createWWMT = true
												) else (
													createWWMT = false
													setUserProp obj "wwmt_source" undefined
												
												)
										)*/
									
										createWWMT = true
									)
								
								
							) 
						--)
						
					)
			
			

					

					

					if createWWMT==true then (
						


						
						
						isset = true
						global wwmt_lodLimit 		
						global wallworm_userIni
						global wwmt_default_staticprop 
						global wwmt_use_local_origin 
						global wwmt_def_material_path 
						global wwmt_def_model_path 
						global wwmt_rotateRefsystem
						global wwmt_mappingChannel
						/*
							Get globals for default values in new WWMT object
						*/
						
						target = Text text:"WWMT:" size:50 color:blue
						custAttributes.add target  wallworm_model_tools_CA
						
						--append target.targets obj
						
						setModelName(obj.name)
						
						target.name = uniqueName  ("wwmt_"+modelName+"_")
						target.parent = obj
						target.pos.x = obj.pos.x
						target.pos.y = (obj.pos.y + 100)
						target.pos.z = obj.pos.z


						
						setUserProp target "wwmt_source_helper"  true
						--setUserProp obj "wwmt_source"  target.name
					
						setStaticprop staticprop


						setNormalMethod normalMethod
						
						
						if wwmt_rotateRefsystem == "true" OR wwmt_rotateRefsystem == true then (
							rotateRefsystem = true
						) else (
							rotateRefsystem = false	
							
						)

						
						setRotateRefsystem rotateRefsystem
						setinternalOrigin internalOrigin
						
						if wwmt_use_local_origin == "true" OR wwmt_use_local_origin == true then (
							useLocalOrigin = true
						) else (
							useLocalOrigin = false	
							
						)

						setLocalOrigin  useLocalOrigin

						
						
						setUVW(wwmt_mappingChannel)

					--createSelectionSets()	
					
					
					
					--make a name for a layer for this object	
					layer = "WWMT Layer " + target.name
						
					mPath= GetINISetting wallworm_userIni "Directories" "def_model_path"
					maPath = GetINISetting wallworm_userIni "Directories" "def_material_path"
					
					if mPath != undefined AND mPath != "" do (

						setModelPath mPath
					)
					
						
					if maPath != undefined AND maPath != "" do (

						setMaterialPath maPath

					)
					addObjToObjects obj recurse:true		

					ww_SetObjLayer obj layer	
				--createIlluminationHelper()
					
			return true
		) else (
				--create the info from the obj
				
				
				if NOT isProperty target "wwmt_ca" then (
						global wallworm_model_tools_CA
						custAttributes.add target  wallworm_model_tools_CA	
					
						/*Get Params from legacy WWMT where the following properties were stored in userprop data. Now stored in a custom attribute.*/		
					
						local exclude = getUserProp target "wallworm_exclude_vmf"
					
						if exclude != undefined then (
							target.exclude_vmf = exclude
						)
						
						
						local sk = getUserProp target "wwdt_skybox_export"
					
						if sk != undefined then (
							target.skybox = sk
						)
						
					


						physname = getUserProp target "wwmt_phys_copy"
						
						
						modelName = (getUserProp target "wwmt_modelname") as string
						if modelName == undefined do(
							modelName = "modelname"
						)
						if physname != undefined do (
							physObj = getNodeByName (physname as string)
						
							if physObj != undefined do (
							
							phys = physObj
							
								
											
								
								
								
							massobjname =  getUserProp target "wwmt_mass_helper"
							if massobjname != undefined do (
								massoriginObj = getNodeByName (massobjname as string)
								if massoriginObj != undefined AND classof massoriginObj == Point then (
									massorigin = massoriginObj
								) else (
									
									--createMassHelper()
									
									)
								
							)
							
						

						
							if massorigin != undefined then (
								masscenter = massorigin.controller.position
							) else (
								masscenter = [0,0,0]
							)

							)
						)
						
						temphulls = getUserProp target "wwmt_hulllist"
						if temphulls != undefined do (
							for word in (filterString (temphulls as string) ",") do( 
								n = getNodeByName word
			
								if (n != undefined AND isDeleted n == false) do (
									/*
									if findItem target.hulls n == 0 then (
										append target.hulls n
									)*/
									
									append hulls n
								)
								--print word
							)
						
							target.hulls = hulls
						)
							
						
							
							
							
						materialPath = (getUserProp target "wwmt_materialPath") as string
						modelPath = (getUserProp target "wwmt_modelPath") as string
						surfaceprop = (getUserProp target "wwmt_surfaceprop") as string
						
						staticprop = getUserProp target "wwmt_staticprop"	
						opaque = getUserProp target "wwmt_opaque"	
						mostlyopaque = getUserProp target "wwmt_mostlyopaque"	
						mass = getUserProp target "wwmt_mass"
						altOrigin = getUserProp target "wwmt_altOrigin"
						automass = getUserProp target "wwmt_automass"
						concave = getUserProp target "wwmt_concave"
						useLocalOrigin = getUserProp target "wwmt_useLocalOrigin"
						if (useLocalOrigin == undefined OR useLocalOrigin == "") AND (wwmt_use_local_origin == "true") do (
							useLocalOrigin = true
						)
						
						internalOrigin = getUserProp target "wwmt_internalOrigin"
						if (internalOrigin == undefined OR internalOrigin == "") do (
							internalOrigin = true
						)
							
							
							
							
					
						noselfcollisions = getUserProp target "wwmt_noselfcollisions"
						if (noselfcollisions == undefined OR noselfcollisions == "") do (
							noselfcollisions = false
						)
						
						
						
						animatedfriction = getUserProp target "wwmt_animatedfriction"

						
						mapChannel = (getUserProp target "wwmt_mapChannel")
						
						if mapChannel == undefined do (
							
							 mapChannel = wwmt_mappingChannel 
						)
						mapChannel = mapChannel as integer
						
						mscale = getUserProp target "wwmt_scale"
							
							
						
						morphasvta = getUserProp target "wwmt_morphasvta"
						if morphasvta == undefined OR morphasvta == "" do (
							morphasvta = true
						)
						ambientboost  = getUserProp target "wwmt_ambientboost"
						constantdirectionallight = getUserProp target "wwmt_constantdirectionallight"
						
					
						

						
						contents = getUserProp target "wwmt_contents"
						inertia  = getUserProp target "wwmt_inertia" 
						damping= getUserProp target "wwmt_damping"
						phdrag = getUserProp target "wwmt_phdrag"

						rotDamping = getUserProp target "wwmt_rotDamping"
						jointConstraints = getUserProp target "wwmt_jointConstraints"

						autoHull = getUserProp target "wwmt_autoHull"


						locked= getUserProp target "wwmt_lock"
						if locked==undefined do (
							locked  = false
						)
						
						base= getUserProp target "wwmt_base"
						health = getUserProp target "wwmt_health"
						allowstatic = getUserProp target "wwmt_allowstatic"
						physicsmode = getUserProp target "wwmt_physicsmode"
						blockLOS = getUserProp target "wwmt_blockLOS"
						AIWalkable = getUserProp target "wwmt_AIWalkable"
						dmg_bullets = getUserProp target "wwmt_dmg_bullets"
						dmg_club = getUserProp target "wwmt_dmg_club"
						dmg_explosive = getUserProp target "wwmt_dmg_explosive"
						ignite = getUserProp target "wwmt_ignite"
						explosive_resist = getUserProp target "wwmt_explosive_resist"
						flammable = getUserProp target "wwmt_flammable"
						explosive_damage = getUserProp target "wwmt_explosive_damage"
						breakable_model = getUserProp target "wwmt_breakable_model"
						breakable_count = getUserProp target "wwmt_breakable_count"
						breakable_skin = getUserProp target "wwmt_breakable_skin"
						multiplayer_break = getUserProp target "wwmt_multiplayer_break"
						explosive_radius = getUserProp target "wwmt_explosive_radius"
						fadetime = getUserProp target "wwmt_fadetime"
						motiondisabled = getUserProp target "wwmt_motiondisabled"
						normalMethod = getUserProp target "wwmt_normalmethod"
						if normalMethod == undefined then (
							normalMethod = 1
						)
						
						
						shaderType = getUserProp target "wwmt_shader"
						if shaderType == undefined do (
							
							shaderType = "VertexLitGeneric"
						)

							
						lockInitialOrigin = getUserProp target "wwmt_lockInitialOrigin"
						
						
						
						local rotateRefsystem1 = getUserProp target "wwmt_rotateRefsystem"
						if rotateRefsystem1 != undefined then (
							rotateRefsystem = rotateRefsystem1
						)
						
						
							tempgibslist = getUserProp target "wwmt_gibslist"
							if tempgibslist != undefined do (
								
								for word in (filterString (tempgibslist as string) ",") do (
									
									n = getNodeByName word
									if (n != undefined AND isDeleted n == false) do (
										appendGibs n 
										
										)
									
									
									)
								
								
								)
						
								
				
						
							illumobjname =  getUserProp target "wwmt_illumination_helper"
							if illumobjname != undefined do (
								illumoriginObj = getNodeByName illumobjname
								if illumoriginObj != undefined AND classof illumoriginObj == Point do (
									illumorigin = illumoriginObj
								) 
								
							)
							
							
							
							camobjname =  getUserProp target "wwmt_cam"
							if camobjname != undefined do (
								camObj = getNodeByName camobjname
								if (camObj != undefined AND (classof camObj == targetCamera OR classof camObj == freeCamera))  do (
									cam = camObj
									setCamChangeHandler()
								) 
								
							)	
								
							
							templist = getUserProp target "wwmt_targetslist"
							if templist != undefined do (
								for word in (filterString (templist as string) ",") do( 
									n = getNodeByName word
									if (n != undefined AND isDeleted n == false) do (
										
										if findItem target.targets n == 0 then (
											append target.targets n
										)
										append targets n
									)
								)
							)
							
								
							templist = getUserProp target "wwmt_sequencelist"
							if templist != undefined do (
								for word in (filterString templist ",") do( 
									append sequencelist word
									--print word
								)
							
								sort sequencelist
								
								makeSequenceListFromCust getFromOld:true	
								
							)
									
							getLegacyLODS()
								
							setWWMTAttribFromThis()
							--target.updateWWMTFromThis()
					
				) else (
					
					
					/*
					Get properties from WWMT Custom Attribute added in WWMT 2.0		
					*/
					
					
/**/
							
					local v = target.baseobject.Wallworm_Model_Tools.version
					case of (
						
						(v < 12): (
							getLegacyLODS()
							
							wallworm_update_wwmt_cas target
							
							if lods.count > 0 then (
								
								for l in lods do (
									l.wrapper = this
									l.setCustomAttributes()
								)
								
								target.lods = for l in lods collect l.helperTape
							)
							
						)
						(v < 14):  (
							wallworm_update_wwmt_cas target
						)
						default:()
					)		
							
							
	

					getParamsFromWWMTAttrib()
					
					
				)
			
			
				
				if lods.count > 0 then (
					
					for l in lods do (
						l.wrapper = this
					)
					
					
				)


				
				getParticleSystems()
		
				
				idleSequence = getUserProp target "wwmt_idleSequence"
				if (idleSequence == undefined OR idleSequence == "" OR idleSequence=="true" OR idleSequence==true) then (
					idleSequence = true
				) else (
					idleSequence = false
				)

				
				
	
					
				modelSetName = getUserProp target "wwmt_modelSetName" 
				physSetName= getUserProp target "wwmt_physSetName"
				shadowlod = getUserProp target "wwmt_shadowlod"
			
				
				collapsebones = getUserProp target "wwmt_collapsebones"
				
				if collapsebones == undefined OR collapsebones == "" OR collapsebones == false OR collapsebones == "false" then (
					collapsebones = false
				)	else (
					
				 collapsebones = true	
				)
	


				if target.sequences.count > 0 then (
					makeSequenceListFromCust()	
				)


					
					
					
				
				
				templist = getUserProp target "wwmt_weightlists"
				if templist != undefined do (
					for word in (filterString templist ",") do ( 
						append weightlistnames word
						--print word
					)
				
					sort weightlistnames
					
					makeWeightListFromCust()	
					
				)
				
				
				
				--weightlistnames=#(),
				--weightlists=#(),
				
				
				
				templist = getUserProp target "wwmt_attachmentlist"
				if templist != undefined do (
					for word in (filterString templist ",") do( 
						
						append attachmentlist word

					)
				
					sort attachmentlist
					
					makeAttachmentListFromCust()	
					
				)
				
				


	
				expHL1Format=getUserProp target "wwmt_expHL1Format"

				
		
				

				
				if illumorigin != undefined then (
				illumposition = illumorigin.controller.position
				) else (
					illumposition = [0,0,0]
				)
				

				--include "$scripts/WallWorm.com/WallWormModelTools/ww_struct_lod.ms"	
					
					


					
				if hasProperty target "text" == true then (
					target.text = ("WWMT: "+modelName)
				)
				
				
				return true
			)

			
	),
	function createIlluminationHelper = (
		illuminationName = target.name + "_illuminationorigin"
		setUserProp target "wwmt_illumination_helper" illuminationName
		
	
		if isValidNode targets[1] then (
			helperpos = targets[1].pos
		) else (
			helperpos = target.pos
		)	
		
		illumorigin =  Point name:illuminationName pos:helperpos Box:on centermarker:on cross:off axistripod:off wirecolor:yellow size:64
		illumorigin.parent = targets[1]
		
		target.illumorigin = illumorigin
		
		ww_SetObjLayer illumorigin layer	
		
	),
	function createMassHelper = (
		massName = target.name + "_massorigin"
		setUserProp target "wwmt_mass_helper" massName

		oldmassorigin = getNodeByName massName
			
		if oldmassorigin != undefined AND isDeleted oldmassorigin == false do (
			delete oldmassorigin
		)

		if isValidNode targets[1] then (
			helperpos = targets[1].pos
		) else (
			helperpos = target.pos
		)	

				
		massorigin =  Point name:massName pos:helperpos Box:on centermarker:on cross:off axistripod:off wirecolor:blue size:64

		target.massorigin = massorigin

		massorigin.parent = targets[1]
		ww_SetObjLayer massorigin layer
		
		),	
	function makeLodsArray toValue &wwmt= (
			max select all
			clearNodeSelection()
		
		if toValue == undefined do (
			toValue = 1
		)
		--get the layer associated with this function
		llayer = ww_CreateLayer layer	
		--layer = llayer

		
		
		wwmt_vertexPercentages = #(75,56.25,42.1875,31.6406,23.73,17.7975,13.348,10.0111,7.5083,5.6312)
			
		--loop to make new ww_lod objects; makes as many LODs as are in the spinner value
		for i = 1 to toValue by 1 do (

			makeLOD i target wwmt_vertexPercentages[i] undefined wwmt


		)

	),
		
	function hideCM = (
		its = for so in hulls WHERE NOT isDeleted so collect so
		if its.count > 0  then (
			hide its
		)
	),
	function showCM = (
		its = for so in hulls WHERE NOT isDeleted so collect so
		if its.count > 0  then (
			unhide its
		)
	),
			
	
	function unhideLod  i = (
		
		its = for so in lods[i].items WHERE NOT isDeleted so collect so
		if its.count > 0  then (
			unhide its
		)
	
	),
	function hideLod  i = (
		its = for so in lods[i].items WHERE NOT isDeleted so collect so
		if its.count > 0  then (
			hide its
		)

	),
	function selectSelectionSets i = (
		select lods[i].items
		
	),

		
	function setLod level obj &wwmt alertMessage:true= (
		
		
		
		
		if lods[level] == undefined then (
			newLod = ww_lod();
			newLod.wrapper = wwmt
			newLod.level = level

			
			newLod.newMR()
			newLod.setGizmo (64 * level)			
			
			lods[level] = newLod
			
		) else (
			
			newLod = lods[level]
			
			
			
		)
		
		
		
		
		
		if wwmt_autoMaterialNewModel == "true" AND obj.material == undefined do (
			
			
			obj.material = getMainMaterial matname:("VMT_"+modelName+"_"+obj.name)

				
		)
		
		append newLod.items obj
		newLod.setCustomAttributes()
		
		return l 
	),
	function makeLodGroup = (
		message = "This function is disabled in the current version of WWMT."
		messageBox message
		),
		
	function processPhys = (

		try (
		wwmt_applyWWMTHullMaterial(phys)
		
		ww_SetObjLayer phys layer
		) catch()
	),
	function appendHull obj = (
		
		
		
		if classOf obj == ObjectSet then (
			
			for i in obj do (
				
				if (wwmt_valid_geometry i == false) do (
					return false
				) 	

				)
			
			
			) else (

				if (wwmt_valid_geometry obj == false) do (
					return false
				) 	

			
			)
			

				
				if (append  target.hulls obj) == true do (
					wwmt_applyWWMTHullMaterial(obj)
					ww_SetObjLayer obj layer
					remakeHullNames()
				
			)
			
			if target.hulls != undefined AND target.hulls.count > 0 then (
				
				autoHull = false
				setAutoHull false
			)
			hulls = target.hulls as array
			return true
	),
	

	function tieToTargetPosition obj =(
			
					paramWire.connect targets[1].pos.controller[#X_Position] obj.pos.controller[#X_Position] "X_Position"
					paramWire.connect targets[1].pos.controller[#Y_Position] obj.pos.controller[#Y_Position] "Y_Position"
					paramWire.connect targets[1].pos.controller[#Z_Position] obj.pos.controller[#Z_Position] "Z_Position"
 					paramWire.connect2way targets[1].rotation.controller[#X_Rotation] obj.rotation.controller[#X_Rotation] "X_Rotation" "X_Rotation"
 					paramWire.connect2way targets[1].rotation.controller[#Y_Rotation] obj.rotation.controller[#Y_Rotation] "Y_Rotation" "Y_Rotation"
 					paramWire.connect2way targets[1].rotation.controller[#Z_Rotation] obj.rotation.controller[#Z_Rotation] "Z_Rotation" "Z_Rotation"
					
			
	),
	function addPhysModel obj = (
		
		
		if wwmt_valid_geometry obj == false then (
			
			return false
			
			) else (
			

		originalName = obj.name
				
		if phys != undefined do (
			if ( isDeleted phys ==false) then (
			oldName = getUserProp phys "wwmt_original_name"
			) else (
				oldName = ""
				)
			if oldName != undefined and oldName != "" then (
				
				phys.name = oldName
				
				) else (
					try (
					oldName = oldPhys.name + "_old"
					phys.name = oldName
					) catch()
				)
			
			)			

			--if copyTarget == "true" OR obj == targets[1] then (
			if (findItem targets obj)!=0 then (
				phys = copy obj
				convertTo phys Editable_Poly			
				
				newPhysName = target.name as string
		        newPhysName+="_hull"		
				phys.name = newPhysName
			) else (
				phys = obj
				
			)

		
			--append hulls phys
				
				
				

			
		setUserProp obj "wwmt_phys_copy"  phys.name
		setUserProp target "wwmt_phys_copy"  phys.name
		setUserProp phys "wwmt_phys_source"  obj.name
		setUserProp phys "wwmt_target"  target.name
		setUserProp phys "wwmt_original_name" originalName
			
		--phys.parent = targets[1]
		--tieToTargetPosition phys
			
		processPhys()	
		--createMassHelper()
			
		if obj != target do (
		  -- hide obj
		)
		return appendHull(phys)
		)
	),
	function addAHull obj = (
		if target.hulls.count == 0 then (
			return addPhysModel obj
		) else (
			return appendHull obj
		)
	),			
					
	function removeItemFromHulls obj = (
		ind = findItem target.hulls obj
		
		if ind>0 do (
			deleteItem target.hulls ind
			remakeHullNames()
		)
		hulls = target.hulls as array
	),	
	function removeItemsFromHulls sel =(
			for obj in sel do (
				removeItemFromHulls(obj)
				
				)
			
			
			),

				function canCompile type= (

				can = false
				
				if type == "tex" do (
					
					if materialPath == undefined OR  materialPath == "" do (
						return false
					)
					
					can = wallworm_binSet type
					
				)
				if type == "model" do (
					if modelPath == undefined OR  modelPath == "" do (
						return false
					)
					can = wallworm_binSet type
				)
				
				
				return can
	
	),
	function resetHullBonesarray = (
		hullbonesarray = #()		
		hullbonesarray = target.bonelist	as array
		for t in hulls WHERE isValidNode t do (
				if t.modifiers[#skin] != undefined then (
					global wallworm_getBonesFromSkin	
					join hullbonesarray ((wallworm_getBonesFromSkin t.modifiers[#skin]) as array)
				) else(
					 --print "no modifiers"
				)
		)
		hullbonesarray = makeUniqueArray hullbonesarray 
	),
	function resetBonesArray = (
		bonesarray = #()	
		bonesarray = target.bonelist	as array
		for t in targets WHERE isValidNode t do (
				if t.modifiers[#skin] != undefined then (
					global wallworm_getBonesFromSkin	
					join bonesarray ((wallworm_getBonesFromSkin t.modifiers[#skin]) as array)
				) else(
					 --print "no modifiers"
				)
		)
		bonesarray = makeUniqueArray bonesarray 
	),
		

		
		function boneNameList = (
			local out = #("")
			for b in bonesarray where isvalidnode b do (
				appendIfUnique out b.name
				
				
				)
			
				return out
			),
			
		function populateBodyGroups = (
				bodygroups=#()
				global ww_wwmt_bodygroup
				if ww_wwmt_bodygroup == undefined then (
					fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_bodygroup.ms"
				)
				if target.children.count > 0 do (
					 
					
					for c in target.children do (
						
						local hp = ww_wwmt_bodygroup()
						hp.setHelper c refNode:(getRefNode())
							
						if hp.bgmodels.count > 0 do (
							
							append bodygroups hp
							)
						
						
						)
					
				)
				
				
		),	

		
		function exportBodyGroups tempRefNode:undefined = (
			-- !TODO ... add code to exclude exporting SMDs that were already exported
			if bodygroups.count > 0 do (

				--if tempRefNode == undefined then (
					tempRefNode = getRefNode()
				--)
				--local tempRefNode = Box pos:referenceNode.pos
				
				
				for b in bodygroups do (
					
					for m in b.bgmodels WHERE isValidNode m AND m != target do (
						
						if findItem alreadyExported m == 0 then (
							m.getWWMT()
							m.wwmt.alreadyExported = join m.wwmt.alreadyExported alreadyExported
							
							if findItem alreadyExported m.wwmt.target == 0 then (
								m.wwmt.sequences =  join m.wwmt.sequences sequences

								m.wwmt.resetBonesArray()
								
							    m.wwmt.modelPath = modelPath
								--m.wwmt.setRefNode n:(getRefNode())
								m.wwmt.offsetFaces = true
								m.wwmt.staticprop = false
								--m.wwmt.useLocalOrigin = useLocalOrigin
								m.wwmt.internalOrigin = internalOrigin
								--m.wwmt.rotateRefsystem = rotateRefsystem
								
								--if useLocalOrigin == false then (
								m.wwmt.referenceNode = tempRefNode
								--) else (
									--m.wwmt.getRefNode()
								--)
								m.wwmt.outputModelQC resetExportList:false forceBoneReset:false
								
								alreadyExported = join alreadyExported m.wwmt.alreadyExported
								appendIfUnique alreadyExported m.wwmt.target
							)
							
						)
					)
					
					
					
					
				)
				
				--delete tempRefNode
					
			)
		
		),


		
			function getBodygroupMats = (
					matstring = ""
					
					if target.mat != undefined AND classOf target.mat == MultiMaterial then (
						t="$texturegroup \""+modelName+"_skins\"\n{\n\n"
						append matstring t
				

					for m in target.mat.materialList do (
						
						if  m != undefined do (
							/*
						   if classOf m == Standard AND m.diffuseMap != undefined AND classOf m.diffuseMap == BitmapTexture AND m.diffuseMap.filename != undefined then (
							skinName = getFilenameFile m.diffuseMap.filename
							   if getFileNameType m.diffuseMap.filename == ".ifl" then (
								   append skinName "0"
								   )
						   ) else (
							   skinName = m.name
							)
							*/
							
							if classOf m == MultiMaterial then (
								skinName = ""
								for m2 in m.materialList do (
						
									if  m2 != undefined do (
										
										skinName +=" \""+ (wallworm_getMaterialName m2  forModel:true)+"\""
										
										)
														
								)
								
							) else (
								skinName =" \""+ (wallworm_getMaterialName m  forModel:true)+"\""
							)
							
						  t=" { "+skinName+" }\n"
						  append matstring t
						
						)
					)
					t="\n}\n"
					append matstring t	
				)
					matstring
			),		
		
		
	function appendBitmaps &mat &materials getNameFromPath:false= (
	
	
	if mat != undefined do (
		
		inList = false
			for m in materials while inList == false do (	
		--for m in materials do (
			try (
				if m.mat == mat  do (inList=true)
			) catch()
			)
		
		if(inList ==false) do(
		if (classOf mat == Standardmaterial ) then (
			
			

					vmt = ww_vmt()
					vmt.mat = mat
					vmt.materialPath = materialPath
					vmt.compression = compression
					vmt.getNameFromPath = getNameFromPath
--print getNameFromPath			
			--if mat.diffuseMap != undefined do (
				
				--if classOf mat.diffuseMap == Bitmaptexture then (

			
					if mat.diffuseMap != undefined AND classOf mat.diffuseMap == BitmapTexture AND mat.diffuseMap.filename != undefined do (

						

						--parsedFilename = filterString (filenameFromPath mat.diffuseMap.filename) "."
						
						
						--if toLower (parsedFilename[parsedFilename.count] ) == "tga" do (
							if ( vmt.isValidBitmap  (toLower (getFilenameType mat.diffuseMap.filename))  == true) do (
							
							--include "$scripts/WallWorm.com/common/ww_struct_mat.ms"
							
							--appendIfUnique bitmaps mat.diffuseMap.filename

								vmt.diff = mat.diffuseMap.filename

							)

						)
								
								
							--print vmt.diff 
							
						--if mat.refractMap != undefined AND mat.refractMapEnabled == true then (
							--)
						
							vmt.setShader shaderType
							vmt.forModel = true

							if opaque != undefined AND opaque == true do (
									vmt.forceOpaque = true
							)
							
				if mat.refractionMap  != undefined AND classOf mat.refractionMap == BitmapTexture do (

						if mat.refractionMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if (vmt.isValidBitmap  (toLower (getFilenameType mat.refractionMap.filename))  == true  ) do (

								vmt.refract = mat.refractionMap.filename
							
							)
						)

				)
							
							
				--add specular level map as phong exponent texture								
				if mat.specularMap  != undefined AND mat.shaderType == 6 do (
					if classOf mat.specularMap  == Bitmaptexture do (
						if mat.specularMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (toLower (getFilenameType mat.specularMap.filename))  == true ) do (

								vmt.spec = mat.specularMap.filename
							
							)
						)
					)
				)
						

				if mat.specularLevelMap  != undefined do (
					if classOf mat.specularLevelMap  == Bitmaptexture do (
						if mat.specularLevelMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if (vmt.isValidBitmap  (toLower (getFilenameType mat.specularLevelMap.filename))  == true ) do (

								vmt.specLevelMap = mat.specularLevelMap.filename
							
							)
						)
					)
				)				
							
				if mat.ambientMap  != undefined do (
					if classOf mat.ambientMap  == Bitmaptexture do (
						if mat.ambientMap.filename != undefined do (
						--parsedFilename = filterString mat.ambientMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.ambientMap.filename) "."
							if ( vmt.isValidBitmap  (toLower (getFilenameType mat.ambientMap.filename))  == true ) do (

								vmt.ambient = mat.ambientMap.filename
							
							)
						)
					)
				)							
							
							
				if mat.selfIllumMap  != undefined do (
					if classOf mat.selfIllumMap  == Bitmaptexture do (
						if mat.selfIllumMap.filename != undefined do (
						--parsedFilename = filterString mat.selfIllumMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.selfIllumMap.filename) "."
							if (vmt.isValidBitmap  (toLower (getFilenameType mat.selfIllumMap.filename))  == true ) do (

								vmt.illum = mat.selfIllumMap.filename
							
							)
						)
					)
				)			
				
				
				if isProperty mat "lightwarptexture" == true AND mat.lightwarptexture  != undefined do (
					if classOf mat.lightwarptexture  == Bitmaptexture do (
						if mat.lightwarptexture.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.lightwarptexture.filename) == true) do (

								vmt.lightwarptexture = mat.lightwarptexture.filename
								/*
								if coords == true AND (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == "true")  then (
									
									
									vmt.envmapmasktransform = ("center 0 0 scale "+(mat.lightwarptexture.coords.U_Tiling as string)+" "+(mat.lightwarptexture.coords.V_Tiling as string)+" rotate "+((mat.lightwarptexture.coords.W_Angle + 180) as string)+" translate "+(mat.lightwarptexture.coords.V_Offset as string)+" "+(mat.lightwarptexture.coords.U_Offset as string))
									
									
								)
								
							*/
							)
						)
					)
				)	
				
				
				
				detailMap = undefined		
				
				if mat.bumpMap  != undefined do (
					
					
					if classOf mat.bumpMap == Normal_Bump then (
						
						mapToUse = mat.bumpMap.normal_map
						
						
						if mat.bumpMap.bump_map != undefined AND classOf mat.bumpMap.bump_map == Bitmaptexture do (
							detailMap = mat.bumpMap.bump_map
						)
						
						) else (
							mapToUse = mat.bumpMap

						)
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat.bumpMap.filename "."
							if ( vmt.isValidBitmap  (toLower (getFilenameType mapToUse.filename))  == true  ) do (

								vmt.bump = mapToUse.filename
							
							)
						)
					) 
				)							
					

				if mat.displacementMap  != undefined do (
					
					
						if classOf mat.displacementMap == Normal_Bump then (
						
							mapToUse = mat.displacementMap.normal_map
						
							if mat.displacementMap.bump_map != undefined AND classOf mat.displacementMap.bump_map == Bitmaptexture do (
								detailMap = mat.displacementMap.bump_map
							)
						
							
							
						) else (
							mapToUse = mat.displacementMap

						)
					
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat.displacementMap.filename "."
							if (vmt.isValidBitmap  (toLower (getFilenameType mapToUse.filename))  == true ) do (

								vmt.normal = mapToUse.filename
							
							)
						)
					)
				)	


-----
				
						if detailMap != undefined do (
						--parsedFilename = filterString mat.displacementMap.filename "."
							if (vmt.isValidBitmap  (toLower (getFilenameType detailMap.filename))  == true	) do (

								vmt.detail = detailMap.filename
							
							)
						)
				
				
-----
				
				--)
						
						
						
			--)
					
					
					appendIfUnique materials vmt
					--) else (
					
					 -- print (classOf mat.diffuseMap)
					--)
				
				
				--)
			
				if isProperty mat "crackmaterial" == true AND mat.crackmaterial != undefined then (
					
					appendBitmaps mat.crackmaterial materials getNameFromPath:getNameFromPath

				)		
			
			) else (
				if (classOf mat == Multimaterial ) then (
					for m in mat.materialList do (
						appendBitmaps m materials getNameFromPath:getNameFromPath
						)
					) else (
						
						if (classOf mat ==Shell_Material) do (
							
							appendBitmaps mat.bakedMaterial materials getNameFromPath:getNameFromPath
							
							)
						
						)
			)
		)
	)
),	




function getOnlyBonesList meshlist bonelist = (
	
	local theOnlyBones = #()
	for b in bonelist do (
		if findItem meshlist b == 0 then (
			append theOnlyBones b
		)
	)
	
	return theOnlyBones
),

function export_sequence s wwDir:undefined resetBnArray:true= (

	if resetBnArray then (
		resetBonesArray()
	)
	
	if wwDir == undefined then (
		
		local mp = FsToBs modelPath
		global wwmt_export
		local wwDir = wwmt_export + "\\"+mp		
	)


			if wwmtExporter=="3" then (
				
				explist = #()
				join explist (targets as array)
				
				if bonesarray.count > 0 do (
					join explist  (bonesarray as array)
				) 
				
				
			) else (
				
				clearNodeSelection()
				select targets
			
				if bonesarray.count > 0 do (
					selectMore (bonesarray as array)
				) 
			)
	



	global wwmtExporter
		fr = s.fps as string
		seqname = modelName+"_sequence_"+s.sequence
		--seqname = s.sequence
		fname = wwDir +"\\"+seqname + ".smd"

			if wwmtExporter=="3" then (	
				
				--use WWMT MXS SMD Exporter
				smd = 	wallwormSMD()
				smd.type = "Sequence"
				smd.uvwchannel = mapChannel
				smd.range = #()
				
				if s.end == s.start then ( 
					append smd.range s.start
					
				) else (
					local sequenceDir = 1
					
					if s.end < s.start then (
						sequenceDir = -1	
					)
					for r = s.start to s.end by sequenceDir do (
						append smd.range r
					)
					
				)
				smd.makeNodeList explist
				smd.nonRenderableAsBone=exportNonRenderableMeshAsBone	
				--smd.refNode = getRefNode()
				smd.refNode = getRefNode()
				smd.offsetFaces = offsetFaces
					--smd.refNode = targets[1]
				smd.normalMethod = normalMethod	
				smd.origin = useLocalOrigin	
				smd.staticprop = staticprop
				smd.normalMethod = normalMethod	
				smd.internalOrigin = internalOrigin	
				smd.rotateRefsystem = rotateRefsystem	
				if lockInitialOrigin != undefined AND lockInitialOrigin == true then (
					smd.lockInitialOrigin = lockInitialOrigin
					/*local locksys = smd.refNode.transform
					locksys = rotateZMatrix -90 * locksys
					smd.initialReFSystem = locksys
					locksys = undefined*/
				)
				smd.flip = altOrigin
					
				smd.exportSMD fname
				
				
			) else (
			if wwmtExporter=="2" then (	
				ExportSMD fname true false false false false (s.start as string) (s.end as string)
			) else (
				if useOldWBS == false then (
						if WBSMDExportVersionNum() < 1700 then (
							status = WBSMDExport fname true 1 hl1 s.start s.end false false false exportNonRenderableMeshAsBone
						) else(
							status = WBSMDExport fname true 1 hl1 (mapChannel as integer) s.start s.end false false false exportNonRenderableMeshAsBone
						)
				) else (
					try(
						refInt = 1
						setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Type" (refInt as string)
						setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Start" (s.start as string)
						setINISetting "$plugcfg/smdexp.ini" "Batch Config" "End" (s.end as string)
						setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Reverse" (s.expReverse as string)
						setINISetting "$plugcfg/smdexp.ini" "Batch Config" "HL1Format" (expHL1Format as string)

					) catch(
						noPlugWrite = true
					)
					exportFile fname #noPrompt  selectedOnly:true using:SMDExporter
					--print "USED OLD for Sequence"

				)
			)
		)
),
											

function exportSMDS resetBnArray:true runCompile:true = (
	local failed = 0
	global wwmtAutoCompile
	if resetBnArray then (
		resetBonesArray()
	)
	local makeSMDs
	global wwmtExporter
	if wwmtExporter == "3" then (
		makeSMDs = true
	) else (
		theClasses = exporterPlugin.classes
		makeSMDs = false
		for c in theClasses  do (
			--is Jed's Exporter Selected and Installed
			if wwmtExporter=="1" AND c == SMDExporter do (
				makeSMDs = true

			)
				
			--is Cannonfodder's Exporter Selected and Installed
			if wwmtExporter=="2" AND  c== SmdExport do (
				makeSMDs = true
			)
		)
	)
	local exportNotice = ""
	local mp = FsToBs modelPath
	local wwDir = wwmt_export + "\\"+mp		
	
	if ( makeSMDs == true ) then (

	
	
		max select all
		clearNodeSelection()
		
		shouldUpdateSMDExporter = false
		noPlugWrite = false
		


		if wwmt_exportNonRenderableMeshAsBone != undefined AND wwmt_exportNonRenderableMeshAsBone != "" AND (wwmt_exportNonRenderableMeshAsBone == "true" OR wwmt_exportNonRenderableMeshAsBone == true ) then (
			exportNonRenderableMeshAsBone = true
		) else (
			exportNonRenderableMeshAsBone = false
		)

		local useOldWBS = true
		if wwmtExporter=="1" do (
			try(
				if WBSMDExportVersionNum() >= 1600 do (
					useOldWBS = false
				)
				
				if WBSMDExportVersionNum() < 1700 do (
					shouldUpdateSMDExporter = true
				)
				
			) catch(
				
				useOldWBS = true
				shouldUpdateSMDExporter = true
			)
		)
					
					

		local tempRefNode =  getRefNode()
					
			
		if wwmtExporter=="3" then (
				
				explist = #()
				join explist (targets as array)
				
				if bonesarray.count > 0 do (
					join explist  (bonesarray as array)
				) 
				
				
		) else (

			clearNodeSelection()
			select targets
			
			if bonesarray.count > 0 then (
				selectMore (bonesarray as array)
			) else (
				--print "no bones"
			)
		
		)
		hl1 = false
		if expHL1Format == undefined OR expHL1Format == "undefined" do (
			
			expHL1Format = 0
		)
		
		if expHL1Format == 1 do (
			hl1 = true
			
		) 
	
								
		if dmx == true then (
			fileExt =  ".dmx"	
		)	else (
			fileExt = ".smd"
			
		)	
					
		fname = wwDir +"\\"+modelName + fileExt
		
		global wwmt_gameInfoDir
		--added because some mods/installs of Steam won't create the dir when compiling
		if (makeDir (wwmt_gameInfoDir + "\\models\\"+mp) all:true) == true then (
			--print ("created " + (wwmt_gameInfoDir + "\\models\\"+mp) )
		)

		if wwmtExporter=="3" then (	
			
			--use WWMT MXS SMD Exporter

			
			smd = 	wallwormSMD()
			smd.uvwchannel = mapChannel
			/*
			expArray = #()
			join expArray bonesarray
			join expArray targets
			*/
			smd.makeNodeList explist
			
			smd.nonRenderableAsBone=exportNonRenderableMeshAsBone
			smd.refNode = getRefNode()
			--smd.refNode = tempRefNode
			smd.origin = useLocalOrigin
			smd.staticprop = staticprop
			smd.offsetFaces = offsetFaces
			smd.normalMethod = normalMethod
			smd.internalOrigin = internalOrigin
			smd.rotateRefsystem = rotateRefsystem
			smd.flip = altOrigin
			smd.justBones = getOnlyBonesList targets bonesarray
			smd.range=#(0)
			if dmx == true then (
				smd.outtype = "dmx"	
			)
			
			
			smd.exportSMD fname
			
			/*
			if lockInitialOrigin != undefined AND lockInitialOrigin == true then (

				local locksys = smd.refNode.transform
				locksys = rotateZMatrix -90 * locksys

			)
			
			*/
			global wallworm_debug
			
			if wallworm_debug == true then (
				
					global wallworm_smd_debug = smd
			)
			
			
		) else (
			if wwmtExporter=="2" then (	
				
				ExportSMD fname true true false false false "" ""
			) else (
				

				if useOldWBS == false then (
						

						if WBSMDExportVersionNum() < 1700 then (
					
							status = WBSMDExport fname true 0 hl1 0 0 false false false exportNonRenderableMeshAsBone
						) else (
							
							print ("Using 1700 with map channel: "+(mapChannel as string))
							status = WBSMDExport fname true 0 hl1 (mapChannel as integer) 0 0 false false false exportNonRenderableMeshAsBone
							
							)
						--print "USED NEW for mesh"
					--print status
				) else (
						
						--print (getCurrentException())
						try(

							setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Type" "0"
							setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Start" "0"
							setINISetting "$plugcfg/smdexp.ini" "Batch Config" "End" "0"
							setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Reverse" "0"
							setINISetting "$plugcfg/smdexp.ini" "Batch Config" "HL1Format" (expHL1Format as string)
						) catch(
							noPlugWrite = true
							)
					
						exportFile fname #noPrompt  selectedOnly:true using:SMDExporter
						--print "USED OLD"
					
						)
			)
		)
		
		exportNotice += "# Target Model Exported to "+fname

						
		if staticprop != true AND areMorphs() == true AND morphasvta==true do (
			exportVTAs (exportNonRenderableMeshAsBone)
		)
						
						
						
						
		if hulls.count>0 AND (autoHull == undefined OR autoHull==false) do (
			

			for h in hulls do (
				if isDeleted h do (
					deleteItem hulls (findItem hulls h)
				)
			)
			
			if resetBnArray then (

				resetHullBonesArray()
			)
			if wwmtExporter=="3" then (
				
				explist = #()
				join explist (hulls as array)
				
				if hullbonesarray.count > 0 do (
					join explist  (hullbonesarray as array)
				) 
				
				
			) else (
				
				clearNodeSelection()
				select hulls

				if hullbonesarray.count > 0 do (
					selectMore (hullbonesarray as array)
				) 
			)
			

							
			fname = wwDir +"\\"+modelName + "_hull"+fileExt
			try (
								
				if wwmtExporter=="3" then (	
					
					--use WWMT MXS SMD Exporter
					smd = 	wallwormSMD()
					smd.uvwchannel = mapChannel
					smd.makeNodeList explist
					smd.nonRenderableAsBone=exportNonRenderableMeshAsBone
					--smd.refNode = getRefNode()
					smd.refNode = tempRefNode
					smd.offsetFaces = offsetFaces
					--smd.refNode = targets[1]
					smd.origin = useLocalOrigin
					smd.staticprop = staticprop
					smd.normalMethod = normalMethod	
					smd.internalOrigin = internalOrigin
					smd.rotateRefsystem = rotateRefsystem
					smd.flip = altOrigin
					range=#(0)
					smd.justBones = getOnlyBonesList hulls hullbonesarray
					
					if dmx == true then (
						smd.outtype = "dmx"	
					)
					
					smd.exportSMD fname
				) else (
					
					if wwmtExporter=="2" then (	
						ExportSMD fname true true false false false "" ""
					) else (
						
					if useOldWBS == false then (
						
						
						if WBSMDExportVersionNum() < 1700 then (
							status = WBSMDExport fname true 0 hl1 0 0 false false false exportNonRenderableMeshAsBone
						) else (
							
							status = WBSMDExport fname true 0 hl1 (mapChannel as integer) 0 0 false false false exportNonRenderableMeshAsBone
							)
						--print status
						--print "USED NEW for Hull"
						) else (
							
							
							try(

								setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Type" "0"
								setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Start" "0"
								setINISetting "$plugcfg/smdexp.ini" "Batch Config" "End" "0"
								setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Reverse" "0"
								setINISetting "$plugcfg/smdexp.ini" "Batch Config" "HL1Format" (expHL1Format as string)
							) catch(
								noPlugWrite = true
								)
								

							exportFile fname #noPrompt  selectedOnly:true using:SMDExporter
								--print "OLD for hull"
						)
					)
				)
					exportNotice += "\n# Phys Model Exported to "+fname
				) catch (
					print (getCurrentException())
					exportNotice += "\nThe collision model DID NOT EXPORT due to an error!"
					failed=failed+1
				)
			/*END HULLS*/
		)
					
					
		for l in lods do (
			
			if wwmtExporter=="3" then (
				
				explist = #()
				join explist (l.items as array)
				
				if bonesarray.count > 0 do (
					join explist  (bonesarray as array)
				) 
				
				
			) else (
				
				clearNodeSelection()
				select l.items
				if bonesarray.count > 0 do (
					selectMore (bonesarray as array)
				) 
			)
			
			

			fname = wwDir +"\\"+modelName+"_LOD_"+l.level as string + fileExt

				
				if wwmtExporter=="3" then (	
					--use WWMT MXS SMD Exporter
					smd = 	wallwormSMD()
					smd.uvwchannel = mapChannel
					smd.makeNodeList explist
					smd.nonRenderableAsBone=exportNonRenderableMeshAsBone
					--smd.refNode = getRefNode()
					smd.refNode = tempRefNode
					smd.offsetFaces = offsetFaces
					smd.range=#(0)
					--smd.refNode = targets[1]
					smd.origin = useLocalOrigin
					smd.staticprop = staticprop
					smd.normalMethod = normalMethod
					smd.internalOrigin = internalOrigin
					smd.rotateRefsystem = rotateRefsystem
					smd.flip = altOrigin
					smd.justBones = getOnlyBonesList l.items bonesarray
					
					if dmx == true then (
						smd.outtype = "dmx"	
					)
					
					
					
					if (smd.exportSMD fname) then (
						exportNotice += "\n# LOD Level "+l.level as string+" Exported to "+fname
					) else (
						exportNotice += "\n# LOD Level "+l.level as string+" Failed Exported"
					)
					
					
				) else (
					if wwmtExporter=="2" then (	
						ExportSMD fname true true false false false "" ""
					) else (
						if useOldWBS == false then (
							
								
								if WBSMDExportVersionNum() < 1700 then (
									status = WBSMDExport fname true 0 hl1 0 0 false false false exportNonRenderableMeshAsBone
								) else (
									
									status = WBSMDExport fname true 0 hl1 (mapChannel as integer) 0 0 false false false exportNonRenderableMeshAsBone
									)
								--print "USED NEW for LOD"
							) else (
								
								
								try(

									setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Type" "0"
									setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Start" "0"
									setINISetting "$plugcfg/smdexp.ini" "Batch Config" "End" "0"
									setINISetting "$plugcfg/smdexp.ini" "Batch Config" "Reverse" "0"
									setINISetting "$plugcfg/smdexp.ini" "Batch Config" "HL1Format" (expHL1Format as string)
								) catch(
									noPlugWrite = true
								)
								exportFile fname #noPrompt  selectedOnly:true using:SMDExporter
									--print "USED OLD for LOD"
							)
					)
				)
				

		)
						
						
						
						
		if staticprop != true do (
			
			for s in sequences WHERE (s.makeSMD == true OR s.asAnimation == true) do (
					export_sequence s wwDir:wwDir resetBnArray:false
					exportNotice += "\n# Sequence "+s.sequence+" Exported t"
			)
		)	
	
						

				

				

					
		if wwmtExporter== "1" AND noPlugWrite==true then (
			if (useOldWBS == true) then (
				--exportNotice+= "\n\nBecause your plugcfg folder is not writable, the batch format function did not work--that is why you had to confirm all the export dialogues."
				exportNotice+= "\n\nBecause your plugcfg folder is not writable, the batch format function did not work--that is why you had to confirm all the export dialogues."
			) else  (
				try(				
					deleteFile "$plugcfg/smdexp.ini"						
				) catch ()
			)

			if 	shouldUpdateSMDExporter == true do (
				exportNotice+= "\n\nYou may not be using the latest SMD Exporter. You should update the SMD Exporter to Version 1.7. Please visit www.wunderboy.org."							
			)
		)
		
		
		print exportNotice
		if wwmtCompileMessage == true OR wwmtCompileMessage == "true" do (
			messageBox exportNotice
		)



		
		exportBodyGroups tempRefNode:tempRefNode




		if doesFileExist (wwDir+"\\"+modelName+".bat") == true then (
			local newBatch = openFile (wwDir+"\\"+modelName+".bat") mode:"w"
		) else (
			local newBatch = CreateFile(wwDir+"\\"+modelName+".bat")
		)
			
			
			 
			
		Format "@echo on\n" to:newBatch

		--local bt = "cd \""+wwmt_binDir+">\"\n" 
		local bt = "REM Compiling using the Wall Worm Batch File...\n" 
		Format bt to:newBatch
		local gameInfoParam = ""
		global wwmt_gameInfoDir
		global wwmt_hull_limit_handling
		if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
			gameInfoParam = " -game \""+wwmt_gameInfoDir+"\""
			
			) 
			
		if wwmt_hull_limit_handling == 3 AND theRealHullCount != undefined AND theRealHullCount > 20 do (
			
			append gameInfoParam " -fullcollide"
		)
		
		append gameInfoParam " -nop4"
		
		bt = "\""+wwmt_binDir+"\studiomdl.exe\""+gameInfoParam+" \""+wwDir + "\\"+modelName+".qc\"\n"
		Format bt to:newBatch
		Format "@pause\n" to:newBatch



		try (
			close newBatch	
			free newBatch
			flush newBatch
		) catch ()
		
-- 2012 initial release maxVersion() = #(14000, 38, 0)
			
		if ((maxVersion())[1] >= 14000) do (

			newBatch = openFile (wwDir+"\\"+modelName+".bat") 
			seek newBatch #eof
			maxlen=filepos newBatch
			seek newBatch 0
			res = readChars newBatch maxlen errorAtEOF:false
			try (
				close newBatch	
				free newBatch
				flush newBatch
			) catch ()
			(dotnetclass "System.IO.File").WriteAllText (wwDir+"\\"+modelName+"_2012.bat") res		
				
		)
			



			
			if (wwmtAutoCompile == "true" AND failed==0) do (
				if ((maxVersion())[1] >= 14000) then (

					compileBatStr = wwDir+"\\"+modelName+"_2012.bat"
					) else (
					
					compileBatStr = wwDir+"\\"+modelName+".bat"
				)
					
					--print compileBatStr
				
				
					if findItem alreadyExported target == 0 then (
				
						shellLaunch compileBatStr ""
					)
				
					
			)			

						


			--)
				
		if runCompile == true AND wwmtAutoOpenFolder == "true" do (
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen

		)	
						
	
		return true
	) else (
		return false
	)
		
),
	/*
	This function gets all the objects associated with the model
	*/
	function collectAllObjects = (
	
	local c = for i in targets  collect i
	for l in lods do (
		if  l.helperGizmo != undefined AND isDeleted l.helperGizmo == false do (
			append c l.helperGizmo
		)
		join c l.items
	)	
	append c target
	if target.children != undefined AND target.children.count > 0 then (
			join c target.children
	)
	
	if hulls.count > 0 then (
		join c hulls
		
	)
	try(
		if gibs.count >0 do (
			
			
			for g in gibs do (
				
				local tempWWMT = ww_LOD_wrapper()
				tempWWMT.init()
				tempWWMT.setTargetModel g tempWWMT 
				if (tempWWMT.isset == true) do (
					setChildGibs tempWWMT
				) 
				tempWWMT.populateBodyGroups()
				join c (tempWWMT.collectAllObjects()	)
			)
			
			
			
		)	
		
	) catch (
			print (getCurrentException())
			
	)	
		
		
	--try(
			
	populateBodyGroups()
	if bodygroups.count >0 do (
		
		
		for b in bodygroups do (
			
			
			
			for i in b.bgmodels do (
	
				i.populateMyMaterials()
				
				join c (i.collectAllObjects())
				
		)
	

	

			
			
		)
		
		
		
	)	
		
--) catch (
		--print (getCurrentException())
		
		--)			
	

	
	
	return c
	),
	

function populateMyMaterials = (
	
	materials = #()
	/*
	if wwmt_legacy_names == "true" then (
		
		getNameFromPath = false
		) else (
		getNameFromPath = true
		)*/
	getNameFromPath = false
	
	for i in targets do (
	
	
		--appendBitmaps i.mat materials
	wallworm_appendBitmaps i.mat materials valveShader getNameFromPath:false forModel:true materialPath:materialPath
	
	)
	
for l in lods where l != undefined do (
	
	--for i in l.items do (
	
		if (l.testForExport l.helperGizmo.mat) == true do (
			--appendBitmaps l.helperGizmo.mat materials getNameFromPath:true
			wallworm_appendBitmaps l.helperGizmo.mat materials valveShader getNameFromPath:false forModel:true materialPath:materialPath
			

		)
		--)
	
	--print (l.helperGizmo.mat)
	
	)	
	
	if target.mat != undefined AND classOf target.mat == MultiMaterial do (
		
		--appendBitmaps target.mat materials
		
		wallworm_appendBitmaps target.mat materials valveShader getNameFromPath:false forModel:true materialPath:materialPath
		)
	
		
		try(
	if gibs.count >0 do (
		
		
		for g in gibs do (
			
			local tempWWMT = ww_LOD_wrapper()
			tempWWMT.init()
				tempWWMT.setTargetModel g tempWWMT 
			if (tempWWMT.isset == true) do (
				setChildGibs tempWWMT
			) 
			tempWWMT.populateMyMaterials()
				
			for im in tempWWMT.materials do (
					--appendBitmaps im.mat materials
				
				wallworm_appendBitmaps im.mat materials valveShader getNameFromPath:false forModel:true materialPath:materialPath
			)

			
		)
		
		
		
	)	
		
) catch (
		print (getCurrentException())
		
)	
		
		
	--try(
			
	populateBodyGroups()
	if bodygroups.count >0 do (
		
		
		for b in bodygroups do (
			
			
			
			for i in b.bgmodels do (
	

				i.getWWMT()
				i.wwmt.populateMyMaterials()
				
				for im in i.wwmt.materials do (
					--appendBitmaps im.mat materials
					wallworm_appendBitmaps im.mat materials valveShader getNameFromPath:false forModel:true materialPath:materialPath
					
					)
				
		)
	

	

			
			
		)
		
		
		
	)	
		
--) catch (
		--print (getCurrentException())
		
		--)			
	

	
	
	
),
	
	
		function createCustomQCI = (
			global wwmt_export
			local qcistr = modelName+"_wwmt_custom.qci"
			if modelPath != undefined then (
						local m = FsToBs modelPath
						wwDir = wwmt_export + "\\"+m		
						qcistr = wwDir + "\\"+modelName+"_wwmt_custom.qci"
						if NOT doesFileExist wwDir then (
							makeDir wwDir all:true
						)
						if doesFileExist wwDir then (
							if doesFileExist (wwDir + "\\"+modelName+"_wwmt_custom.qci") == false do (
							 
							 local CustomQCFile = CreateFile( wwDir + "\\"+modelName+"_wwmt_custom.qci")
							 str = "//File for injecting custom rules. Safe to edit. Do not delete.\n\n"
							Format str to:CustomQCFile
								try (
									close CustomQCFile	
									free CustomQCFile
									flush CustomQCFile
								) catch ()
							 )	
						)
			)
			qcistr
		),
		
		function outputModelQC resetExportList:true writeSMDs:true runCompile:true forceBoneReset:false= (
			--resetExportList will clear the alreadyExported array at the end of the method if true
			
			if dmx == true then (
				fileExt =  ".dmx"	
			)	else (
				fileExt = ".smd"
				
			)	

			setRefNode()
			
			with redraw off 
			(
			--currentSel = getCurrentselection()
			exportNotice = ""
			--try (
			errors = #()
			
				
				
			for t in targets do (
				if  NOT isValidNode t then (
					
					deleteItem targets (findItem targets t)
					
					) else (
					
					   if isGroupHead t ==false do (
						if t.material == undefined AND superClassOf t == GeometryClass AND classOf t != BoneGeometry do (
							
							if wwmt_autoMaterialNewModel == "true" AND t.material == undefined then (
								t.material = getMainMaterial()
						
							) else (
								
								append errors "The model has meshes with no material. Please add a standard material with a Bitmap in the diffuse slot to each mesh in your model."
								)
							
							)
							
						)
					)
				
				)
				
				if checkForRenderableMesh() == false then (
					append errors "You have the Export Non-renderable Mesh as Bone option turned on in the WW Settings. All of your meshes are non-renderable... so no mesh data can be exported."
					
				)
				
				local missingUVW = checkForUVWData()
				if missingUVW.count > 0 then (
					
					append errors "One or more of the meshes are missing UVW data. At the moment, the Wunderboy SMD Exporter will fail if you do not have UVW data for every vertex on a mesh. The objects with missing UVW data have been selected for you."
					
					select missingUVW

					)
				
				
				if targets.count == 0 do (
					append errors "The model has no meshes currently assigned. Check that the base objects are Renderable if you have the global setting to export non-renderable meshes as bones."
				)

			for h in hulls do (
				
				if isDeleted h then (
					
					deleteItem hulls (findItem hulls h)
					
					) else(
					
						if h.material == undefined do (
							wwmt_applyWWMTHullMaterial h
							--append errors "The collision model has meshes with no material. Please add a standard material with a Bitmap in the diffuse slot to each mesh in your collision model."
						)
					
					)
				
				
				)			

			--include "$scripts/WallWorm.com/common/config.ms"

			
			local m = FsToBs modelPath
			wwDir = wwmt_export + "\\"+m		

            if (makeDir wwDir all:true) == false do (
				
				append errors ("The Path you want to export to does not exist. Please make sure to create the following path.:\n\n" +wwDir)
				
			)

			if errors.count > 0 do (
				
				message = "There were problems.\n\n"
				
				for er in errors do (
					
					message += er + "\n"
					
				)
				enablesceneredraw()
				messageBox message
				if missingUVW.count > 0 then (
					missingUVW = undefined
					max tool hlist
				)
				
				return false
			)
			


				
				local theRealHullCount = 0




			local mp =  BsToFs modelPath
			
			resetBonesArray()
		
			local doWriteQC = true
			
			
			local QCExists = doesFileExist(wwDir + "\\"+modelName+".qc")
			
			if locked==true  then (
				
					if ( QCExists  == true) do (
						doWriteQC = false
						exportNotice+="** The QC was not written because it already existed and this model has Lock QC turned on. If you want to overwrite the QC, you must rename it, delete it or turn off this model's QC Lock.\n\n"
					)
				) else (
					if doWriteQC == true AND (QCExists == true) do (
						
						if (wwmt_overWriteQC == false OR wwmt_overWriteQC == "false") then (
							doWriteQC = false
							exportNotice+="** The QC was not written because it already existed. If you want to overwrite the QC, you must rename it, delete it or turn on QC Over-writing in the WWMT Settings.\n\n"
						) else (
							exportNotice+="** The exisitng QC was over-written. If you do not want to overwrite existing QCs, turn off QC Over-writing in the WWMT Settings or lock the QC with the Lock QC option.\n\n"
							)
					)				
						
			)
			

			
			if doWriteQC == true do (
			try (
				
				

			if QCExists == true then (
					local NewQC = openFile ( wwDir + "\\"+modelName+".qc" )  mode:"w"
				) else (
					local NewQC = CreateFile( wwDir + "\\"+modelName+".qc" )
				)	
				
			
			
			) catch (
				
				return messagebox ("The exporter cannot create "+wwDir + "\\"+modelName+".qc . Please check that the path to that file is writable.")
				
			)



			
			
			local t = "// QC File generated by the Wall Worm Model Tools Version "+ww_wwmt_version as string+"\n"
			Format  t to:NewQC
			
			Format "// Get the latest version and notes at:\n" to:NewQC
			Format "// http://dev.wallworm.com \n\n" to:NewQC


			if mscale != undefined do (
				
				t = "$scale "+mscale as string+"\n"
				Format  t to:NewQC
				
			)
			
			t = "$modelname	\"" + mp +"/"+modelName+".mdl\"\n"
			Format t to:NewQC
			


			--and staticprop == true
			if (useLocalOrigin == true )  do (
				
				if (wwmtExporter=="3" AND internalOrigin == true) then (
					--don't add the $origin line
					
				) else (
					
					
					
					

				
				
				
				if altOrigin == undefined  do (
					altOrigin= false
				)

		local calcpost = targets[1].transform.position

				
					
				yval = abs calcpost.y
				xval = abs calcpost.x
				--calcpost.z = calcpost.z - 4
				--zRotationVal = "90"	
				
				
				if (altOrigin==true) then  (					
					/*Alt (flip)*/
					zRotationVal = "-180"
					if calcpost.x < 0 do (
					
							xval = xval * -1
					
						)

						if calcpost.y < 0 do (
					
							yval = yval * -1
					
						)
						
						
						
						
						
						
						
					
				) else (

					zRotationVal = "0"	
					
						if calcpost.x > 0 do (
					
							xval = xval * -1
					
						)

						if calcpost.y > 0 do (
					
							yval = yval * -1
					
						)	
						
						
						
					
					)
					
					
					if (base!=undefined AND base!="") then (
						zpos = ((calcpost.z)) *-1
						
						) else (
						
						zpos = (calcpost.z  * -1)
						
					)


					
					if staticprop == true  then (
						if (wwmtExporter=="3") then (
							t = "$origin "+(formattedPrint (yval * -1 ) format:".16g")+" "+(formattedPrint (xval  ) format:".16g")+" "+(formattedPrint zpos format:".16g")+" "+zRotationVal as string+" \n"	
						) else (
							t = "$origin "+(formattedPrint xval format:".16g")+" "+(formattedPrint yval format:".16g")+" "+(formattedPrint zpos format:".16g")+" "+zRotationVal as string+" \n"	
						)

						
						
					) else (
						
						
						zpos = zpos * -1
						
						
						/*
						xval = xval * -1
						yval = yval * -1*/
						


						
						if rotateRefsystem == false  then (
							xval = xval * -1
							yval = yval * -1		
							t = "$origin "+(formattedPrint (xval ) format:".16g")+" "+(formattedPrint (yval) format:".16g")+" "+(formattedPrint zpos format:".16g")+" "+zRotationVal as string+" \n"	
						) else (
							
							
								t = "$origin "+(formattedPrint (yval *-1) format:".16g")+" "+(formattedPrint (xval) format:".16g")+" "+(formattedPrint zpos format:".16g")+" "+zRotationVal as string+" \n"	
						)
						
						

						)
					

				--t = "$origin "+(formattedPrint xval format:".16g")+" "+(formattedPrint yval format:".16g")+" "+(formattedPrint zpos format:".16g")+" "+zRotationVal as string+" \n"	
					
				--delete tempH
				Format  t to:NewQC
				--Format "\n" to:NewQC
						
					)
			)
			
			
			populateBodyGroups()
				
					
			
			if bodygroups.count > 0 do (
			
				if staticprop == true do (
					
					exportNotice+="** A model with bodygroups cannot have the $staticprop flag. The model was temporarily changed to not have $staticprop for the export.\n"
					)
				
				staticprop=false	
			)
			
			
			if staticprop == true then (
				Format "$staticprop\n" to:NewQC
			) else (
					
				if collapsebones == true then (
					Format "$collapsebones\n" to:NewQC
				)
			)
			
			if opaque == true do (
				Format "$opaque\n" to:NewQC
			)
			
			if mostlyopaque == true do (
				Format "$mostlyopaque\n" to:NewQC
			)
			

			if (illumorigin != undefined AND isDeleted illumorigin==false)  do (
			if illumorigin.controller.position != [0 , 0, 0] do (
				
				
				if useLocalOrigin == true then (
				
				
				--ox = illumorigin.controller.position[1] 
				
				--if useLocalOrigin == true then (
					
					
					
					
					
					
				if altOrigin == undefined  do (
					altOrigin= false
					)
				
	
				
				yval = illumorigin.controller.position[2]
				xval = illumorigin.controller.position[1] *-1
				

				/*
				
				if (altOrigin==false) then  (	

					if  illumorigin.controller.position[2] < 0 do (
					
							xval = xval * -1
					
						)

						if  illumorigin.controller.position[1] < 0 do (
					
							yval = yval * -1
					
						)
						
						
						
						
						
						
						
					
				) else (
					

					
						if  illumorigin.controller.position[2] > 0 do (
					
							xval = xval * -1
					
						)

						if  illumorigin.controller.position[1] > 0 do (
					
							yval = yval * -1
					
						)	
						
						
						
					
					)
					*/
					
					
					
					
					
					
					
					formattedPrint yval format:".16g"
					
					
					
					t="$illumposition "+(formattedPrint yval format:".16g")+" "+(formattedPrint xval format:".16g")+" "+(formattedPrint  illumorigin.controller.position[3] format:".16g" )+" \n"

					
					
					
					
					
					
					) else(
					
					t="$illumposition "+(formattedPrint illumorigin.position.x format:".16g")+" "+(formattedPrint illumorigin.position.y format:".16g")+" "+(formattedPrint illumorigin.position.z format:".16g")+" \n"
					)
				
				
				
				--) else (
					
				--	t="$illumposition "+illumorigin.pos.x  as string+" "+illumorigin.controller.pos.y  as string+" "+illumorigin.controller.pos.z  as string+" \n"
					
					--)
				Format t to:NewQC
				
				)
			)
			
			if ambientboost != undefined AND (ambientboost == 1 OR ambientboost == true) do (
				
				t="$ambientboost\n"
				Format t to:NewQC
			)
				
			if constantdirectionallight != undefined do (
				
				t="$constantdirectionallight "+(constantdirectionallight as string)+"\n"
				Format t to:NewQC
			)
			

					
				if staticprop != true AND morphasvta==true AND areMorphs() == true then (
					flexQC = (modelName+"_wwmt_flex.qci")
					

					
					if doesFileExist ( wwDir + "\\"+flexQC ) == true then (
						local flexQCFile = OpenFile ( wwDir + "\\"+flexQC ) mode:"w"
					) else (
						local flexQCFile = CreateFile( wwDir + "\\"+flexQC )
					)
					--append qci (flexQC)		
					
					str = "//File generated by WWMT for flex. DO NOT EDIT/DELETE THIS FILE as it will alwasy get over-written when exported in WWMT.\n\n//If you need to edit the flex rules, use the \""+modelName+"_wwmt_flex_custom.qci\" file\n\n\n	defaultflex frame 0\n"
					Format str to:flexQCFile
					
					
					flexnames = getVTAFlexnames()
					
					
					
					for fns in flexnames do (
						str = "	flex \""+fns[1]+"\" frame "+(fns[2] as string)+"\n"
						Format str to:flexQCFile
						)
					try (
						close flexQCFile	
						free flexQCFile
						flush flexQCFile
					) catch ()
                  --flex "AU42" frame 5		// eyes	half_closed
					
						
					 if doesFileExist (wwDir + "\\"+modelName+"_wwmt_flex_custom.qci") == false do (
						 
						 
						 local flexCustomQCFile = CreateFile( wwDir + "\\"+modelName+"_wwmt_flex_custom.qci" )
						 str = "//File for injecting custom flex data. Safe to edit. Do not delete.\n\n"
						Format str to:flexCustomQCFile
							try (
								close flexCustomQCFile	
								free flexCustomQCFile
								flush flexCustomQCFile
							) catch()
						 )
					
						 
						 flexcontroller = "	flexcontroller wwmt_flex_controller "
						 flexlist = ""
						 fnum = 0
						 for fns in flexnames do (
							try(
								local controllername = wallworm_makeStringSafe fns[1]
							 append flexcontroller (" \""+controllername+"\"")
							 append flexlist ("\%"+controllername+" = "+controllername+"\n")
							) catch ()
							 )
						 
						append flexcontroller ("\n\n"+flexlist)
						t = "$model "+modelName+" \""+modelName+".smd\" {\n\n	flexfile \""+modelName+"_flex\" {\n		$include		\""+flexQC+"\"\n		$include		\""+modelName+"_wwmt_flex_custom.qci\"\n}\n"+flexcontroller+"\n}\n"

					

				) else (
								t = "$body "+modelName+" \""+modelName+fileExt+"\"\n"
					
					)
					
			Format t to:NewQC
					
					
			populateBodyGroups()

					
			bodygroupNum = 1
			if bodygroups.count > 0 do (
				
				
				
				for b in bodygroups do (
						--t="studio \""+( BsToFs b.modelPath)+"/"+b.modelName+".smd\"\n"
					
					   
						t = "$bodygroup "+b.bgname+"\n{\nblank\n"
						Format t to:NewQC
					
					    for m in b.bgmodels do (
								t="studio \""+m.modelName+fileExt+"\"\n"
								Format t to:NewQC
							
							)
				t = "}\n"
				Format t to:NewQC
					)
				

					
					
				)
					
					
				
				
			if(hulls.count > 0 OR (autoHull != undefined AND autoHull==true)) do (
				
				
				if (staticprop == true ) then (
					cmtype = "$collisionmodel"
					) else (
					
					
					resetHullBonesArray()
					
					if ((hullbonesarray.count > 1) OR (hullbonesarray.count ==1 AND hulls.count == 1)) then (
						
						 cmtype = "$collisionjoints"
						) else (
						
						cmtype = "$collisionmodel"
						
						)
					
					
					
					 
					)
				
				if (autoHull==true) then (
					t=cmtype+" \""+modelName+fileExt+"\" {\n"
				) else(
					t=cmtype+" \""+modelName+"_hull"+fileExt+"\" {\n"
					)
				Format t to:NewQC
				
				
				
					
					
				if(concave != undefined) do (
					
					if(concave==true) do (
						
						
						if cmtype == "$collisionmodel" then (
						t="$concave\n"
				
						Format t to:NewQC
						) else()
						theRealHullCount = wwmt_count_hulls hulls true						
						if wwmt_hull_limit_handling == 2 AND theRealHullCount > 20 do (


							
								t="$maxconvexpieces "+(theRealHullCount as string)+"\n"
				
								Format t to:NewQC
							

						)
						
						)
					
					)
					

				if (noselfcollisions != undefined AND noselfcollisions ==true ) do (
					
					t = "$noselfcollisions\n"
					Format t to:NewQC
					)	
					
				if (inertia != undefined) do (
					
					t = "$inertia "+(inertia as string)+"\n"
					Format t to:NewQC
					)	
					
				if (damping != undefined) do (
					
					t = "$damping "+(damping as string)+"\n"
					Format t to:NewQC
					)		
					
					
				

				
				if (rotDamping != undefined) do (
					
					t = "$rotdamping "+(rotDamping as string)+"\n"
					Format t to:NewQC
					)	
					
					
				if (phdrag != undefined) do (
					
					t = "$drag "+(phdrag as string)+"\n"
					Format t to:NewQC
					)	
				
				if (massorigin != undefined AND (isDeleted massorigin == false) AND cmtype == "$collisionmodel") do (
				if massorigin.controller.position != [0 , 0, 0] then (
				if useLocalOrigin == true then (
					
					yval = massorigin.controller.position[2]
					xval = massorigin.controller.position[1] *-1
				
					
					
					t="$masscenter "+(formattedPrint yval   format:".16g")+" "+(formattedPrint xval   format:".16g")+" "+(formattedPrint massorigin.controller.position[3]   format:".16g")+" \n"
				) else(
					
					t="$masscenter "+(formattedPrint massorigin.position.x format:".16g")+" "+(formattedPrint massorigin.position.y  format:".16g")+" "+(formattedPrint massorigin.position.z format:".16g")+" \n"

				)
				--ox = massorigin.controller.position[1] 
				Format t to:NewQC
				
				) else(
					--print "Mass Center at object origin"
					--print massorigin.controller.position					
				)
				
				)
				if (automass != undefined) then (
					
					if ( automass == true ) do (
						Format "$automass\n" to:NewQC
					)
					
					
					) else(
						if(mass != undefined) then (
							automass = false
						) else (
							 automass = true
							)
					)
				
				if(mass != undefined AND (automass == undefined OR automass == false)) do (
					
					t="$mass "+mass as string +"\n"
					Format t to:NewQC
				)
				

					
					
					
					if (jointConstraints != undefined AND jointConstraints == true) AND hullbonesarray != undefined AND cmtype == "$collisionjoints" do (
						
						if(animatedfriction != undefined AND animatedfriction != "") do (
							
							animatedfriction = trimLeft  (trimRight animatedfriction)
							
							if animatedfriction != "" then (
								t="$animatedfriction "+animatedfriction as string +"\n"
								Format t to:NewQC
							)
						)
						
						
						for b in hullbonesarray  do (
							
							
							local wwmt_jointskip = getUserProp b "wwmt_jointskip"
							
							if wwmt_jointskip != undefined then (
								
								t = "$jointskip \""+b.name+"\"\n"
								Format t to:NewQC
								
							)
							
							
							local bonemass = getUserProp b "wwmt_jointmassbias"
							
							if bonemass != undefined then (
								
								t = "$jointmassbias \""+b.name+"\" "+(bonemass as string)+"\n"
								Format t to:NewQC
								
								)
							
							
								
								
							if b.parent != undefined AND (findItem bonesarray b.parent > 0) then (
							
							
							ba = ik.getAxisLimit b #rotational
							boneActive = ik.getAxisActive b #rotational 
							
							boneDamp = ik.getAxisDamping b #rotational
							
							if ba != undefined OR boneActive != undefined then (
								min = ik.getAxisMin b #rotational
								bmax = ik.getAxisMax b #rotational
								
								
								
							    --bDamp =  ik.getAxisDamping b #rotational
								
								if findItem boneActive 1 > 0 then (
								
									if findItem ba 1 > 0 then (
										
										if (min[1] != 0 AND bmax[1] != 0) then (
										
											t = "$jointconstrain \""+b.name+"\" x limit "+(min[1] as string)+" "+(bmax[1] as string)+" "+(boneDamp[1] as string)+"\n"
											Format t to:NewQC
											
										) else (
											
											t = "$jointconstrain \""+b.name+"\" x fixed "+(min[1] as string)+" "+(bmax[1] as string)+" "+(boneDamp[1] as string)+"\n"
											Format t to:NewQC
										)
										
									
									) else (

										t = "$jointconstrain \""+b.name+"\" x free "+(min[1] as string)+" "+(bmax[1] as string)+" "+(boneDamp[1] as string)+"\n"
										Format t to:NewQC

									)
								) else (
									
											t = "$jointconstrain \""+b.name+"\" x fixed "+(min[1] as string)+" "+(bmax[1] as string)+" "+(boneDamp[1] as string)+"\n"
											Format t to:NewQC
									
								)
									
								
								
								
								if findItem boneActive 2 > 0 then (
								
									if findItem ba 2 > 0 then (
										
										if (min[2] != 0 AND bmax[2] != 0) then (
											t = "$jointconstrain \""+b.name+"\" y limit "+(min[2] as string)+" "+(bmax[2] as string)+" "+(boneDamp[2] as string)+"\n"
											Format t to:NewQC
										) else (
											t = "$jointconstrain \""+b.name+"\" y fixed "+(min[2] as string)+" "+(bmax[2] as string)+" "+(boneDamp[2] as string)+"\n"
											Format t to:NewQC											
										)
									) else (

										t = "$jointconstrain \""+b.name+"\" y free "+(min[2] as string)+" "+(bmax[2] as string)+" "+(boneDamp[2] as string)+"\n"
										Format t to:NewQC

									)
								) else (
									
											t = "$jointconstrain \""+b.name+"\" y fixed "+(min[2] as string)+" "+(bmax[2] as string)+" "+(boneDamp[2] as string)+"\n"
											Format t to:NewQC		
									
								)
								
								if findItem boneActive 3 > 0 then (
								
									if findItem ba 3 > 0 then (
										
										if (min[3] != 0 AND bmax[3] != 0) then (
											t = "$jointconstrain \""+b.name+"\" z limit "+(min[3] as string)+" "+(bmax[3] as string)+" "+(boneDamp[3] as string)+"\n"
											Format t to:NewQC
										) else (
											t = "$jointconstrain \""+b.name+"\" z fixed "+(min[3] as string)+" "+(bmax[3] as string)+" "+(boneDamp[3] as string)+"\n"
											Format t to:NewQC											
										)
									) else (

										t = "$jointconstrain \""+b.name+"\" z free "+(min[3] as string)+" "+(bmax[3] as string)+" "+(boneDamp[3] as string)+"\n"
										Format t to:NewQC

									)
								) else (
									
											t = "$jointconstrain \""+b.name+"\" z fixed "+(min[3] as string)+" "+(bmax[3] as string)+" "+(boneDamp[3] as string)+"\n"
											Format t to:NewQC		
									
								)
								
								
								
								/*
									
								if findItem ba 2 > 0 do (
									--t = "//$jointconstrain "+b.name+" y limit "+(min[2] as string)+" "+(bmax[2] as string)+" "+(bDamp[2] as string)+"\n"
									t = "$jointconstrain \""+b.name+"\" y limit "+(min[2] as string)+" "+(bmax[2] as string)+" 0\n"
									Format t to:NewQC
									
									)
								if findItem ba 3 > 0 do (
									--t = "//$jointconstrain "+b.name+" z limit "+(min[3] as string)+" "+(bmax[3] as string)+" "+(bDamp[3] as string)+"\n"
									t = "$jointconstrain \""+b.name+"\" z limit "+(min[3] as string)+" "+(bmax[3] as string)+" 0\n"
									Format t to:NewQC
									
									)
								*/
								
								
								) else ()

							
							
							
							)
						
						)
						
						
						)
						

				--jointConstraints	$jointconstrain "valvebiped.bip01_r_thigh" x limit -12.00 12.00 0.00  // from -12 to 12 degrees in the X-axis - twist knee left/right	
					
					
				
				t="\n}\n"
				Format t to:NewQC
				
				
			)
				
							--jigglebones
							for b in bonesarray do (
								
								ba = ik.getAxisSpringOn b #rotational
								
								
								
									if ba != undefined do (
										
										
										
										
										if (findItem ba 1 > 0 OR findItem ba 2 > 0 OR findItem ba 3 > 0) do (
											
											
											min = ik.getAxisMin b #rotational
											bmax = ik.getAxisMax b #rotational
											
											tensions = ik.getAxisSpringTension b #rotational
											dampings = ik.getAxisDamping b #rotational
											 
											t = "$jigglebone \""+b.name+"\" {\n is_flexible {\n"
											Format t to:NewQC

											
											if findItem ba 1 > 0 do (
												if tensions[1]  != undefined do (
													t="yaw_stiffness "+((tensions[1] * 20) as string)+"\n"
													Format t to:NewQC
												)
												if dampings[1] != undefined do (
													t="yaw_damping "+((dampings[1] * 10) as string)+"\n"
													Format t to:NewQC
												)
												if min[1]  != undefined AND bmax[1] != undefined do (
													t="yaw_constraint "+(min[1] as string)+" "+(bmax[1] as string)+"\n"
													Format t to:NewQC
												)
												
											)
											
											
											if findItem ba 2 > 0 do (
												if tensions[2]  != undefined do (
													t="pitch_stiffness "+((tensions[2] * 20) as string)+"\n"
													Format t to:NewQC
												)
												if dampings[2] != undefined do (
													t="pitch_damping "+((dampings[2] * 10) as string)+"\n"
													Format t to:NewQC
												)
												if min[2]  != undefined AND bmax[2] != undefined do (
													t="pitch_constraint "+(min[2] as string)+" "+(bmax[2] as string)+"\n"
													Format t to:NewQC
												)
												
											)
											
											
											if findItem ba 3 > 0 do (
												if tensions[3]  != undefined do (
													t="along_stiffness "+((tensions[3] * 20) as string)+"\n"
													Format t to:NewQC
												)
												if dampings[3] != undefined do (
													t="along_damping "+((dampings[3] * 10) as string)+"\n"
													Format t to:NewQC
												)
-- 												if min[3]  != undefined AND bmax[3] != undefined do (
-- 													t="along_constraint "+(min[3] as string)+" "+(bmax[3] as string)+"\n"
-- 													Format t to:NewQC
-- 												)
												
											)
											
											
											
											
											t = "\n }\n}\n\n"
											Format t to:NewQC
											
											
											
											
											)
										
								
								
									)
								
								
								)
			
			
				
			if(surfaceprop != undefined AND surfaceprop != "undefined" AND surfaceprop != "") do (
				t="$surfaceprop \""+ surfaceprop+"\" \n"
				Format t to:NewQC
			)
			
			if(contents != undefined) do (
					t="$contents \""+ contents+"\" \n"
					Format t to:NewQC
				/*
				if cmtype == "$collisionjoints" AND bonesarray.count > 0 do (

					for b in bonesarray WHERE b.parent != undefined do (
						
						t="$jointcontents \""+b.name+"\" \""+ contents+"\" \n"
						Format t to:NewQC
						
					)
				) */
				
			)
			
			--local matP = fsToBs materialPath
			local matP = BsToFs materialPath
			t="$cdmaterials \""+materialPath+"\"\n"
			Format t to:NewQC
			
			
				/*
				
			if target.mat != undefined AND classOf target.mat == MultiMaterial do (	
			t="$texturegroup \""+modelName+"_skins\"\n{\n\n"
			Format t to:NewQC
				
*/

				
				
					
				format (getBodygroupMats()) to:NewQC
					
				otherSkins = #(modelName)	
				for bdy in bodygroups do (
					for tmpwwmt in bdy.bgmodels do (
						if findItem otherSkins tmpwwmt.modelName == 0 then (
							tmpwwmt.getWWMT()
							format (tmpwwmt.wwmt.getBodygroupMats()) to:NewQC
							append otherSkins tmpwwmt.modelName
						)
					)
					
					
				)	
				otherSkins = undefined

				/*
						t="\n}\n"
			Format t to:NewQC			
								)
				*/
				
				
				

			
			
if bodygroups.count > 0 OR lods.count > 0 do (
	
		--local targMats = #()
		--for mshs in targets do (
			--appendBitmaps mshs.mat targMats
			
			--wallworm_appendBitmaps mshs.mat targMats valveShader coords:false decal:false  getNameFromPath:getNameFromPath
		--)			
				
	theLods = #()			
				
				
				
			if bodygroups.count > 0 do (
				
	
				for b in bodygroups do (
						--t="studio \""+( BsToFs b.modelPath)+"/"+b.modelName+".smd\"\n"
					

					
					    for m in b.bgmodels do (
				
							
							if m.lods != undefined AND m.lods.count > 0 do (
								
										for mshs in m.targets do (
											
											--appendBitmaps mshs.mat targMats
											--wallworm_appendBitmaps mshs.mat targMats valveShader coords:false decal:false  getNameFromPath:getNameFromPath
											
										)	
								
							
									for lodm in m.lods do (
										lodm.getMetric()
										lodm.getMatFromOtherLOD()
										--lodindex = (floor (lodm.helperGizmo.radius* 100 *( 2 *(tan(wwmt_FOV/2)  ) ) ) / wwmt_horizontalRes)
										if theLods[lodm.metric] == undefined do (
											theLods[lodm.metric] = #()
										)
										
										append theLods[lodm.metric] lodm
										
									)
								)
							
						)
					)
				)
				
				
				
				
				
				

			
			if lods.count > 0 do (
				for l in lods do (
					l.getMetric()
					l.getMatFromOtherLOD()
					
					--lodindex = (floor (l.helperGizmo.radius* 100 *( 2 *(tan(wwmt_FOV/2)  ) ) ) / wwmt_horizontalRes)
					if theLods[l.metric] == undefined do (
						theLods[l.metric] = #()
					)
					
					append theLods[l.metric] l
					
				)

			)
			
			
	if  theLods.count > 0  do (
		
		--collect materials in reference model

	populateMyMaterials()
	 for ind = 1 to theLods.count do (
		if theLods[ind] != undefined and classOf theLods[ind] == Array do (


			local lodMats = #()
			--collect materials in this lod model
			--for mshs in l.items do (
			   

			--)
			
			--see if any materials in this reference have an LOD materials
			

			

			
			
				Format "\n\n" to:NewQC

				--calcString="Calculated Pixel Height: "+pixelHeight as string

			    --lodnum = (l.helperGizmo.radius* 100 *( 2 *(tan(wwmt_FOV/2)  ) ) ) / wwmt_horizontalRes
					
					
				--divString = "Pixel Height divided by 100 : "+lodnum as string
				--print divString
				--lodnum = floor lodnum
					
				--floorString = "Pixel Height floor : "+lodnum as string
				--print floorString
					
				t=	"$lod "+ind as string+"\n"
				Format t to:NewQC

					
				--qc+="$lod "+l.helperGizmo.radius as string+"\n"
				Format "{\n" to:NewQC
				
				
		previousMats = #()	

		--populateM


		for l in theLods[ind] do (		
			
				--appendBitmaps l.helperGizmo.mat lodMats
			
			wallworm_appendBitmaps l.helperGizmo.mat lodMats valveShader coords:false decal:false  getNameFromPath:getNameFromPath
			
		
			local mainMat = #()
			
			
			--check if this model has an lod for this level
			--TODO see if there is a highel level LOD if one not present
			t="replacemodel \""+modelName+"\" \""+modelName+"_LOD_"+l.level as string+fileExt+"\"\n"
				Format t to:NewQC
				
			
			for targMat in materials do (	
				
				local alreadyUsed = #()
				--print targMat
				
				--local dfile = targMat.getTexName targMat.diff
				if wwmt_legacy_names == true then (
					--set the name from the diffuse bitmap
					local dfile = targMat.getTexName targMat.diff
				) else (
					--set the name from the material
					local dfile = wallworm_getMaterialName targMat.mat forModel:true
				)
				local lodfile = dfile+"LOD"+(l.level as string)
				--format "Looking at % for LODs...\n" targMat
				
				local lodmatopts = #()	
				for i = 0 to l.level while i <= l.level do (
					thatlod = dfile+"LOD"+((l.level - i) as string)
					
					append lodmatopts thatlod
					)
				
				
				for lodMat in lodMats do (
						--format "Looking at LOD MAT: %...\n" lodMat
						--print (lodMat.getTexName lodMat.diff)

						--if ( findItem alreadyUsed lodfile ) == 0 AND (lodMat.getTexName lodMat.diff==lodfile) do (
					
						--local theFind = findItem lodmatopts (lodMat.getTexName lodMat.diff)
					
						--enter false for model because the true will force the material name to be the name of the 
						if wwmt_legacy_names == true then ( 
							--check against the diffuse bitmaps
							local theFind = findItem lodmatopts (lodMat.getTexName lodMat.diff)
						) else (
							--check against the material names
							local theFind = findItem lodmatopts ((wallworm_getMaterialName lodMat.mat forModel:true))
						)
					
						
						if ( findItem alreadyUsed lodfile ) == 0 AND theFind>0 do (
							theLODfile = lodmatopts[theFind]
							append alreadyUsed  theLODfile
							append mainMat dfile
							append previousMats theLODfile
							t="replacematerial \""+dfile+"\" \""+theLODfile+"\"\n"
							Format t to:NewQC
						) 

					
					)
					
					
		)
		
		
		/*
			for targMat in targMats do (
				--print targMat
				local dfile = targMat.getTexName targMat.diff
				if (findItem mainMat dfile) == 0 do 
					local findOtherLOD = true

					if l.level > 1 do (
						for i = 1 to  (l.level) while (findOtherLOD AND (l.level) > i)do (
							local lastLODFile = dfile+"LOD"+((l.level - i) as string)
							--print lastLODFile
							print alreadyUsed
							if (findItem alreadyUsed lastLODFile) > 0 do (
								t="replacematerial \""+dfile+"\" \""+lastLODFile+"\"\n"
								Format t to:NewQC
								findOtherLOD = false
							)
						)
				
					)
				)
				*/
		)
		
				
				
		
				
				Format "}\n" to:NewQC


		)		
					
		)
					
		if shadowlod != undefined do (			
			if (lods.count > 0 AND shadowlod==true) do (					
		
				Format "$shadowlod \n" to:NewQC
				Format "{\n" to:NewQC
	
				t="replacemodel \""+modelName+"\" \""+modelName+"_LOD_"+lods[lods.count].level as string+fileExt+"\"\n"
				Format t to:NewQC
				Format "}\n" to:NewQC
			)
					
		)	
	)
			
)

	if idleSequence == true then (
				if staticprop == true then (
					t="$sequence idle \""+modelName+"\" activity ACT_IDLE -1.0 fps 1\n"				
				) else (
					fr = frameRate as string
					t="$sequence idle \""+modelName+"\"  activity ACT_IDLE -1.0 loop fps "+fr+"\n"				
				)
	)






	Format  t to:NewQC
				
	particleData = #()
	particleEvents = #()
--AND (staticprop==undefined OR staticprop==false)
	if particlesystems.count > 0  do (
	  
		for p in particlesystems do (
			
			if p.type == "keyvalue" then (
				append particleData p
				) else (
				
				append particleEvents p
				)
			
			
			)
		
	  
	  
	)					
					
				
	
	
	
				
			if staticprop != true do (
				
				
				
				
				
				if weightlists.count > 0 then (
				
					
					for w in weightlists do (
						
						local weightlistlines = "$weightlist "+w.name+" "
						
						
						local afterBone = ""
						local openBracket=""
						local closeBracket="\n"
						
						if w.bns.count > 1 then (
							
						 afterBone = "\n"
						 openBracket="{\n"
						 closeBracket="}\n"
							
						)
						
						append weightlistlines openBracket
						
						
						for bi = 1 to w.bns.count do (
							
							append weightlistlines ("\""+w.bns[bi]+"\" "+w.weights[bi] as string+afterBone)
							
						)
						
						
						append weightlistlines closeBracket
						
						Format  weightlistlines to:NewQC
						
					)
					
					
				)
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				--For Static Prop... animation sequences make no sense... so skip if staticprop
				fr = frameRate as string
				
				
				local alreadyUsedSeq = #()
				
				
		fn sortSequences seq1 seq2 =

		(



		case of

		(

		(seq1.asAnimation == true AND seq2.asAnimation == false): -1

		(seq2.asAnimation == true AND seq1.asAnimation == false): 1

		default: 0

		)

		)
		tempSegList = deepCopy sequences
		qsort tempSegList sortSequences
				
				
				for s in tempSegList do (
					
					
					--print ("Making Sequence: "+s.sequence)

					if s.asAnimation == true then (
						s.makeSMD == true
					)
					
					afterOp = " "
						if s.makeSMD == true then (
							seqname ="\""+ modelName+"_sequence_"+s.sequence+"\""	
							
						) else (
							seqname = ""
							if s.asAnimation == false then (
								afterOp = "\n"
							)
						)
						if findItem  alreadyUsedSeq  s.sequence == 0 then (
							--fr = s.fps as string
							
					        --seqname = modelName+"_sequence_"+s.sequence


							local seQEvent = ""						
							for p in particleEvents do (
								
								if p.sequence == s.sequence AND p.type != "keyvalue" do (
									local atpoint = ""
									if 	p.attachTo=="start_at_attachment" OR p.attachTo == "follow_attachment" do (
										atpoint = " "+p.attachmentPoint
									) 
									
									
									if p.type == "once" then (
										 
												append seQEvent ("\n{ event AE_CL_CREATE_PARTICLE_EFFECT "+(p.pframe as string)+" \""+p.systemname+" "+p.attachTo+atpoint+"\" }\n")
										 ) else (
										 
											if p.pframe != undefined AND p.pEnd != undefined AND p.pframe<p.pEnd do (
												
												--TODO add code to check if the range is in the target sequence
												append seQEvent ("\n{ event AE_START_SCRIPTED_EFFECT "+(p.pframe as string)+" \""+p.systemname+" "+p.attachTo+atpoint+"\" }\n")
												append seQEvent ("\n{ event AE_END_SCRIPTED_EFFECT "+(p.pEnd as string)+" \""+p.systemname+" "+p.attachTo+atpoint+"\" }\n")
											)
										 )
									
									

									)
								
							)
							
							
							
							local moreSeqOptions = ""
							
							

							if s.asAnimation == true then (
								sLabel = "animation"
								
								
								
								
							) else (
								

							if s.animations != undefined AND s.animations != "" then (
								
								append moreSeqOptions (s.animations+afterOp)
							)
								
							append moreSeqOptions ("fps "+(s.fps as string)+afterOp)	
							if s.loop == 1 then (
								append moreSeqOptions ("loop "+afterOp)
								) else (

							)
							
							
							if s.weightlist != undefined AND s.weightlist != ""AND s.weightlist != "undefined" then (
								
								append moreSeqOptions ("weightlist " +s.weightlist+afterOp)
							)
							
							if s.activity != undefined AND s.activity != "" then (
								
								append moreSeqOptions ("activity "+ s.activity+" "+(s.activityWeight as string)+afterOp)
							)
							
							if s.addlayer != undefined AND s.addlayer != "" then (
								
								append moreSeqOptions ("addlayer "+s.addlayer+afterOp)
							)
							
							if s.fadeIn != undefined  then (
								
								append moreSeqOptions ("fadein "+s.fadeIn as string+afterOp)
							)
							
							if s.fadeOut != undefined  then (
								
								append moreSeqOptions ("fadeout "+s.fadeOut as string+afterOp)
							)
							if s.nd != undefined AND s.nd != "" then (
								
								append moreSeqOptions ("node "+s.nd+afterOp)
							)
							

							
							if s.autoplay != undefined AND s.autoplay ==true  then (
								
								append moreSeqOptions ("autoplay"+afterOp)
							)
							if s.snap != undefined AND s.snap ==true  then (
								
								append moreSeqOptions ("snap"+afterOp)
							)
							if s.realtime != undefined AND s.realtime ==true  then (
								
								append moreSeqOptions ("realtime"+afterOp)
							)
							if s.hidden != undefined AND s.hidden ==true then (
								
								append moreSeqOptions ("hidden"+afterOp)
							)							
							
							
							
							if s.makeSMD == false AND s.asAnimation == false then (
								
								append seQEvent moreSeqOptions
								moreSeqOptions = ""
							)
							
							
							if seQEvent != "" do (
								seQEvent = " {\n"+seQEvent+"\n}"
								
							)

								sLabel = "sequence"
							)
							
							if s.asAnimation == true then (

								if s.loop == 1 then (
								append moreSeqOptions ("loop "+afterOp)
								) else (

							)
							
							
							if s.weightlist != undefined AND s.weightlist != ""AND s.weightlist != "undefined" then (
								
								append moreSeqOptions ("weightlist " +s.weightlist+afterOp)
							)
							
								
								
								
							)
								
							t="$"+sLabel+" "+s.sequence+" "+seqname+""+" "+moreSeqOptions+seQEvent+"\n"
							Format  t to:NewQC
					
							appendIfUnique alreadyUsedSeq s.sequence
						)
					)
				
				
			tempSegList = undefined
				
			)	
				
			for ats in attachments do (
					
					try (		
					--r = ats.getMyRotation() 
						--print (r as string)
						rst = ""
					--if r != [0,0,0] then (
						
						
						if ats.absolute == true OR ats.absolute==1 then (
							ab = " absolute"
						) else (
							ab	= ""						
						)
							
						if ats.rigid == true OR ats.rigid==1 then (
							ri = " rigid"
						) else (
							ri	= ""						
						)		
						
						in coordsys parent  r = ats.atPoint.transform.rotationPart
						if r != (quat 0 0 0 1) then (
							
						) else(
						rst = ""
						)
												/*	rotateAttachment = true
						) else (
							rotateAttachment = false
						)

						!TODO
						
						Look into why the rotations are only sometimes correct
						*/
						
						--rst = " rotate "+(r.x as string)+" "+(r.y as string)+" "+(r.z as string)

					

					
							

					if ats.atPoint.parent != undefined then
					(
						
						if isProperty ats.atPoint "pos" == true then (
							thePosA =at time 0 in coordsys parent ats.atPoint.pos
						) else (
							thePosA =at time 0 in coordsys parent ats.atPoint.transform.translationPart
						)

						r2 = (at time 0 ((ats.atPoint.transform.rotationPart * (inverse ats.atPoint.parent.transform.rotationPart)))) as EulerAngles
					)
					else
					(
						if refSystem == undefined then (
							getRefOrientation()
						)
						if isProperty ats.atPoint "pos" == true then (
							thePosA =at time 0 in coordsys refSystem ats.atPoint.pos
						) else (
							thePosA =at time 0 in coordsys refSystem ats.atPoint.transform.translationPart
						)
						r2 = at time 0 in coordsys refSystem (ats.atPoint.transform.rotationPart as EulerAngles)
					)
					
					
	
					
				--	in coordsys parent r2 = ats.atPoint.rotation as eulerAngles
						
				
						
					rst = " rotate "+((r2.x)   as string)+" "+(r2.y as string)+" "+(r2.z  as string)
					
					
					t = "$attachment \""+ats.attachment+"\" \""+ats.pb+"\" "+(formattedPrint thePosA.x )+" "+(formattedPrint thePosA.y )+" "+(formattedPrint thePosA.z )+""+ab+ri+rst+"\n"
					
				

							
					Format  t to:NewQC
	
	
				) catch (
				
				  format "****** % \n" (getCurrentException())
				
				)
												
			)
					
					

		
	if (base!=undefined AND base!="") OR (particleData.count >0) do (

		t=" $keyvalues {\n"
		
		Format  t to:NewQC
		
		if particleData.count >0  do (
		t="	\"particles\"\n	{\n"
		Format  t to:NewQC
			
			for p in particleData do (
				t="	\"effect\"\n	{\n"
				Format  t to:NewQC
				
				
				t="		name		\""+(p.systemname as string)+"\"  \n"
				Format  t to:NewQC
				
				t="		attachment_type		\""+(p.attachTo as string)+"\"  \n"
				Format  t to:NewQC
				
				if p.attachmentPoint != undefined AND p.attachmentPoint != "" do (
					
				t="		attachment_point		\""+(p.attachmentPoint as string)+"\"  \n"
				Format  t to:NewQC
					
					)
				
				
				
				t="\n	}\n"
				Format  t to:NewQC
				
				
				)
			
			
		t="\n	}\n"
		Format  t to:NewQC
			
			
		)
		
		
		
					
	gibsText = ""				
	if base!=undefined AND base!="" do (
		
		

		
		
		t="	\"prop_data\"\n	{\n"
		Format  t to:NewQC
		
		t="		\"base\"		\""+base+"\"\n"
		Format  t to:NewQC
		
		if health != undefined AND health != "undefined" do (
			t="		\"health\"		\""+(health as string)+"\"\n"
			Format  t to:NewQC	
		)
		
		if allowstatic != undefined AND (allowstatic == "true" OR allowstatic ==true) do (
			t="		\"allowstatic\"		\""+(allowstatic as string)+"\"\n"
			Format  t to:NewQC	
		)
		
		if blockLOS != undefined AND blockLOS != "undefined" AND (blockLOS == "true" OR blockLOS == true) do (
			t="		\"blockLOS\"		\""+(blockLOS as string)+"\"\n"
			Format  t to:NewQC	
		)
		if AIWalkable != undefined AND (AIWalkable == "true" OR AIWalkable == true) do (
			t="		\"AIWalkable\"		\""+(AIWalkable as string)+"\"\n"
			Format  t to:NewQC	
		)
		
		if physicsmode != undefined  do (
			
			local phym = ((-1) + (physicsmode) )
			
			--if classOf physicsmode == Integer do (
				--messagebox "int"
				--)
			t="		\"physicsmode\"		\""+ ( phym as string ) +"\"\n"
			Format  t to:NewQC	
		)

		
		if dmg_bullets != undefined AND dmg_bullets != "undefined" do (
			t="		\"dmg.bullets\"		\""+(dmg_bullets as string)+"\"\n"
			Format  t to:NewQC	
		)
		if dmg_club != undefined AND dmg_club != "undefined" do (
			t="		\"dmg.club\"		\""+(dmg_club as string)+"\"\n"
			Format  t to:NewQC	
		)
		if dmg_explosive != undefined AND dmg_explosive != "undefined" do (
			t="		\"dmg.explosive\"		\""+(dmg_explosive as string)+"\"\n"
			Format  t to:NewQC	
		)

		flammables = ""
		
		if ignite != undefined AND (ignite == true OR ignite == "true") do (
			
			append flammables "			\"ignite\"		\"halfhealth\"\n"
		)
		if explosive_resist != undefined AND (explosive_resist == true OR explosive_resist == "true") do (
			
			append flammables "			\"explosive_resist	\"	\"yes\"\n"
		)
		if flammable != undefined AND (flammable == true OR flammable == "true") do (
			
			append flammables "			\"flammable	\"	\"yes\"\n"
		)		
		
	if flammables != "" do (
	
		t = "\n		\"fire_interactions\"\n			{\n"+flammables+"			}\n"
		Format  t to:NewQC	
	)
	
	
	if breakable_model != undefined AND breakable_model != "" do (	
		
		if  breakable_model !="CustomGibs" then (

			t = "		\"breakable_model\"		\""+breakable_model+"\"\n"
			Format  t to:NewQC		
			
	
			
			
		) else(
		

			
			if gibs.count > 0 do (
				
				
				
				for obj in gibs do (
					
				 if isDeleted obj == false do (
					 
						local tempWWMT = ww_LOD_wrapper()
						tempWWMT.init()				
					    
					--local fadetime = getUserProp obj "wwmt_fadetime"
					--if fadetime == undefined do (
						--fadetime = 15
						
						--)
-- 						setNew = false
-- 					 
-- 					 
-- 					 
-- 					local isWWMTSource = getUserProp obj "wwmt_source_helper"
-- 					local isWWMTModel = getUserProp obj "wwmt_source"
					tempWWMT.setTargetModel obj tempWWMT 
					 
-- 					 if isWWMTSource == undefined AND isWWMTModel == undefined do (
-- 						 setNew = true
-- 						 )
-- 					 
					 
						
					if (tempWWMT.isset == true) then (
								setChildGibs tempWWMT
						   -- messagebox "SETTING DETAILS!!!!"
						) else (

							--messagebox "NOT SETTING DETAILS"

					)
					h=""
						if tempWWMT.health != undefined AND tempWWMT.health != "undefined" then (
							h="	 \"health\" \""+(tempWWMT.health as string)+"\""
						) else(
							h=""
						)
						
						if tempWWMT.motiondisabled != undefined AND (tempWWMT.motiondisabled == "true" OR tempWWMT.motiondisabled == true) then (
							h+="	 \"motiondisabled\" \"1\""
						) else(

						)
						
						if tempWWMT.fadetime != undefined AND tempWWMT.fadetime != "undefined" then (
						f=(tempWWMT.fadetime as string)
						) else(
						f="0"
						)
						

						
						t = "\"break\"\n{				\n \"model\" \""+tempWWMT.modelPath+"/"+tempWWMT.modelName+".mdl\"	\"fadetime\" \""+(f as string)+"\""+h+"	\n}\n"
						append gibsText t
				)
				
				
				)
			
			

			
			)
			
			if breakable_count != undefined AND breakable_count != "undefined" do (
			
				t = "		\"breakable_count\"		\""+(breakable_count as string)+"\"\n"
				Format  t to:NewQC		
			)
			if breakable_skin != undefined  AND breakable_skin != "undefined" do (
			
				t = "		\"breakable_skin\"		\""+(breakable_skin as string)+"\"\n"
				Format  t to:NewQC		
			)			
			
		)
		
		
		if multiplayer_break != undefined  AND multiplayer_break != "undefined" do (
			t = "		\"multiplayer_break\"		\""+(multiplayer_break as string)+"\"\n"
			Format  t to:NewQC		
		)		
		
	
	)
	
	
		if explosive_radius != undefined AND explosive_radius != "undefined"  do (
			t = "		\"explosive_radius\"		\""+(explosive_radius as string)+"\"\n"
			Format  t to:NewQC		
		)		
		if explosive_damage != undefined AND explosive_damage != "undefined"  do (
			t = "		\"explosive_damage\"		\""+(explosive_damage as string)+"\"\n"
			Format  t to:NewQC		
		)		

	--gibs=#(),		
		
		
		t="\n	}\n"
		Format  t to:NewQC
		
		
		
		
		

		
		
		)				
			
		t="\n	}\n"
		Format  t to:NewQC

		
	)		
					

	
					
					if gibsText !=undefined AND gibsText != "" do (

					t = "\n$collisiontext\n{\n"+gibsText+"\n}\n"
					Format  t to:NewQC		
					
					)		
					
					
					
				/* Hitboxes */	
				
				if staticprop != true AND (targets.count >1 OR bonesarray.count > 0 OR hullbonesarray.count >0) then (
					try (
				
					
					
					
					
					local hboxobjs = #()
					join hboxobjs targets
					join hboxobjs bonesarray
					--join hullbonesarray targets
					hboxobjs = makeUniqueArray hboxobjs
					hbsets = #()
					wwmt_get_hitboxsets hbsets objs:hboxobjs
					local hboxes = #()
					local hbArrs = #()
					
					for hb in hboxobjs do (
						
						
						--appendIfUnique hboxes hb.children
						
						local jsurfaceprop = getUserProp hb "wwmt_surfaceprop_bone"
						
						if jsurfaceprop != undefined AND jsurfaceprop != "" then (
							t = "\n$jointsurfaceprop "+hb.name+" "+jsurfaceprop+"\n"
							Format  t to:NewQC		
						)
					)
					
					local theHitBoxes = wwmt_getBoneHitboxes bs:hboxobjs
					
					if theHitBoxes.count > 0 then (
						
						for hb in  theHitBoxes do (
							
							local wwmt_hboxset = getUserProp hb "wwmt_hboxset"
							if wwmt_hboxset == undefined OR wwmt_hboxset == "" then (
								wwmt_hboxset = "default"
							)
							
							local hbIndex = findItem hboxes wwmt_hboxset
							--print hbIndex
							if hbIndex == 0 then (
								
								append hboxes (wwmt_hboxset as string)
								append hbArrs (#())
									
								hbIndex = hboxes.count
							)
							--print hbIndex
							append hbArrs[hbIndex] hb
							
							
							
						)

						
						for hbi = 1 to hboxes.count do (
							
							
							
							t = "\n$hboxset \""+hboxes[hbi]+"\"\n"
							Format  t to:NewQC		
							
							for hbo in hbArrs[hbi] do (
								
								
								--local theTm  = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]) * rotateZMatrix 90 * ((matrix3 [1,0,0] [0,1,0] [0,0,1] [hbo.parent.transform.translationpart.x,hbo.parent.transform.translationpart.y,hbo.parent.transform.translationpart.z]))
								--theTm = rotateZMatrix -90 * theTm
								/*
								local minmax = nodeGetBoundingBox hbo ((matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]) * rotateZMatrix -90 * hbo.parent.transform)
								

									t = "\n$hbox 0 \""+(hbo.parent.name)+"\" "+(formattedPrint minmax[1].x)+" "+(formattedPrint minmax[1].y)+" "+(formattedPrint minmax[1].z)+" "+(formattedPrint minmax[2].x)+" "+(formattedPrint minmax[2].y)+" "+(formattedPrint minmax[2].z)+"\n"
									Format  t to:NewQC			


								*/
								
								local wwmt_hitbox_group = getUserProp hbo "wwmt_hitbox_group"
								if wwmt_hitbox_group == undefined OR wwmt_hitbox_group == "" then (
									wwmt_hitbox_group = "0"
									
								)
								
								
								
								
								/*
								!TODO
								The calculations are not correct... the hitbox is rotated equal to the parent's rotation... creating an offset rotation. Probably using min/max is wrong or need rotate coordsys
								if hbo.parent != undefined then (
									
									local pcoordsys =(matrix3 1)  *  rotateZMatrix 90 * hbo.parent.transform
									
								) else (
									
									
									local pcoordsys = (matrix3 1)  *  rotateZMatrix 90
									)
								*/
								

								
								
								in coordsys parent (
											
									local bb = nodeLocalBoundingBox hbo

										t = "\n$hbox "+(wwmt_hitbox_group as string)+" \""+(hbo.parent.name)+"\" "+(formattedPrint bb[1].x)+" "+(formattedPrint bb[1].y)+" "+(formattedPrint bb[1].z)+" "+(formattedPrint bb[2].x)+" "+(formattedPrint bb[2].y)+" "+(formattedPrint bb[2].z)+"\n"
										Format  t to:NewQC			
								)
							)
						)
						
						--format "\n##############\nObjects: %\nHitboxes: %\nHBSets: %\nHitboxesArrays: %\n" hboxobjs theHitBoxes hboxes hbArrs
					)
					
				) catch (
				
				print (getCurrentException())
				--format "\n##############\nObjects: %\nHitboxes: %\nHBSets: %\nHitboxesArrays: %\n" hboxobjs theHitBoxes hboxes hbArrs
				)
				
				
				
				if alwayscollapse == true then (
					
					for t in targets where findItem bonesarray t == 0 AND findItem hullbonesarray t == 0 do (
							t = "\n$alwayscollapse \""+t.name+"\"\n"
							Format  t to:NewQC		
					)
					
					
				)
				

				
				
				
					
			)
					
					
					
					t = "\n$include	\""+modelName+"_wwmt_custom.qci\""
					Format  t to:NewQC		
					
					
				createCustomQCI()
			
			

					
					
					
			try(
				
				close NewQC
				free NewQC
				flush NewQC


			) catch()

			)
					
			print exportNotice

			if writeSMDs then (
				if 	(exportSMDS resetBnArray:forceBoneReset runCompile:runCompile ) == false then (			
					
						messageBox "The SMDs were not exported because you do not have one of the SMD exporters installed. Please get one from www.wunderboy.org and/or www.chaosincarnate.net ."
						enablesceneredraw()
				)
			
			)
					--)
/*
		) catch (
			print (getCurrentException())
		)*/

		true
	)
				
	
	if resetExportList == true then (
	
		alreadyExported = #()
	)
				
),
	
			

	function exportGibs = (
		
			if gibs.count > 0 do (

				for obj in gibs do (
					
				 if isDeleted obj == false do (
							local tempWWMT = ww_LOD_wrapper()
							tempWWMT.init()					
							tempWWMT.setTargetModel obj tempWWMT
					 
						if referenceNode != undefined then (
							tempWWMT.referenceNode = referenceNode
							
						)
					 
					 
					 if (tempWWMT.isset == true) then (
								setChildGibs tempWWMT
					 
					 ) else (
						 
						 
					)
					 

					tempWWMT.outputModelQC()
					
					
					

				
				)
				
				)
			)
		
		),
		
	function showOnlyModel = (
		
			if lods.count > 0  then (
				
					for l in lods do (
						hide l.items
						hide l.helperGizmo
					)
			)
			
		 if hulls.count > 0 then (
			hide hulls
		)	
		
		unhide targets
		
			
	),	
	function gatherMySkins = (

		if target.mat != undefined OR classOf target.mat != Multimaterial do (
			newmat = MultiMaterial numsubs:1
			newmat.name = ("Skin Material for "+ modelName)
			target.mat = newmat
			if (targets[1].mat != undefined) do (
				target.mat.materialList[1] = targets[1].mat
				target.mat.names[1]= "Skin 0"
			)
			
		)
		
		
		for obj in objects where (obj.mat != undefined AND ((getUserProp obj "wwmt_proxie_source") != undefined AND (getUserProp obj "wwmt_proxie_source") == target.name)) do (
			notFound = true
			for m in target.mat.materialList while notFound do ( 
				
				if m == obj.mat OR m.name == obj.mat.name do (
					notFound = false
				)
			)
			if notFound do (
				--print obj.mat.name
				--append target.mat.materialList obj.mat
				local nextSlot = target.mat.materialList.count+1
				target.mat.materialList[nextSlot]=obj.mat
				target.mat.names[nextSlot]= ("Skin " + ((nextSlot - 1) as string))
			)
		)
	),
	function createProxy = (
		if targets == undefined OR targets[1] == undefined OR isDeleted targets[1] then return undefined
			
		local newModel = editable_mesh pivot:targets[1].pivot --pos:targets[1].pivot
		--newModel.transform = targets[1].transform
		--newModel.pivot = targets[1].pivot
		m = snapshotAsMesh targets[1]
		newModel.mesh=m
		update newModel
		newModel.mat = targets[1].mat
		
		convertTo newModel editable_poly
		newModel.name = uniqueName (modelName + " Proxie")
		if targets.count > 1 do (
			for index = 2 to targets.count do (
				
				local cp = editable_mesh()
				
				cp.mesh = snapshotAsMesh targets[index]

				cp.mat = targets[index].mat

				newModel.attach cp newModel
			)
		)
		
		setUserPropBuffer newModel ""

		setUserProp newModel "wwmt_proxie_source" target.name
		newModel.pos.x = newModel.pos.x + 128
		newModel.pos.y = newModel.pos.y + 128

		setTransformLockFlags newModel #{7,8,9}

	/*	if Deformable_gPoly != undefined then (
			convertTo newModel Deformable_gPoly
		)
		*/
		newModel.parent = undefined
		return newModel
	),
		

		
		function createHull maxVerts:44= (
			
		try (
		

	-- test if hull fns are available and if so run them.
	if (wwmt_hull_tool as string == "2") AND Maple3D_HullFnsAvailable()  then (
		local oldSelection = selection
		clearselection()
		select targets
		--local NewHulls = Maple3DConvexWrapper.HullObject $ ApproxVertsTo:#(-1,44) HullElements:true;
		local NewHulls = Maple3DConvexWrapper.HullObject $ ApproxVertsTo:#(maxVerts) HullElements:true GroupElements:false;
		
		-- code to select returned hulls.
		local ObsToSelect = #()
		local ncount = NewHulls.count;
		for j = 1 to ncount - 1 do append ObsToSelect NewHulls[j];
		if NewHulls[ncount].count > 0 do join ObsToSelect NewHulls[ncount]; -- add lower approximations if any.
		clearselection();
		for i = 1 to ObsToSelect.count do (
			ObsToSelect[i].name = uniqueName (modelName+"_WWMT_hull")
			addAHull	ObsToSelect[i]; -- select the hulls, use this method because elements are returned in arrays.
		)
		--selcoll = selection as array
		--if selcoll.count > 0 then (
	
	-- 		) else (
	-- 			
	-- 			messagebox "No hulls were created. " 
	-- 			
	-- 			)
			
				
		clearselection()
		select oldSelection
	) else (

		
		local targcollection = #()
		
		
		
		getAllNodesFromGroup targcollection targets
		
		
		 local NewHulls = wallwormCreateMeshFromMeshes targcollection  vertlimit:maxVerts doOffsetransforms:true resestX1:false
		
			for obj in NewHulls do (
				
				obj.name = uniqueName (modelName+"_WWMT_hull")
				if staticprop == false then (
					addAHull(obj)
				)
				--obj.parent = ww_scene_lods.targets[1]
				
			)
			
			if staticprop == true then (
				local newhull = wallworm_merge_hulls thehulls:NewHulls
				newhull.name = uniqueName (modelName+"_hull")
				if newhull != undefined then (
					addAHull(newhull)
				)
			)
			
		)
		

		
			wwmt_hullsmoothinggroups hulls 1
			
			if hulls.count > 1 OR (NewHulls != undefined AND NewHulls.count > 1) do (
				
				setConcave true

			)
	

		return true

		) catch (
		--	select oldSelection
			
				--messagebox "There was a problem:\n\n The Wall Worm Hull Helper only works if you have either:\n\n *The nVidia PhysX Plugin or MassFX (Integrated into 3ds Max 2012+)\n*Convexity 1.17+.\n\nIf you meet one of these requirements, please submit a bug report."
				return false
			)
			
			
		),
		function checkForProblems = (
			local ers  = #()
			
			if findString modelPath ":" != undefined then (
					
				append ers "The Model Path is invalid. It cannot have a colon (:) character. Do not use full paths here."
			)
			
			if findString materialPath ":" != undefined then (
					
				append ers "The Material Path is invalid. It cannot have a colon (:) character. Do not use full paths here."
			)
			
			
			return ers
		),
		function update_proxies_in_scene = (
				max create mode
				newProxies = #()
				getProxies()
			
				local newProx = createProxy()
			
				for proxy in proxies  do (
				
					maxops.clonenodes newProx actualNodeList:&c newNodes:&d cloneType:#copy
					addedProx = d[1]
					
					addedProx.transform = proxy.transform
					
					addedProx.parent = proxy.parent
					addedProx.scale = [1,1,1]
					addedProx.position.controller = proxy.position.controller
					addedProx.rotation.controller = proxy.rotation.controller
					addedProx.scale.controller = proxy.scale.controller
					
					
					local custAtrCt = custAttributes.count proxy
					
					if custAtrCt > 0 then (
						for i = 1 to custAtrCt do (
							wallworm_copy_ca i proxy addedProx
						)
						
					)
					/*
					 check for scene dependencies and try to replace with new node
					*/
					
					addedProx.material = proxy.material
					
					append newProxies addedProx
					
					delete proxy
				)
				
				delete newProx
				
				newProxies
		)
		
		
		

)



fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_bodygroup.ms"
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_struct_sequence.ms"
fileIn "$scripts/WallWorm.com/WallWormModelTools/wwmt_struct_attachment.ms"
fileIn "$scripts/WallWorm.com/common/wwmt_particles.ms"

