/*

Common Functions in Wall Worm Tools
http://www.wallworm.com 

Copyright (c) 2011-2014 by Shawn Olson
http://www.shawnolson.net

Most functions by Shawn Olson

If a function is from elsewhere or derived from another source, it is usually listed in a comment above the function.

Thanks to Denis Trofimov, Kostadin Kotev and others for a lot of random help.


*/


/*
Function from discussion at http://forums.cgsociety.org/showthread.php?f=98&t=1131972
*/
 fn wallworm_klunk_ToggleMaxRedraw arg =
 (
 	if arg == 1 then
 	(
 		cui.CommandPanelOpen = true; 
 		enableSceneRedraw();
 		enableRefMsgs();
 	) 
 	else 
 	(
 		disableSceneRedraw();
 		disableRefMsgs();
 	)	
 	WM_SETREDRAW = 0xB;
 	hwnd = (windows.getChildHWND #max "Command Panel");
 	
 -- is the command panel floating ?	
 	
 	if hwnd == undefined then -- this doesn't really work because when floating I think max/windows turns redraw back on somewhere 
 		hwnd = (windows.getChildHWND (windows.getDesktopHWND()) "Command Panel"); -- works with disableRefMsgs() though ! :)
 		
 -- if something didn't go wrong !
 			
 	if 	hwnd != undefined then	
 		windows.sendmessage (hwnd[1]) WM_SETREDRAW arg 0;
 )





/*Function return a randomized copy of an array*/
function wallworm_randomize_array ar = (
	
		startArrayCount = ar.count
		ar2 = #()
	
		while ar2.count != startArrayCount do (
			
			index = random 1 ar.count
			
			append ar2 ar[index]
			
			deleteItem ar index
			
			
		)
		ar2
)




function wwmt_smd_exporters_installed = (
	
		local smdExporters = 0
		local wunderboySMDExporterInstalled = false
		local cannonfodderSMDExporterInstalled = false
		for c in exporterPlugin.classes do (
				
			if c == SMDExporter do (
				smdExporters = smdExporters +1
			)
	
			if c== SmdExport do (
						
				smdExporters = smdExporters + 2
						
			)

		)
		
		return smdExporters
				
	)
	
	/*Function will set the value of vals array to val based on the index of prop in props. 
	Useful for datasets stored in two arrays where one array is a named index for the values stored in another array.
	This function is helpful because there are no named indexes in MXS arrays and you don't always want to create a struct.
	
	
	props and vals should be arrays.
	*/
	function wallworm_set_kvarrays &props &vals prop val checkMatch:true= (
		
		if checkMatch == true AND props.count != vals.count then (
			/*Stop the function if the props and vals array aren't the same length... as this probably means bad data.*/
			return false
		)
		
		local currentPos = findItem props prop
		if currentPos != 0 then (
			vals[currentPos] = val
		) else (
			append props prop
			append vals val
			
		)
		true
	)



struct xpecSkinOpsDef(   
	--http://tech-artists.org/forum/showthread.php?t=692
	fn getBoneNames skinMod =    ( 
		local cnt = skinOps.getNumberBones skinMod     
		global 	wallworm_skinops_getBoneNameByListID	
		for i = 1 to cnt collect wallworm_skinops_getBoneNameByListID skinMod i 1
	),   
	fn getBoneId skinMod boneName =    (
		findItem (getBoneNames skinMod) boneName    
		),    
	fn getVertexWeightBoneIdByName skinMod vert boneName =    (
		skinOps.getVertexWeightBoneId skinMod vert (getBoneId skinMod boneName)    
	)
)

 fn wallworm_getBonesFromSkin theSkin =
 (
		local boneArray=for o in objects where (refs.dependencyLoopTest theSkin o) collect o
 )


fn getBoneFromSkin theSkin boneID boneArray:undefined sysInt:1=
 (
	 --http://forums.cgsociety.org/archive/index.php/t-779310.html
	if boneArray == undefined then (
		 local boneArray=for o in objects where (refs.dependencyLoopTest theSkin o) collect o
	)
 local boneName=(skinOps.GetBoneName theSkin boneID sysInt)
 local notFound=true
 local i=0
 while notFound and i<boneArray.count do
 (
 i+=1
 if boneArray[i].name==boneName then notFound=false
 )
 if notFound then undefined else boneArray[i]
 )


 

global xpecSkinOps = xpecSkinOpsDef()

 function wallworm_slash_start str = (
	 
	 badstart = #("r","t","n")
	 if findItem badstart str[1] != 0 then (
		 str = "\\"+str
		 
	)	
	str	
)
 
 
 function wallworm_FsToBs s = (
	if s != undefined do (
		for i = 1 to s.count do (
			if s[i] == "/" then
			(
			s = replace s i 1 "\\"
			)
		)
	)
	return s
)

function wallworm_bsToFs s = (
	for i = 1 to s.count do
	(
		if s[i] == "\\" then
		(
			s = replace s i 1 "/"
		)
	)

	return s
)
 		
function wallworm_clean_decimals d = (
	local num = d
	if mod num 1 == 0 then ( 
		num = (num as integer) 
	)
	return num 
)


