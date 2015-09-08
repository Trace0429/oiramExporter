/*function wallworm_align_dxf_origin sel:objects= (
	local theGroup = group sel name:"WallWormTempDWGGroup"  select:true
	theGroup.pos = [0,0,0]
	ungroup theGroup

)
*/

function wallworm_fix_dxf  sel:objects dim:128= (
	
	
	local uv = UVWMap name:"WallWorm Default UVW" maptype:4 length:dim width:dim height:dim utile:1 vtile:1 wtile:1 
	local mat = Standard name:"tools/toolsnodraw" diffuse:(color 201 236 7)
	
	local norm = Normalmodifier name:"WallWormTempNormal"
	norm.unify=on
	--norm.fliP=on
	
	
	
	sel.mat = mat
	addModifier sel uv
	addModifier sel norm
	setUserProp sel "wwdt_brush_geometry_export" true
	convertToPoly sel
	
	for obj in sel do (

		vs = polyop.getNumVerts obj
			
		obj.weldThreshold = 1
		polyop.weldVertsByThreshold obj #{1..vs}

	)


)

function wallworm_import_dxf dim:128 = (
	if objects.count == 0 OR (queryBox "There are objects already in the scene.\nAre you sure you want to import objects?" title:"Confirm Scene Import") == true then (

		theDWG = getOpenFileName  caption:"Get DXF File" types:"DXF File|*.dxf" historyCategory:"Wall Worm DXF Imports"


		if theDWG != undefined then (

			importFile theDWG #noPrompt 
			/*
			if align == true then (
				wallworm_align_dxf_origin()
			)*/
			wallworm_fix_dxf dim:dim
			
			
			messagebox "Scene imported!\n\nYou *may* need to Flip Normals on imported geometry if it doesn't export correctly."
			return true
		) else (
		
		
			messagebox "No File Imported"
			return false
		)
	) 
	return false
)