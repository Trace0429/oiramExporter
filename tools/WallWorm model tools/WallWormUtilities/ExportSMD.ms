/*
Wall Worm SMD Exporter
Copyright (c) 2012-2013 by Shawn Olson



*/

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"

try(destroyDialog wallwormSMDExport)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/smdexport.ms"

createDialog wallwormSMDExport