filein "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
filein "$scripts/WallWorm.com/common/matgenfuncs.ms"
filein "$scripts/WallWorm.com/importers/Mario_Kart_SMD_Importer.ms"
global wallWormSMDImporter

try(destroyDialog wallWormSMDImporter)catch(
	   --there was not any open
)

fileIn "$scripts/WallWorm.com/rollouts/SMDImport.ms"

createDialog wallWormSMDImporter