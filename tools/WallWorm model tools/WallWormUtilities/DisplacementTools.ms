/*
Wall Worm Displacement Tools
Copyright (c) 2012 by Shawn Olson



*/

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
include 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil_funcs.ms"
try(destroyDialog anvil_displacements_settings)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/displacement_settings.ms"

createDialog anvil_displacements_settings
	
