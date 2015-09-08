rollout wallWormSMDImporter "SMD and QC Importer" 
(
	group "General Options" (
		checkbox chkAnimatedModel "Animated Model" align:#left tooltip:"Click here to deactivate functions bad for animated models."
 		checkbox chkRotate "Rotated Model" align:#left toolTip:"Check this option if the SMD is a staticprop exported by Wall Worm and you want it to be rotated by 90."
		checkbox chkRemoveUnweightedBones "Remove Unweighted Bones from Skin" align:#left tooltip:"Remove any bone from the skin if it has no vertices weighted to it. Takes longer."
		checkbox chkWeldVerts "Weld Vertices" align:#left toolTip:"Weld the verticed of the mesh. You will lose the Normals/Smoothing." checked:false
		--checkbox chkConvertToPoly "Convert To Poly" align:#left toolTip:"Convert the imported mesh to editable poly." checked:true
		checkbox chkQuadrifyAll "Quadrify" align:#left toolTip:"Quadrify the incoming mesh. Works best when using the Weld Verts and Convert To Poly. If not converting to editable poly, applies a Quadrify Modifier with a quad size of 10 (which you can adjust after the import)." checked:true
		checkbox chkZeroRotations "Nullify Root Rotation" align:#left tooltip:"Nullify the root rotation in the SMD. Best if limited to staticprop models." checked:true
		checkbox chkXForm "Xform Mesh Node" align:#left tooltip:"Add Xform to generated mesh node." checked:true
		checkbox chkStatic "Remove Bones" align:#left toolTip:"Remove all the bones from this model... useful for props that have multiple pieces." checked:true
		checkbox chkCollapseMesh "Collapse Mesh" align:#left toolTip:"When on, collapses the mesh into a single mesh. This is probably best for static props but may not be good for skinned models." checked:true
		checkbox chkUniqueNames "Force Unique Bone Names" align:#left tooltip:"Force the node names to be unique in the scene. This is important for scenes with a lot of objects... but may be indesirable if the names of the bones are important."
		checkbox chkDeepMatSearch "Extended Material Search" align:#left tooltip:"Search more paths for missing VMTs. Slower." checked:true
	)
	group "SMD Only Options" (
		checkbox chkCreateWWMT "Create a WWMT Helper" align:#left toolTip:"Check this option if you want to create a WWMT helper assigned to this imported SMD." checked:true
	)
	
	group "QC Only Options" (
		checkbox chkScaleMesh "$scale to Mesh" align:#left toolTip:"When unchecked, the $scale in a QC is translated to the WWMT helper. If this option is checked, the meshes themselves are scaled then the XForm reset."
		checkbox chkskipLODS	 "Skip LODS"
		label lblExtraSMDPaths "Extra Sequences Folder"
		editText edtExtraSMDPath "" enabled:false
		
	)
	
	group "Actions" (
	button btnImportSMD "Import QC or SMD"  toolTip:"Import a SMD File or all SMD files from the QC."
	)

	group "About" (
		
		label lblVersion "Version 1.52"
		hyperlink helplink "SMD/QC Importer Help" address:"http://dev.wallworm.com/document/121/smd_and_qc_importer.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		
		)
	
	
	group "Developed by MarioKart" (
		
		hyperlink mklink1 "Corey Nguyen" address:"http://www.facebook.com/corey.van.nguyen" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		hyperlink mklink2 "mariokart64 on Youtube" address:"http://www.youtube.com/user/mariokart64n"	color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		
	)
	
	group "And by" (
		
		hyperlink wwlink "Wall Worm" address:"http://dev.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		hyperlink smolink "Shawn Olson" address:"http://www.shawnolson.net" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		
	)
	
	on chkAnimatedModel changed stat do (
		
		if stat == true then (
			chkWeldVerts.checked = false
			chkWeldVerts.enabled = false
			/*chkConvertToPoly.checked = false
			chkConvertToPoly.enabled = false*/
			chkQuadrifyAll.checked = false
			chkQuadrifyAll.enabled = false
			chkZeroRotations.checked = false
			chkZeroRotations.enabled = false
			chkXForm.checked = false
			chkXForm.enabled = false
			chkStatic.checked = false
			chkStatic.enabled = false
			chkCollapseMesh.checked = false
			chkCollapseMesh.enabled = false
			chkUniqueNames.checked = false
			chkUniqueNames.enabled = false
			edtExtraSMDPath.enabled = true
			
			
		) else (

			chkWeldVerts.enabled = true
			--chkConvertToPoly.enabled = true
			chkQuadrifyAll.enabled = true
			chkZeroRotations.enabled = true
			chkXForm.enabled = true
			chkStatic.enabled = true
			chkCollapseMesh.enabled = true
			chkUniqueNames.enabled = true
			edtExtraSMDPath.enabled = false
		)
	)
	
	function processMesh msh makeWWMT:false forceWeld:false= (
		
				if msh != undefined then (
					

					if chkQuadrifyAll.checked == true AND PolyToolsModeling != undefined  then (
							select msh
							PolyToolsModeling.Quadrify false false
							
					)
						
					if forceWeld OR chkWeldVerts.checked == true then (
							
						if classOf msh == editable_poly then (
							msh.weldThreshold = 0.1
							polyop.weldVertsByThreshold msh #{1..msh.numverts}
						) 
							
					)
						
					
					if chkQuadrifyAll.checked == true AND PolyToolsModeling == undefined  then (

							
							local qm = Quadify_Mesh()
							qm.quadsize = 10
							addModifier msh qm

					)
				)
	)
	
	
	
	on btnImportSMD pressed do (
		
		fsource = GetOpenFileName historyCategory:"Wall Worm SMD Exporter" caption:"SMD File Importer" types: "QC File (*.qc)|*.QC|Studio Model Data (*.smd)|*.SMD|All files (*.*)|*.*|"
		
		if (fsource!=undefined) AND ((doesFileExist fsource)==true) then (
		
			if toLower (getFileNameType fsource) != ".qc" then (
		
	
				if chkAnimatedModel.checked then (timeOffset = sliderTime ) else (timeOffset = 0)
				
				
				mshes = (wallworm_import_smd fsource removeUnweightedBonesFromSkin:chkRemoveUnweightedBones.checked rotateModel:chkRotate.checked deepSearchMaterials:chkDeepMatSearch.checked zeroRotations:chkZeroRotations.checked staticprop:chkStatic.checked xf:chkXForm.checked uniqueNames:chkUniqueNames.checked collapseMeshes:chkCollapseMesh.checked timeOffset:timeOffset isSequence:(chkAnimatedModel.checked) addToTimeline:(chkAnimatedModel.checked)) 
				if mshes.count > 0 then (

					
					if chkCreateWWMT.checked == true then (
							tempWWMT = ww_LOD_wrapper()
							tempWWMT.init()
							tempWWMT.setTargetModel mshes[1] tempWWMT
						
							for msh in mshes do (
								
								processMesh msh
								if msh != mshes[1] then (
									
									tempWWMT.addObjToObjects msh
								)
							)
						
						
					)
					
				) else (
					
					print "Sequence Imported but not added to wwmt due to an unknown problem."
				)

				wallworm_smd_import_time = undefined
			) else (
				
				local wwmt = wallworm_parse_qc fsource removeUnweightedBonesFromSkin:chkRemoveUnweightedBones.checked skipLODS:chkskipLODS.checked  deepSearchMaterials:chkDeepMatSearch.checked  staticprop:chkStatic.checked rotateModel:chkRotate.checked zeroRotations:chkZeroRotations.checked  xf:chkXForm.checked  uniqueNames:chkUniqueNames.checked collapseMeshes:chkCollapseMesh.checked scaleMesh:chkScaleMesh.checked extraSequences:edtExtraSMDPath.text
				if wwmt != undefined then (
					
						select wwmt.targets[1]
					
					
						processMesh wwmt.targets[1] makeWWMT:false
						
						if wwmt.hulls.count > 0 then (
							select wwmt.hulls[1]
							processMesh wwmt.hulls[1] makeWWMT:false --forceWeld:true
							
						)
						
						if wwmt.lods.count > 0 then (
							
								for l in wwmt.lods do (
									select l.items[1]
									processMesh l.items[1] makeWWMT:false
									
								)
						)
					
				)
				
			
			--import QC
			)
			
		)
	)
	
)
