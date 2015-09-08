filein "$scripts\\WallWorm.com\\WallWormModelTools\\ww_structs.ms"
filein "$scripts\\WallWorm.com\\common\\matfuncs1.ms"
filein "$scripts/WallWorm.com/common/version_funcs.ms"
filein "$scripts/WallWorm.com/common/matgenfuncs.ms"
(

mats = for obj in objects where obj.mat != undefined AND ((classof obj.mat == DirectX_9_Shader)  OR (isProperty obj "wallworm"==true AND (isProperty obj "ww_displacement_brush"==true OR isProperty obj "ww_displacement"==true OR isProperty obj "wallworm_edit_mesh"==true))) collect obj.mat
	
mats = makeuniquearray mats
for m in mats do wallworm_update_material_from_vmt m	
	
)