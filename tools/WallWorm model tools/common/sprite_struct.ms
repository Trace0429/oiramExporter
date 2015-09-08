/*
Functions for parsing a detail.vbsp file in Source

Written by Shawn Olson
http://www.shawnolson.net

Copyright (c) 2013 - 2014

for Wall Worm

Sponsored by Robert Briscoe of Dear Esther

*/

function wallworm_cluster_details sel:undefined= (
	
	if sel == undefined then (
		sel = objects
	)
	
	local clusters = #()
	max create mode
	with redraw off
	undo off (
		local disps = for obj in objects WHERE (classof obj.baseobject == WallWormDetailProp OR getUserprop obj "wallworm_imported_detail" != undefined) AND obj.parent != undefined AND findItem (sel as array) obj.parent > 0  collect obj.parent
			
		disps = makeUniqueArray disps
		

		for disp in disps WHERE disp != undefined AND disp.children != undefined do (
			
			local details = for detail in disp.children WHERE detail != undefined AND isValidNode detail AND (classof detail.baseobject == WallWormDetailProp OR getUserprop detail "wallworm_imported_detail" != undefined) collect detail
				
			if details.count > 1 then (
				
				local cluster  = details[1]
				convertToPoly cluster
				
				for di =details.count  to 2 BY -1 do (
				
					cluster.attach details[di] cluster
					
				)
				
				
				cluster.pivot = cluster.center
				resetXForm cluster
				convertToPoly cluster
				
				
				cluster.name = uniquename ("Cluster on " + disp.name+"_")
				cluster.wireColor = disp.wireColor
				append clusters cluster
			) else (
				--print "no details"
			)
			
			
		)
	)
	clusters
)


if wallworm_generateMaterialFromVMT == undefined then (
	fileIn "$scripts/WallWorm.com/common/matgenfuncs.ms"
)


function wallworm_get_prop_detail_sprites = (
	for obj in objects where classOf obj.baseobject == WallWormDetailProp OR getUserProp obj "wallworm_detail_model" != undefined collect obj
)

function wallworm_check_prop_detail_sprite_count = (
 (wallworm_get_prop_detail_sprites()).count <= 65535 
)

function wallworm_export_vbsp = (
		local str = stringstream ""
		details = for obj in objects WHERE classof obj.baseObject == WallWormDetailType collect obj
	
		if details.count > 0 then (
			
			
			format "detail" to:str
			format "\n{\n" to:str
			for t in details do (
				local exptext = (t.export()) as string
				format exptext to:str
				
			)
			format "\n\t}\n" to:str
		)
		(str as string)
)





