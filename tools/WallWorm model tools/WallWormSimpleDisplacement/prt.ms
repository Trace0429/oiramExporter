global wallworm_portal_CA = attributes  "wallworm_portal_CA" version:2 (
	local wallworm = true
	local wallworm_portal = true
	local thisNode, paramrollout
	
	function getNode = (
		if thisNode == undefined then (
			thisNode = refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
		)
		thisNode
	)
	
	parameters params rollout:paramrollout (
			
		leafA type:#integer
		leafB type:#integer
		
	)
	
	
	function flashLeafA = (
			
			lA = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == leafA OR obj.leafB == leafA) collect obj
			if lA.count > 0  then (
				flashnodes lA
				forcecompleteredraw()
			)
		)
		
	function flashLeafB = (
			
			lB = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == leafB OR obj.leafB == leafB) collect obj
			if lB.count > 0  then (
				flashnodes lB
				forcecompleteredraw()
			)
		)
		
	function getLeafA = (
			
			lA = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == leafA OR obj.leafB == leafA) collect obj
			if lA.count > 0  then (
				select lA
			)
		)
		
	function getLeafB = (
			
			lB = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == leafB OR obj.leafB == leafB) collect obj
			if lB.count > 0  then (
				select lB
			)
		)
	
	rollout paramrollout "Portal Information" (
		
		
		
		
		button btnflashLeafA "Flash Leaf A"
		button btnflashLeafB "Flash Leaf B"
		
		button btngetLeafA "Select Leaf A"
		button btngetLeafB "Select Leaf B"
		
		on paramrollout open do (
			btngetLeafA.text = ("Select Leaf " + leafA as string)
			btngetLeafB.text = ("Select Leaf " + leafB as string)
			btnflashLeafA.text = ("Flash Leaf " + leafA as string)
			btnflashLeafB.text = ("Flash Leaf " + leafB as string)
			
		)
		
		on btnflashLeafA pressed do (
			
			flashLeafA()
		)
		
		on btnflashLeafB pressed do (
			
			flashLeafB()
		)
		
		on btngetLeafA pressed do (
			
			getLeafA()
		)
		
		on btngetLeafB pressed do (
			
			getLeafB()
		)
	)
	
	
)


struct wallworm_portal (
	leafA,
	leafB,
	vertCount=0,
	verts = #(),
	sp,
	function makePortals = (
		
		sp =  splineshape pos:verts[1]
		sp.name = ("Leaf_"+leafA as string+"_Leaf_"+leafB as string+" PRT")
		
		addNewSpline sp	
	
		for v in verts do (
			in coordsys world addKnot sp 1 #corner #line v
			
		)
		

			
		close sp 1
		
		
		updateShape sp
		
		sp.render_displayRenderMesh = true
		sp.render_viewport_thickness = 2
		sp.render_displayRenderSettings = false
		sp.render_useViewportSettings = true
		
		sp.wireColor = yellow
		
		
		custAttributes.add sp wallworm_portal_CA
		sp.leafA = leafA
		sp.leafB = leafB
		

		
		
		setUserProp sp "wwdt_brush_geometry_export" false
		sp 
	)
	
)

struct wallworm_leaf (
	id,
	portals=#(),
	visibility = #(),
	leafPoint
)


struct wallworm_prt (
	
	leaves = #(),
	portals = #(),
	version,
	portalCount = 0,
	leafCount = 0,
	function parse_visibility filename:undefined = (
		
		if filename == undefined then (
			
			filename = GetOpenFileName types: "Portal File (*.prt)|*.PRT|All files (*.*)|*.*|" historyCategory:"Wall Worm VMF" caption:"Load Portal File" 
		)
		
		if filename == undefined OR NOT doesFileExist filename then (
			return false
		)
		--filename = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Counter-Strike Global Offensive\\sdk_content\\maps\\ar_close_quarters.prt"
		local ms = memStreamMgr.openFile filename

		local lineNum = 1
		
		while  ms.eos() == false  do (

			

			
			
			theLine = (ms.readLine())
				
				
			case lineNum	of (
				
				1:(version = theLine)
				2:(leafCount = theLine as integer)
				3:(portalCount = theLine as integer)
				default: (
					
					local data = filterString theLine " "
					
					for di = 1 to data.count do (
						
						str = substituteString 	data[di] "(" ""
						str = substituteString 	str ")" ""
						str = trimLeft (trimRight str)
						if str != "" then (
							data[di] = str as float
						) else (
							data[di] = undefined
						)
					)
					data = for d in data where d != undefined collect d
					newPrt = wallworm_portal()
					newPrt.leafA = data[2] as integer
					newPrt.leafB = data[3] as integer
					newPrt.vertCount=data[1] as integer
					
					
					for vc = 4 to (3 + newPrt.vertCount * 3) by 3 do (
						
						vert = [data[vc],data[vc+1],data[vc+2]]
						append newPrt.verts vert
					)
					

					
					append portals newPrt
	
				)
				
			)
				
			
				lineNum += 1
		)
		 memStreamMgr.close ms
		
		true
	),
	function getAllPortalsInScene = (
		pnodes = for p in portals  collect p.sp
	),
	function setAllPortalsToPRTLayer = (
	
		local pnodes = getAllPortalsInScene()
		
		
		if pnodes.count > 0 then (
			local Lay = "PRT Import Layer"
			
			local Ly = (layermanager.getLayerFromName Lay)
			if Ly == undefined then (
				Ly = layermanager.newLayer()
				Ly.setName Lay
			)
			
			for p in pnodes do (
				Ly.addnode  p
			)
			
		)
		pnodes
	),
	function creatPortalSpines = (
		with redraw off (
			

			for p in portals do (
				p.makePortals()
			)
			
			local pnodes = setAllPortalsToPRTLayer()
			if pnodes.count > 0 then (
				setTransformLockFlags pnodes #all
			)
		)
	),
	
	
	function construct_leaves = (
		for i = 0 to (leafCount - 1 ) do (
			
			leaf = wallworm_leaf()
			leaf.id = i
			leaf.portals = for p in portals where p.leafA == i OR p.leafB == i collect p
			append leaves leaf
			
			
		)
		
	)
	
)