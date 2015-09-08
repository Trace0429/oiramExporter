fn oiramResetNodeScale =
(
	if oiram.resetNodeScale do
	(
		geom = for obj in Geometry as array where (not obj.ishidden) and (classof(obj) != BoneGeometry) and (classof(obj) != Biped_Object) collect obj
		for i = 1 to geom.count do
		(
			ResetScale geom[i]
		)
	)
)
