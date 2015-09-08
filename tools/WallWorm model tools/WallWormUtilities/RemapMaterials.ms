/*
Wall Worm Bone Tools
Copyright (c) 2012-2013 by Shawn Olson



*/
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"

try(destroyDialog wallwormRemapMaterials)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/remap_materials.ms"

createDialog wallwormRemapMaterials