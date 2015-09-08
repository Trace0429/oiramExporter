/*
This script will take all the DX11 compatible DirectX_9_Shader materials in the scene and give those nodes a DX9 compatible version.

You'll run this script if you are opening a scene in older versions of Max with materials created in 3ds Max 2014+

*/




/*
From Denis Trofimov
http://forums.cgsociety.org/showpost.php?p=6304905
*/
fn xchangeMats source target = if source != target and iskindof source material and iskindof target material do
(
	for n in refs.dependents source do case of
	(
		(isvalidnode n and n.mat == source): n.mat = target
		(iskindof n material): for i=1 to (getNumSubMtls n) where (getSubMtl n i) == source do setSubMtl n i target
	)
	target	
)



for mat in sceneMaterials WHERE classOf mat == DirectX_9_Shader AND (getFileNameFile mat.effectfile) == "blend_dxsas11_nitrous" do with redraw off (
				

				local bm1 = openBitMap mat.rendermaterial.map2.diffusemap.filename
				local bm2 =  openBitMap mat.rendermaterial.map1.diffusemap.filename
	
				local newMat = DirectX_9_Shader()
				newMat.effectFilename="$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas.fx"
				if bm1 != undefined AND classOf bm1 == Bitmap then (
					newMat.seteffectbitmap 1 bm1
				)
				if bm2 != undefined AND classOf bm2 == Bitmap then (
					newMat.seteffectbitmap 2 bm2	
				)
				newMat.renderMaterial = mat.renderMaterial
				

				xchangeMats mat newMat
)