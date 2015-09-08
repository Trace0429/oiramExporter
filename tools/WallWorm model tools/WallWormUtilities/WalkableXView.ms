(

global WWDTFaceWalkableChecker 

struct WWDTFaceWalkableCheckerStruct 

(

WWDTFaceWalkableThresholdMax = 30, 

WWDTFaceWalkableDialog = undefined, 


fn geomCheck theTime theNode theResults = 

(

for f = 1 to theNode.numfaces do

(

	if classOf theNode == Editable_Poly OR theNode.modifiers[#Edit_Poly] != undefined  OR theNode.modifiers[#Poly_Select] != undefined then (
	in coordsys world gfn=polyOp.getFaceNormal theNode f
	) else (
	
	
		in coordsys world gfn=getFaceNormal theNode f
			
	)
	
	
	
		--if abs(gfn.z)<=cos(45) do (
	if gfn.z<=cos(45) do (
		append theResults f
		
		)

)
3
),

 

fn supportedCheck theNode =

(

 classof theNode == Editable_Poly OR classOf theNode == Editable_Mesh OR (theNode.modifiers != undefined AND (theNode.modifiers[#Edit_Poly] != undefined OR theNode.modifiers[#Edit_Mesh] != undefined OR theNode.modifiers[#Poly_Select] != undefined OR theNode.modifiers[#Mesh_Select] != undefined) )

)

 
)--end struct

 



WWDTFaceWalkableChecker = WWDTFaceWalkableCheckerStruct() 

 try (

XViewChecker.unRegisterChecker "WW Face Walkable" 

XViewChecker.registerChecker WWDTFaceWalkableChecker.geomCheck WWDTFaceWalkableChecker.supportedCheck #Faces "WW Face Walkable" undefined undefined undefined
 ) catch (
	  --messagebox "Your version of Max may not Support xView. This function works in Max 2010+."
	 )

)--end script
