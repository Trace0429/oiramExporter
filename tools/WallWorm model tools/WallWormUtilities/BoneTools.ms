/*
Wall Worm Bone Tools
Copyright (c) 2012-2013 by Shawn Olson



*/

fileIn "$scripts/WallWorm.com/common/config.ms"
fileIn "$scripts/WallWorm.com/common/bone_funcs.ms"

try(destroyDialog wwmt_bone_options)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/bone_options.ms"

createDialog wwmt_bone_options