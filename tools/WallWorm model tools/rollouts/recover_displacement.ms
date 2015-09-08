rollout anvil_displacements_repair "Displacement Repair" width:234 height:112
(
	button btn1 "Recover Displacement" pos:[6,53] width:218 height:54
	label lbl1 "Do you want to Recover your Control Mesh?" pos:[7,10] width:220 height:19
	HyperLink recoverlink "What does this mean?" pos:[7,30] width:215 height:15 address:"http://dev.wallworm.com/document/99/recovering_a_displacement_mesh.html"  color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
 
	
	on btn1 pressed do
	(
	with undo off (
	if wallworm_repair_displacement() == true then (
	messagebox "The displacement mesh was recovered."
	) else (
	 messagebox "The displacement mesh was not recovered."
	)
	)
	try (
		global anvil_displacements_repair
		destroyDialog  anvil_displacements_repair
	) catch()
	)
)
