/**/
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
filein "$scripts/WallWorm.com/common/matgenfuncs.ms"
fileIn "$scripts/WallWorm.com/importers/Mario_Kart_SMD_Importer.ms"
fileIn "$scripts/WallWorm.com/WallWormUtilities/getQCtoMDLMap.ms"

function wallworm_get_modeldata_by_modelname mdlname = (
	global wallworm_models_array
	for ind = 1 to wallworm_models_array.count do (
			if (toLower (wallworm_models_array[ind].orig)) == (toLower mdlname) then (
				--data = wallworm_models_array[ind]
				--deleteItem wallworm_models_array ind
				return ind
			)
		
	)
	undefined
)



/*

special cases are for models in paths that don't map 1:1 between modelsrc directory and models directory

bits:
1 = Old Format (SMDs were not generated with the WW Rotate function)
2 == Dear Esther

*/
function wallworm_import_mdls special:#{} ang:0 sel:objects fromArray:"ents"   mdls:false props:false= (

max create mode
clearlistener()
suspendEditing()
with undo off (
excludeLayer = LayerManager.getLayerFromName "VMF_Exclude"
if excludeLayer == undefined then (
	
	excludeLayer = LayerManager.newLayerFromName "VMF_Exclude"
)

excludeLayer.current = true


case fromArray of (
	"ents":(theProps = for obj in sel WHERE isDeleted obj == false AND isProperty obj "wallworm" == true AND isProperty obj "entityType" == true AND isProperty obj "model" == true AND obj.entityType == "PointClass" AND obj.model != undefined AND obj.model != "" AND getUserProp obj "wallworm_already_imported" ==undefined collect obj)
	"details":(theProps = for obj in sel WHERE isDeleted obj == false AND isProperty obj "wallworm" == true AND isProperty obj "ww_detail" == true obj.model != undefined AND obj.model != "" AND getUserProp obj "wallworm_already_imported" ==undefined collect obj)
	default:theProps = for obj in sel WHERE isDeleted obj == false AND isProperty obj "wallworm" == true AND isProperty obj "entityType" == true AND isProperty obj "model" == true AND obj.entityType == "PointClass" AND obj.model != undefined AND obj.model != "" AND getUserProp obj "wallworm_already_imported" ==undefined collect obj

)
if theProps.count > 0 then (

struct wallworm_model_import_wrapper (

		modelpath,
		modelname,
		orig,
		qc,
		wwmt
	
)


global wallworm_models_array = #() --store the data for the models

global alreadyProcessed = #() --store array of model names


for obj in theProps  do  with redraw off (

	if findItem alreadyProcessed (toLower obj.model) == 0 then (
		

	theStor = wallworm_findQCByModelName obj.model
	

		
		
	theModelPath = getFilenamePath (toLower obj.model)
	theFileName = getFilenameFile (toLower obj.model)
	
	theStruct = wallworm_model_import_wrapper()
	
		

	theStruct.orig = tolower obj.model
		
	theStruct.modelname = theFileName
	
		
	if theStor.count > 0 then (

		theStruct.qc = theStor[1].qc
		
		theStruct.modelpath = theStor[1].mdl


	) else (
		
	
	if substring theModelPath 1 6 == "models" then (
		
		theModelPath =  replace theModelPath 1 7 ""
	)
	
	
	theQCShouldBe = wwmt_export + "\\"+theModelPath+"\\"+theFileName+".qc"
	
	


		theStruct.qc = theQCShouldBe
		theStruct.modelpath = theModelPath
)
		append wallworm_models_array theStruct
	
	
/*
	\wood\\plank_002c.qc"
	
	
	misc\\ghost
	
	\\ghosts

	

	
	*/
	
	

	
	/*
	if (doesFileExist theQCShouldBe) == false then (
		print theQCShouldBe	
		--selectMore obj
	)
	*/
	
	--excludeLayer.addNode wwmt
	
	

		append alreadyProcessed obj.model
	)
	
	
	
)






/*Go through all the QC files and generate WWMT associations*/
for i=1 to alreadyProcessed.count do with redraw off (
	
	dataindex= (wallworm_get_modeldata_by_modelname alreadyProcessed[i])
	modelData = wallworm_models_array[dataindex]
	

	
	/*see if there is already a WWMT helper in scene*/
	
	--wwmts = for obj in objects WHERE getUserProp obj "wwmt_source_helper" != undefined AND getUserProp obj "wwmt_modelname" != undefined AND getUserProp obj "wwmt_modelPath" != undefined AND getUserProp obj "wwmt_modelname"== modelData.modelname AND getUserProp obj "wwmt_modelPath" == modelData.modelpath collect obj
	
	wwmts = for obj in objects WHERE (getUserProp obj "wallworm_import_mdl_name") != undefined AND  ( toLower (getUserProp obj "wallworm_import_mdl_name")) == (toLower alreadyProcessed[i]) collect obj
	
	if wwmts.count == 0 then (
		/*An existing WWMT was not found... import it from the QC*/
		--print modelData.qc
		resumeEditing()
		slidertime = 0
		wwmt = wallworm_parse_qc modelData.qc rotateModel:mdls rotationAmount:ang zeroRotations:true collapseMeshes:true uniqueNames:true scaleMesh:true xf:true
		/*if ang != 0 then (
		
		) else (
			wwmt = wallworm_parse_qc modelData.qc rotateModel:mdls rotationAmount:ang zeroRotations:true collapseMeshes:true uniqueNames:true scaleMesh:true xf:true
		)*/
		if wwmt == undefined then (
			print ("Missing WWMT: " +  alreadyProcessed[i])
		) else (
			setUserProp wwmt.target "wallworm_import_mdl_name" (toLower (alreadyProcessed[i]))
		)
		
		suspendEditing()
	) else (
		
		/*A WWMT was already found... assign the wwmt to the struct*/
		
		wwmt = ww_LOD_wrapper()
		wwmt.init()
		wwmt.setTargetModel wwmts[1] wwmt
		
		print "resuing a wwmt"
	)
	if wwmt != undefined then (
		wallworm_models_array[dataindex].wwmt = wwmt
	)

)
	


proxyLayer = LayerManager.getLayerFromName "Imported_Prop_Proxy"
if proxyLayer == undefined then (
	
	proxyLayer = LayerManager.newLayerFromName "Imported_Prop_Proxy"
)

proxyLayer.current = true




function rotateTheObj obj unRotatedSMDs:true fromCFDecompile:false ang:0= (

	if isProperty obj "angles" then (
			local anglesArray = filterString (trimLeft (trimRight (obj.angles))) " " splitEmptyTokens:false
		
				
			local angles = eulerAngles (anglesArray[2] as float ) (anglesArray[1] as float) (anglesArray[3] as float) 

			--theANgles = eulerAngles (anglesArray[1] as integer) (anglesArray[2] as integer) (anglesArray[3] as integer)
			

				/*
				tmp = eulerAngles 0 0 0
				
				
				
				
				
				ImportedSMDRotations = getUserProp obj "ImportedSMDRotations"
				if ImportedSMDRotations != undefined AND ImportedSMDRotations != "" then (
					
					tmp = execute (ImportedSMDRotations)
					

					
				)
				*/
				
				/*
					if classof tmp == eulerAngles AND tmp.z != 0 then (
						--rotate obj (angleaxis (tmp.z * -1)  [0,0,1]) -- z
						rAngle = (tmp.z * -1)
						rotate obj (angleaxis rAngle  [0,0,1]) -- z
					) else (
						
						rotate obj (angleaxis 90   [0,0,1]) -- z
					)
					
					
					*/

				--angles.y -= 90
			/*	
			if unRotatedSMDs == true then (
					in coordsys world rotate obj (angleaxis 90   [0,0,1]) -- z
			)
			if fromCFDecompile == true then (
					in coordsys world rotate obj (angleaxis 90   [0,0,1]) -- z
			)
			*/
			/**/
			if ang != 0 then (
				/*
				local cs = matrix3 1
				cs.row4 = obj.transform.row4
				*/
				in coordsys world rotate obj (angleaxis ang   [0,0,1]) 
				
			) else (
				
				--in coordsys world rotate obj (angleaxis 90   [0,0,1]) 
				--resetXform obj
				--convertToPoly obj
			)
			
			
			
				/*
				if obj.position.x > 0 then xmod = -1 else xmod = 1	
				if obj.position.y > 0 then ymod = -1 else ymod = 1		
*/
				
			in coordsys obj (
				rotate obj (angleaxis (angles.x ) [0,0,1]) -- Z
				--rotate obj (angleaxis (anglesArray[1] as integer ) [1,0,0]) -- Y
					
	
				rotate obj (angleaxis (angles.y  ) [1,0,0]) -- Y
						
				--see about rotate obj (angleaxis (anglesArray[3] as integer  ) [0,1,0]) --X		
					
				rotate obj (angleaxis (angles.z *-1) [0,1,0]) --X
								/**/
				
				
				

			)	
			

	)
	

)


slidertime = 0

/*
Go through all the props in the scene and turn them into proxies from the WWMT helpers.
*/
for obj in theProps  do with redraw off ( 


	--mdl = wallworm_get_modeldata_by_modelname obj.model
	
	dataindex= (wallworm_get_modeldata_by_modelname obj.model)
	mdl = wallworm_models_array[dataindex]
	
	
	if mdl.wwmt != undefined then (
		
		if mdl.wwmt.targets != undefined AND mdl.wwmt.targets.count > 0 AND mdl.wwmt.targets[1] != undefined then (
			proxie = mdl.wwmt.createProxy()
			if proxie != undefined then (
				
				
				--proxie.transform = obj.transform
				
				
				ImportedSMDRotations = getUserProp mdl.wwmt.targets[1] "ImportedSMDRotations"
				if ImportedSMDRotations != undefined then (
					setUserProp proxie "ImportedSMDRotations" (ImportedSMDRotations as string)
				)
				proxie.position =obj.position
				--proxie.rotation =obj.rotation
				wallworm_copy_ca 1 obj proxie
				delete obj
				--excludeLayer.addNode obj
				
				if isProperty proxie "modelscale" AND proxie.modelscale != undefined AND proxie.modelscale != 0.0 then (
					proxie.scale = [proxie.modelscale,proxie.modelscale,proxie.modelscale]
					
				)
				
				
				if special[1] == true then (
					unRotatedSMDs = false
				) else (
					unRotatedSMDs = true
				)
				
				if special[2] == true then (
					fromCFDecompile = false
				) else (
					fromCFDecompile = true
				)
				

				theANg = ang
				if props == false then (
					theANg = 0
					)
				rotateTheObj proxie unRotatedSMDs:unRotatedSMDs fromCFDecompile:fromCFDecompile ang:theANg
				
				setUserProp proxie "wallworm_already_imported" "true"
				
				--delete  obj
			)
		) else (
				print "No targets for WWMT"
		)
	) else (
			print ("No WWMT found for " + obj.model)
	)

--wallworm_models_array = #() --store the data for the models

--alreadyProcessed = #() --store array of model names


)





excludeLayer.on = false
/*
theProps = for obj in objects WHERE isDeleted obj == false AND isProperty obj "wallworm" == true AND isProperty obj "model" == true AND obj.model != undefined AND obj.model != "" AND getUserProp obj "wallworm_already_imported" !=undefined collect obj
	
for obj in theProps do (
	excludeLayer.addNode obj
)
*/
) else (
	messagebox "There are no entities in the scene with MDLs listed."
)


)
resumeEditing()

)
