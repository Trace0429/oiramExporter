fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\ww_structs.ms"

allObject = objects as array

allObject2 = wallworm_get_all_objects()
if allObject2.count > 0 then (
	join allObject allObject2
)


for wwmt in allObject where isProperty wwmt "wwmt_ca"  do (
	
			local tempWWMT = ww_LOD_wrapper()
			tempWWMT.init()					
			tempWWMT.setTargetModel wwmt tempWWMT
			tempWWMT.showOnlyModel()

)

wwlodcollection = for obj in allObject WHERE isProperty obj "wwmt_lod" AND isProperty obj "helperGizmo" AND isValidNode obj.helperGizmo collect obj.helperGizmo
if wwlodcollection.count > 0 then (
	hide wwlodcollection	
)

forceCompleteRedraw()