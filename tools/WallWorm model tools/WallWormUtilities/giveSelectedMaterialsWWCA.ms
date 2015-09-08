include "$scripts/WallWorm.com/common/matfuncs1.ms"
include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"



cmnt = ""
if selection.count > 0 then (
	theSel = selection as array
	cmnt = "the selected"
) else (
	theSel = objects as array
	cmnt = "all"
)
	
wallworm_assign_wwmats_to_objs theSel

message =  ("The materials for "+cmnt+" objects were given Wall Worm Material Attributes or had the Material Attribute updated." )
messagebox message