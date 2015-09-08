/*
Wall Worm Proxy Tools
Copyright (c) 2012 by Shawn Olson



*/

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
try(destroyDialog wallworm_proxy_tools)catch(
	
	   --there was not any open
	)

fileIn "$scripts/WallWorm.com/rollouts/proxy_tools.ms"

createDialog wallworm_proxy_tools