function wallworm_string_remove_duplicate inputstring lookfor= (
	
	while (findString inputstring (lookfor+lookfor)) != undefined do (
		inputstring = replace inputstring (findString inputstring (lookfor+lookfor))  2 lookfor
	)
	return inputstring
)

function wallworm_safe_bitmappath inp = (
	r = inp.count
	for i = 1 to r do (
		if (inp[i] == "%" OR inp[i] == "#") do (
			inp = replace inp i 1 "_"
		) 
	)	
	return inp
)



function wallworm_safe_path p = (
	
	p = wallworm_bsToFs p
	p = wallworm_string_remove_duplicate p "/"
	p = wallworm_safe_bitmappath p
	p = trimLeft p
	p = trimRight p
	return p
)
 
function wallworm_safe_local p = (
	
	p = wallworm_FsToBs p
	p = wallworm_string_remove_duplicate p "\\\\"
	p = wallworm_safe_bitmappath p
	p = trimLeft p
	p = trimRight p
	return p
)
 
function wallworm_makeStringSafe inp = (
	r = inp.count
	for i = 1 to r do (
		if (inp[i] == "." OR inp[i] == " " OR inp[i] == "/" OR inp[i] == "\\" OR inp[i] == "%" OR inp[i] == "#") do (
			inp = replace inp i 1 "_"
		) 
	)	
	return inp
)

function  wwmt_findGroupHead obj = 
(
	if (isGroupHead obj) then (
		return obj
		) else (
		if (isGroupMember obj) then (
			wwmt_findGroupHead (obj.parent)
		) 
		else (
			return undefined
		)
		
	)
)

