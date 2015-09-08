fn oiramMerge =
(
	if oiram.merge do
	(
		--undo on

		geom = for obj in Geometry as array where (not obj.ishidden) and (classof(obj) != BoneGeometry) and (classof(obj) != Biped_Object) collect obj
		if geom.count > 1 do
		(
			m = geom[1]
			ConvertToMesh m  
			for i = 2 to geom.count do
			(
				g = geom[i]
				meshop.attach m g attachMat:#MatToID
			)
		)

		geom[1].name = getFilenameFile maxFileName
	)
)
