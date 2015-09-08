macroscript ShawnsUtilPolygonMap 
	category:"Wallworm.com"
	tooltip:"Apply a Polygon Map Modifer to each object in the selection"
	buttonText:"Apply PG Map"
(
	
	
	for obj in selection where validModifier obj PolygonMap do (
		addModifier obj (PolygonMap())
	)


	
)