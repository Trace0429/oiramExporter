

function wwmt_normalize_edge_vertices objs = (
	if objs.count != undefined AND objs.count > 1 do (
		local pointArrays = #()
		for ind = 1 to objs.count do (
			
			
			pointArrays[ind] = #()
			
			
			for v = 1 to objs[ind].getNumVertices() do (
		
		
				pointArrays[ind][v] = objs[ind].GetVertex v
		
		
			)
			
			
			
			
		)
		
		
		
		--select objs


			
			local enm = Edit_Normals selectBy:1
			addModifier objs enm


			
			
		
		for ind = 1 to pointArrays.count do (
			
			
			for vi = 1 to pointArrays[ind].count do (
				normals = #{}
				
				objs[ind].EditablePoly.SetSelection #Vertex #{vi}
				enm.ConvertVertexSelection  (objs[ind].EditablePoly.GetSelection #Vertex) normals node:objs[ind]
				try (
				ind2 = (ind+1)
				for ind2 = ind2 to pointArray.count do (

					for i=1 to pointArray[ind2].count do (
						local vertices = #{}
						if pointArray[ind2][i] == pointArrays[ind][vi] do (
							
									append vertices i
									objs[ind2].EditablePoly.SetSelection #Vertex #{i}
							--add object to current selection for normal

							
						)
						
						deleteItem pointArrays[ind2] i
						)

						print (ind2 as string)
						enm.ConvertVertexSelection  vertices normals node:objs[ind2]	
									
					)
					) catch (
					  print (ind2 as string)
					
					)

					enm.EditNormalsMod.Select normals
					enm.EditNormalsMod.Average ()
					enm.EditNormalsMod.SetSelection #{}
					
					)
				
					collapsestack objs[ind]
				)
			
			


			)
		
		
	
)



function wwmtnormal objs = (
	
	
			local enm = Edit_Normals selectBy:1
			addModifier objs enm
			normals = #{}
			for obj in objs do (
				
				vsel = #{}
				for i = 1 to obj.getNumVertices() do (
					
					append vsel i
					)
				enm.ConvertVertexSelection vsel normals node:obj

				
				
				)
		enm.EditNormalsMod.SetSelection normals
		enm.EditNormalsMod.AverageGlobal ()		
	
	
	
	
	)