function getXrefs &collection &ref= (
	
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
		for index = 1 to xrefs.getXRefFileCount()  do(
			local xref = xrefs.getXRefFile index 
			if xref.disabled == false then (
				if findItem collection (xref) == 0 then (
					
					append collection xref
				)
				getXrefs collection xref
			)
			
		)

	
	)
	
	
)

function updateAllActiveXrefs = (
	for index = 1 to xrefs.getXRefFileCount()  do(
		local xref = xrefs.getXRefFile index 
		if xref.disabled == false then (
			
			updateXRef  xref
		)
	)
	xrefs.updateChangedXRefs()
)


function collectXrefObjects collection &items type:"Brush" = (

	for xref in collection do (
		for obj in xref.tree.children do (
			if findItem items obj == false do (
				
				--!TODO add type check
				
				append items obj
				
				
				
			)
			
		)
		
		
	)
	
)