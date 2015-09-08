/*

Function to repair DX Shader RenderMaterial Names

This is needed in some versions of Max (maybe Max 2013 PU3) where the Render Material name is not getting saved and always resets
*/


	function wallworm_rename_directX dxm = (
		if dxm.renderMaterial != undefined AND (findString dxm.name "/") != undefined AND (findString dxm.renderMaterial.name "/") == undefined then (
			dxm.renderMaterial.name = dxm.name
		) else (

		)
	)
	
	for obj in objects WHERE (getUserProp obj "ww_wwdt_displacement_brush") != undefined AND obj.mat != undefined AND classOf obj.mat == DirectX_9_Shader do (
		wallworm_rename_directX obj.mat
	)