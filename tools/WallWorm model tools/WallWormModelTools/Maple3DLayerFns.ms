--Functions written by Michael Little from Maple3D.com

-- Some functions i wrote that might be useful to you :)
fn ww_SetObjLayer obj Lay forceFunc:false= ( -- Lay is name of layer, if layer of that name does not exist then it is created.
	global wwmt_createLayers
if (wwmt_createLayers == "true" OR forceFunc == true) do (
	local Ly = (layermanager.getLayerFromName Lay)
	if Ly != undefined then (Ly.addnode obj) else
		(
		Ly = layermanager.newLayer();Ly.setName Lay; Ly.addnode obj
		)
	)
)

fn ww_CreateLayer Lay forceFunc:false= ( -- Creates a Layer of the name Lay if it does not already exist.
	global wwmt_createLayers
if (wwmt_createLayers == "true"  OR forceFunc == true) do (
	local Ly = (layermanager.getLayerFromName Lay)
	if Ly != undefined then (return Ly) else
		(
		Ly = layermanager.newLayer();Ly.setName Lay;
		)
	Ly
	)
)