(
	global wallworm_VBSP

	function wallworm_getPropValFromLine inputline = (
		if inputline == undefined OR inputline == "" then (
				return (#())
		)
		local param = ""
		local val = ""
		lineArray = filterString inputline " "
				
			if lineArray.count > 1 then (
				param = lineArray[1]
				
				
				val= substring inputline ((findString inputline " ") +1 ) inputline.count
				if val != undefined then (
					val = substituteString val "\"" ""
					val = trimRight ( trimLeft val)
				)
			) else (
				param = theLine
				val = ""
			)
				

		if param != undefined then (		
		param = substituteString param "\"" ""
		)
		#(param,val)
	)

	function wallworm_trimmedVal inp = (
		trimRight (trimLeft(inp))
		inp = substituteString inp "\t" " "
		inp = substituteString inp "  " " "	
	)
		
struct wallworm_detail (
	
	
	/*
	detailOrientation <int> How the sprite will react to the camera:  0: It will not rotate. 
 1: It will rotate around its origin to always face the camera head-on 
 2: It will rotate around its Z-axis only to face the camera. This is the most common setting, as it foreshortens the sprite while keeping it otherwise head-on. 

	*/

		amount=1.0,
		upright=false,
		minangle=0.0,
		maxangle=180.0,
		name="new sprite",
		sprite = undefined,
		width = 1024,
		sprite_bitmap = undefined,
		spritesize = [0.0,0.0,0.0,0.0],
		spriterandomscale=0.1,
		spritedetailorientation=2,
		sprite_shape="", --tri,cross
		sway=0.0,
		swaystrength=0.0,
		swayscrumblestrength=1.0,
		shape_angle=0.0,
		shape_size=0.2,
		model=undefined,
		wwmt=undefined,
		mshes=#(),
		mat=undefined,
		flat=false, --specific to Dear Esther
		flatheight=0,  --specific to Dear Esther
		groupBits=#{},
		scaleX=1.0,
		scaleY=1.0,
		offsetY=0.0,
		offsetX=0.0,
		alphapositionPlaced=undefined,
		anglePlaced=undefined,
		src=undefined,
		skipNormal = false,
		firstMeshWasUsed = false,
		function sanitize = (
			mshes = for m in mshes where m != undefined AND isDeleted m == false collect m
		),
		function fillFromWWDetail obj = (
			src = obj
			spr = obj.getSprite()
			width = spr[2]
			sprite =spr[1]
			amount = obj.amount 
			upright = obj.upright 
			minangle = obj.minangle 
			maxangle = obj.maxangle 
			spritesize = point4 0.5 0 obj.width obj.height
			spriterandomscale = obj.spriterandomscale 
			spritedetailorientation  = obj.spritedetailorientation - 1
			case (obj.sprite_shape) of (
				2: sprite_shape="tri" 
				3: sprite_shape="cross" 
				default: sprite_shape = ""
			)
			sway = obj.sway 
			swaystrength  = obj.swaystrength
			swayscrumblestrength = obj.swayscrumblestrength 
			shape_angle  = obj.shape_angle
			shape_size  = obj.shape_size
			model  = obj.model
			wwmt  = obj.wwmt
			if obj.mshes != undefined then (
				mshes  = obj.mshes
			)
			flat  = obj.flat
			flatheight  = obj.flatheight
			mat = obj.mat
			if mat != undefined AND mat.diffusemap != undefined then (
				sprite_bitmap = mat.diffusemap
			)
			obj.setModelForWWMT()
			if obj.wwmt != undefined  AND obj.mshes[1] != undefined AND isDeleted obj.mshes[1] == false then (
				src = obj.mshes[1]
			)
			if obj.mshes != undefined AND obj.mshes.count > 0 then (
				join (mshes as array) (obj.mshes as array)
			)

			
		),
		function fillObjWWDetail obj setObj:false= (
			if setObj == true then (
				src = obj
			)
			obj.normLocked = true
			obj.amount =amount 
			obj.upright = upright 
			obj.minangle =  minangle 
			obj.maxangle = maxangle 
			obj.width = spritesize.z
			obj.height = spritesize.w
			obj.spriterandomscale  = spriterandomscale
			obj.spritedetailorientation = spritedetailorientation + 1
			case (obj.sprite_shape) of (
				"tri": obj.sprite_shape=2 
				"cross" : sprite_shape= 3
				default: sprite_shape = ""
			)
			obj.sway  = sway
			obj.swaystrength = swaystrength 
			obj.swayscrumblestrength  = swayscrumblestrength
			obj.shape_angle = shape_angle 
			obj.shape_size = shape_size 
			if model != undefined then (
				obj.model = model 
			)
			if wwmt != undefined AND isDeleted wwmt == false then (
				obj.wwmt = wwmt 
				
				wwmtHelper = ww_LOD_wrapper()
				wwmtHelper.init()
				wwmtHelper.setTargetModel obj.wwmt wwmtHelper
				
				
				m = wwmtHelper.createProxy()
				
				src = m
				
				
			)
			if mshes != undefined AND mshes.count > 0 then (
				obj.mshes = mshes 
			)
			obj.flat = flat
			obj.flatheight =  flatheight
			
			obj.setSprite sprite

		),
		function create_detail forceShape:"" app:true useMultiMat:false makeNormal:true reuseFirstMesh:false wwmtAsSprite:false= (
			/*Create a sprite from this detail.*/
			if mshes.count >0 then (
				if mshes[1] == undefined OR isDeleted mshes[1] == true then (
					sanitize()
				)
			)
			
			if mshes.count >0 OR src != undefined  then (
				--local na =
				
				if reuseFirstMesh == true AND firstMeshWasUsed == false then (
					
					p = mshes[1] 
					firstMeshWasUsed = true
					
				) else (
					
					
					local makeCopy = true
					if src == undefined  then (
					
						local ms = #(mshes[1])
					) else (

						if isDeleted src == true AND wwmt != undefined AND isDeleted wwmt == false then (
							
							wwmtHelper = ww_LOD_wrapper()
							wwmtHelper.init()
							wwmtHelper.setTargetModel wwmt wwmtHelper
							p = wwmtHelper.createProxy()
							src = p
							makeCopy = false
						) else (
							
							local ms = #(src)
						)
						
						
						
					)
					
					if makeCopy == true then (
						maxOps.CloneNodes ms actualNodeList:&act newNodes:&pa
						p = pa[1]
					)
					
					if classof p.baseObject == WallWormDetailProp then (
							p.mshes = #()
						
							if NOT p.flat then (
								case (forceShape) of (
									"tri": p.sprite_shape=2 
									"cross": p.sprite_shape=3
									default: ()
								)
							)
						
						
					)
					
					setUserProp p "wallworm_exclude_vmf" false
					
					
					if wwmt == undefined  OR wwmtAsSprite == true then (
						setUserProp p "wallworm_imported_detail" true
					)
					
					p.scale = [1,1,1]
					p.position = [0,0,0]
					p.rotation = (quat 0 0 0 1)
					
					p.backfacecull = off
					--if app == true then (
						append mshes p
					--)
					
				)
				
				

			) else (
			
			
				if model == undefined OR model=="" then (
					/*Create a Billboard*/
					
					w =   spritesize.z
					l =  spritesize.w
					
					
					if flat == false then (
						p =  (plane length:l width:w lengthsegs:1 widthsegs:1 dir:[1,0,0] pos:[0,0,(l/2)] pivot:[0,0,0])
						resetXForm p
						
						if makeNormal == true then (
							local en = Edit_Normals ui:on
							addModifier p en
							max modify mode
							modpanel.setcurrentobject en
							local normalcount = en.GetNumNormals node:p
							local normalValue = [0,0,1]
							--newSelection = #{1..normalcount}
							--en.SetSelection &newSelection node:p
							for i = 1 to normalcount do (
								en.SetNormalExplicit i explicit:true node:p
								en.SetNormal i normalValue node:p
							)
						)
						
						max create mode
					) else (
						p =  (plane length:l width:w lengthsegs:1 widthsegs:1)
					)
					
					/*
					convertToMesh p
					
					setNormal p 1 [0,0,1]
					setNormal p 2 [0,0,1]
					setNormal p 3 [0,0,1]
					setNormal p 4 [0,0,1]
					
					*/
					

					
					
					convertToPoly p
					p.name = uniquename ("Prop Detail "+ (sprite as string))
					setMapVert = polyop.setMapVert
						
					if useMultiMat == false then (
						leftU = ((sprite.x  )  / width) 
						topV = (((sprite.y  )  / width) * -1) + 1
						
						bottomV = (((sprite.y + sprite.w)  / width)  * -1) + 1
						rightU = ((sprite.x + sprite.z )  / width) 
						
						setMapVert p 1 1 [leftU,bottomV,0]
						setMapVert p 1 2 [rightU,bottomV,0]
						setMapVert p 1 3 [leftU,topV,0]
						setMapVert p 1 4 [rightU,topV,0]
						
					)	
						
						
					if forceShape == "" OR flat == true then (
						
							forceShape = sprite_shape
					)	
					
					case forceShape of (
						"tri":(
						
							
						
							p2 =  copy p

							convertToPoly p2
							p3 =  copy p

							convertToPoly p3
							in coordsys world (
									--rotate p (angleaxis 120 [0,0,1])
									rotate p2 (angleaxis 120 [0,0,1])
									rotate p3 (angleaxis 240 [0,0,1])
							)
						
							in coordsys local (
								if shape_size > 0.0 then (
									dist = w  * shape_size --sprite_shape tri only. Percentage of the sprites' width to put between them and the centre of the triangle. 0 means that the sprites cross at the prop's origin. 
									
									
									move p [dist,0,0]
									move p2 [dist,0,0]
									move p3 [dist,0,0]
								)
								
								if shape_angle > 0.0 then (
									local rt = (angleaxis shape_angle [0,1,0])
									rotate p rt
									rotate p2 rt
									rotate p3 rt
								)
								
							)
							
							p.attach p2 p
							p.attach p3 p
							
							
							resetXForm p
						)
						"cross":(
							p2 =  copy p
							in coordsys local rotate p2 (angleaxis 90 [0,0,1])
							p.attach p2 p
							
						)
						default:()
					)
					
					
					
					/*
					if spriterandomscale != 1.0 then (
						
						p.scale *= (random (1.0 - spriterandomscale) (1.0 + spriterandomscale))
						
					)
					*/
					resetXForm p
					

					
					
					convertToPoly p
					if app == true then (
						append mshes p
						setUserProp p "wallworm_imported_detail" "true"
					) else (
						setUserProp p "wallworm_detail_painted" "true"
					)
				) else (
						/*
					!!TODO
					Create a Model
					*/
					if wwmt != undefined then (
						
						wwmtHelper = ww_LOD_wrapper()
						wwmtHelper.init()
						wwmtHelper.setTargetModel wwmt wwmtHelper
				
						p = wwmtHelper.createProxy()
						
						--setUserPropBuffer p ""
						
						if app == true then (
							append mshes p
							setUserProp p "wallworm_imported_detail" "true"
						) else (
							setUserProp p "wallworm_detail_painted" "true"
						)
					)
				)
			)
			p
		),
		function destroyDetails rebuildProps = (
				if rebuildProps == true then (
					delete (for m in mshes where m != undefined AND isDeleted m == false collect m)
					mshes = #()
				) else (
					if mshes.count > 1 then (
						for i = mshes.count to 2 by -1 do (
							
							if mshes[i] != undefined AND isDeleted mshes[i] == false then (
								delete mshes[i]
							)
							deleteItem mshes i
							
						)
					)
					
				)
		)


)


function wallworm_vbsp_from_nodes = (
		max  create mode 

		global wallworm_VBSP
		global wallworm_detail_vbsp
		global wallworm_detail_type
		global wallworm_detail_group
		global wallworm_detail
	
		if wallworm_detail_vbsp == undefined then (
			fileIn "$scripts/WallWorm.com/common/sprite_struct.ms"
		)
	
		--if wallworm_VBSP == undefined then (
			wallworm_VBSP = wallworm_detail_vbsp()
		--)
		undo off
		with redraw off (
			/*Get all the detail types in scene.*/
		
			local ds = for obj in objects where classOf obj.baseObject == WallWormDetailType collect obj
			
			if ds.count > 0 then (
				wallworm_VBSP.mat = ds[1].mat
				
				mname = wallworm_getMaterialName wallworm_VBSP.mat matId:1 forModel:false
				--wwmt_gameInfoDir + "\\materials\\"
				wallworm_VBSP.vmt =  mname
				wallworm_VBSP.useMultiMat = false
				wallworm_VBSP.rebuildProps = false

				for d in ds do (
						t = wallworm_detail_type()
						t.name = trimRight (trimLeft d.name)
						t.density = d.density
						t.groups = #()	
						t.wwmtAsSprite = d.wwmtAsSprite					
						for gr in d.groups do (
							
								g = wallworm_detail_group()
								g.name = gr.name
								g.alpha = gr.alphaval
								for p in gr.detail WHERE p != undefined AND isDeleted p == false do (
									--if p.ww_detail == undefined then (
										--p.updateDetailObj()
									--)
									local detail = wallworm_detail()
									detail.fillFromWWDetail p
/*
									if p.wwmt != undefined AND isDeleted p.wwmt == false then (
										wwmtHelper = ww_LOD_wrapper()
										wwmtHelper.init()
										wwmtHelper.setTargetModel p.wwmt wwmtHelper
										newp = wwmtHelper.createProxy()
										if newp != undefined then (
											--setUserPropBuffer newp ""
											if detail.src == undefined AND p.mshes[1] != undefined AND isDeleted p.mshes[1] == false then (
												detail.src = p.mshes[1]
											)
											setUserProp newp "wallworm_detail_model" ("models/"+wwmtHelper.modelPath+"/"+wwmtHelper.modelName+".mdl")
										)
									) else (
										local sprar = #(p)
										maxOps.CloneNodes sprar actualNodeList:&act newNodes:&pa	
										newp = pa[1]	
										setUserPropBuffer newp ""	
										--setUserProp p "wallworm_imported_detail" "true"
										setUserProp newp "wallworm_imported_detail" "true"		
									)

												
									newp.scale = [1,1,1]
									newp.position = [0,0,0]
									newp.rotation = (quat 0 0 0 1)

									detail.mshes[1] = newp


									append t.props newprop
									*/									
									
									append g.details detail
									
								)
								append t.groups g
							
						)
						t.findAllObjectsForType()
						t.createInitialProps()
						
						append wallworm_VBSP.types t
				)
				
				wallworm_VBSP.generateSpriteMaterials()
			)	
	
		)
)



function wallworm_nodes_from_vbsp = (
		max  create mode 
		
		global wallworm_VBSP
	

		local WallWormDetailLayer = LayerManager.getLayerFromName "Detail Control Layer"
		if WallWormDetailLayer == undefined then (
			WallWormDetailLayer = LayerManager.newLayerFromName "Detail Control Layer"
		)

		if wallworm_detail_vbsp == undefined then (
			fileIn "$scripts/WallWorm.com/common/sprite_struct.ms"
		)
		--wallworm_VBSP = wallworm_detail_vbsp()
		local cont = false		
		if wallworm_VBSP != undefined AND classof wallworm_VBSP == wallworm_detail_vbsp AND WallWormDetailType != undefined then (
			undo off
			with redraw off (
				/*Get all the detail types in VBSP.*/
				if wallworm_VBSP.types.count > 0 then (
					
					local lastPos = [0,0,0]
					
					for d in wallworm_VBSP.types do (
							local t = WallWormDetailType()
							setUserProp t "wwdt_brush_geometry_export" "false"
							WallWormDetailLayer.addNode t
							t.setup()
							t.pos = lastPos
							lastPos += [0,512,0]
							t.mat = wallworm_VBSP.mat
							t.name = trimRight (trimLeft d.name)
							t.density = d.density
							d.src = t
							for gr in d.groups do (
									g = t.createNewGroup()
									setUserProp g "wwdt_brush_geometry_export" "false"
									g.name = gr.name
									g.alphaval = gr.alpha
									local cval = g.alphaval * 255
									g.wirecolor = color cval cval cval
									for p in gr.details WHERE p != undefined  AND (p.src == undefined OR isDeleted p.src == true) do (
										local detail = g.createNewModel()
										p.fillObjWWDetail detail setObj:true
										detail.backfacecull = off
										WallWormDetailLayer.addNode detail
									)
							)
					)
				)	
			)
			true
		) else (
			false
		)	
)



struct wallworm_detail_group (
	
		name="New Group",
		alpha=1.0,
		details=#(),
		groupBits=#{},
		function destroyDetails rebuildProps = (
			for d in details WHERE d != undefined AND d.mshes != undefined AND d.mshes.count > 0 do (
				d.destroyDetails rebuildProps
			)
		),
		function setDetailBits = (
			currentBit= 1
			for d in details do (
				moreBits = floor (d.amount * 100)
				newEnd = currentBit + moreBits - 1
				d.groupBits = #{currentBit..newEnd}
				currentBit = newEnd + 1
			)
			
		),
	
		function isAngleValid ang skipAngles:true= (
			
			local valid = true			
			if skipAngles == false then (
				valid = false	


				local r = for d in details where ang.z <= cos(d.minangle) AND ang.z >=cos(d.maxangle) collect d
				if r.count > 0 then (
					valid = true
				)  else ()
			
			)
			valid

		),
		/*This can lead to an infinite loop so check with isAngleValid before using this method!!!! */
		function getRandomDetail  ang sd:123456 skipAngles:true = (
			d = undefined
			randomDetail = random 1 100
			local r = for d in details where d.groupBits[randomDetail] == true collect d
				
			
			if r.count > 0 then (
				d = r[1]
				if d != undefined then (

						if (skipAngles == true OR (ang.z <= cos(d.minangle) AND ang.z >=cos(d.maxangle))) then (
								--all good
						) else  (
							--look for another face that fits the bill
							d = getRandomDetail  ang skipAngles:skipAngles
						)
				)
			)
			d
		),
	
	function getModelFromBlock str detailname= (
	
		
			
			local detail = wallworm_detail()
			detail.name = detailname
			if str.count > 0 then (
				local msC = memStreamMgr.openString str
				if msC.pos() != 0 then (
					msC.seek 0 #seek_set
				)
				local thelineC
				while msC.eos() == false AND msC.peekToken() != undefined do (
				
					msC.skipSpace()

					theLineC= (msC.readLine())
						
						trimmedLineC = wallworm_trimmedVal theLineC
						if (trimmedLineC == "" OR trimmedLineC == undefined OR ( (substring trimmedLineC 1 2) == "//") ) do continue
						if ((matchPattern trimmedLineC pattern:"\\\\*") == true) do continue
						vals = wallworm_getPropValFromLine trimmedLineC
						if vals[2] != undefined then (
							case vals[1] of (
								
								"amount":detail.amount= vals[2] as float
								"upright":detail.upright = true
								"minangle":detail.minangle= vals[2] as float
								"maxangle":detail.maxangle= vals[2] as float
								"sprite":(
											filteredVals = filterString vals[2] " "
											detail.sprite = [(filteredVals[1] as float),(filteredVals[2] as float),(filteredVals[3] as float),(filteredVals[4] as float)]
											detail.width = filteredVals[5] as float
								)
								"spritesize":(
								
											filteredVals = filterString vals[2] " "
											detail.spritesize = [(filteredVals[1] as float),(filteredVals[2] as float),(filteredVals[3] as float),(filteredVals[4] as float)]
								)
								"spriterandomscale":detail.spriterandomscale= vals[2] as float
								"spritedetailorientation":detail.spritedetailorientation= vals[2] as integer
								"sprite_shape":detail.sprite_shape = vals[2] as string
								"sway":detail.sway = vals[2] as float
								"swaystrength":detail.swaystrength = vals[2] as float
								"swayscrumblestrength":detail.swayscrumblestrength = vals[2] as float
								"shape_angle":detail.shape_angle = vals[2] as float
								"shape_size":detail.shape_size = vals[2] as float
								"model":detail.model = vals[2] as string
								"flat":(
									--if vals[2] == "1" then (
										detail.flat = true
									--)
								)
								"flat_height":detail.flatheight = vals[2] as float
								--specific to Dear Esther
							)
						)
						
						
				)

				MemStreamMgr.close msC
			)
			

			append details detail
		

	)
	
)

struct wallworm_detail_type (
	name="newdetailtype",
	density=1000.0,
	groups=#(),
	displacements=#(),
	--disparray=#(),--stores the trimesh surfaces of the displacements.
	surfaceArea=0,
	allowedProps = 0,
	props=#(),
	propseed=12345,
	forceShape="",
	densityMultiplier = 1.0,
	limitToSelection=false,
	scaleOffsetMin=0.0,
	scaleOffsetMax=0.0,
	scaleOption="normalize",
	forceOrientation="",
	pGetFaceArea=polyop.getFaceArea,
	forceFillProps=false,
	skipNormal = true,
	src = undefined,
	skipAngles=true,
	wwmtAsSprite=false,
	function sanitize = (
		props = for p in props where p != undefined AND isDeleted p == false collect p
	),
	function destroyDetails rebuildProps= (
		for g in groups  do (
				g.destroyDetails rebuildProps
				if rebuildProps == true then (
					props=#()
				)
		)
		sanitize()
	),

	/*
	
	Will search scene for displacements or other objects with DirectX_9_Shader for distributing props.
	
	Note that WW Displacement Brushes are skipped as well as Sculpt Meshes.
	
	Sculpt meshes are skipped because they do not necessarily represent the surface area of the displacements (unless committed), and because the original displacements that make up the sculpt mesh will match the sculpt mesh so long as it has been committed.
	
	Sets the results to the displacements property array.
	
	*/
	function findAllObjectsForType = (
		
		if limitToSelection == false then (
				displacementPool = objects as array
		) else (
				displacementPool = selection as array
		)

		displacements = for obj in displacementPool WHERE \
			obj.mat != undefined  AND isProperty obj.baseObject "ww_displacement_brush" == false \
			AND isProperty obj.baseObject "wallworm_edit_mesh" == false AND \
		((classOf obj.mat == DirectX_9_Shader AND obj.mat.renderMaterial != undefined AND isProperty obj.mat.renderMaterial "wallworm"==true AND obj.mat.renderMaterial.detail == name) \
		OR (classOf obj.mat == Blend AND isProperty obj.mat "wallworm"==true AND obj.mat.detail == name) ) \
		collect obj

	),
	function calculateTotalSurfaceArea recalculate:false = (
		if displacements.count == 0 OR recalculate==true then (
			findAllObjectsForType()
		)
		if displacements.count != 0 then (
			surfaceArea = 0
			for disp in displacements do (
				for i = 1 to disp.numfaces do (
					surfaceArea += pGetFaceArea disp i
				)
			
			)
		)
	),
	function calculatePropNumber recalculate:false = (
		if surfaceArea == 0 OR recalculate==true OR limitToSelection == true then (
			calculateTotalSurfaceArea recalculate:recalculate
		)
		allowedProps = (floor ((surfaceArea * density * 0.000001) * densityMultiplier)) as integer
	),
	function findClosestAlphaGroup alph ang = (
		local groupToUse = undefined
		for g in groups WHERE g.isAngleValid ang skipAngles:skipAngles == true do (
			if groupToUse == undefined  then (
				groupToUse = g
			) else (
				if abs (groupToUse.alpha - alph) > abs (g.alpha - alph) then (
					groupToUse = g
				)
			)
		)
		groupToUse
	),
	/*
	Sets the likeilhood of each prop type in each group.
	*/
	function createInitialProps = (
		max create mode
		with redraw off (
			for g in groups do (
				g.setDetailBits()
			)
		)
	),

	function getPropByAlpha a ang sd:123456 reuseFirstMesh:false= (
		max create mode
		local newprop = undefined
		local g = findClosestAlphaGroup a ang
		local d = undefined
		if g != undefined AND g.details.count > 0 then (
			d = g.getRandomDetail ang sd:sd skipAngles:skipAngles
			if d != undefined then (
				if forceOrientation == "Upright" then (
					makeNormal = false
				)  else (
					makeNormal = true
				)
				newprop = d.create_detail forceShape:forceShape makeNormal:makeNormal reuseFirstMesh:reuseFirstMesh wwmtAsSprite:wwmtAsSprite
				if newprop != undefined then (
					if  d.model == undefined OR d.model == "" AND d.mat != undefined  AND newprop != undefined then (
						newprop.mat = d.mat
					)
					append props newprop
				)
			) else (
				
			)
		) else (
			global wallworm_debug	
			if wallworm_debug == true then (
				format "No Group Found for Alpha : %\n" a
			)
		)


		#(d,newprop)
	),
	function randomizePositions reuseFirstMesh:false = (
		max create mode
		oldSel = selection
		--max select none
		if allowedProps > 0 then (
			dispCount = displacements.count
			disparray = #()
			local getFaceCenter =  meshop.getFaceCenter

			local getFaceArea = meshop.getFaceArea
			--local getV = meshop.getVert
			local getVertsUsingFace = meshop.getVertsUsingFace
			local getMapVert = meshop.getMapVert
			local getMapFace = meshop.getMapFace
			local getMapSupport = meshop.getMapSupport
			if dispCount > 0 then (
				local startPlanting = timestamp()
				local propcount = 0
				local loopcount = 0 -- used to prevent infinite loops ... or insanely long times due to unlikely detail rules (like a rule that only places a prop in a place you can randomly pick 1 in a million times, etc)
				local keepAddingProps = true

				while propcount <= allowedProps AND keepAddingProps == true  do (
					local disIndex = random 1 dispCount
					local cordsysnode = displacements[disIndex] 
					local disp = disparray[disIndex]
					if disp == undefined then (
						disp = snapshotasMesh cordsysnode
						disparray[disIndex]  = disp 
					)
					
					local randomFace = random 1 (disp.numfaces)
						

					in coordsys cordsysnode ang = getFaceNormal disp randomFace 
					local theFace = getFace disp randomFace--get the face def. of the random face
				
					local theX = random 0.0 1.0 --get a random X
					 local theY = random 0.0 1.0 --get a random Y
					 if theX+theY > 1.0 do --if the sum is greater than 1, subtract them from 1.0
					 (
						 theX = 1.0 - theX
						 theY = 1.0 - theY 
					 )
					 local theZ = 1.0 - theX - theY --the third bary coord is 1.0 minus the other two
					 --store the position in the array

					 local vertX = (getVert disp theFace.x )
					 local vertY = (getVert disp theFace.y )
					 local vertZ = (getVert disp theFace.z )
					 
					in coordsys world randomposition = ((vertX)*theX + (vertY)*theY + (vertZ)*theZ)
					
						 if getMapSupport disp -2 == true then (
							local Mapface = getMapFace disp -2 randomFace
							local alphaposition = ((getMapVert disp -2 Mapface.x )*theX + (getMapVert disp -2 Mapface.y )*theY + (getMapVert disp -2 Mapface.z )*theZ)
							local valphacolor = (color (alphaposition.x * 255.0) (alphaposition.y * 255.0) (alphaposition.z * 255.0))
							 
						)	else (

							valphacolor = color 255 255 255
						)	

				

						local det = getPropByAlpha (valphacolor.value/255.0) ang  reuseFirstMesh:reuseFirstMesh skipAngles:skipAngles
						p = det[2]
						if p != undefined then (

							det[1].anglePlaced=ang
							in coordsys world p.position = randomposition
								
							if ( det[1].flat == true OR (  det[1].upright == false OR (forceOrientation=="Face Normal")) AND (orceOrientation != "Upright" AND forceOrientation != "Upright Test")) then (
								
								p.dir = ang
								
								if forceOrientation != "Upright Test" AND skipNormal == false AND classof p == WallWormDetailProp AND  p.norm.x != 0 AND p.norm.y != 0 and p.norm.z != 1 then (
									p.normLocked = false
									p.norm = newNormal
									p.normLocked = true
								)
								
							)

							if det[1].flat == true OR (det[1].model != undefined AND det[1].model != "") then (
								if det[1].flatheight > 0 AND classof p != WallWormDetailProp then (
									in coordsys local  p.position.z += det[1].flatheight
								)
							)		
							
							
							/*Only scale sprites and shapes... models will not scale.*/
							if det[1].model == undefined OR det[1].model == "" then (
							
								local scaleOffset = 1.0
								--scaleOffset1 = 1.0
								

									scaleOffset = det[1].spriterandomscale
								/*	if scaleOffsetMin != scaleOffsetMax then (
										scaleOffset = random scaleOffsetMin scaleOffsetMax
									) else (
										--scaleOffset1 = scaleOffset	
									)*/

								

								if scaleOption=="normalize" then (
									p.scale *= abs (random (1.0 - scaleOffset) (1.0 + scaleOffset))	
									if scaleOffsetMin != scaleOffsetMax AND (scaleOffsetMin != 1.0 OR scaleOffsetMax != 1.0) AND scaleOffsetMin > 0  then (
										p.scale *= abs  (random scaleOffsetMin scaleOffsetMax)
									) else (
										--print scaleOffsetMin
									)
								) else (
									if scaleOffsetMin != 0.0 OR scaleOffsetMax != 0.0 then (
										scaleOffset += random scaleOffsetMin scaleOffsetMax	
									) 

									p.scale *= abs (random (1.0 - scaleOffset) (1.0 + scaleOffset))
								)
							
							)
								
							local rotationAngle = random 0.0 360.0
							in coordsys local rotate p (angleaxis (rotationAngle) [0,0,1])

							
							

							if skipNormal == false AND (det[1].upright == true AND forceOrientation == "") OR forceOrientation == "Upright" then (

								local nar= #(p)
								InstanceMgr.MakeObjectsUnique nar #individual
								
								local newNormal = ang * rotateZMatrix (rotationAngle * -1)
								
								if classOf p.baseObject == WallWormDetailProp then (
									p.normLocked = false
									p.norm = newNormal
									p.normLocked = true
								) else (
									local en = p.modifiers[#Edit_Normals]
									
									if en == undefined then (
										en = Edit_Normals()
										addModifier p en
									) else (
										local enAr = #(en)
										InstanceMgr.MakeModifiersUnique nar enAr #individual
									)
									
									
									max modify mode
									modpanel.setcurrentobject en
									--max create mode
									disableRefMsgs()
									local normalcount = en.GetNumNormals node:p

									local newNormal = ang * rotateZMatrix (rotationAngle * -1)
									enableRefMsgs()
									for i = 1 to normalcount do (
										en.SetNormalExplicit i explicit:true node:p
										en.SetNormal i newNormal node:p
									)

									convertToPoly p
									gc()
							
								
								)
								
								max create mode	

								
							)
									
									
							p.parent = cordsysnode		
								--det[1].alphapositionPlaced=alphaposition
							
							propcount+= 1
						)	else (
								--format "Found None for Alpha % and Angle %\n" valphacolor.value ang
						)
					

							
						loopcount += 1
						if forceFillProps == false then (
							
							if loopcount > allowedProps then (
								keepAddingProps = false
							)
							
						) 		
						
						if (loopcount == allowedProps AND propcount == 0) OR loopcount == allowedProps * 2  then (
							keepAddingProps = false
						)		
						
						
					)
					--print loopcount
					local endPlanting = timestamp()
					
					results = (endPlanting - startPlanting) / 1000
					
					format "\n#############\nDetail Results for %:\nDisplacements %\nAllowed Props: %\nActual Props: %\nTime To Plant: % seconds.\n" name dispCount allowedProps propcount results

				
				)
				for trm in disparray do (
					if trm != undefined then (
						delete trm
				)
			)
		)
		if oldSel != undefined AND oldSel.count > 0 then (
			select oldSel
		)
	),
	function get_group_from_block str grname= (
			
			local gr = wallworm_detail_group()
			gr.name = grname
			if str.count > 0 then (
				local msC = memStreamMgr.openString str
				if msC.pos() != 0 then (
					msC.seek 0 #seek_set
				)
				local thelineC
				while msC.eos() == false AND msC.peekToken() != undefined do (
				
					msC.skipSpace()

					theLineC= (msC.readLine())
						
						trimmedLineC = wallworm_trimmedVal theLineC
						if (trimmedLineC == "" OR trimmedLineC == undefined OR ( (substring trimmedLineC 1 2) == "//") ) do continue
						if ((matchPattern trimmedLineC pattern:"\\\\*") == true) do continue
						
						
							if msC.peekToken() == "{" then (
									newName = trimmedLineC
								
									nextString = msC.readBlock "{" "}"
									gr.getModelFromBlock nextString newName
								
							) else (
								vals = wallworm_getPropValFromLine trimmedLineC
								
								if vals.count > 1 then (
								
									case vals[1] of (
										
										"alpha":gr.alpha= vals[2] as float
											
									)
								
								
								)
								
							)
							
						


						
						
				)
			MemStreamMgr.close msC
			
		)
		append groups gr
		

	)
	
)


struct wallworm_detail_vbsp (
		filename="",
		types=#(),
		vmt="",
		spriteMats = MultiMaterial(),
		mat=undefined,
		ui,
		propseed = 123456,
		densityMultiplier = 1.0,
		forceShape = "", -- "",tri,cross
		useMultiMat=false,
		limitToSelection=false,
		destroyOnRandomize=true,
		scaleOffsetMin=1.0,
		scaleOffsetMax=1.0,
		scaleOption="normalize",
		forceOrientation="",
		forceFillProps=false,
		skipNormal = true,
		rebuildProps = true,
		skipAngles = true,
		function destroyDetails rebuildProps = (
			for t in types do (
				t.destroyDetails rebuildProps
			)
			
		),
		
		function writeVBSP = (
			str = wallworm_export_vbsp()
			out = false
			if str != undefined AND str != "" AND filename != "" then (
				
				local fi = openFile filename mode:"w"
				format str to:fi
				
				close fi
				out = true
			)
			out
		),
		
		function get_type_from_block str grname= (
			
			local ty = wallworm_detail_type()
			ty.name =    trimRight (trimLeft grname) 
				if str.count > 0 then (
				local msC = memStreamMgr.openString str
				if msC.pos() != 0 then (
					msC.seek 0 #seek_set
				)
				local thelineC
				while msC.eos() == false AND msC.peekToken() != undefined do (
				
					msC.skipSpace()

					theLineC= (msC.readLine())
						
						trimmedLineC = wallworm_trimmedVal theLineC
						if (trimmedLineC == "" OR trimmedLineC == undefined OR ( (substring trimmedLineC 1 2) == "//") ) do continue
						if ((matchPattern trimmedLineC pattern:"\\\\*") == true) do continue
						
						
							if msC.peekToken() == "{" then (
									newName = trimmedLineC
									nextString = wallworm_readBlock msC p1:"{" p2:"}"
									ty.get_group_from_block nextString newName
								
							)	else (
								
								vals = wallworm_getPropValFromLine trimmedLineC
								
								if vals.count > 1 then (
									
									case vals[1] of (
										
										"density":ty.density= vals[2] as float
											
									)
								
								
								) 
								
							)			
						


						
						
				)
				MemStreamMgr.close msC
		
			)
			append types ty
		

	),
	function getAllTypes msC = (
			local hasPassedFirstBracket = false
			
			if msC.pos() != 0 then (
				msC.seek 0 #seek_set
			)
			local thelineC
			while msC.eos() == false AND msC.peekToken() != undefined do (
			
				msC.skipSpace()

				theLineC= (msC.readLine())
					
					trimmedLineC = wallworm_trimmedVal theLineC
					if (trimmedLineC == "" OR trimmedLineC == undefined OR ( (substring trimmedLineC 1 2) == "//") ) do continue
					if ((matchPattern trimmedLineC pattern:"\\\\*") == true) do continue
						if msC.peekToken() == "{" then (
							
							
								if hasPassedFirstBracket == true then (
									
									newName = trimmedLineC
								
									--nextString = msC.readBlock "{" "}"
								
									nextString = wallworm_readBlock msC p1:"{" p2:"}"
									get_type_from_block nextString newName
								) else (
									
										hasPassedFirstBracket = true
								)
							
						)
						


					
					
			)

		
	),
	function loaddetailvbsp_from_file file= (

		local attempts = 0
		local trycount = 16
		while attempts < trycount do (
		
			try (
				types = #()
				local msC = MemStreamMgr.openFile file
				filename = file
				getAllTypes msC
				MemStreamMgr.close msC
				attempts = 1000
			) catch (
				types = #()
				format "There was a parse Error. Trying again...\n"
				trycount += 1
			)
			
		)
	),
	function loaddetailvbsp_from_string str = (
		types = #()
		local msC = memStreamMgr.openString str
		getAllTypes msC
		MemStreamMgr.close msC
	),
	function load_material_from_filename f = (
			if  f != undefined AND f != "" then (
			mat = undefined
			vmt = f
			mat =wallworm_generateMaterialFromVMT vmt
			)
	),
	function setupTypes = (
			seed propseed
			wallworm_klunk_ToggleMaxRedraw 0
			for t in types do undo off (
				
				t.propseed = propseed
				t.skipNormal = skipNormal
				t.forceFillProps = forceFillProps
				t.densityMultiplier = densityMultiplier
				t.scaleOption =scaleOption
				t.forceOrientation = forceOrientation
				t.scaleOffsetMin=scaleOffsetMin
				t.scaleOffsetMax=scaleOffsetMax
				t.skipAngles = skipAngles
				t.findAllObjectsForType()
				--t.calculatePropNumber()
				t.createInitialProps()
			)
			wallworm_klunk_ToggleMaxRedraw 1
	),
	function randomize = (

			local start = timestamp()
		
			if limitToSelection == false AND destroyOnRandomize == true then (
				destroyDetails rebuildProps
			)

			
			
			for t in types do with redraw off undo off (
				
				
				
				t.forceShape = forceShape
				--seed (propseed+ms)
				
				t.skipAngles = skipAngles
				t.limitToSelection = limitToSelection
				t.skipNormal = skipNormal
				--t.findAllObjectsForType()
				--if limitToSelection == true then () 
				t.forceFillProps = forceFillProps
				t.scaleOption =scaleOption
				t.forceOrientation = forceOrientation
				t.propseed = propseed
				t.densityMultiplier = densityMultiplier
				t.scaleOffsetMin=scaleOffsetMin
				t.scaleOffsetMax=scaleOffsetMax
				t.calculatePropNumber recalculate:true 


				t.randomizePositions reuseFirstMesh:(not rebuildProps)

			)
			
			local end = timestamp()
			
			local total = (end-start)/1000
			
			local minutes = floor (total / 60)
			local seconds = mod total 60
			
			format "\nDetail Props finished in %:% (%  total seconds).\n" minutes seconds total
			
	),
	function getDetailMatByName matName = (
		local submat = undefined
		local ms = for m in spriteMats.materialList WHERE m.name == matName collect m
		if ms.count > 0 then (
			submat = ms[1]
		)	
		submat
	),
	function doesMaterialExistInSpriteMat = (
		
	),
	function generateSpriteMaterials = (
		

		spriteMats = MultiMaterial()
		local canUseMultiMat = true
		if mat != undefined AND mat.diffusemap != undefined then (
			texfile = mat.diffuseMap.filename
		) else (
			canUseMultiMat = false
		)
		newMatCount = 0
		for t in types do (
			for g in t.groups do (
				for s in g.details WHERE s.sprite != undefined do (
					if useMultiMat == true AND canUseMultiMat == true then (
						matName = s.sprite as string
						local ms = for m in spriteMats.materialList WHERE m.name == matName collect m
						if ms.count == 0 then (
							newMatCount += 1
							
							local newMat = Standard showInViewport:true
							newMat.name = t.name+" " +g.name+" "+matName
							newTex = BitmapTexture filename:texfile name:(UniqueName ((getFileNameFile vmt)+" Sprite Texture"))

							scaleX = ( s.sprite.z ) / s.width
							scaleY= (s.sprite.w ) / s.width
							
							offsetY = ((s.sprite.y  )  / s.width) 
							offsetX = ((s.sprite.x  )  / s.width) 
							
							newTex.coords.U_Offset =  ( ((offsetX  /  scaleX   )  - ((1/ scaleX)/2)) + 0.5) * -1
							newTex.coords.V_Offset =   ((offsetY  /  scaleY   )  - ((1/ scaleY)/2)) + 0.5
							
							newTex.coords.U_Tiling = scaleX
							newTex.coords.V_Tiling = scaleY
							
							 newMat.diffuseMap = newTex
							newMat.opacityMap = newMat.diffuseMap
							newMat.opacityMap.monoOutput = 1
							spriteMats.numsubs = newMatCount
							spriteMats[newMatCount] = newMat
							spriteMats.names[newMatCount] = newMat.name

							
							s.mat = newMat
						) else (
							s.mat = ms[1]
						)
					) else (
						s.mat = mat
					)
					
				)
				
			)
		)
	),
	function import = (
		localresult = #(false,"No Import Run")
		if filename != undefined AND doesFileExist filename == true then (
			loaddetailvbsp_from_file filename
			if types.count > 0 then (
				load_material_from_filename  vmt
				if mat != undefined then (
					
					
					generateSpriteMaterials()
					setupTypes()
					
					if WallWormDetailType != undefined then (
						wallworm_nodes_from_vbsp()
					)
					
					result = #(true,"Detail Files Imported")
				) else (
					result = #(false,"Detail VMT not Found")
				)
			) else (
				result = #(false,"File Parse Returned No Results")
			)
		) else (
			result = #(false,"Detail VBSP File Not Found")
		)
		result
	),
	function getTypesWithDisplacements = (
			for t in types where t.displacements.count > 0 collect t
	),
	
	function getTypesByName n = (
		for t in types where t.name == n collect t
	),

	function getRollout = (
		if ui == undefined then (
			ui = \
			(
				rollout wallworm_vbsp_parser "Parse detail.vbsp" width:595 height:602
				(

					label lbl1 "Detail.VBSP File" pos:[13,8] width:82 height:16
					edittext edt_detail_file "" pos:[7,30] width:574 height:29
					button btn_browse_vbsp "Browse For Detail VBSP" pos:[452,5] width:131 height:20 toolTip:"Find the detail.vbsp file used for your mod or this level."
					label lbl2 "DetailSprites.VMT File" pos:[12,84] width:138 height:16
					edittext edt_detail_vmt "" pos:[6,106] width:577 height:29
					button btn_browse_vmt "Browse For Detail VMT" pos:[451,81] width:131 height:20 toolTip:"Browse for the VMT used for this mod or level. The VMT should contain all the parameters for the materials used in the details."
					button btnImport "Parse and Import" pos:[429,143] width:152 height:32 toolTip:"Parse the detail.vbsp and detail.vmt listed above so that the details can be used."
					button btnExport "Export VBSP " pos:[345,529] width:235 height:31 toolTip:"Export a custom VBSP from the scene's Wall Worm Detail Prop nodes. Requires the commercial Detailer plugin from Wall Worm."
					button btnAssignMat "Assign Mat to Selection" pos:[15,313] width:126 height:31 toolTip:"Assign the imported detail.vmt material to the selected objects in the scene."
					materialButton btn9 "Get Material From Scene" pos:[14,277] width:126 height:30 toolTip:"Convert a material in the scene into a detail.vmt file."
					bitmap bmp1 "Bitmap" pos:[12,145] width:128 height:128
					button btnApplySprites "Apply Details to Scene" pos:[307,386] width:275 height:37 toolTip:"Build detail models and distribute them across the scene based on the displacement materials in the scene."
					spinner spnScale "Density Multiplier" pos:[361,186] width:123 height:16 range:[0.1,1024,1] type:#float scale:0.01 toolTip:"Use this to offset the density from the defaults."
					spinner spnSeed "Seed" pos:[403,210] width:177 height:16 range:[1,1e+007,123456] type:#integer scale:1 toolTip:"Generate a random seed to use for the detail scattering."
					listbox lbxDetailTypes "Detail Types" pos:[143,166] width:157 height:25 selection:0
					checkbox chkLimitToScene "Show Only Those in Scene" pos:[142,146] width:159 height:17 toolTip:"Limit the display below to the types of details actually used by displacements in the scene."
					dropdownList ddlForceType "Coerce Shape Type" pos:[310,244] width:271 height:40 items:#("", "cross", "tri") toolTip:"Choose cross or tri if you want all imported details to be of one of these types rather than the default from the detail.vbsp file."
					button btnStartPainting "Object Paint Type" pos:[9,528] width:158 height:32 toolTip:"Start painting the objects from the current detail type selected in Detail Types. Requires Object Paint in a version of Max that has the Graphite Modelling Tools with Object Paint."
					button btnSelectDisps "Select Used Displacements" pos:[172,529] width:158 height:32 toolTip:"Select all displacements in the scene that have a material using the selected detail type."
					button btnDeleteAuto "Delete Imported Details" pos:[307,448] width:132 height:32 toolTip:"Delete all the details in the scene that have been automatically generated."
					button btnDeletePainted "Delete Painted Details" pos:[443,448] width:138 height:33 toolTip:"Delete all the detail props that have been placed manually with the Object Paint tools."
					button btnReset "Reset" pos:[344,144] width:75 height:29 toolTip:"Reset this UI and clear the cached VBSP info."
					HyperLink lblWW "Wall Worm" pos:[12,575] width:171 height:19 address:"http://www.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
					HyperLink linkHelp "Help" pos:[200,575] width:171 height:19 address:"http://dev.wallworm.com/document/132/vbsp_parser.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
					HyperLink lblBriscoe "Sponsored by Robert Briscoe" pos:[430,574] width:151 height:19 address:"http://www.littlelostpoly.co.uk" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
					checkbox chkLimit "Limit Creation/Deletion To Selected" pos:[308,427] width:270 height:16
					button btnSelImp "Select Imported" pos:[309,485] width:98 height:35 toolTip:"Select all imported props."
					button btnSelPainted "Select Painted" pos:[412,486] width:86 height:34 toolTip:"Select all objects painted from this tool."
					button btnCollapse "Collapse" pos:[504,487] width:77 height:17 toolTip:"Collapse Selected objects."
					spinner spnMin "Min" pos:[423,306] width:60 height:16 range:[0,1000,1] scale:0.01 toolTip:"Randomly offset scales with a minimum of this value."
					spinner spnMax "Max" pos:[505,306] width:60 height:16 range:[0,1000,1] scale:0.01 toolTip:"Randomly offset scales with a maximum of this value."
					GroupBox grp1 "Randomly Offset Scales" pos:[311,286] width:270 height:52
					dropdownList ddlScaleOptions "" pos:[320,302] width:85 height:21 items:#("normalize", "offset") selection:1 toolTip:"Should these be absolute offsets or normalized multipliers? Normalize means 1.0 == no change and 0.5 == half. Offset generates wider ranges."
					dropdownList ddlCoerceOrientation "Coerce Orientation" pos:[310,341] width:271 height:40 items:#("", "Upright", "Face Normal", "Upright Test") toolTip:"Override the orientation of placed props instead of using the VBSP settings. Note that Face Normal is the default in the VBSP. Upright takes longer to do because it must calculate normals from faces for each prop! Upright Test skips correctly applying the displacement face normal to the prop."
					checkbox chkForceFillProps "Fill to Allowed" pos:[495,185] width:84 height:17 toolTip:"When on, every allowed prop seed is used. When off, prop seeds may go unused if the spot produces no props based on group alpha settings."
					button btnLoadFromScene "Load From Scene" pos:[18,364] width:115 height:22 toolTip:"Load Detail Sprites from the scene nodes (which requires the commercial Detailer plugin from Wall Worm)."
					button btnGenerateDetailType "Create Type" pos:[21,483] width:112 height:17 toolTip:"Generate DetailType Tree by adding nodes and controlling the values in the Max UI. Requires the Detailer plugin from Wall Worm."
					checkbox chkSkipNormal "Skip Normal" pos:[419,340] width:78 height:17 toolTip:"Skip the normal for upright models. Works much faster. Useful for quicker previews."
					checkbox chkSkipAngles "Skip Angles" pos:[501,341] width:77 height:13
					button btn18 "Cluster" pos:[504,506] width:76 height:15 toolTip:"Make Clusters from selected displacements."
					button btnSelectUnused "Select Unused Types" pos:[20,413] width:115 height:21
					button btnDeleteUnused "Delete Unused Types" pos:[19,440] width:115 height:17
					button btn21 "Create Detailer Nodes" pos:[19,390] width:115 height:19
					button btnDelSelDetailer "Delete Selected Types" pos:[20,462] width:114 height:16
					groupBox grp3 "Detailer Plugin" pos:[14,349] width:124 height:164		
					

					function renderDetailMap = (
						global wallworm_VBSP
						m = wallworm_VBSP.mat
						if m != undefined  then (
							if m.diffusemap != undefined then (
								bmp1.bitmap = renderMap m.diffusemap size:[128,128]
							)
							
						)
					)

					function fillDetailList = (
						global wallworm_VBSP
						
						if wallworm_VBSP.types.count > 0 then (
							
							if chkLimitToScene.checked == true then (
								ts = wallworm_VBSP.getTypesWithDisplacements()
								lbxDetailTypes.items =  for t in ts collect t.name    
							) else (
								lbxDetailTypes.items = for t in wallworm_VBSP.types collect t.name
							)
						)
						
					)
					
					
					
			
					
					
					function getTypeNodes name = (
						for obj in objects WHERE obj.name == name AND classof obj.baseObject == WallWormDetailType collect obj
					)
					
					
					


					
					on wallworm_vbsp_parser open do
					(
						global wallworm_VBSP
						m = wallworm_VBSP.mat
						if m != undefined AND bmp1.bitmap == undefined then (
							renderDetailMap()
						)
						spnScale.value = wallworm_VBSP.densityMultiplier
						ddlForceType.selection = findItem (ddlForceType.items) wallworm_VBSP.forceShape
						chkSkipNormal.checked = wallworm_VBSP.skipNormal
						fillDetailList()
					)
					on edt_detail_file entered tex do
					(
						global wallworm_VBSP
						wallworm_VBSP.filename = tex
					)
					on btn_browse_vbsp pressed do
					(
						global wallworm_VBSP
						f = getOpenFileName caption:"Open VBSP File" filename:wallworm_VBSP.filename types:"VBSP Detail File (*.vbsp)|*.vbsp" historyCategory:"Wall Worm VBSP"
						if f != undefined then (
							wallworm_VBSP.filename = f
							edt_detail_file.text = wallworm_VBSP.filename
						)
					)
					on edt_detail_vmt entered tex do
					(
						global wallworm_VBSP
						wallworm_VBSP.vmt = tex
					)
					on btn_browse_vmt pressed do
					(
						global wallworm_VBSP
						f = getOpenFileName caption:"Select Detail Material File" filename:wallworm_VBSP.vmt types:"Valve Material File (*.vmt)|*.vmt" historyCategory:"Wall Worm Materials"
						if f != undefined then (
							wallworm_VBSP.vmt = f
							edt_detail_vmt.text = wallworm_VBSP.vmt
						)
					)
					on btnImport pressed do
					(	
						global wallworm_VBSP
					
							
							local res = wallworm_VBSP.import()
							if res[1] == true then (
								fillDetailList()
								renderDetailMap()
								format "#############\nVBSP Importer: \nDetail Types: %\n" wallworm_VBSP.types.count
								
							) else (
								messagebox (res[2])
							)
					
					)
					on btnExport pressed do
					(			
						
						if WallWormDetailType != undefined then (
							global wallworm_VBSP
							p = wallworm_VBSP.filename
							if doesFileExist p == false then (
									p = getFileNamePath p
							)
							if doesFileExist p == false then (
									global wwmt_gameInfoDir
									p = wwmt_gameInfoDir
							)
							
							f = getSaveFileName caption:"Save Custom VBSP File" filename:p types:"VBSP Detail File (*.vbsp)|*.vbsp" historyCategory:"Wall Worm VBSP"
							if f != undefined then (
								wallworm_VBSP.filename = f
								wallworm_VBSP.writeVBSP()
								global wallworm_text_editor
								if wallworm_text_editor == undefined OR wallworm_text_editor == "" then (
									wallworm_text_editor = "notepad.exe"
								)
								folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+(wallworm_VBSP.filename as string)+"\""
								execute folderOpen
							)
						) else (
							messagebox "The exporter requires functions the Wall Worm Detailer Plugin."
							macros.run "wallworm.com" "WallWormWebProductsMCR"
						)
					)
					on btnAssignMat pressed do
					(
						global wallworm_VBSP
						m = wallworm_VBSP.mat
						if m != undefined then (
							if selection.count > 0  then (
								
								selection.mat = m
								) else (
								
									messagebox "Nothing is selected in the scene."
								
								)
							
						) else (
								messagebox "No material generated yet. Run the Parse and Import function."
						)
						
					)
					on btnApplySprites pressed do
					(
						global wallworm_VBSP
						local ps = (for obj in objects where getUserProp obj "wallworm_imported_detail" != undefined collect obj)
						local runImport = true
						if chkLimitToScene.checked == false AND  ps.count > 0  then (
							
							res = yesNoCancelBox "There are already details in the scene. Click Yes to delete existing imported details before adding new ones, No to add new props to scene, and Cancel to do nothing." title:"Detail Import Conflict."
						
							case res of (
					
							#cancel: runImport = false
							#yes:wallworm_VBSP.destroyOnRandomize = true
							#no:wallworm_VBSP.destroyOnRandomize = false	
							)
						)
						if runImport == true then (
							wallworm_VBSP.randomize()
						)
					)
					on spnScale changed val do
					(
											global wallworm_VBSP
											wallworm_VBSP.densityMultiplier = val
										
										)
					on spnSeed changed val do
					(
											global wallworm_VBSP
											wallworm_VBSP.propseed = val
											seed val
										)
					on lbxDetailTypes selected sel do
					(
											nds = getTypeNodes lbxDetailTypes.selected 
											if nds.count > 0 then (
												flashNodes nds
												forceCompleteRedraw()
											)
											
										)
					on lbxDetailTypes rightClick sel do
					(
											nds = getTypeNodes lbxDetailTypes.selected 
											if nds.count > 0 then (
												select nds
												max modify mode
											)
											
										)
					on chkLimitToScene changed state do
					(
						fillDetailList()
					)
					on ddlForceType selected sel do
					(
						global wallworm_VBSP
						wallworm_VBSP.forceShape =  ddlForceType.selected 
						
					
						
					)
					on btnStartPainting pressed do
					(
						if lbxDetailTypes.selection != 0 then (
								global wallworm_VBSP
								if chkLimitToScene.checked == true then (
									
									local ts = wallworm_VBSP.getTypesWithDisplacements()
									
								) else (
									local ts = wallworm_VBSP.types
								)
							
								local newProps = #()
								wallworm_klunk_ToggleMaxRedraw 0
								for t in ts do (
										for g in t.groups do (
												for d in g.details do (
													
													
													local det = (d.create_detail forceShape:wallworm_VBSP.forceShape app:false useMultiMat:wallworm_VBSP.useMultiMat)
													
													if wallworm_VBSP.useMultiMat == true then (
														det.mat = wallworm_VBSP.getDetailMatByName (d.sprite as string)
													) else (
															det.mat = wallworm_VBSP.mat
													)
													
													append newProps det
												)
											
										)
									
								)
								wallworm_klunk_ToggleMaxRedraw 1
							
									if newProps.count > 0 then (
											ObjectPaint.nodes = newProps
											ObjectPaint.NodeNames = for obj in newProps collect obj.name
											ObjectPaint.SetSelectedObject newProps.count
											macros.run "Ribbon - Modeling" "ObjectPaintUseNodesAllRandomly"
											macros.run "PolyTools" "ObjectPaintPaint"
									)
							
						)
					)
					on btnSelectDisps pressed do
					(
											
						if lbxDetailTypes.selection != 0 then (
							global wallworm_VBSP
							if chkLimitToScene.checked == true then (
														
								local ts = wallworm_VBSP.getTypesWithDisplacements()
														
							) else (
								local ts = wallworm_VBSP.types
							)
												
							local disps = #()
							
							disps = for obj in objects WHERE  getUserProp obj "wallworm_imported_detail" == undefined AND getUserProp obj "wallworm_detail_painted" == undefined AND getUserProp obj "ww_wwdt_displacement_target" == undefined AND obj.mat != undefined AND (isProperty obj.mat "wallworm"==true  AND obj.mat.detail == lbxDetailTypes.selected OR (classOf obj.mat == DirectX_9_Shader AND obj.mat.renderMaterial != undefined AND isProperty obj.mat.renderMaterial "wallworm"==true AND obj.mat.renderMaterial.detail ==  lbxDetailTypes.selected)) collect obj
							if disps.count > 0 then (
									
									select disps
									macros.run "PolyTools" "ObjectPaintTypeSelected"
									
							) else (
									messagebox "No displacements use this detail type."
							)
												
						)
					)
					on btnDeleteAuto pressed do
					(
						
						global wallworm_VBSP
						if querybox "Are you sure? This will delete all details generated by the tool." == true then (
							
							if wallworm_VBSP.limitToSelection == true then (
								delete (for obj in selection where getUserProp obj "wallworm_imported_detail" != undefined collect obj)
								
							) else (
								delete (for obj in objects where getUserProp obj "wallworm_imported_detail" != undefined collect obj)
							)
							
							
						)
						
					)
					on btnDeletePainted pressed do
					(
						if querybox "Are you sure? This will delete all details you've painted with this tool." == true then (
							
							global wallworm_VBSP
							if wallworm_VBSP.limitToSelection == true then (
								
								delete (for obj in selection where getUserProp obj "wallworm_detail_painted" != undefined collect obj)
							) else (
								delete (for obj in objects where getUserProp obj "wallworm_detail_painted" != undefined collect obj)
							)
							
							
						)
					)
					on btnReset pressed do
					(
						global wallworm_VBSP
						if wallworm_VBSP != undefined AND wallworm_VBSP.ui != undefined then (
							destroyDialog wallworm_VBSP.ui
						)
						wallworm_VBSP = undefined
						macros.run "wallworm.com" "WallWormImportVBSPMCR"
					)
					on chkLimit changed stat do
					(
							global wallworm_VBSP
							wallworm_VBSP.limitToSelection	= stat
					)
					on btnSelImp pressed do
					(
						
						global wallworm_VBSP
					
							
							if wallworm_VBSP.limitToSelection == true then (
								select (for obj in selection where getUserProp obj "wallworm_imported_detail" != undefined collect obj)
								
							) else (
								select (for obj in objects where getUserProp obj "wallworm_imported_detail" != undefined collect obj)
							)
							
					)
					on btnSelPainted pressed do
					(
						global wallworm_VBSP
							if wallworm_VBSP.limitToSelection == true then (
								select (for obj in selection where getUserProp obj "wallworm_detail_painted" != undefined collect obj)
							) else (
								select (for obj in objects where getUserProp obj "wallworm_detail_painted" != undefined collect obj)
							)
					)
					on btnCollapse pressed do
					(
						global wallworm_VBSP
						local objs
						max create mode
						if wallworm_VBSP.limitToSelection == true then (
							objs =  (for obj in selection where (getUserProp obj "wallworm_imported_detail" != undefined OR getUserProp obj "wallworm_detail_painted" != undefined) collect obj)		
						) else (
							objs =  (for obj in objects where (getUserProp obj "wallworm_imported_detail" != undefined OR getUserProp obj "wallworm_detail_painted" != undefined) collect obj)
						)
					
						local total = 	objs.count				
												
						if total > 0 then (
							wallworm_klunk_ToggleMaxRedraw 0					
							if total < 10000 OR (querybox "There are over 10,000 props to collapse. It may take a very long time. Do you want to continue?") == true then (
												
								local p
												
								max select none
								local en = Edit_Normals()
								addModifier objs en
								max modify mode
								modpanel.setcurrentobject en
								--select obj		
								resetXForm objs
					
								for obj in objs do with redraw off (		
									if p == undefined then (
										p = copy obj	
										delete obj
										convertToPoly p
										p.name = uniquename "Collapsed Prop Details"
										gc()
									) else (
										p.attach obj p
									)
								)
							)
							wallworm_klunk_ToggleMaxRedraw 1
						)
												
					)
					on spnMin changed val do
					(
						global wallworm_VBSP
						wallworm_VBSP.scaleOffsetMin = val
						
					)
					on spnMax changed val do
					(
						global wallworm_VBSP
						wallworm_VBSP.scaleOffsetMax = val
						
					)
					on ddlScaleOptions selected sel do
					(
						global wallworm_VBSP
						wallworm_VBSP.scaleOption =  ddlScaleOptions.selected 
					)
					on ddlCoerceOrientation selected sel do
					(
						global wallworm_VBSP
						wallworm_VBSP.forceOrientation =  ddlCoerceOrientation.selected 
					)
					on chkForceFillProps changed state do
					(
					global wallworm_VBSP
					wallworm_VBSP.forceFillProps = state
					)
					on btnLoadFromScene pressed do
					(
						if WallWormDetailType != undefined then (
							wallworm_vbsp_from_nodes()				
							renderDetailMap()
							fillDetailList()
						) else (
							messagebox "This function requires the Wall Worm Detail Plugin."
							macros.run "wallworm.com" "WallWormWebProductsMCR"	
						)
					)
					on btnGenerateDetailType pressed do
					(
						global wallworm_VBSP
						if WallWormDetailType != undefined then (
							dt = WallWormDetailType()
							dt.setup()
							if wallworm_VBSP.mat != undefined then (
								dt.mat = wallworm_VBSP.mat
							)
							select dt
							forcecompleteredraw()
							max modify mode
							
						) else (
							messagebox "This function requires the Wall Worm Detail Plugin."
							macros.run "wallworm.com" "WallWormWebProductsMCR"
						)
						
					)
					on chkSkipNormal changed state do
					(
					
					global wallworm_VBSP
					
					wallworm_VBSP.skipNormal = state
					)
					on chkSkipAngles changed stat  do
					(
											global wallworm_VBSP
											wallworm_VBSP.skipAngles =  stat
										)
					on btn18 pressed do
					(
						
						local sel 
						if chkLimit.checked then (
							
							sel = selection	
						) else (
							sel = objects
						)
						clusters = wallworm_cluster_details sel:sel
						
						if clusters.count > 0 then (
						
							print (clusters.count as string + " clusters created.")
							select clusters 
							forcecompleteredraw()
						)
					)
					on btnSelectUnused pressed do
					(
						global wallworm_VBSP
						if wallworm_VBSP.types.count > 0 then (
							
					
								ts = wallworm_VBSP.getTypesWithDisplacements()
								existingTypes =  for t in ts collect t.name    
									
								select (for obj in objects where classof obj == WallWormDetailType AND findItem existingTypes obj.name == 0 collect obj)
					
						)
					)
					on btnDeleteUnused pressed do
					(
						
						if (querybox "Are you sure? This cannot be undone!") then (
						
							max create mode
							with redraw off
							undo off (
								
								global wallworm_VBSP
								
								if wallworm_VBSP.types.count > 0 then (
									
					
										ts = wallworm_VBSP.getTypesWithDisplacements()
										existingTypes =  for t in ts collect t.name    
											
										objs = for obj in objects where classof obj == WallWormDetailType AND findItem existingTypes obj.name == 0 collect obj
										
										for obj in objects where classof obj == WallWormDetailType AND findItem existingTypes obj.name == 0 do (
										
											obj.deleteMyGroups()
											
											
										)
										
										
										delete objs
					
								)
								
								
							)
							forcecompleteredraw()
						)
					)
					

					
					on btnDelSelDetailer pressed do
					(
						
						if (querybox "Are you sure? This cannot be undone!") then (
						
							max create mode
							with redraw off
							undo off (
								
								if selection.count > 0 then (
									
					
										objs = for obj in (selection as array) where obj != undefined AND isValidNode obj AND classof obj == WallWormDetailType  collect obj

											if objs.count > 0 then (
												
												for obj in objs  do (
												
													obj.deleteMyGroups()
													
													
												)
												
												
												delete objs
												
											)
							
								)
								
								
							)
							forcecompleteredraw()
						)
					)
					
					on btn21 pressed do
					(
					
						if WallWormDetailType != undefined then (
					
							wallworm_nodes_from_vbsp()
							forcecompleteredraw()
						) else (
							messagebox "This function requires the Detailer plugin. Get it from WallWorm.com ."
							macros.run "wallworm.com" "WallWormWebProductsMCR"
						)
					
					)
				)
			)

		) 
	ui
	),
	function show = (
		
		getRollout()
		if ui.inDialog == false then (
			createDialog ui
		)
		ui.edt_detail_file.text = filename
		ui.edt_detail_vmt.text = vmt
		ui.spnScale.value	= densityMultiplier
		ui.spnSeed.value = propseed 
		ui.spnMin.value = scaleOffsetMin
		ui.spnMax.value = scaleOffsetMax
		ui.ddlScaleOptions.selection = findItem ui.ddlScaleOptions.items scaleOption
		ui.ddlCoerceOrientation.selection = findItem ui.ddlCoerceOrientation.items forceOrientation
		ui.chkSkipAngles.checked = wallworm_VBSP.skipAngles
		ui.chkForceFillProps.checked = forceFillProps

	),
	function setupDefault onlifIfEmpty:true = (

	
		if onlifIfEmpty == false OR (onlifIfEmpty== true AND ((vmt==undefined OR vmt=="")) OR (filename==undefined OR filename=="")) then (

			if isProperty rootNode "DetailVBSP" then (
				

				
				
				if onlifIfEmpty == false OR (onlifIfEmpty==true AND (filename == undefined OR filename=="")) then (
					filename = wwmt_gameInfoDir + "\\" + rootNode.DetailVBSP
				)
				if onlifIfEmpty == false OR (onlifIfEmpty==true AND (vmt == undefined OR vmt=="")) then (
					vmt = wwmt_gameInfoDir + "\\materials\\" +rootNode.DetailSprites
				
					if getfilenametype vmt == "" then (
						
						vmt = (rootNode.DetailSprites + ".vmt")
					)
				)
				
				
			) else (
				
			wallwormVMFSettingsIndex = fileProperties.findProperty #custom "wallwormVMFSettings"
			if wallwormVMFSettingsIndex != 0 then (
				wallwormVMFSettings1=fileProperties.getPropertyValue #custom wallwormVMFSettingsIndex
				wallwormVMFSettings1 = "global wallworm_file_vmf_presets1 = ("+wallwormVMFSettings1+")"
				execute wallwormVMFSettings1
			) 
			
			global wallworm_file_vmf_presets1
			if wallworm_file_vmf_presets1 != undefined AND classOf wallworm_file_vmf_presets1 == wallwormVMF then (
				
				if onlifIfEmpty == false OR (onlifIfEmpty==true AND (filename == undefined OR filename=="")) then (
					filename = wwmt_gameInfoDir + "\\" + wallworm_file_vmf_presets.DetailVBSP
				)
				if onlifIfEmpty == false OR (onlifIfEmpty==true AND (vmt == undefined OR vmt=="")) then (
					vmt = wwmt_gameInfoDir + "\\materials\\" +wallworm_file_vmf_presets.DetailSprites
				
					if getfilenametype vmt == "" then (
						
						vmt = (wallworm_file_vmf_presets.DetailSprites + ".vmt")
					)
				)
			)	
		

			
				
			)
			
			if filename == undefined OR filename == "" then (
			
				filename = wwmt_gameInfoDir + "\\detail.vbsp"
			)
			
			if vmt == undefined OR vmt == "" then (
			
				lookArray = #((wwmt_gameInfoDir+"\\materials"),wwmt_exportMats,wwmt_raw_mats)
				for i = 1 to lookArray.count while vmt == "" do (
					vmtsearch = lookArray[i]+"\\detail\\detailsprites.vmt"
					if doesFileExist vmtsearch then (
						vmt =   vmtsearch
					)
				)
			)				
			

			
		)
		wallworm_file_vmf_presets1 = undefined
	)	
)
)
