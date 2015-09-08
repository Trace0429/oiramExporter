global wallworm_cordon_CA =  attributes "Wallworm_Cordon" (
	local wallworm = true
	local vmf_exclude = true
	local wallworm_cordon = true
	local thisNode
	
	function getNode = (
		refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
	)
	
	function getThisNode = (
		if thisNode == undefined then (
			thisNode = getNode()
		)
		thisNode
	)
	
	function activate = (
		getThisNode()
		if isValidNode thisNode then (

			activeCordon = true
			thisNode.wireColor = red
		)	
	)
	
	function deactivate = (
		getThisNode()
		if isValidNode thisNode then (
			activeCordon = false
			thisNode.wireColor = color 220 220 220
		)	
	)
	
	parameters params rollout:paramrollout (
		
		activeCordon type:#boolean default:true ui:chk_active
		
		on activeCordon set val do (
			if val then (
				activate()
			) else (
				deactivate()
			)
		)
	)
	
	rollout paramrollout "Cordon Parameters" (
		checkbox chk_active "Active Cordon" tooltip:"Check to make this cordon active." 
	)
	
	
)

global wallworm_mapsize_CA =  attributes "Wallworm_Mapsize" (
	
	local wallworm = true
	local vmf_exclude = true
	local wallworm_mapsize = true
	local thisNode
	
	function getNode = (
		refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
	)
	
	function getThisNode = (
		if thisNode == undefined then (
			thisNode = getNode()
		)
		thisNode
	)
	
	parameters params rollout:paramrollout (
		
		fgd type:#filename
		multipleCordons type:#boolean default:true ui:chkmultipleCordons
		escapeOutputs type:#boolean default:false ui:chkEscape
	)
	
	
	function updateLimits = (
		getThisNode()
		global wallworm_mapsize
		if wallworm_mapsize == undefined OR classof wallworm_mapsize != Point2 then (
			wallworm_mapsize =  [-16384,16384]
		)
		
		
		thisNode.transform = matrix3 1
		thisNode.parent = undefined
		thisNode.boxsize = [wallworm_mapsize[2],wallworm_mapsize[2],wallworm_mapsize[2]]
		setTransformLockFlags thisNode #all
		
		global wwmt_def_fgd
		
		if wwmt_def_fgd != undefined then (
			fgd = wwmt_def_fgd
		)
			
		
	)
	
	rollout paramrollout "Map Parameters" (
		
		label lblFile "FGD Used"
		label lblFile2 ""
		group "VMF Options" (
			checkBox chkmultipleCordons "Multiple Cordons" tooltip:"Output the VMF with the multiple cordon format."
			checkBox chkEscape "Escape Outputs" tooltip:"Export with the ESC command separator in the VMF."
		)
		button btnCordons "Cordon Manager"
		button btnReset "Reset Map Limits"
		button btnMapProperties "Open Map Properties"		

		
		on btnCordons pressed do (
			macros.run "wallworm.com" "WallWormCordonManagerMCR"
		)
		
		
		
		
		on paramrollout open do (
			getThisNode()
			updateLimits()
			
			if fgd != undefined AND fgd != "" then (
				lblFile2.text = (filenameFromPath  fgd)
				
			)
			
		)
		on btnReset pressed do (
			updateLimits()
		)
		on btnMapProperties pressed do (
			global wallworm_map_properties_show = true
			macros.run "wallworm.com" "WallWormEntityOutputsMCR"
		)
		
	)
	
	
	
) 
	
function wallworm_get_map_limits cvx:false = (
	local res = for obj in objects where isProperty obj "wallworm_mapsize" == true collect obj
	if res.count == 0  AND cvx == true then (
		res = for obj in objects where getUserProp obj "CVXBorder" == 1 collect obj
	)
	res
)

function wallworm_create_map_limits showLimits:false= (
	local mp = wallworm_get_map_limits()
	local mapsize
	if mp.count == 0 then (
		mapsize = dummy()
		mapsize.name = "Map Limits"
		custAttributes.add mapsize wallworm_mapsize_CA
		mapsize.isHidden = NOT showLimits
	) else (
		mapsize = mp[1]
	)
	mapsize.updateLimits()
	ww_SetObjLayer mapsize "VMF_Exclude" forceFunc:true
	mapsize
)
