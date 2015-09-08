	function wwmt_getBoneInfo obj = (
		local wwmt_jointmassbias = getUserProp obj "wwmt_jointmassbias"
		local wwmt_surfaceprop_bone = getUserProp obj "wwmt_surfaceprop_bone"
		--local wwmt_animatedfriction = getUserProp obj "wwmt_animatedfriction"
		local wwmt_jointskip = getUserProp obj "wwmt_jointskip"
		#(wwmt_jointmassbias,wwmt_surfaceprop_bone,wwmt_jointskip)
	)
	

	
	function wwmt_setJointSkip obj vals:false = (
		setUserProp obj "wwmt_jointskip" (vals as string)
		vals
	)
	
	
	function wwmt_setBoneMassBias obj amount:1.0 = (
		setUserProp obj "wwmt_jointmassbias" (amount as string)
		amount
	)
	
	
	function wwmt_setBoneSurfaceprop obj prop:"" = (
		setUserProp obj "wwmt_surfaceprop_bone" (prop as string)
		prop
	)
	function wwmt_setHitboxGroup obj grp:0 = (
		setUserProp obj "wwmt_hitbox_group" (grp as string)
		grp
	)
	function wwmt_getBoneHitboxes bs:selection = (
		hitboxes = #()
		
		if bs.count > 0 then (
			for b in bs do (
				if b != undefined then (

					if b.children.count > 0 then (
						for hb in b.children WHERE (getUserProp hb "wwmt_hitbox" != undefined AND (getUserProp hb "wwmt_hitbox" == "true" OR getUserProp hb "wwmt_hitbox"==true)) do (
							
							append hitboxes hb
						)

						
					)
				
				)
			)
		)
		hitboxes
	)
	
	function wwmt_createBoneHitbox b= (
		
					if getUserProp b "wwmt_hitbox" != undefined then (
						--print "Hitbox not created for existing hitbox"
						return undefined
						
						)
	
							
							
					hitboxHelper = boxGizmo ()
					hitboxHelper.name = uniquename ("WWMT_hbox_"+b.name)
					--setUserProp b 	"wwmt_hbox" hitboxHelper.name
					setUserProp hitboxHelper "wwmt_hitbox" "true"
					setUserProp hitboxHelper "wallworm_exclude_vmf" "true"
					--hitboxHelper.renderable = off
					--hitboxHelper.xray = on
				/*
					if b.parent != undefined then (
						
						
						
						
					)
					*/
					hitboxHelper.parent = b
					hitboxHelper.transform = b.transform
						
					if classof b == BoneGeometry OR classOf b == CatBone OR classof b == HubObject then (
							--hitboxHelper.transform  =rotateXMatrix 180 * rotateYMatrix -90 * hitboxHelper.transform 
					)
					
					in coordsys b (
						
						
					hitboxHelper.height = b.max.z
					
					hitboxHelper.width = b.max.x	
						
					hitboxHelper.length = b.max.y		
						
					)
					
					
					
			
			hitBoxHelper
		)
		
		
		function wwmt_setHboxSets objs val:"default" = (
			
			
			if objs != undefined AND objs.count >0 then (
				

				setUserProp objs "wwmt_hboxset" val

				
				)
			
			
			
		)
		
		
		
		function wwmt_get_hitboxsets &hboxsets objs:selection = (

			if objs != undefined AND objs.count > 0 then (
				
					for hb in objs do (
						hbset = getUserProp hb "wwmt_hboxset"
						if hbset != undefined AND hbset != "" then (
							
							appendifunique hboxsets  hbset
							
							
							)
						
						
						)
				
				)
			
			
			)
			
			
	function wwmt_get_hitboxes objs:selection= (
		local hbs = #()
		--hboxsets = #("default")
			if objs.count > 0 then (
				
				local newhb = wwmt_getBoneHitboxes bs:objs
				if newhb != undefined AND newhb.count > 0 then (
					join hbs newhb	
				)
				/*
				if hbs.count > 0 then (
					wwmt_get_hitboxsets hboxsets objs:hbs
				)*/
			return hbs
		)
	)
		
	


/*Following  two functions by Denis Trofimov... discussion at 
	
http://forums.cgsociety.org/showthread.php?f=98&t=1114788
	
*/
function wallworm_convertCATSkeleton catRoot showlinks:on namePre:"WW_BoneShadow_" = 
(
	bones = #()
	catBones = join #() catRoot
	for node in catBones do
	(
		b = point name:(namePre + node.name) transform:node.transform wirecolor:node.wirecolor 
		if (k = finditem catBones node.parent) != 0 do b.parent = bones[k]
		append bones b
	)
	bones.showLinks = bones.showLinksOnly = showlinks
	bones
)



function wallworm_transferCATAnimation catRoot boneRoot range: = 
(
	if not iskindof range interval do range = animationrange
		
	catBones = join #() catRoot
	bones = join #() boneRoot
	with animate on for t = range.start to range.end do at time t 
	(
		for k=1 to catBones.count do bones[k].transform = catBones[k].transform
	)
)

			