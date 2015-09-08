rollout wallwormDXFImport "Wall Worm DXF Importer" width:327 height:78
(
	spinner spnUVW "UVW Size" pos:[32,9] width:165 height:16 range:[8,1024,128] type:#integer scale:1

	button btnImportDXF "Import DXF" pos:[206,8] width:109 height:43
	label lbl1 "This function can take several minutes!" pos:[10,34] width:195 height:18
	HyperLink overlink "Help, Tips and Tricks" pos:[11,57] width:101 height:15 address:"http://dev.wallworm.com/document/108/dxf_importer.html" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	
	on btnImportDXF pressed do
	(
		if (wallworm_import_dxf dim:spnUVW.value) == true then (
			
			try (
				DestroyDialog wallwormDXFImport
				) catch ()
			
			)
	
	)
)
