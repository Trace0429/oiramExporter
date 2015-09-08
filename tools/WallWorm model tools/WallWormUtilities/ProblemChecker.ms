/*

Wall Worm Scene Checker


Functions to help check for problems and to fix some common problems.

*/
global wallwormProblemChecker

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
include "$scripts/WallWorm.com/common/version_funcs.ms"
include "$scripts/WallWorm.com/rollouts/problem_checker.ms"

try (
	destroyDialog wallwormProblemChecker
) catch ()

createDialog wallwormProblemChecker