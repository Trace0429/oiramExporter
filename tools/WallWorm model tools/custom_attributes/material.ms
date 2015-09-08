global wallworm_material_CA = attributes "Wallworm Material" version:16 (


	local wallworm = true
	local surfaceproplist = #("", "Metal_Box", "Plastic_Box", "Wood_Box", "Wood_Crate", "Wood_Furniture", "Wood_Panel", "Wood_Plank", "Wood_Solid", "Wood_lowdensity", "alienflesh", "antlion", "antlionsand", "armorflesh", "asphalt", "baserock", "bloodyflesh", "boulder", "brakingrubbertire", "brick", "canister", "cardboard", "carpet", "ceiling_tile", "chain", "chainlink", "combine_glass", "combine_metal", "computer", "concrete", "concrete_block", "crowbar", "default", "default_silent", "dirt", "flesh", "floating_metal_barrel", "floatingstandable", "foliage", "glass", "glassbottle", "grass", "gravel", "gravel", "grenade", "gunship", "ice", "item", "jeeptire", "ladder", "metal", "metal_barrel", "metal_bouncy", "metal_seafloorcar", "metalgrate", "metalpanel", "metalvehicle", "metalvent", "mud", "no_decal", "paintcan", "paper", "papercup", "plaster", "plastic", "plastic_barrel", "plastic_barrel_buoyant", "player", "player_control_clip", "popcan", "pottery", "quicksand", "rock", "roller", "rubber", "rubbertire", "sand", "slidingrubbertire", "slidingrubbertire_front", "slidingrubbertire_rear", "slime", "slipperymetal", "slipperyslime", "snow", "solidmetal", "strider", "tile", "wade", "water", "watermelon", "weapon", "wood", "zombieflesh")
	local detaillist = #("","swamp_land_002","grass01","grass02","coastline_grass01","coastline_grass02","coastline_redgrass01","coastline_redgrass02","coastline_redgrass03","citygrass01","redgrass","redgrass_light","short_redgrass","PerfTest1","canal_reeds","rocks_redgrass","lostcoast_grass","lostcoast_grass2")
	local displacementRollout, compileRollout, params,modelsRollout,miscRollout,decalRollout
	
	
	
	parameters main rollout:params (

		forModel type:#boolean default:false ui:chk_forModel animatable:false
		valveShader type:#string default:"LightmappedGeneric" animatable:false -- VertexLitGeneric , UnlitGeneric, WorldVertexTransition
		surfaceproperty type:#string default:"" animatable:false
		ssbump type:#boolean default:false ui:chk_ssbump animatable:false
		ignorez  type:#boolean default:false ui:chk_ignorez animatable:false 
		vertexfog type:#boolean default:false ui:chk_vertexfog animatable:false
		ww_vertexcolor type:#boolean default:false ui:chk_ww_vertexcolor animatable:false
		vertexalpha type:#boolean default:false ui:chk_vertexalpha animatable:false
		
		receiveflashlight type:#boolean ui:chk_receiveflashlight  animatable:false default:false
		singlepassflashlight type:#boolean ui:chk_singlepassflashlight animatable:false default:false
		
		nofog type:#boolean default:false ui:chk_nofog animatable:false
		alphatest type:#boolean default:false ui:chk_alphatest animatable:false
		AlphaTestReference type:#float  ui:spn_AlphaTestReference default:0.5 animatable:false
		useColor type:#boolean ui:ch_useColor default:false animatable:false
		blendTintByBaseAlpha type:#boolean ui:ck_blendTintByBaseAlpha default:false animatable:false
		blendTintColorOverBase  type:#float  ui:sp_blendTintColorOverBase default:0.0 animatable:false
	)
	
	
	parameters decalMain rollout:decalRollout (
		decal type:#boolean default:false ui:chk_decal animatable:false
		writeZ type:#boolean default:false ui:chk_writeZ animatable:false
		decalscale type:#float default:1.0 ui:spn_decalscale animatable:false
		modelmaterial type:#string default:"" ui:edt_modelmaterial animatable:false
		decalfadeduration type:#float default:1.0 ui:spn_decalfadeduration animatable:false
		decalfadetime type:#float default: 1.0 ui:spn_decalfadetime animatable:false
		fogscale type:#float default: 1.0 ui:spn_fogscale animatable:false

	)


	
	parameters modelsMain rollout:modelsRollout (
		cdmaterials type:#string default:"" ui:edt_cdmaterials animatable:false
		
		halflambert type:#boolean default:false ui:chk_halflambert animatable:false  --VertexLitGeneric. 
		FlashlightNoLambert type:#boolean default:false ui:chk_FlashlightNoLambert animatable:false 
		
		rimlight type:#boolean ui:chk_rimlight default:false animatable:false -- only with phong
		rimexponent type:#integer ui:spn_rimexponent default:2  animatable:false
		rimboost  type:#integer ui:spn_rimboost default:1 animatable:false
		rimmask  type:#boolean ui:chk_rimmask default:false  animatable:false
		
		phongboost type:#float default:1.0 ui:spn_phongboost animatable:false
		phongfresnelranges type:#string  default:"0 0.5 1" ui:edt_phongfresnelranges animatable:false
		phongexponent type:#integer default:5 ui:spn_phongexponent animatable:false		
		
		

		disablecsmlookup type:#boolean ui:chk_disablecsmlookup default:false animatable:false
		
		use_maxfogdensityscalar type:#boolean default:false ui:chk_use_maxfogdensityscalar animatable:false
		maxfogdensityscalar type:#float default:0.0 ui:spn_maxfogdensityscalar animatable:false
		
		treeSway  type:#boolean default:false ui:chk_treeSway  animatable:false
		treeSwayHeight type:#float ui:spn_treeSwayHeight default: 200.0 animatable:false
		treeSwayStartHeight type:#float default:.5 ui:spn_treeSwayStartHeight   animatable:false
		treeSwayRadius type:#float default:200.0 ui:spn_treeSwayRadius  animatable:false
		treeSwayStartRadius type:#float default:0.0 ui:spn_treeSwayStartRadius animatable:false
		treeSwaySpeed type:#float default:.2  ui:spn_treeSwaySpeed animatable:false
		treeSwayStrength type:#float default:1.0 ui:spn_treeSwayStrength animatable:false
		treeSwayScrumbleSpeed type:#float default:.2 ui:spn_treeSwayScrumbleSpeed animatable:false
		treeSwayScrumbleStrength type:#float default:1.0 ui:spn_treeSwayScrumbleStrength animatable:false
		treeSwayScrumbleFrequency type:#float default:2.0 ui:spn_treeSwayScrumbleFrequency animatable:false
		treeSwayFalloffExp type:#float default:32.0  ui:spn_treeSwayFalloffExp animatable:false
		treeSwayScrumbleFalloffExp type:#float default:32.0 ui:spn_treeSwayScrumbleFalloffExp animatable:false
		treeSwaySpeedHighWindMultiplier type:#float default:1.0  ui:spn_treeSwaySpeedHighWindMultiplier animatable:false
		treeSwaySpeedLerpStart type:#float default:200.0  ui:spn_treeSwaySpeedLerpStart animatable:false
		treeSwaySpeedLerpEnd type:#float default:600.0   ui:spn_treeSwaySpeedLerpEnd animatable:false
		
		detailsprite type:#boolean default:false ui:chk_detailsprite animatable:false
		useJitter type:#boolean default:false ui:chk_useJitter animatable:false
				
		lightjittercolour type:#color ui:cp_lightjittercolour animatable:false	default:(color 255 229.5 127.5)
		lightjitteramount	type:#float  ui:spn_lightjitteramount animatable:false	default:0.3	
			
		lightjittersin1angle	type:#float  ui:spn_lightjittersin1angle animatable:false	default:180.0
		lightjittersin1speed	type:#float  ui:spn_lightjittersin1speed animatable:false	default:150
		lightjittersin1dispersion	type:#float  ui:spn_lightjittersin1dispersion animatable:false default:0.02
		
		lightjittersin2angle	type:#float  ui:spn_lightjittersin2angle animatable:false	default:180.0
		lightjittersin2speed	type:#float  ui:spn_lightjittersin2speed animatable:false	default:150
		lightjittersin2dispersion	type:#float  ui:spn_lightjittersin2dispersion animatable:false	default:0.02
		
		lightjittersin3angle		type:#float  ui:spn_lightjittersin3angle animatable:false	default:180.8
		lightjittersin3speed		type:#float  ui:spn_lightjittersin3speed animatable:false	default:140.0
		lightjittersin3dispersion	type:#float  ui:spn_lightjittersin3dispersion animatable:false	default:0.03

		lightjittergustmultiplier type:#float  ui:spn_lightjittergustmultiplier animatable:false	default:7.0
		lightjittergustspeed type:#float  ui:spn_lightjittergustspeed animatable:false	default:10.0
	)

	
	
	parameters displacementMain rollout:displacementRollout (
		
		use_seamless_scale type:#boolean default:false ui:chk_use_seamless_scale animatable:false

		seamless_scale type:#float  default:0.005 ui:spn_seamless_scale animatable:false
		detail type:#string default:""  animatable:false
		--detail2 type:#string default:"" animatable:false
		surfaceproperty2 type:#string default:""  animatable:false
		ssbump2 type:#boolean default:false ui:chk_ssbump2  animatable:false
		
	)
	

	
	parameters compileMain rollout:compileRollout (
		
		compileclip type:#boolean ui:chk_compileclip animatable:false
		compilenodraw type:#boolean ui:chk_compilenodraw animatable:false
		compilenonsolid type:#boolean ui:chk_compilenonsolid animatable:false
		compilepassbullets type:#boolean ui:chk_compilepassbullets animatable:false
		
		compile2Dsky type:#boolean ui:chk_compile2Dsky animatable:false
		compileDetail type:#boolean ui:chk_compileDetail animatable:false
		compilefog type:#boolean ui:chk_compilefog animatable:false
		compilehint type:#boolean ui:chk_compilehint animatable:false
		compileladder type:#boolean ui:chk_compileladder animatable:false
		compileNoLight type:#boolean ui:chk_compileNoLight animatable:false
		compilenpcclip type:#boolean ui:chk_compilenpcclip animatable:false
		compileorigin type:#boolean ui:chk_compileorigin animatable:false
		compileplayercontrolclip type:#boolean ui:chk_compileplayercontrolclip animatable:false
		compileskip type:#boolean ui:chk_compileskip animatable:false
		compilesky type:#boolean ui:chk_compilesky animatable:false
		compileSlime type:#boolean ui:chk_compileSlime animatable:false
		compileTeam type:#boolean ui:chk_compileTeam animatable:false
		compiletrigger type:#boolean ui:chk_compiletrigger animatable:false
		compilewater type:#boolean ui:chk_compilewater animatable:false
		
		)

		
			
		function getMyVMTName = (
			vmtname = (custAttributes.getOwner this).name
		)
			
		function getMyVMTFileName = (
			global wwmt_gameInfoDir
			if wwmt_gameInfoDir != undefined then (
				materialPath = getMyVMTName()
				if forModel == true AND cdmaterials != "" then (

					materialPath = cdmaterials+"/"+getFileNameFile materialPath
					
				) else (
						
				)
				
				 return 	(wwmt_gameInfoDir+"/materials/"+(materialPath)+".vmt")
			)
			undefined
		)
			
	
	
	function getRolloutByName theRollout theSubRolloutName = (
			for subr in theRollout do (
					if subr.name == theSubRolloutName then (
							return subr
					)
			)
		
	)
	
	function checkDecal dontclose:true= (
		
		decalRollout.spn_decalscale.enabled = decal
		decalRollout.spn_decalfadeduration.enabled=decal
		decalRollout.spn_decalfadetime.enabled=decal
		decalRollout.spn_fogscale.enabled=decal	
		decalRollout.edt_modelmaterial.enabled=decal	
		decalRollout.chk_writeZ.enabled = decal
/*

		decalRollout.chk_vertexalpha.enabled = decal
		decalRollout.chk_ww_vertexcolor.enabled = decal
		*/
		if dontclose == false then (
			decalRollout.open = decal
		)
		
	)	
	
	function update_surface2_list val = (
		

			if findItem displacementRollout.cmb_surfaceproperty2.items val == 0 then (
				theItems = displacementRollout.cmb_surfaceproperty2.items
				append theItems val
				sort theItems
				displacementRollout.cmb_surfaceproperty2.items = theItems
			)
			displacementRollout.cmb_surfaceproperty2.selection = findItem displacementRollout.cmb_surfaceproperty2.items val
			surfaceproperty2 = val
	)
	
	function update_detail_list_from_scene = (
		scenedetailtypes = makeUniqueArray (for obj in objects where classof obj == WallWormDetailType collect obj.name )
		if scenedetailtypes.count > 0 then (
			theItems = displacementRollout.cmb_detail.items
			
			for sd in scenedetailtypes WHERE findItem theItems sd == 0 do (
				
				append theItems sd
			)
			
			sort theItems
			displacementRollout.cmb_detail.items = theItems
			
			displacementRollout.cmb_detail.selection = findItem displacementRollout.cmb_detail.items detail
		)
		
	)
	
	function update_detail_list val = (
		

			if findItem displacementRollout.cmb_detail.items val == 0 then (
				theItems = displacementRollout.cmb_detail.items
				append theItems val
				sort theItems
				displacementRollout.cmb_detail.items = theItems
			)
			displacementRollout.cmb_detail.selection = findItem displacementRollout.cmb_detail.items val
			detail = val
	)
	/*
	function update_detail2_list val = (

			if findItem displacementRollout.cmb_detail2.items val == 0 then (
				theItems = displacementRollout.cmb_detail2.items
				append theItems val
				sort theItems
				displacementRollout.cmb_detail2.items = theItems
			)
			displacementRollout.cmb_detail2.selection = findItem displacementRollout.cmb_detail2.items val
			detail2 = val
	)
	*/
	function displacementCheck = (
		
		
	--	local rnode = refs.dependentnodes (custAttributes.getOwner this) firstonly:on
		--print (classof (custAttributes.getOwner this))
		
			
		if (classof (custAttributes.getOwner this)) == Blend then (
			valveShader = "WorldVertexTransition"
			params.drp_valveShader.items = #("WorldVertexTransition")
			--drp_valveShader.enabled = false
			
			forModel = false
			params.chk_forModel.enabled = false
			decal = false
			checkDecal()
		)
			
		if valveShader == "WorldVertexTransition" then (
			
			params.drp_valveShader.items = #("WorldVertexTransition")
			params.drp_valveShader.selection = 1
			
			

			displacementRollout.cmb_detail.enabled = true
			--displacementRollout.cmb_detail2.enabled = true
			displacementRollout.chk_use_seamless_scale.enabled = true
			displacementRollout.spn_seamless_scale.enabled = true
			displacementRollout.cmb_surfaceproperty2.enabled = true
			displacementRollout.open = true
			
			
		) else (

			displacementRollout.cmb_detail.enabled = false
			--displacementRollout.cmb_detail2.enabled = false
			displacementRollout.chk_use_seamless_scale.enabled = false
			displacementRollout.spn_seamless_scale.enabled = false
			displacementRollout.cmb_surfaceproperty2.enabled = false
			displacementRollout.open = false
		)
		
		
	)
	
	
	
	function VertexLitCheck = (
		

		if valveShader == "VertexLitGeneric" then (
				modelsRollout.chk_halflambert.enabled = true
		) else (
				modelsRollout.chk_halflambert.enabled = false
		)
	)
	
	function checkTreesway = (
		local treeSwayEnable 
		if treeSway == true AND modelsRollout.chk_treeSway.enabled == true then (
			treeSwayEnable = true
		) 	else (
			treeSwayEnable = false
		)
			modelsRollout.spn_treeSwayHeight.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayStartHeight.enabled = treeSwayEnable  
			modelsRollout.spn_treeSwayRadius.enabled = treeSwayEnable 
			modelsRollout.spn_treeSwayStartRadius.enabled = treeSwayEnable
			modelsRollout.spn_treeSwaySpeed.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayStrength.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayScrumbleSpeed.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayScrumbleStrength.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayScrumbleFrequency.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayFalloffExp.enabled = treeSwayEnable
			modelsRollout.spn_treeSwayScrumbleFalloffExp.enabled = treeSwayEnable
			modelsRollout.spn_treeSwaySpeedHighWindMultiplier.enabled = treeSwayEnable
			modelsRollout.spn_treeSwaySpeedLerpStart.enabled = treeSwayEnable
			modelsRollout.spn_treeSwaySpeedLerpEnd.enabled = treeSwayEnable
			
	)
	
	
	function modelCheck = (

		modelsRollout.chk_disablecsmlookup.enabled=forModel
		modelsRollout.edt_cdmaterials.enabled = forModel
		modelsRollout.chk_treeSway.enabled = forModel		
		modelsRollout.chk_FlashlightNoLambert.enabled=forModel
		modelsRollout.chk_halflambert.enabled = forModel
		modelsRollout.spn_phongboost.enabled = forModel		
		modelsRollout.spn_phongexponent.enabled=forModel
		modelsRollout.edt_phongfresnelranges.enabled = forModel
		modelsRollout.chk_rimlight.enabled = forModel	

		
		if rimlight == true AND forModel == true then (
			modelsRollout.spn_rimexponent.enabled=rimlight
			modelsRollout.spn_rimboost.enabled = rimlight
			modelsRollout.chk_rimmask.enabled = rimlight
		) else (
			modelsRollout.spn_rimexponent.enabled=false
			modelsRollout.spn_rimboost.enabled = false
			modelsRollout.chk_rimmask.enabled = false
		)
		
	
		modelsRollout.chk_disablecsmlookup.enabled=forModel
		modelsRollout.chk_use_maxfogdensityscalar.enabled = forModel
		
		if use_maxfogdensityscalar == true AND forModel == true then (
			modelsRollout.spn_maxfogdensityscalar.enabled = true		
		) else (
				modelsRollout.spn_maxfogdensityscalar.enabled = false		
		)
		
		

		miscRollout.spn_radAmount.enabled = not forModel
		
		if forModel == true then (
			params.drp_valveShader.items = #("VertexLitGeneric","UnlitGeneric","Refract")

			params.drp_valveShader.selection = findItem params.drp_valveShader.items valveShader


			if cdmaterials == "" AND detailsprite == false then (
				
				cdmaterials	 = getFileNamePath ((custAttributes.getOwner this).name)
				
				try (
					cdmaterials = wallworm_safe_path cdmaterials
					cdmaterials = wallworm_remove_first_slash cdmaterials
					cdmaterials = wallworm_remove_last_slash cdmaterials
				) catch (
					
					print "The $cdmaterials sanitzation failed... probably because wallworm isn't loaded. Make sure it has no starting or trailing slashes."
					
					)
				
				modelsRollout.edt_cdmaterials.text = cdmaterials
			)

		) else (


			if (classof (custAttributes.getOwner this)) == Blend then (
				valveShader = "WorldVertexTransition"
				params.drp_valveShader.items = #("WorldVertexTransition")

			) else (
				params.drp_valveShader.items = #("LightmappedGeneric","UnlitGeneric","Water","Sky","Refract","DecalModulate")
				params.drp_valveShader.selection = findItem params.drp_valveShader.items valveShader			
			)
		)
		checkTreesway()
		
		if forModel == false then (modelsRollout.open = forModel)
	)
	




	rollout params "Wall Worm Source Material Settings" (
		
		
		
		checkbox chk_forModel "For Model"
		
		
		dropdownlist drp_valveShader "Source Shader" items:#("LightmappedGeneric","UnlitGeneric","WorldVertexTransition","Water","Sky","Refract","DecalModulate")
		combobox cmb_surfaceproperty "Surface Property" items:surfaceproplist

		checkbox ch_useColor "Use Diffuse Color even with Bitmap" tooltip:"Add the diffuse color into the VMT even when there is a bitmap."
		
		checkbox ck_blendTintByBaseAlpha "$blendTintByBaseAlpha" toolTip:"Enables the use of an alpha mask to define areas to tint. Uses the mask of the Base Texture."
		spinner sp_blendTintColorOverBase "$blendTintColorOverBase" type:#float scale:0.01  range:[0.0,1.0,0.0] toolTip:"Sets the amount to replace with solid color. A value of '0' will be full tint while a value of '1.00' will replace the albedo in the mask area with the color defined with $color2. Default value is '0'."

		
		
		checkbox chk_ssbump "Self Shadowing Bump Map ($ssbump)"
		checkbox chk_ignorez "Ignore Z"

		checkbox chk_vertexfog "Vertex Fog"  enabled:true
		checkbox chk_vertexalpha "Vertex Alpha" 
		checkbox chk_ww_vertexcolor "Vertex Color" 
		
		
		checkbox chk_receiveflashlight "Receive Flashlight" tooltip:"Allow the player's flashlight to illuminate the material. " enabled:true
		checkbox chk_singlepassflashlight "Single Pass Flashlight" enabled:true
		checkbox chk_nofog "No Fog"



		Group "Alpha Settings" (
			label alphalabel "Use Opacity for Alpha and 2-Sided for Nocull"
			checkbox chk_alphatest "Alpha Test"
			spinner spn_AlphaTestReference "Alpha Test Reference" range:[0.0,1.0,0.5]

		)
		
		



		
		

		

/*		group "Compile Parameters" (




			
			checkbox chk_compile2Dsky "Compile 2D Sky"
			checkbox chk_compileclip "Compile Clip"
			checkbox chk_compileDetail "Compile Detail"
			checkbox chk_compilefog "Compile Fog"
			checkbox chk_compilehint "Compile Hint"
			checkbox chk_compileladder "Compile Ladder"
			checkbox chk_compilenodraw "Compile No Draw"
			checkbox chk_compileNoLight "Compile No Light"
			checkbox chk_compilenonsolid "Compile Non Solid"
			checkbox chk_compilenpcclip "Compile NPC Clip"
			checkbox chk_compileorigin "Compile Origin"
			checkbox chk_compilepassbullets "Compile Pass Bullets"
			checkbox chk_compileplayercontrolclip "Compile Player Control Clip"
			checkbox chk_compileskip "Compile Skip"
			checkbox chk_compilesky "Compile Sky"
			checkbox chk_compileSlime "Compile Slime"
			checkbox chk_compileTeam "Compile Team"
			checkbox chk_compiletrigger "Compile Trigger"
			checkbox chk_compilewater "Compile Water"
			
		)
		*/
		

		
	function setUIElements = (
		modelsRollout.spn_maxfogdensityscalar.enabled = use_maxfogdensityscalar
		displacementRollout.spn_seamless_scale.enabled = use_seamless_scale
	)
	
	function displacementOpts = (
		
		
	)
	

	
	function update_surface_list val = (
		

			if findItem cmb_surfaceproperty.items val == 0 then (
				theItems = cmb_surfaceproperty.items
				append theItems val
				sort theItems
				cmb_surfaceproperty.items = theItems
			)
			cmb_surfaceproperty.selection = findItem cmb_surfaceproperty.items val
			surfaceproperty = val
	)
	
	
	

	
	function update_shader_list val = (
		--print val
		if (classof (custAttributes.getOwner this)) == Blend then (
			val = "WorldVertexTransition"
			valveShader = "WorldVertexTransition"
			drp_valveShader.items = #("WorldVertexTransition")
			--drp_valveShader.enabled = false
			drp_valveShader.selection = 1
		) else (
			
			if findItem drp_valveShader.items val == 0 then (
				theItems = drp_valveShader.items
				append theItems val
				sort theItems
				drp_valveShader.items = theItems
			)
			drp_valveShader.selection = findItem drp_valveShader.items val
			valveShader = val
		)
		
		if valveShader == "DecalModulate" then (
			decal = true
			decalRollout.chk_decal.checked = true
			checkDecal()
			decalRollout.chk_writeZ.enabled = true
			
		) else (
			decalRollout.chk_writeZ.enabled = false


			
			
			
		)
		
			if valveShader == "LightmappedGeneric" OR  valveShader == "WorldVertexTransition" then ( 
				chk_ssbump.enabled = true		
				displacementRollout.chk_ssbump2.enabled = true		
						
			) else (
				chk_ssbump.enabled = false		
				displacementRollout.chk_ssbump2.enabled = false		
				
			)
		
		
		
		VertexLitCheck()


	)
	


	
	on cmb_surfaceproperty entered val do (
		update_surface_list val 
	)
	
	on cmb_surfaceproperty selected sel do (
		update_surface_list cmb_surfaceproperty.selected
	)
	

	
	

	

	
	
	
	on chk_forModel changed stat do (
		modelCheck()
		if findItem drp_valveShader.items valveShader == 0 then (

			if forModel then (
				valveShader = "VertexLitGeneric"
			) else (
				valveShader = "LightmappedGeneric"
			)
			drp_valveShader.selection = findItem drp_valveShader.items valveShader
		)
		
		
	)
	
	on params open do (
		
		cmb_surfaceproperty.items = surfaceproplist
		update_surface_list surfaceproperty 
		update_shader_list valveShader
		displacementCheck()
		if valveShader == "WorldVertexTransition" OR valveShader=="LightmappedGeneric" OR valveShader=="Sky" then (
			forModel = false
		)
		
		modelCheck()
		checkDecal()
		VertexLitCheck()

	)
	
	
	on drp_valveShader selected sel do (
		valveShader = drp_valveShader.selected
		displacementCheck()
		checkTreesway()
	)
	
	

		
		

		on chk_use_seamless_scale changed stat do (
			setUIElements()
		)
		
	on drp_valveShader selected sel do (
		update_shader_list drp_valveShader.selected
		VertexLitCheck()
	)
		
	
	)


		
	
	rollout modelsRollout "Model Shader Settings" (
		
		editText edt_cdmaterials "$cdmaterials" toolTip:"Enter the Output Path for this material if it is a model material." enabled:forModel
		checkbox chk_FlashlightNoLambert "Flashlight No Lambert"  enabled:forModel
		checkbox chk_halflambert "Half Lambert" enabled:forModel
		group "Phong" (
						label phongNote "Only works if Standard Shader Type set to Phong"
			
						spinner spn_phongboost "Phong Boost" type:#float range:[0.0,32.0,1.0] enabled:forModel
						spinner spn_phongexponent "Phong Exponent" type:#integer step:1 range:[0,32,5] enabled:forModel
			
						editText edt_phongfresnelranges "Phong Fresnel Ranges"  enabled:forModel

						checkbox chk_rimlight "Rim Light" enabled:forModel
			
						spinner spn_rimexponent "Rim Light Exponent" default:2 enabled:rimlight animatable:false type:#integer step:1
						spinner spn_rimboost "Rim Light Boost" default:1 enabled:rimlight animatable:false type:#integer step:1
						checkbox chk_rimmask "Rim Light Mask" default:false enabled:rimlight animatable:false
			
			
		)
		

		checkbox chk_disablecsmlookup "Disable CSM Lookup"  enabled:forModel
		group "Tree Sway" (
			checkbox chk_treeSway "Tree Sway" enabled:forModel
			spinner spn_treeSwayHeight "Tree Sway Height" range:[0,1024,200] enabled:treeSway
			spinner spn_treeSwayStartHeight   "Tree Sway Start Height" range:[0.0,32.0,0.5] enabled:treeSway
			spinner spn_treeSwayRadius "Tree Sway Radius"  range:[0,1024,100] enabled:treeSway
			spinner spn_treeSwayStartRadius "Tree Sway Start Radius"  range:[0.0,32.0,0.5] enabled:treeSway
			spinner spn_treeSwaySpeed "Tree Sway Speed"  range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayStrength "Tree Sway Strength" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayScrumbleSpeed "Tree Sway Scrumble Speed" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayScrumbleStrength "Tree Sway Scrumble Strength" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayScrumbleFrequency "Tree Sway Scrumble Frequency" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayFalloffExp "Tree Sway Falloff Exponent" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwayScrumbleFalloffExp "Tree Sway Scrumble Falloff Exponent" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwaySpeedHighWindMultiplier "Tree Sway High Wind Multiplier" range:[0.0,1000,1.1] enabled:treeSway
			spinner spn_treeSwaySpeedLerpStart "Tree Sway Speed Lerp Start" range:[0.0,1000,0.5] enabled:treeSway
			spinner spn_treeSwaySpeedLerpEnd "Tree Sway Speed Lerp End" range:[0.0,1000,0.5] enabled:treeSway
		)
		
		checkbox chk_use_maxfogdensityscalar "Use Max Fog Density" toolTip:"Check here to use the Max Fog Density."  enabled:forModel
		spinner spn_maxfogdensityscalar "Max Fog Density" range:[0.0,1.0,0.0] enabled:use_maxfogdensityscalar -- enabled:use_maxfogdensityscalar 
		
		
		on chk_treeSway changed stat do (
			
				checkTreesway()
		)
	
		on chk_rimlight changed stat do (
			
			spn_rimexponent.enabled = stat
			spn_rimboost.enabled = stat
			chk_rimmask.enabled = stat
		)
	
		on chk_use_maxfogdensityscalar changed stat do (
			spn_maxfogdensityscalar.enabled = stat
		)
		
		on modelsRollout open do (
			
			modelCheck()
		)
		
		checkbox chk_detailsprite "Detail Sprite" tooltip:"Set the Detailsprite setting for this material."

		group "Jitter Settings" (
			checkbox chk_useJitter "Use Jitter" tooltip:"Enable and use the Jitter Settings" -- enabled:detailsprite
			
			colorpicker cp_lightjittercolour "Light Jitter Color" enabled:useJitter
			spinner spn_lightjitteramount "Light Jitter Amount" enabled:useJitter
				
			spinner spn_lightjittersin1angle "Light Jitter Angle 1" enabled:useJitter
			spinner spn_lightjittersin1speed "Light Jitter Speed 1" enabled:useJitter
			spinner spn_lightjittersin1dispersion "Light Jitter Dispersion 1" enabled:useJitter
			
			spinner spn_lightjittersin2angle "Light Jitter Angle 2" enabled:useJitter
			spinner spn_lightjittersin2speed "Light Jitter Speed 2" enabled:useJitter
			spinner spn_lightjittersin2dispersion "Light Jitter Dispersion 2" enabled:useJitter
				
			spinner spn_lightjittersin3angle "Light Jitter Angle 3" enabled:useJitter
			spinner spn_lightjittersin3speed "Light Jitter Speed 3" enabled:useJitter
			spinner spn_lightjittersin3dispersion "Light Jitter Dispersion 3" enabled:useJitter
				
			spinner spn_lightjittergustmultiplier "Light Jitter Gust Multiplier" enabled:useJitter
			spinner spn_lightjittergustspeed "Light Jitter Gust Speed" enabled:useJitter
			
		)
		
		function setJitterFields = (
			
			

			
			spn_lightjitteramount.enabled = useJitter
			spn_lightjittersin1angle.enabled = useJitter
			spn_lightjittersin1speed.enabled = useJitter
			spn_lightjittersin1dispersion.enabled = useJitter
			
			spn_lightjittersin2angle.enabled = useJitter
			spn_lightjittersin2speed.enabled = useJitter
			spn_lightjittersin2dispersion.enabled = useJitter
				
			spn_lightjittersin3angle.enabled = useJitter
			spn_lightjittersin3speed.enabled = useJitter
			spn_lightjittersin3dispersion.enabled = useJitter
				
			spn_lightjittergustmultiplier.enabled = useJitter
			spn_lightjittergustspeed.enabled = useJitter
			cp_lightjittercolour.enabled = useJitter
		)
		
		on chk_detailsprite changed stat do (
			
			chk_useJitter.enabled = true
			setJitterFields()
		)
		
		on chk_useJitter changed stat do (


			setJitterFields()

			
		)
		
	
		
	)	
	
	
	
	rollout displacementRollout "WorldVertexShader (Blend) Settings" (
			combobox cmb_detail "Detail Type" items:detaillist
			button btn_update_details "Update List from Scene Details" tooltip:"Update the list from the detail types in the scene. Requires the Detailer Plugin."
			label dispnote "NOTE: surfaceprop2 refer to Material 1 in Blend"
			
			combobox cmb_surfaceproperty2 "Surface Property2" items:surfaceproplist
			--combobox cmb_detail2 "Detail Type 2" items:detaillist
			checkbox chk_use_seamless_scale "Use Seamless Scale" toolTip:"Check here to use the Seamless Scale"
			spinner spn_seamless_scale "Seamless Scale" rang:[0.0001,16.000,0.001] --enabled:use_seamless_scale
			checkbox chk_ssbump2 "Self Shadowing Bump Map ($ssbump2)"
		
			on btn_update_details pressed do (
				update_detail_list_from_scene()
			)
		
			on cmb_detail selected sel do (
				update_detail_list cmb_detail.selected
			)
			
			on cmb_detail entered tex do (
				
				update_detail_list tex
			)
			/*
			on cmb_detail2 selected sel do (
				update_detail2_list cmb_detail2.selected
			)
			on cmb_detail2 entered tex do (
				
				update_detail2_list tex
			)*/
			on cmb_surfaceproperty2 entered val do (
				update_surface2_list val 
			)
			
			on cmb_surfaceproperty2 selected sel do (
				update_surface2_list cmb_surfaceproperty2.selected
			)
			
			
			on displacementRollout open do (

				
				if forModel == false then (

					--update_detail2_list detail2
					update_detail_list detail
					update_surface2_list surfaceproperty2
					cmb_detail.items = detaillist
					--cmb_detail2.items = detaillist
					
					update_detail_list detail 
					--update_detail2_list detail2 
				) else (

				)
						
				displacementCheck()
				
			)
			
		
	)
	
	rollout 	decalRollout "Decal Settings" (

		
			checkbox chk_decal "Decal"
			
			spinner spn_decalscale "Decal Scale" enabled:decal range:[0.0,128.0,1.0]
			spinner spn_decalfadeduration "Decal Fade Duration" enabled:decal range:[0.0,1024.0,1.0]
			spinner spn_decalfadetime "Decal Fade Time" enabled:decal range:[0.0,1024.0,1.0]
			spinner spn_fogscale "Decal Fog Scale" enabled:decal range:[0.0,1024.0,1.0]
			editText edt_modelmaterial "Model Material Name" enabled:decal
			checkbox chk_writeZ "Write Z"  enabled:decal toolTip:"Only available if the Source Shader is set to DecalModulate."

			on chk_decal changed stat do (
					checkDecal()
			)
			
			on decalRollout open do (
				
				checkDecal dontclose:false
			)
		
	)

	
	
	parameters envmapvars rollout:envmaprollout (
		
		useReflectivity type:#boolean ui:ch_useRefelctivity animatable:false default:false
		reflectivity type:#color ui:cp_reflectivity animatable:false default:(color 255 255 255)
		
		useEnvSettings type:#boolean ui:ch_useEnvSettings animatable:false default:false
		envmaptint type:#color ui:cp_envmaptint animatable:false default:(color 255 255 255)
		envmapcontrast type:#float ui:sp_envmapcontrast default:0.0  animatable:false
		envmapsaturation type:#float ui:sp_envmapsaturation default:1.0  animatable:false
	)
	
	
	rollout envmaprollout "Reflections and Env" (

		label envlabel "Use Specular Level for envmapmask. Use Reflection for envmap."
		
		checkbox ch_useRefelctivity "Use Reflectivity Setting"
		colorpicker  cp_reflectivity "$reflectivity" enabled:useReflectivity  tooltip:"$reflectivity overrides a VTF file's embedded reflectivity value. It tells VRAD how much light should be bounced off the material, without affecting how much it receives. "
		group "Env Settings" (
			checkbox ch_useEnvSettings "Use Env Settings:"
			colorpicker cp_envmaptint "$envmaptint" enabled:useEnvSettings   tooltip:"Controls the intensity of the reflection's red, green and blue color channels. Any positive number can be used. Default is \"[1 1 1]\", which means 100% intensity.\n\nThis command is often used to dim the brightness of a specular reflection without the overhead of an $envmapmask."
			spinner sp_envmapcontrast "$envmapcontrast" enabled:useEnvSettings  type:#float scale:0.0001 range:[0.0,1.0,0.0] tooltip:"Controls the contrast of the reflection. 0 is natural contrast, while 1 is the full squaring of the color (i.e. color*color).\n\nUse higher contrasts to diminish relatively darker areas and increase hot spots.\n\nWill not work when Phong is enabled"
			spinner sp_envmapsaturation "$envmapsaturation" enabled:useEnvSettings  type:#float range:[0.0,1.0,0.0] scale:0.0001 tooltip:"Controls the colour saturation of the reflection. 0 is greyscale, while 1 is natural saturation.\n\nWill not work when Phong is enabled"
		)
		
		on envmaprollout open do (
			
			cp_reflectivity.enabled = useReflectivity
			
			
			cp_envmaptint.enabled = useEnvSettings
			sp_envmapcontrast.enabled = useEnvSettings
			sp_envmapsaturation.enabled = useEnvSettings
		)
		
		on ch_useRefelctivity changed stat do (
			
			cp_reflectivity.enabled = useReflectivity
		)
		
		on ch_useEnvSettings changed stat do (
			cp_envmaptint.enabled = useEnvSettings
			sp_envmapcontrast.enabled = useEnvSettings
			sp_envmapsaturation.enabled = useEnvSettings
		)
		
	)
	
	
	parameters matsandmaps rollout:matsrollout (
		lightwarptexture type:#texturemap ui:mp_lightwarptexture animatable:false
		crackmaterial type:#material ui:mt_crackmaterial animatable:false
		
		parallaxmap	type:#texturemap ui:mp_parallaxmaptexture animatable:false
		parallaxmapscale type:#float default:0.05 ui:sp_parallaxmapscale animatable:false
		
		breakablesurface type:#boolean ui:chk_BreakableSurface animatable:false default:false
		detailscale type:#float default:4.0 animatable:false ui:sp_detailscale
		detailblendfactor type:#float default:0.5 animatable:false ui:sp_detailblendfactor
		detailblendmode type:#integer default:0 animatable:false --ui:sp_detailblendmode
		detailtint type:#color ui:cp_detailtint animatable:false default:(color 127 127 127)
		
		useadvanceddetail type:#boolean ui:ch_useAdvancedDetail animatable:false default:false
		usedetailscale type:#boolean ui:ch_usedetailscale animatable:false default:false
	)
	
	rollout matsrollout "Extra Maps and Materials" 
	(


		

		
		
		group  "Texture Maps" (
			
			label lightwarplabel "$lightwarptexture" 
			mapButton mp_lightwarptexture "Select lightwarptexture Bitmap" 
			
			label parallaxmaplable "$parallaxmap" 
			mapButton mp_parallaxmaptexture "Select parallaxmap Bitmap" 
			
			spinner sp_parallaxmapscale "Parallax Map Scale" range:[0.0,1.0,0.05] tooltip:"Parallaxmap scale. Brick is good at 0.05."

		)
		group "Detail Texture" (
				label detaillabelinfo "Set Detail Map in Extra Bump property of a Normal Bump in Bump"
				
				checkbox ch_usedetailscale "Use Detail Scale instead of Detail Texture Transform"
				spinner sp_detailscale "$detailscale" enabled:usedetailscale type:#float scale:0.01  range:[0.01,1024.0,4.0]   tooltip:"Fits the detail texture onto the material the given number of times (default = 4). Generally used instead of $detailtexturetransform with a value of around 7 or 8 for a 128px detail texture." 
				checkbox ch_useAdvancedDetail "Use Advanced Detail Settings"
				spinner sp_detailblendfactor "$detailblendfactor" enabled:useadvanceddetail type:#float scale:0.01  range:[0.0,1.0,0.0]  tooltip:"Effectively an $alpha value for the detail texture." 
				dropdownlist dp_detailblendmode "$detailblendmode"  enabled:useadvanceddetail tooltip:"How to combine the detail material with the albedo. " items:#("0 = normal (darken)","1 = additive (lighten)" ,"2 = alpha blend detail over base ","3 = crossfade ","4 = overlays over alpha map" )
				colorpicker cp_detailtint "$detailtint"  enabled:useadvanceddetail
		)
		
		group   "Materials" (
			label crackmatlabel "$crackmaterial" 
			materialButton mt_crackmaterial "Crack Material" tooltip:"The crack material for this material. You may have to use Slate to add this property."
			checkbox chk_BreakableSurface "Breakable Surface" tooltip:"Add Proxy block for breakable surface. May need to further edit VMT."
		)

		function setDetailMode = (
		
				detailblendmode = dp_detailblendmode.selection - 1
			
		)
		
		function setDetailModeUI = (
			
			dp_detailblendmode.selection = detailblendmode + 1
		)
		
		
		on matsrollout open do (
			
			setDetailModeUI()
		)
		
		on dp_detailblendmode selected sel do (
			setDetailMode()
		)
		
		on ch_usedetailscale changed stat do (
			sp_detailscale.enabled = usedetailscale
		)
		
		on ch_useAdvancedDetail changed stat do (
			sp_detailblendfactor.enabled= useadvanceddetail 
			dp_detailblendmode.enabled=useadvanceddetail 
			cp_detailtint.enabled=useadvanceddetail 
		)
		
	)
	
	


		rollout compileRollout "Source Compile Parameters" (
			checkbox chk_compile2Dsky "Compile 2D Sky"
			checkbox chk_compileclip "Compile Clip"
			checkbox chk_compileDetail "Compile Detail"
			checkbox chk_compilefog "Compile Fog"
			checkbox chk_compilehint "Compile Hint"
			checkbox chk_compileladder "Compile Ladder"
			checkbox chk_compilenodraw "Compile No Draw"
			checkbox chk_compileNoLight "Compile No Light"
			checkbox chk_compilenonsolid "Compile Non Solid"
			checkbox chk_compilenpcclip "Compile NPC Clip"
			checkbox chk_compileorigin "Compile Origin"
			checkbox chk_compilepassbullets "Compile Pass Bullets"
			checkbox chk_compileplayercontrolclip "Compile Player Control Clip"
			checkbox chk_compileskip "Compile Skip"
			checkbox chk_compilesky "Compile Sky"
			checkbox chk_compileSlime "Compile Slime"
			checkbox chk_compileTeam "Compile Team"
			checkbox chk_compiletrigger "Compile Trigger"
			checkbox chk_compilewater "Compile Water"
			
		)
		



		parameters miscMain rollout:miscRollout(
			keywords type:#stringTab tabSizeVariable:true  animatable:false
			RadAmount type:#integer default:1000 ui:spn_radAmount animatable:false
			exportTexTransforms type:#boolean default:false ui:chk_texTransforms animatable:false	
		)
		
		rollout miscRollout "Miscellaneous" (
		
			spinner spn_radAmount "Radiosity Amount" type:#integer step:1 range:[1,64000,1000] toolTip:"Brightness for this Material when giving radiosity light in a lights.rad file."
			
			combobox cmb_keywords "Keywords" items:(keywords as array)
			button btn_delete_keyword "Delete Selected Keyword"
			
			checkbox chk_texTransforms "Write Tex Transforms Into VMT" toolTip:"Write the texture transforms into the VMT. Only applicable to Brush Materials since this is always done for materials used on models." 
			button exportMat "Write Material File (VMT)"
			
			button exportMe "Export Textures to VTF"
			
			button openMe "View VMT"
			
			
			hyperlink wwlink "Powered By Wall Worm" address:"http://dev.wallworm.com"  color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
			
			hyperlink valvelink "Valve Shader Wiki" address:"https://developer.valvesoftware.com/wiki/Category:List_of_Shader_Parameters?from=3ds+max+and+wallworm"  color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
			
			
			on exportMat pressed do (



				
						m = (custAttributes.getOwner this)
				
						local exportMatlist = #()
				/*
						if m.forModel == true then (
							exportTexTransforms = true	
						)*/
						local getNameFromPath = false
						local materialPath=getFileNamePath m.name
						if forModel == true AND cdmaterials != "" then (
							getNameFromPath = false
							materialPath = cdmaterials
						) else (
							--materialPath =  m.getMaterialPathForMat m
							--getNameFromPath = true
						)
							
						if wallworm_appendBitmaps == undefined then (
							fileIn "$scripts\\WallWorm.com\\common\\matfuncs1.ms"
							global wallworm_appendBitmaps
						)

						
						wallworm_appendBitmaps m exportMatlist valveShader coords:exportTexTransforms decal:decal getNameFromPath:getNameFromPath forModel:forModel materialPath:materialPath
					


						
						if classOf m == Blend then (

							exportMatlist[1].matName= wallworm_getMaterialName m
							exportMatlist[1].materialPath = ""
						)	else (
							if exportMatlist[1].mat1 == undefined then exportMatlist[1].mat1 = exportMatlist[1].mat
							exportMatlist[1].matName = wallworm_getMaterialName exportMatlist[1].mat1 forModel:forModel
						)	
						
						if m.forModel == true AND m.cdmaterials != "" then (
							
							--exportMatlist[1].materialPath = m.cdmaterials
						) else (
							
							if classOf m != Blend then (
								materialPath =  exportMatlist[1].getMaterialPathForMat m
							)

						)
						exportMatlist[1].setTransforms()
						
					--	if m.diffuseMap == undefined then 

							


							if classOf m == Blend then (
								
								exportMatlist[1].compileTexture m.map1.diffuseMap "diff" writeVMT:true exportVTF:false shoutNotice:true
								
							) else (
								exportMatlist[1].compileTexture m.diffuseMap "diff" writeVMT:true exportVTF:false shoutNotice:true
								
																
							)

			)
			
			on exportMe pressed do (

						global wallworm_exportMatlist
						wallworm_exportMatlist = #((custAttributes.getOwner this))
						try (
							macros.run "wallworm.com" "WallWormAnvilCompileVTFMCR"
						) catch (
								messagebox "Oops... this function only works if Wall Worm is installed. Go to http://dev.wallworm.com"
						)
				
			)

			on openMe pressed do (
				
				global wwmt_gameInfoDir
				local f = getMyVMTFileName()
				if f != undefined then (
				
					print f
					
					if doesFileExist f == true then (
						global wallworm_text_editor
						if wallworm_text_editor == undefined OR wallworm_text_editor == "" then (
							wallworm_text_editor = "notepad.exe"
							)
						folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+f+"\""
						execute folderOpen
						
					) else (
						
							messagebox "This file doesn't exist. Perhaps it is in a VPK or has not been exported yet."
					)
					
				)
				
				
				
			)

			
			
			on cmb_keywords entered tex do (
				
					if findItem keywords tex == 0 then (
						
						append keywords tex
						sort (keywords as array)
						cmb_keywords.items = keywords as array
						
					)
					
					
					
			)
			on btn_delete_keyword pressed do (
				if cmb_keywords.selection > 0 then (
					local kw = (keywords as array)
					ind = findItem kw cmb_keywords.selected
					if ind != 0 then (
						deleteItem kw ind
						cmb_keywords.items = kw as array
						keywords = kw
						
					)
					
				)
				
			)			
			
		)
		
		
	
	function outputme forceModel:false forceDecal:false = (
	
			local forModelCheck = forModel
		
			if forModel == false AND forceModel==true AND 	valveShader != "WorldVertexTransition" AND valveShader != "LightMappedGeneric"    AND valveShader != "Sky"    then (
					forModelCheck = forceModel
			)
			
			local forDecalCheck = decal
			
			if decal == false AND forceDecal==true then (
					forDecalCheck = forceDecal
			)
		
			local outStr = ""
		
			if forModelCheck == true then (
				
				if valveShader != "VertexLitGeneric" then (
					append outStr "\t\"$model\" 1\n"
				)
				if detailsprite == true then (	
					append outStr "\t\"$detailsprite\" 1\n"
				)
				
				if treeSway == true then (

				append outStr "\n\t\"$treeSway\" 1\n"
				append outStr ("\t\"$treeSwayHeight\" \""+(treeSwayHeight as string)+"\"\n")
				append outStr ("\t\"$treeSwayStartHeight\" \""+(treeSwayStartHeight as string)+"\"\n")
				append outStr ("\t\"$treeSwayRadius\" \""+(treeSwayRadius as string)+"\"\n")
				append outStr ("\t\"$treeSwayStartRadius\" \""+(treeSwayStartRadius as string)+"\"\n")
				append outStr ("\t\"$treeSwaySpeed\" \""+(treeSwaySpeed as string)+"\"\n")
				append outStr ("\t\"$treeSwayStrength\" \""+(treeSwayStrength as string)+"\"\n")
				append outStr ("\t\"$treeSwayScrumbleSpeed\" \""+(treeSwayScrumbleSpeed as string)+"\"\n")
				append outStr ("\t\"$treeSwayScrumbleStrength\" \""+(treeSwayScrumbleStrength as string)+"\"\n")
				append outStr ("\t\"$treeSwayScrumbleFrequency\" \""+(treeSwayScrumbleFrequency as string)+"\"\n")
				append outStr ("\t\"$treeSwayFalloffExp\" \""+(treeSwayFalloffExp as string)+"\"\n")
				append outStr ("\t\"$treeSwayScrumbleFalloffExp\" \""+(treeSwayScrumbleFalloffExp as string)+"\"\n")
				append outStr ("\t\"$treeSwaySpeedHighWindMultiplier\" \""+(treeSwaySpeedHighWindMultiplier as string)+"\"\n")
				append outStr ("\t\"$treeSwaySpeedLerpStart\" \""+(treeSwaySpeedLerpStart as string)+"\"\n")
				append outStr ("\t\"$treeSwaySpeedLerpEnd\" \""+(treeSwaySpeedLerpEnd as string)+"\"\n\n")
				
				
				)
				if disablecsmlookup == true then (
					
					append outStr "\t\"$DISABLECSMLOOKUP\" 1\n"
				)
				if valveShader == "VertexLitGeneric" AND halflambert == true  then (
					append outStr "\t\"$halflambert\" 1\n"
				) 
				if  (classof (custAttributes.getOwner this) == Standard) AND (custAttributes.getOwner this).shaderByName == "Phong" then (
					
					append outStr ("\t\"$phongboost\" \""+(phongboost as string)+"\"\n")
					
					--append outStr ("\t\"$phongexponent\" \""+(phongexponent as string)+"\"\n")
					
					append outStr ("\t\"$phongfresnelranges\" \"["+(phongfresnelranges as string)+"]\"\n")
					
					
					if rimlight == true then (
						
						append outStr "\t\"$rimlight\" 1\n"
						
						append outStr ("\t\"$rimexponent\" \""+(rimexponent as string)+"\"\n")
						append outStr ("\t\"$rimboost\" \""+(rimboost as string)+"\"\n")
						if rimmask == true then (
							append outStr ("\t\"$rimmask\" 1\n")
						)
						
					)
						
					
				)
				
			
				if use_maxfogdensityscalar == true then (
					
					
					append outStr ("\t\"$maxfogdensityscalar\" \""+(maxfogdensityscalar as string)+"\"\n")
				)
				
				if FlashlightNoLambert == true then (
					
					append outStr "\t\"$FlashlightNoLambert\" 1\n"
				)
				

			)
			
			
		
		
			if surfaceproperty != "" then (
				append outStr ("\t\"$surfaceproperty\" \""+surfaceproperty+"\"\n")
			)
			
		
			if compileclip == true then (
				append outStr "\t\"\%compileclip\" 1\n"
			)

			if compilenodraw == true then (
				
				append outStr "\t\"\%compilenodraw\" 1\n"
			)
			
			if compilenonsolid == true then (
				
				append outStr "\t\"\%compilenonsolid\" 1\n"
			)
			
			if compilepassbullets == true then (
				
				append outStr "\t\"\%compilepassbullets\" 1\n"
			)
			

			if compilewater == true then (
				
				append outStr "\t\"\%compilewater\" 1\n"
			)	
			if compiletrigger == true then (
				
				append outStr "\t\"\%compiletrigger\" 1\n"
			)
			if compileTeam == true then (
				
				append outStr "\t\"\%compileTeam\" 1\n"
			)
			
			if compile2Dsky == true then (
				
				append outStr "\t\"\%compile2Dsky\" 1\n"
			)
			if compileDetail == true then (
				
				append outStr "\t\"\%compileDetail\" 1\n"
			)
			if compilefog == true then (
				
				append outStr "\t\"\%compilefog\" 1\n"
			)	
			if compilehint == true then (
				
				append outStr "\t\"\%compilehint\" 1\n"
			)
			if compileladder == true then (
				
				append outStr "\t\"\%compileladder\" 1\n"
			)
			if compileNoLight == true then (
				
				append outStr "\t\"\%compileNoLight\" 1\n"
			)
			if compilenpcclip == true then (
				
				append outStr "\t\"\%compilenpcclip\" 1\n"
			)
			if compileorigin == true then (
				
				append outStr "\t\"\%compileorigin\" 1\n"
			)	
			if compileplayercontrolclip == true then (
				
				append outStr "\t\"\%compileplayercontrolclip\" 1\n"
			)
			if compileskip == true then (
				
				append outStr "\t\"\%compileskip\" 1\n"
			)
			if compilesky == true then (
				
				append outStr "\t\"\%compilesky\" 1\n"
			)
			if compileSlime == true then (
				
				append outStr "\t\"\%compileSlime\" 1\n"
			)
			
			
			
			
			
			
			
			if keywords.count > 0  then (
				
				append outStr "\t\"\%keywords\" \""
				hasComma = false
				for k in keywords do (
					
					if hasComma == true then (
						append outStr  ","
						
					) else (
						hasComma = true
					)
					
					append outStr  k
					
				)
				
				append outStr "\"\n"
			)
			

			
			
			if valveShader == "DecalModulate" AND writeZ == true  then (
				append outStr "\t\"$writeZ\" 1\n"
			) 

			
			
			
			
			
			if ssbump == true then (
				
				append outStr "\t\"$ssbump\" 1\n"
			)

			
			if ignorez == true then (
				
				append outStr "\t\"$ignorez\" 1\n"
			)


			if nofog == true then (
				
				append outStr "\t\"$nofog\" 1\n"
			)

			if vertexfog == true then (
				append outStr "\t\"$vertexfog\" 1\n"
			)		

			

			

			
			
				if vertexalpha == true then (
					
					append outStr "\t\"$vertexalpha\" 1\n"
				)
				if ww_vertexcolor == true then (
					
					append outStr "\t\"$vertexcolor\" 1\n"
				)		

				if receiveflashlight == true then (
					
					append outStr "\t\"$receiveflashlight\" 1\n"
				)
				if singlepassflashlight == true then (
					
					append outStr "\t\"$singlepassflashlight\" 1\n"
				)	
				

			
			if forDecalCheck == true then (
				append outStr "\t\"$decal\" 1\n"


				
				

				append outStr ("\t\"$decalscale\" \""+(decalscale as string)+"\"\n")
				append outStr ("\t\"$decalfadeduration\" \""+(decalfadeduration as string)+"\"\n")
				append outStr ("\t\"$decalfadetime\" \""+(decalfadetime as string)+"\"\n")
				if modelmaterial != "" then (
					append outStr ("\t\"$modelmaterial\" \""+(modelmaterial as string)+"\"\n")
				)
			)
		

			




			
			if alphatest == true then (
				
				append outStr "\t\"$alphatest\" 1\n"
				append outStr ("\t\"$AlphaTestReference\" \""+(AlphaTestReference as string)+"\"\n")
			)
			

			
			


			if useJitter == true then (
				append outStr ("\t\"$lightjitteramount\" \""+(lightjitteramount as string)+"\"\n")	
				append outStr ("\t\"$lightjittercolour\" \"["+( (lightjittercolour.r / 255.0) as string)+" "+((lightjittercolour.g / 255.0) as string)+" "+((lightjittercolour.b / 255.0) as string)+"]\"\n")	

				append outStr ("\t\"$lightjittersin1angle\" \""+(lightjittersin1angle as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin1speed\" \""+(lightjittersin1speed as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin1dispersion\" \""+(lightjittersin1dispersion as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin2angle\" \""+(lightjittersin2angle as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin2speed\" \""+(lightjittersin2speed as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin2dispersion\" \""+(lightjittersin2dispersion as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin3angle\" \""+(lightjittersin3angle as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin3speed\" \""+(lightjittersin3speed as string)+"\"\n")	
				append outStr ("\t\"$lightjittersin3dispersion\" \""+(lightjittersin3dispersion as string)+"\"\n")	
				append outStr ("\t\"$lightjittergustmultiplier\" \""+(lightjittergustmultiplier as string)+"\"\n")	
				append outStr ("\t\"$lightjittergustspeed\" \""+(lightjittergustspeed as string)+"\"\n")	
			)
			
			if valveShader == "WorldVertexTransition" AND forModelCheck == false then (
				
				if use_seamless_scale == true then (
					
					
					append outStr ("\t\"$seamless_scale\" \""+(seamless_scale as string)+"\"\n")
				)
				
				if detail != "" then (
					append outStr ("\t\"\%detailtype\" \""+detail+"\"\n")
				)
				/*
				if detail2 != "" then (
					append outStr ("\t\"\%detailtype2\" \""+detail2+"\"\n")
				)*/
				
				if surfaceproperty2 != "" then (
					append outStr ("\t\"$surfaceproperty2\" \""+surfaceproperty2+"\"\n")
				)
				
				
				if ssbump2 == true then (
					append outStr ("\t\"$ssbump2\" 1\n")
				)
				
			)
			


			return outStr
		)

		
		
		
)


