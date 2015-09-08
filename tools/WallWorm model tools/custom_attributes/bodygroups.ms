global wallworm_bodygroup_CA = attributes  "wallworm_bodygroup_CA" version:2 (
	local wallworm = true
	local bodygroup = true
	local thisNode, paramrollout, updateItemsList
	
	function getNode = (
		if thisNode == undefined then (
			thisNode = refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
		)
		thisNode
	)
	
	parameters params rollout:paramrollout (
		
		wwmts type:#nodeTab tabSizeVariable:true
		
		on wwmts set val do (
			updateItemsList()
		)
	)
	
	function sanitize = (
		wwmts = for obj in wwmts WHERE isValidNode obj collect obj
	)
	function addWWMT obj = (
		if isValidNode obj AND findItem wwmts obj == 0 then (
			append wwmts obj
		)
	)
	
	function removeWWMT obj = (
		local index = findItem wwmts obj
		if index != 0 then (
			deleteItem wwmts index
			sanitize()
		)
	)
	
	function updateItemsList = (
		if isValidNode (getNode())  then (
			sanitize()
			paramrollout.cmboItems.items = for obj in wwmts collect obj.name
		)
		
	)

	function hilightItems = (
		if wwmts.count > 0 OR thisNode.children.count > 0 then (
			nodeList =#()
			join nodeList (wwmts as array)

			join nodeList (for obj in thisNode.children collect obj)
			flashNodes nodeList
			forceCompleteredraw()
		)
	)
	
	function filterFunction obj = (isProperty obj "wwmt_ca")
	
	rollout paramrollout "Bodygroup" (
		
		listbox cmboItems "WWMT Helpers"
		pickbutton addItem "Add WWMT" filter:filterFunction
		button removeSelected "Remove Selected"
		button btnHilight "Flash All"
		
		on btnHilight pressed do (
			hilightItems()
		)
		
		
		on paramrollout open do (
			sanitize()
		)
		
		on addItem picked obj do (
			if findItem wwmts obj == 0 then (
				addWWMT()
				updateItemsList()
			)
		)
		
		
		on removeSelected pressed do (
			
			if cmboItems.selection > 0 then (
				deleteItem wwmts cmboItems.selection
				updateItemsList()
			)
		)
		
	)
	
	
)