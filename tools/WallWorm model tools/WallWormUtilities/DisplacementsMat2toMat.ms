dispsWithWrongMat = for disp in objects WHERE getUserProp disp "ww_wwdt_displacement_brush" != undefined AND disp.mat != undefined AND classOf disp.mat == multimaterial AND disp.mat.materiallist[1] != undefined AND disp.mat.materiallist[2] != undefined AND classOf disp.mat.materiallist[1] != DxMaterial  AND  (classOf disp.mat.materiallist[2] == DxMaterial OR disp.mat.materiallist[1].name=="tools/toolsnodraw") collect disp

for disp in dispsWithWrongMat do (
		disp.mat = disp.mat.materiallist[2]
	
)