Struct ww_wwmt_bodygroup (
	
	bgname, --NAME OF bodygroup (from bghelper node name)
	bghelper, --DUMMY OBJECT THAT STORES INFO
	bgmodels = #(), --WWMT HELPERS
	
	
	function setName n = (
		bgname = n
		
	),
	function appendModel c refNode:undefined= (
		 
		 local isSource = getUserProp c "wwmt_source_helper"
		 if isSource != undefined AND isDeleted c== false  do (
			local tempWWMT = ww_LOD_wrapper()
			tempWWMT.init()					
			tempWWMT.setTargetModel c tempWWMT

			append bgmodels tempWWMT
		)
		 
		 
	),
		 


	function setHelper h refNode:undefined= (
		if classOf h == Dummy do (
			

			
			bghelper = h
			bgname = bghelper.name
			for c in bghelper.children do (
				
				
				appendModel c refNode:refNode
				
				
			)
			
			global wallworm_bodygroup_CA
			if NOT isProperty h "bodygroup" then (
				
				custAttributes.add h wallworm_bodygroup_CA
				
				local theWWMTBodygroups = getUserProp h "wwmt_bodygroups"	
				
				if theWWMTBodygroups!= undefined   then (
					
		

						for word in (filterString (theWWMTBodygroups as string) ",") do ( 
							n = getNodeByName word
		
							if isValidNode n AND findItem bghelper.wwmts n == 0 do (
								
								append bghelper.wwmts n

								
							)

						)
					
						

					
					
				)
				
			)
			
			
			bgmodels = bghelper.wwmts as array
			
			

			
			
		)
		
		
	),
	
	function addItemToBodygroup wwmt refNode:undefined= (

		bghelper.addWWMT n			
		bgmodels = bghelper.wwmts as array
	),
	
	function removeItemFromBodygroup wwmt = (
		bghelper.removeWWMT wwmt
		bgmodels = bghelper.wwmts as array
	)
	

	
	)