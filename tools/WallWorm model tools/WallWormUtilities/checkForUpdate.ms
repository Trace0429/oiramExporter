/*
This script will check to see if the currently installed version of Wall Worm is up-to-date.

If the instlalled version is older, it will alert the user WW is out-of-date and launch a browser window to the WW changelog.

The query string of the 

*/

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
include "$scripts/WallWorm.com/common/version_funcs.ms"

case (wallworm_need_update()) of (
	false:(
		messagebox "Wall Worm is Up-To-Date"
	)
	true:(
		messagebox "There is a newer version of Wall Worm available."
		macros.run "wallworm.com" "WallWormWebChangelogMCR"
	)
	default: (
		messagebox "No version number was returned from the Wall Worm website. Try again later."	
	)
	
) 