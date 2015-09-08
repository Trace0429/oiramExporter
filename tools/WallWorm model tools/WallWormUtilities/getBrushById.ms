/*
Wall Worm Brush ID
Copyright (c) 2013 by Shawn Olson



*/
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
fileIn "$scripts/WallWorm.com/WallWormSimpleDisplacement/anvil_funcs.ms"
try(destroyDialog wallwormBrushID)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/brush_id.ms"

createDialog wallwormBrushID