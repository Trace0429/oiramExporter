fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
fileIn "$scripts/WallWorm.com/common/settings_struct.ms"
fileIn "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"


filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
filein 	"$scripts\\WallWorm.com\\common\\mse\\wallwormVMF.mse"
filein "$scripts\\WallWorm.com\\custom_attributes\\displacements.ms"		
filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil_funcs.ms"

fileIn "$scripts/WallWorm.com/WallWormUtilities/importModelsForProps.ms"

--include "$scripts/WallWorm.com/common/mse/VMFImport2.ms"
include "$scripts/WallWorm.com/common/mse/VMFImport2.mse"

global wallwormVMFImporter

try(destroyDialog wallwormVMFImporter)catch(
	   --there was not any open
)

fileIn "$scripts/WallWorm.com/rollouts/VMFImport.ms"

createDialog wallwormVMFImporter

/*
wallwormVMFImporter.theVMF.brushes[1].planes[1]

wallwormVMFImporter.theVMF.brushes[1].originalBrush

*/