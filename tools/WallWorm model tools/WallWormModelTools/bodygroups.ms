
filein "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"

global wallwormBodyGroups

try (destroyDialog wallwormBodyGroups) catch ()

fileIn "$scripts/WallWorm.com/rollouts/bodygroups.ms"

createDialog wallwormBodyGroups