function wwmt_valid_geometry obj = (
	--if obj == undefined OR isDeleted obj == true OR isValidNode obj == false OR (isGroupHead obj) OR (isGroupMember obj) then (
	if obj == undefined OR isDeleted obj == true OR isValidNode obj == false  then (
		return false
		) else (
		 return true
		)
	)


function wallworm_binSet type = (
	

				can = false

				
				if type == "tex" do (
					if wwmt_binDir != undefined do (
						studiopath = wwmt_binDir+"\\"+"vtex.exe"
						if doesFileExist (studiopath) then (
							can = true
						) else (
							
							--print studiopath
							
							)
					)
				)
				if type == "model" do (
					if wwmt_binDir != undefined  do (
						studiopath = wwmt_binDir+"\\"+"studiomdl.exe"
						if doesFileExist (studiopath) do (
							can = true
						)
					)
				)
				
				
				return can
	
	)
	
	function wallworm_remove_last_slash matName forModel:false char:"/" = (
		
		if matName == undefined OR matName == "" then (
			return ""
			)
		
		if (substring matName matName.count 1) == char then (
			
			return (substring matName 1 (matName.count - 1))
			
		)
		
		return matName
	)
	
	function wallworm_remove_first_slash matName forModel:false char:"/" = (
		
		if matName == undefined OR matName == "" then (
			return ""
			)
		
		if (substring matName 1 1) == char then (
			
			return (substring matName 2 matName.count)
			
		)
		
		return matName
	)
	
	function wwmt_count_hulls hullobjs concave = (
		count = 0
		for c in hullobjs do (
	     
			local h = copy c
			convertToPoly h
			if concave == true then (
					local Elements = #()
					-- Array containing all face indices
					local Faces = #{1..h.numFaces} as array
					-- Loop until nothing left in 'Faces' array
					while Faces.count > 0 do
					(
						-- Get the element using the first face in the 'Faces' array
						local FaceElem = polyOp.getElementsUsingFace h Faces[1]
						-- Subtract the element from the 'Faces' array
						Faces = ((Faces as bitArray) - FaceElem) as array
						-- Append the elements
						append Elements FaceElem
					)
					    for item in Elements do (
							count = count + 1
						)
					) else (
							count = count + 1
					)

                    delete h
	
			)
		return count
		)
		
		
function wwmt_get_rotation r = (
	
	if r <=360 AND r >= -360 then (
		return r
	) else (
		
		
		
			--if r > 0 then (
				return (mod r 360)
			--) else (
				--return (mod r 360)*-1
			--)
		
		)
	
	
	)
	
	
function wwmt_group_warning obj = (
		
		if isGroupMember obj do (
			
			return false
		)
		return true
	)
	
	

	
	
function wwmt_bitarray_value ba = (
		
		local v = 0
		for bv in ba do (
			
			v+=bv
		)
		return v
	)
	
function wwmt_bitarray_int ba = (
		
		local out = 0
		local v = 1
		for bv = 1 to ba.count do (
			if (findItem ba bv) != 0 then (
				
				out +=v
				
				)
			
			
			v = v * 2
		)
		return out
)

function wallworm_getXrefs &collection &ref= (
		
		if ref != undefined then (
			for index = 1 to xrefs.getXRefFileCount root:ref do(
				local xref = xrefs.getXRefFile index root:ref
				if xref.disabled == false then (
					if findItem collection (xref) == 0 then (
						
						append collection xref
					)
					getXrefs collection xref
				)
			)
		) else (
			--format "XREF COUNT: %\n" xrefs.getXRefFileCount()
			for index = 1 to xrefs.getXRefFileCount()  do(
				local xref = xrefs.getXRefFile index 
				if xref.disabled == false then (
					--format "XREF % : % enabled\n" index xref
					
					--if findItem collection (xref) == 0 then (
						
						append collection xref
						--format "XREF % : % Added\n" index xref
						
					--)
					wallworm_getXrefs collection xref
				)
				
			)

		
		)
		
		
	)
	
function ww_getUserProp obj property xref:undefined = (
	if obj == undefined OR classof obj == MAXRootNode then return undefined
	if xref == undefined then (
		return getUserProp obj property
		) else (
			local childIndex = 1
			for childIndex = 1 to xref.count  do (
				if obj == xref[childIndex] then (
					
					return getUserProp xref[childIndex] property
					
				)
				
			)

		)
	return undefined
)


function ww_getNodeByName name xref:undefined = (
	if xref==undefined then (
		return getNodeByName name
		
		) else (
		
		local childIndex = 1
		for childIndex = 1 to xref.count  do (
			
			if xref[childIndex].name == name then (
				
				return xref[childIndex]
				
				)
			)
		)
		return undefined
	)
	
function ww_isProperty obj property xref:undefined = (
	if obj != undefined then (
		if xref == undefined then (
			return isProperty obj property
		) else (
			local childIndex = 1
			for childIndex = 1 to xref.count  do (
				if obj == xref[childIndex] then (
					return isProperty xref[childIndex] property
				)
				
			)

		)
	)
	return false
)
	
function wallworm_collect_children root &collection = (
	if collection == undefined then (
		collection = #()
	)
	
	theChildren = for obj in root WHERE classof obj != MAXRootNode collect obj
	join collection theChildren
	
	for obj in theChildren where obj.children.count > 0 do (
		wallworm_collect_children obj.children &collection
	)
	
)

function wallworm_get_all_objects = (
	objs = #()

	refCollection = #()
	wallworm_getXrefs refCollection undefined
	
	local alreadyIncluded = #()
	for ref in refCollection  do (
		if findItem alreadyIncluded ref.filename == 0 then (
			wallworm_collect_children ref.tree.children objs
			append alreadyIncluded ref.filename
		)
		
	)
	objs
)




function wallworm_setPropDefaults obj type:"prop_static" mdl:undefined= (

	global wallworm_get_entity_by_name
	if wallworm_get_entity_by_name == undefined then (
		filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
	)
	
	test = wallworm_get_entity_by_name  type
	
	if test == undefined OR test.ca == undefined then (
	
	local GLBPntData = ""
	local GLBPntValu = ""
	

	
	case type of  (
		"prop_static":(
			GLBPntData = "prop_static,angles,mindxlevel,maxdxlevel,model,skin,solid,disableshadows,screenspacefade,fademindist,fademaxdist,fadescale,lightingorigin,disablevertexlighting,disableselfshadowing,ignorenormals"
			GLBPntValu = ",0 0 0,0,0,"+mdl+",0,6,0,0,-1,0,1,;,0,0,0"
		)
		
		"prop_physics":(
			GLBPntData = "prop_physics,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,minhealthdmg,shadowcastdist,physdamagescale,Damagetype,nodamageforces,inertiaScale,massScale,overridescript,damagetoenablemotion,forcetoenablemotion,puntsound,renderfx,rendermode,renderamt,rendercolor,disablereceiveshadows"
			GLBPntValu = ",;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,0.1,0,0,1.0,0,;,0,0,;,0,0,255,255 255 255,0"
		)
		"prop_dynamic":(
			GLBPntData = "prop_dynamic,parentname,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,renderfx,rendermode,renderamt,rendercolor,disablereceiveshadows,solid,DefaultAnim,RandomAnimation,MinAnimTime,MaxAnimTime,SetBodyGroup,lightingorigin,StartDisabled"
			GLBPntValu = ",;,;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,255,255 255 255,0,6,;,0,5,10,0,;,0"
		)
		"prop_detail":(
			GLBPntData = "prop_detail,model"
			GLBPntValu = ","+mdl
		)
		
		"prop_physics_multiplayer":(
			GLBPntData = "prop_physics_multiplayer,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,minhealthdmg,shadowcastdist,physdamagescale,Damagetype,nodamageforces,inertiaScale,massScale,overridescript,damagetoenablemotion,forcetoenablemotion,puntsound,renderfx,rendermode,renderamt,rendercolor,disablereceiveshadows,physicsmode"
			GLBPntValu = ",;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,0.1,0,0,1.0,0,;,0,0,;,0,0,255,255 255 255,0,0"
		)
		"prop_physics_override":(
			GLBPntData = "prop_physics_override,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,minhealthdmg,shadowcastdist,physdamagescale,Damagetype,nodamageforces,inertiaScale,massScale,overridescript,damagetoenablemotion,forcetoenablemotion,puntsound,health"
			GLBPntValu = ",;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,0.1,0,0,1.0,0,;,0,0,;,0"

		)
		"prop_dynamic_ornament":(
			GLBPntData = "prop_dynamic_ornament,parentname,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,renderfx,rendermode,renderamt,rendercolor,disablereceiveshadows,DefaultAnim,RandomAnimation,MinAnimTime,MaxAnimTime,SetBodyGroup,lightingorigin,solid,InitialOwner"
			GLBPntValu = ",;,;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,255,255 255 255,0,;,0,5,10,0,;,0,;"

		)
		"prop_dynamic_override":(
			GLBPntData = "prop_dynamic_override,parentname,globalname,angles,model,skin,targetname,damagefilter,disableshadows,ExplodeDamage,ExplodeRadius,PerformanceMode,pressuredelay,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,renderfx,rendermode,renderamt,rendercolor,disablereceiveshadows,solid,DefaultAnim,RandomAnimation,MinAnimTime,MaxAnimTime,SetBodyGroup,lightingorigin,health"
			GLBPntValu = ",;,;,0 0 0,"+mdl+",0,;,;,0,0,0,0,0,0,0,-1,0,1,0,0,255,255 255 255,0,6,;,0,5,10,0,;,0"
		)
		"prop_door_rotating":(
			GLBPntData = "prop_door_rotating,targetname,parentname,angles,globalname,model,skin,disableshadows,slavename,hardware,ajarangles,spawnpos,axis,distance,speed,soundopenoverride,soundcloseoverride,soundmoveoverride,returndelay,dmg,health,soundlockedoverride,soundunlockedoverride,forceclosed,opendir"
			GLBPntValu = ",;,;,0 0 0,;,"+mdl+",0,0,;,1,0 0 0,0,;,90,100,;,;,;,-1,0,0,;,;,0,0"

		)
		"prop_ragdoll":(
			GLBPntData = "prop_ragdoll,angles,targetname,model,skin,disableshadows,mindxlevel,maxdxlevel,fademindist,fademaxdist,fadescale,StartDisabled,angleOverride"
			GLBPntValu = ",0 0 0,;,"+mdl+",0,0,0,0,-1,0,1,0,;"
		)

		
		default:(
			GLBPntData = "prop_static,angles,mindxlevel,maxdxlevel,model,skin,solid,disableshadows,screenspacefade,fademindist,fademaxdist,fadescale,lightingorigin,disablevertexlighting,disableselfshadowing,ignorenormals"
			GLBPntValu = ",0 0 0,0,0,"+mdl+",0,6,0,0,-1,0,1,;,0,0,0"
		)
	)
		
	setUserProp obj "GLBPntData" GLBPntData
	setUserProp obj "GLBPntValu" GLBPntValu
	
			) else (
				
	
				wallworm_remove_entity obj
	
				custAttributes.add obj test.ca
				
				
				if isProperty obj "model" AND mdl != "" AND mdl != ";" then (
					obj.model = mdl
				)
				

			)
	

	)
	
	function wallworm_set_props_type type sel:undefined reselect:false= (
	
					if sel == undefined then (
						sel = selection
						reselect = true
					) else (
						
						)
		
		
					if sel.count == 0 then (
					
					messagebox "This function only works when you have selected a set of WWMT helpers and/or proxies."
					
					) else (
						   oldsel = sel as array
						    local wwmts = 0
						    local failed = #()
						    clearSelection()
							local res = #()
							for obj in oldsel where isDeleted obj == false do (
								
								isWWMTSource = getUserProp obj "wwmt_source_helper"	
								 if isWWMTSource != undefined AND isWWMTSource==true then (
	
											local tempWWMT = ww_LOD_wrapper()
	
											tempWWMT.init()					
											tempWWMT.setTargetModel obj tempWWMT
											--messagebox ddl_propType.selected
											local message = tempWWMT.canBePropType type:type
											if message.count > 0 then (
												
												for m in message do (
													append res m
													)
												
												--append res message
												) else (
												(tempWWMT.setCoreCVXEntityValue type:type )
												
												)
											tempWWMT = undefined
	                                 ) else (
												local mdl = undefined
												local modelSource = getUserProp obj "wwmt_proxie_source"
												
												
												if modelSource != undefined then (
													message = #()
													local theModel = getNodeByName modelSource
													if theModel != undefined then (
														local tempWWMT = ww_LOD_wrapper()
	
														tempWWMT.init()					
														tempWWMT.setTargetModel theModel tempWWMT
														
														local message = tempWWMT.canBePropType type:type
														
														mdl = tempWWMT.modelPath+"/"+tempWWMT.modelName+".mdl"
														tempWWMT = undefined
													) else (
														
														
													)
													if message.count > 0 then (
														for m in message do (
															append res ("[ "+obj.name+" ] - "+m)
														)
														--append res ("[ "+obj.name+" ] - "+message)
													) else (
														wallworm_setPropDefaults obj type:type mdl:mdl

												
													)
													
												)
												
												
												)
									 
	                           )
							   
							   if res.count > 0 then (
								   message = "The action was completed but there were some problems:\n\n"
								   for m in res do (
									   append message ("*"+m+"\n")
									   
									   )
								   messagebox message
								   )
								   if reselect == true then (
										select oldsel
								   ) else ()
	                  )
		
		
		)
	
		
		
		function wallworm_create_path_entity ent type:"path_track" targetname:";" targ:";"= (
			
			global wallworm_get_entity_by_name
			if wallworm_get_entity_by_name == undefined then (
				filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
			)

			test = wallworm_get_entity_by_name  type
			
			if test == undefined OR test.ca == undefined then (
			
				if targ == "" then (
					targ = ";"
					)
				if targetname == "" then (
					targetname = ";"
					)

				case type of (
					
					"path_corner":(
						GLBPntData = "path_corner,targetname,angles,target,wait,speed,yaw_speed"
						GLBPntValu = ","+targetname+",0 0 0,"+targ+",0,0,0"
						ent.wireColor = (color 247 181 82)
					)
					"move_rope":(
						GLBPntData = "move_rope,targetname,parentname,NextKey,MoveSpeed,mindxlevel,maxdxlevel,Slack,Type,Subdiv,Barbed,Width,TextureScale,Collide,Dangling,Breakable,RopeMaterial,NoWind,PositionInterpolator"
						GLBPntValu = ","+targetname+",;,"+targ+",64,0,0,25,0,2,0,2,1,0,0,0,cable/cable.vmt,0,2"
					)
					"keyframe_rope":(
						GLBPntData = "keyframe_rope,targetname,parentname,NextKey,MoveSpeed,mindxlevel,maxdxlevel,Slack,Type,Subdiv,Barbed,Width,TextureScale,Collide,Dangling,Breakable,RopeMaterial,NoWind"
						GLBPntValu = ","+targetname+",;,"+targ+",64,0,0,25,0,2,0,2,1,0,0,0,cable/cable.vmt,0"
					)
					
					"path_corner_crash":(
						GLBPntData = "path_corner_crash,targetname,target"
						GLBPntValu = ","+targetname+","+targ
						ent.wireColor = (color 255 0 0)
					)	
					"path_track":(
						GLBPntData = "path_track,targetname,parentname,angles,target,altpath,speed,radius,orientationtype"
						GLBPntValu = ","+targetname+",;,0 0 0,"+targ+",;,0,0,1"
						ent.wireColor = (color 255 192 0)
					)				
				)
				GLBFlags = "0"
				
				setUserProp ent "GLBPntData" GLBPntData
				setUserProp ent "GLBPntValu" GLBPntValu
				setUserProp ent "GLBFlags" GLBFlags
			) else (
				
				custAttributes.add ent test.ca
				
				
				if isProperty ent "targetname" AND targetname != "" AND targetname != ";" then (
					ent.targetname = targetname
				)
				
				if isProperty ent "wwmt_target" AND targ != "" AND targ != ";" then (
					ent.wwmt_target = (targ as string)
				)
				
				if isProperty ent "NextKey" AND targ != "" AND targ != ";" then (
					ent.NextKey = (targ as string)
				)

			)
			
		)
		
		
		function wallworm_spline_to_path spline type:"path_track" placement:1 useLookat:false= (
			/*
			if wallworm_get_entity_by_name == undefined then (
				filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
				global wallworm_get_entity_by_name
			)*/
			
			local pathEnts = #()
			--spline = copy spline
		--	if superClassOf s == Shape  then (
			
			
			local isSpline = (classof spline == line or classof spline ==splineshape)
			
			if isSpline then (
				sps = numsplines spline
			) else (
				sps = 1
				
			)	
					
				if placement == 1 AND isSpline then (	
					
				 for s = 1 to sps do

				 (

					 
					local closedSpline = false
					
					if ((isSpline  AND  isClosed spline s) OR (NOT isSpline AND ((pathInterp spline s 0.0)  == (pathInterp spline s 1.0)))) then (
						closedSpline = true
					)

					local looped = closedSpline
					 
					 
					if isSpline then (
						nk = numKnots spline s
					) else (
						nk = numKnots spline
						
					)
					 
				  for k = 1 to nk do

				  (

				   knt = getKnotPoint spline s k
					local ent = Box name:(uniqueName type) pos:knt length:16 width:16 height:16
					append pathEnts #(ent,looped)


				  )--end k loop

				 )--end s loop

			 ) else (
				 
				 
		
			local out
			case method of (
				
				default:(
					out =  Line pos:spline.pos
					out.steps = 0
					
				)
			)
			

			
			

			for s = 1 to sps do (
				
				if isSpline then (
					nk = numKnots spline s
				) else (
					nk = numKnots spline
					
				)
				

					local closedSpline = false
					
					if ((isSpline  AND  isClosed spline s) OR (NOT isSpline AND ((pathInterp spline s 0.0)  == (pathInterp spline s 1.0)))) then (
						closedSpline = true
					)

					local looped = closedSpline
					 


				--Point pos:(pathInterp spline s 0.0)
				
				
				local ent = Box name:(uniqueName type) pos:(pathInterp spline s 0.0) length:16 width:16 height:16
				append pathEnts #(ent,looped)
				
				
						
				if NOT isProperty spline "steps" then (
					
					case (classof spline) of (
						
						Helix:steps = 41
						Helix_Pro:steps = spline.sides
						default:steps = 0
					)
					

				) else (
					
					if (NOT isSpline AND (pathInterp spline s 0.0) == (pathInterp spline s 1.0)) OR ( isSpline AND isClosed spline s) then (	
						local steps =( spline.steps + 1) * nk
					)  else (
						local steps = ((spline.steps + 1 ) * (nk - 1)) 
					)
				)

				local percent = 1.0/steps

				local newPercent = percent
				for i = 1 to (steps as integer)  do (
					
					if newPercent > 1.0 then (
						newPercent = 1.0
					)
					--append ptsArray (newPercent)

					--Point pos:(pathInterp spline s newPercent)
					if closedSpline == false OR  i < steps then ( 
						local ent = Box name:(uniqueName type) pos:(pathInterp spline s newPercent) length:16 width:16 height:16
						append pathEnts #(ent,looped)
					)
					
					newPercent += percent
				)
			
			)
				 
				 
				 
				 
			)
				
			--)
				 
				 
				if pathEnts.count > 0 then (
					
					local i = 1
					for ent in pathEnts do (
						local nextTarget = ""
						if (i<pathEnts.count) then (
							
							nextTarget = pathEnts[i+1][1].name

							if useLookat AND isValidNode pathEnts[i+1][1] AND pathEnts[i+1][1] != ent[1] AND (refs.dependencyLoopTest pathEnts[i+1][1] ent[1] == false ) then (
								local lookatN = LookAt_Constraint()
								lookatN.appendTarget (pathEnts[i+1][1]) 100.0
								
								ent[1].rotation.controller = lookatN
							)
						) else (
							
							if pathEnts[i][2] == true then (
								
								nextTarget = pathEnts[1][1].name
								/*local lookatN = LookAt_Constraint()
								lookatN.appendTarget (pathEnts[1][1]) 100.0
								ent[1].rotation.controller = lookatN*/
							)
							
							)
						
						if type != "rope" then (	
							wallworm_create_path_entity ent[1] type:type targetname:ent[1].name targ:nextTarget
						) else (
							
							if i==1 then (
								wallworm_create_path_entity ent[1] type:"move_rope" targetname:ent[1].name targ:nextTarget
								) else (
									wallworm_create_path_entity ent[1] type:"keyframe_rope" targetname:ent[1].name targ:nextTarget
								)
							
							
							
						)

					
					
					 i = i+1
					)
			
			

			)
			pathEnts
		)
		

	

		
		function wallworm_autoconfig = (
			
			
			global wwmt_sdk_folder
			
			wwmt_sdk_folder = (dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk")
		
			wwmt_valvemod_arraystr = (dotnetclass "System.Environment").GetEnvironmentVariable("VProject")
		
	
		
		
		if wwmt_valvemod_arraystr != undefined AND wwmt_valvemod_arraystr != "" then (
			
			wwmt_gameInfoDir = wwmt_valvemod_arraystr
			setINISetting wallworm_userIni "Directories" "gameInfoDir" wwmt_gameInfoDir

			
			
			wwmt_valvemod_array = filterString wwmt_valvemod_arraystr "\\"
			if wwmt_valvemod_array.count > 0 then (
				append wwmt_sdk_folder ("_content\\"+wwmt_valvemod_array[wwmt_valvemod_array.count ])
				)
			
			)
		
			setINISetting wallworm_userIni "Directories" "wwmt_sdk_folder" wwmt_sdk_folder
			
			global wwmt_export
			
			wwmt_export =  (wwmt_sdk_folder+"\\modelsrc")
			setINISetting wallworm_userIni "Directories" "export" wwmt_export

			
			global wwmt_exportMats
			wwmt_exportMats =  (wwmt_sdk_folder+"\\materialsrc")
			setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats

		
			global wwmt_binDir
			wwmt_binDir = ((dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk") + "\\bin\\orangebox\\bin")
			setINISetting wallworm_userIni "Directories" "binDir" wwmt_binDir

			
			global  wwdt_mapsrc
			wwdt_mapsrc =  (wwmt_sdk_folder+"\\mapsrc")
			setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc

			
			
			
			)
			
			
	function wallworm_getNodeSystem obj t:0 loc:false rot:false = (
		
			local refSystem = matrix3 1
			
			if obj != undefined and loc == true  then (
				

					refSystem = at time t ((matrix3 [1,0,0] [0,1,0] [0,0,1] refNode.transform.position))  
		
			)
			
			
			if rot == true then (
				
				refSystem = rotateZMatrix 90 *  refSystem
				
			)
		
			refSystem
		)
	

	function wallworm_is_a_bone obj = (
		if obj != undefined AND  (classOf obj == BoneGeometry OR classOf obj == Bone OR classOf obj == CATParent OR classOf obj == CATBone OR classOf obj == HubObject OR classOf obj == Biped_Object)  then ( 
			return true
			)
		
			false
		)
		
fn wallworm_hasNonPlanarPolygon node = 
(
	local hasNonPlanarPolygon = false
	if superClassOf node == GeometryClass then (
		
		
		
		for e in node.mesh.faces as bitarray while hasNonPlanarPolygon == false do (
			ff = (meshop.getPolysUsingFace  node.mesh e ignoreVisEdges:true) as array
			if ff.count >= 2 and (getfacenormal node.mesh ff[1] != getfacenormal node.mesh ff[2])  then (
				hasNonPlanarPolygon = true
			) 
		)

	)
	return hasNonPlanarPolygon
	
)


function wallworm_isConvex obj = (
	
	
	if nvpx != undefined AND isProperty nvpx "IsConvex" then (
					
		return nvpx.isConvex obj
					
	) else (
					
		if reactor != undefined AND isProperty reactor "GetIsConvex" then (
						
			return reactor.GetIsConvex obj 0
						
		)

	) 
	
	undefined
)

function wallworm_remove_ca_by_name obj name= (

	local c = custAttributes.count obj -- [BaseObject:<bool>]
	local out = false

	if c > 0 then (
		for i = c to 1 by -1 do (
			ca = custAttributes.get obj i
			
			if ca.name == name then (
				custAttributes.delete obj i
				out = true
			)
			
		)
	)
	out
)


function wallworm_get_ca_index_by_name obj name= (

	local c = custAttributes.count obj -- [BaseObject:<bool>]
	local out = undefined

	if c > 0 then (
		for i = c to 1 by -1 while out == undefined do (
			ca = custAttributes.get obj i
			
			if ca.name == name then (

				out = i
			)
			
		)
	)
	out
)





/*
This function will copy a custom attribute from one object to another based on the indexed custom attribute (caIndex) in fromObj
*/
function wallworm_copy_ca caIndex fromObj toObj = (
				
				local ca = custAttributes.get fromObj caIndex
				local objdef = custAttributes.getDef fromObj caIndex
				if objdef != undefined then (
				custAttributes.add toObj  objdef
				local defs = custAttributes.getPBlockDefs objdef
				for pbi = 1 to defs.count do (
					local paramb = defs[pbi]
					for pbin2 = 5 to paramb.count do (
						local param = (paramb[pbin2][1] as string)
						oldVal = getProperty fromObj param
						setProperty toObj param oldVal
					)
				)
			)
)


	function wallworm_readBlock &memstr p1:"[" p2:"]" = (
		local startPos = memstr.pos()

		outputstring = memstr.readblock p1 p2
		if outputstring == undefined then (
			outputstring = ""
			local endPos = memstr.pos()
		
			memstr.seek startPos #seek_set
			local limit = memstr.size()
			if endPos > limit then (
				endPos = limit
			)
			while memstr.pos() < endPos do (
				append outputstring (memstr.readLine()+"\r\n")
			)	

		) else (
			outputstring = replace_LF_with_CRLF outputstring
		)
		outputstring		
	)

	
	fn wallworm_readBlock2 &ms p1:"[" p2:"]" =
 (
	 wallworm_readBlock &ms p1:p1 p2:p1
)


function wallworm_update_proxies proxyselection = (
	newProxies = #()
	max create mode
	with redraw off
	if proxyselection != undefined AND (proxyselection as array).count > 0 then (
	
		local wwmts = #()
		
		wwmtselection = for ww in proxyselection where isProperty ww "wwmt_ca" OR getUserProp ww "wwmt_source_helper" != undefined collect ww
		
		for ww in wwmtselection do (
			local tempWWMT = ww_LOD_wrapper()
			tempWWMT.init()					
			tempWWMT.setTargetModel ww tempWWMT
			newAr = tempWWMT.update_proxies_in_scene()
			if newAr.count > 0 then (
				join newProxies newAr
			)
		)
	
		/*Reduce selection to WWNT proxies*/
		proxyselection = for prox in proxyselection where getUserProp prox "wwmt_proxie_source" != undefined collect prox
		
		/*get array of WWMT names in list*/
		
		wwmtselectionnames = for ww in wwmtselection collect ww.name
		
		local wwmtnames = for prox in proxyselection  collect (getUserProp prox "wwmt_proxie_source") 
		wwmtnames = makeUniqueArray wwmtnames
		
		for i = wwmtnames.count to 1 by -1 do (
			if findItem wwmtselectionnames wwmtnames[i] != 0 then (
				deleteItem wwmtnames i
			)
		)

		
		for i = wwmtnames.count to 1 by -1 do (
			local tname = wwmtnames[i]
			wwmttarget = getNodeByName tname
			if wwmttarget != undefined AND NOT isDeleted wwmttarget AND getUserProp wwmttarget "wwmt_source_helper" != undefined then (
				local tempWWMT = ww_LOD_wrapper()
				tempWWMT.init()					
				tempWWMT.setTargetModel wwmttarget tempWWMT
				newAr = tempWWMT.update_proxies_in_scene()
				if newAr.count > 0 then (
					join newProxies newAr
				)
			) 
			
		)
	)
	
	newProxies
)

		
/*Update the custom attribute definitions for a displacement object.*/
function wallworm_update_wwmt_cas obj  newDef:newDef= (
	if newDef == undefined then (
		global wallworm_model_tools_CA
		newDef = (custAttributes.getDefSource wallworm_model_tools_CA)
	)
	--disableRefMsgs()
	with undo off
	with redraw off (
		local c = custAttributes.count obj -- [BaseObject:<bool>]
		local out = false

		if c > 0 then (
			for i = c to 1 by -1 do (
				def = custAttributes.getDef obj  i 
				
				if  matchpattern def.name  pattern:"*Wallworm Model Tools"  then (
							
							custAttributes.redefine def newDef
						

				)
				
			)
		)
	)
	--enableRefMsgs()
	out
)

function wallworm_update_all_wwmt_cas = (
	global wallworm_model_tools_CA
	local newDef = custAttributes.getDefSource wallworm_model_tools_CA
	for obj in objects where isProperty obj "wallworm" AND isProperty obj "wwmt_ca" do (
		wallworm_update_wwmt_cas obj newDef:newDef
	)
)


global wallworm_single_entities = #("sky_camera","light_environment","env_fog_controller","shadow_control")


function wallworm_should_test_existing_entity_exists entName = (findItem wallworm_single_entities entName != 0)

function wallworm_testExistingEntity  entName= (
		local existing = undefined
		local uniqueproblem = false
		if (wallworm_should_test_existing_entity_exists entName ) then (
			existing = (for obj in objects where isProperty obj "wallworm" AND isProperty obj "entityType" AND isProperty obj "entname" AND obj.entname == entslist.selected  collect obj)
			if existing.count > 0 then (
				
				uniqueproblem = true
			)
		)
		uniqueproblem
)



function wallworm_addEntProps theSelection entName= (
	
	max create mode
	
	theSelection = for obj in theSelection WHERE isProperty obj "ww_displacement_brush" == false AND  isProperty obj "ww_displacement" == false AND isProperty obj "wallworm_edit_mesh" == false collect obj
	
	
	if theSelection.count > 0 then (
		
	
		
	
		if (wallworm_should_test_existing_entity_exists entName) == true AND (theSelection.count > 1 OR wallworm_testExistingEntity() == true) then (
			
			messagebox "This entity should only be added once to the scene. You cannot apply it to multiple objects."
			
		) else (
			

	
			test = wallworm_game_settings.get_entity_by_name entName  
		
			
		
			if test != undefined AND test.ca != undefined then (
				
				toprocess = wallworm_update_entities theSelection test
				
				
				if toprocess.count > 0 then (
					--wallworm_remove_entities toprocess
					custAttributes.add toprocess test.ca
				)
				
				for obj in (theSelection as array) do (
					
					
					if isProperty obj "model" then (
					
						local wwmtname = getUserProp obj "wwmt_proxie_source"
						if wwmtname != undefined then (
							wwmtnode = getNodeByName wwmtname
							
							
							
							if isProperty wwmtnode "modelName" then (
								obj.model = (wallworm_remove_last_slash (wwmtnode.modelPath)) + "/"+ wwmtnode.modelName+".mdl"
							)
							
							
						)
					)
					
					
					if superclassof obj == light then (
						if isProperty obj "brightness" then (
							
							--$
						)
					)
				
					legacyDats = getUserProp obj "GLBPntData"
					legacyValus = getUserProp obj "GLBPntValu"
					legacyFlags = getUserProp obj "GLBFlags"
					
					if legacyDats != undefined AND legacyDats != "" AND legacyValus != undefined AND legacyValus != "" then (
						
						props = filterString legacyDats "," splitEmptyTokens:true
						vals = filterString legacyValus "," splitEmptyTokens:true
						
						if props.count == vals.count then (
							
							for i = 2 to props.count do (
							
								if vals[i] != undefined AND vals[i] != "" AND vals[i] != ";" then (
									
										if isProperty obj props[i] == true then (
											try (
												setProperty obj props[i] (vals[i] as (classof (getProperty obj props[i] )))
											) catch ()
										)
								)
								
							)
							
							
						)
						
						
						
					)
						

						
					if legacyFlags != undefined AND legacyFlags != "" AND isProperty obj "spawnflags" == true AND ((legacyFlags as integer) != undefined) then (

							setProperty obj "spawnflags" (legacyFlags as integer)

					)
						
					
					
					
					
					
					
						
						if legacyDats != undefined then (
							setUserProp obj "GLBPntData" ""
						)

						if legacyValus != undefined then (
							setUserProp obj "GLBPntValu" ""
						)
						if legacyFlags != undefined then (
							setUserProp obj "GLBFlags" ""
						)

						if isProperty obj "entcolor" AND obj.entcolor != undefined AND classOf obj.entcolor == color then (
							obj.wireColor = obj.entcolor
						) else (
							
						) 
						
						if  isProperty obj "iconsprite"  AND obj.iconsprite != undefined then (
							lookFor = substituteString obj.iconsprite ".vmt" ""
							themat = wallworm_VMFIMPORT_getMaterial lookFor  color:obj.wireColor openLib:true
							obj.mat = themat
							if isProperty obj "mapcoords" == true then (
								obj.mapcoords = on
							)
						)
						
						if superclassof obj == light then (
							if classof obj == Directionallight then (

								obj.overshoot = true
							)
							
							if isProperty obj "color" AND isProperty obj "_light"  then (
								
								obj._light = obj.color
							)
							
						)
						
					
					)
				
				
				) else (
					
					messagebox "Oops... this entity was not found in the Entity Cache. You may need to reparse the FGD in the WW Settings."
					
					
					
				)
			)
		
			if selection.count == 1 then (
				max modify mode	
			)

		
		
		) else (
			
			messagebox "Oops... you need to select some objects to us this function."
			
		)
	
)



	fileIn "$scripts/WallWorm.com/common/matfuncs1.ms"
			