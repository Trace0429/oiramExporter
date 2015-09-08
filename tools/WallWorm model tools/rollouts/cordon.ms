rollout wallworm_cordon "Cordon Tools" width:175 height:420
(
	

	button btnCreateCordon "Convert to Cordon" pos:[9,10] width:151 height:31 toolTip:"Convert the selected object to a VMF Cordon. You should not use this on brush geometry, models, or any other geometry that should be exported as any kind of geometry."
	listbox lbxCordons "Scene Cordons" pos:[13,48] width:146 height:11
	button btnUpdateCordonList "Update Cordon List" pos:[14,222] width:146 height:23
	button btnSetNoCordons "Disable All Cordons" pos:[15,309] width:144 height:22
	button btn4 "Hide and Disable Cordons" pos:[15,337] width:144 height:28 
 
 
	HyperLink cordonlink "Cordon Manager Help" pos:[13,392] width:146 height:15 address:"http://dev.wallworm.com/topic/58/cordon_manager.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	button btnEnableAll "Enable All" pos:[13,283] width:147 height:20
	
	

	
	function getCordonList = (
		global wallworm_cordons = #()
		
		
		wallworm_cordons = for obj in objects WHERE  getUserProp obj "wallworm_vmf_cordon"  == true collect obj
		
		for obj in objects WHERE isValidNode obj == true AND isProperty obj "wallworm_cordon" do (
			
			appendIfUnique wallworm_cordons obj
		)
		
		local toAdd = for obj in wallworm_cordons where isProperty obj "wallworm_cordon" == false collect obj
		
		if toAdd.count > 0 then (
			custAttributes.add toAdd wallworm_cordon_CA
		)
		
		
		return wallworm_cordons
	)	
	
	button btnunHideAll "Unhide All" pos:[14,255] width:145 height:22
	
	checkbox chkMulti "Export Multiple Cordons" pos:[16,368] width:143 height:17 enabled:true checked:true
	
	
	
	function setCordonSelection sel selectCordon:false = (
			if sel != undefined AND sel > 0 AND isValidNode wallworm_cordons[sel] then (
				getCordonList()
				global wallworm_cordons
				--hide wallworm_cordons
				unhide wallworm_cordons[sel]
				if selectCordon then (
					select wallworm_cordons[sel]
				) else (
					flashNodes  #(wallworm_cordons[sel]) 
					forceCompleteredraw()
				)
			) else ()
		
		)
	

	
	function setCordonList = (
		lbxCordons.items = #()
		global wallworm_cordons = getCordonList()
		
		local cordonlist = #()
		local index = 1
		for obj in wallworm_cordons do (
			
			append cordonlist obj.name
			--
			if (isProperty obj "wallworm_cordon" AND obj.wallworm_cordon == true)  OR (getUserProp obj  "wallworm_vmf_cordon_active" !=undefined AND getUserProp obj "wallworm_vmf_cordon_active" == true) then (
				lbxCordons.selection = index
			) else (
				index = index+1
			)
			

		)
		
			
			
		lbxCordons.items = cordonlist
		

			
			
	)
	
	
	
	on wallworm_cordon open do
	(
		global wallworm_cordon_CA
		if wallworm_cordon_CA == undefined then (
			
			fileIn "$scripts/WallWorm.com/custom_attributes/map_cas.ms"
		)
		
		local mapsize = wallworm_create_map_limits()
		chkMulti.checked = mapsize.multipleCordons
		
		setCordonList()
	
	)
	on btnCreateCordon pressed do
	(
	    global wallworm_cordons
	    if selection.count > 0 then (
			
			
			local toAdd = for obj in selection where isProperty obj "wallworm_cordon" == false collect (copy obj)
			

			
			if toAdd.count > 0 then (
				custAttributes.add toAdd wallworm_cordon_CA
			)
			
			toAdd.boxmode = on
			toAdd.alledges = on
			toAdd.renderable = off
			
			if toAdd.count > 0 then (
				
				for cordon in toAdd do (
					cordon.name = ("Cordon_"+cordon.name)
				)
			)
			
			
			setCordonList()
			setCordonSelection wallworm_cordons.count
	    ) else (
			messagebox "You must have at least one object selected to convert to a Cordon."
			)
	)
	on lbxCordons selected sel do
	(
		
		
		setCordonSelection sel
		
		
	)
	
	on lbxCordons doubleClicked sel do (
		setCordonSelection sel selectCordon:true
	)
	
	on btnSetNoCordons pressed do
	(
		getCordonList()
		global wallworm_cordons
		if wallworm_cordons.count > 0 then (
			
			wallworm_cordons.activeCordon = false
			
		)
	)
	on btn4 pressed do
	(
		getCordonList()
		global wallworm_cordons
			if wallworm_cordons.count > 0 then (
				wallworm_cordons.activeCordon = false
				hide wallworm_cordons
	
			)
	
	)
	on btnEnableAll pressed do
	(
			
			getCordonList()
			
			global wallworm_cordons
			if wallworm_cordons.count > 0 then (
				unhide wallworm_cordons
				wallworm_cordons.activeCordon = true
			)
		)
	on btnunHideAll pressed do
	(
				global wallworm_cordons
				getCordonList()
				if wallworm_cordons != undefined AND wallworm_cordons.count > 0 then (
					unhide wallworm_cordons
				)
		)
	on chkMulti changed stat do
	(
			
			local mapsize = wallworm_create_map_limits()
			mapsize.multipleCordons = chkMulti.checked	
		)
)
