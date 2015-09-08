macroScript WallWormModelToolsMCR
category:"wallworm.com"
tooltip:"Wall Worm Model Tools"
buttontext:"Wall Worm Model Tools"
(
	
	
	function closeWWMT = (
		global wwToolsFloater
		try(closeRolloutFloater  wwToolsFloater)catch()
		
	)
	
	
	
	on isChecked do (
			global wwToolsFloater
		
			if wwToolsFloater == undefined OR  wwToolsFloater.open == false then (
					return false
			) else (
					return true
			)
		
	)
	on closeDialogs do (
		closeWWMT()
	)

	on execute do (
		global wwToolsFloater
		if wwToolsFloater == undefined OR  wwToolsFloater.open == false then (	
		if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\wallworm_model_tools.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormModelTools\\wallworm_model_tools.ms"
		) else (
			messagebox "Wall Worm Model Tools is not installed properly. Please reinstall WWMT."
			)
			
		) else (
				closeWWMT()
		)
	)

)



macroScript WallWormModelToolsConfigMCR
category:"wallworm.com"
tooltip:"Wall Worm Settings"
buttontext:"Wall Worm Settings"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\wwmtconfigutility.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormModelTools\\wwmtconfigutility.ms"
		) else (
						messagebox "Wall Worm Model Tools is not installed properly. Please reinstall WWMT."
			)
	)

)

macroScript WallWormCheckForUpdateMCR
category:"wallworm.com"
tooltip:"Check for Updates"
buttontext:"Check for Updates"
(
	on execute do (

		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/checkForUpdate.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/checkForUpdate.ms"
		) else (
			messagebox "The updater script is missing. Please reinstall WWMT."
		)
	)

)

macroScript WallWormCheckForProblemsMCR
category:"wallworm.com"
tooltip:"Check for Problems"
buttontext:"Check for Problems"
(
	on execute do (

		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ProblemChecker.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/ProblemChecker.ms"
		) else (
			messagebox "The Problem Checker script is missing. Please reinstall WWMT."
		)
	)

)

macroScript WallWormModelToolsExportSMDMCR
category:"wallworm.com"
tooltip:"Export SMD/VTA File"
buttontext:"Export SMD/VTA File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ExportSMD.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/ExportSMD.ms"
		) else (
			messagebox "The Wall Worm SMD Export UI is missing. Please reinstall WWMT."
		)
	)
)

macroScript WallWormModelToolsSelectAllWWMTMCR
category:"wallworm.com"
tooltip:"Select All WWMT"
buttontext:"Select All WWMT"
(
	on execute do (
		local theSel
		if selection.count > 0 then (
			theSel = selection as array
		) else (
			theSel = objects as array
		)
		
		wwmtcollection = for obj in theSel where isProperty obj "wwmt_ca" OR getUserProp obj "wwmt_source_helper" != undefined collect obj
		if wwmtcollection.count > 0 then (
			select wwmtcollection
		)
	)
)

macroScript WallWormModelToolsExtrudeHelpersMCR
category:"wallworm.com"
tooltip:"Make WWMT Helpers 3D"
buttontext:"Make WWMT Helpers 3D"
(
	on execute do (
		wwmtcollection = for obj in objects where isProperty obj "wwmt_ca" OR getUserProp obj "wwmt_source_helper" != undefined collect obj
		if wwmtcollection.count > 0 then (
			wwmts = for wwmt in wwmtcollection WHERE classof wwmt == Text AND wwmt.modifiers[#Extrude] == undefined collect wwmt
			addModifier wwmts (Extrude amount:4)
		)
	)
)


macroScript WallWormModelToolsQuickCompileMCR
category:"wallworm.com"
tooltip:"Export WWMT to Source Models"
buttontext:"Export WWMT to Source Models"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/exportSelectedWWMT.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/exportSelectedWWMT.ms"
		) else (
			messagebox "The WWMT Quick Compiler is missing. Please reinstall WWMT."
		)
	)
)

macroScript WallWormModelToolsQuickCompileVTFMCR
category:"wallworm.com"
tooltip:"Export Selected Model Textures"
buttontext:"Export Selected Model Textures"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/exportSelectedWWMTVTF.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/exportSelectedWWMTVTF.ms"
		) else (
			messagebox "The WWMT Quick Texture Compiler is missing. Please reinstall WWMT."
		)
	)
)

macroScript WallWormAnvilCompileVTFMCR
category:"wallworm.com"
tooltip:"Export Brush Textures"
buttontext:"Export Brush Textures"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\common\\exportBrushTex.ms" then (
			filein "$scripts\\WallWorm.com\\common\\exportBrushTex.ms"
		) else (
			messagebox "The WWMT Quick Texture Compiler is missing. Please reinstall WWMT."
		)
	)
)


macroScript WallWormModelToolsWWMaterialsCAMCR
category:"wallworm.com"
tooltip:"Give Obj Mats WW Materials"
buttontext:"Give Obj Mats WW Materials"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/giveSelectedMaterialsWWCA.ms" then (
			
			try (
				filein "$scripts/WallWorm.com/WallWormUtilities/giveSelectedMaterialsWWCA.ms"
			) catch (
				filein "$scripts/WallWorm.com/WallWormUtilities/giveSelectedMaterialsWWCA.ms"
			)
			
		) else (
			messagebox "The Wall Worm material assignment script is missing..."
		)
	)
)

macroScript WallWormModelToolsWWMaterialsSlateCAMCR
category:"wallworm.com"
tooltip:"Add WW to Selected Mats in Editor"
buttontext:"Add WW to Selected Mats in Editor"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/giveSelectedSlateMaterialsWWCA.ms" then (
			
			try (
				filein "$scripts/WallWorm.com/WallWormUtilities/giveSelectedSlateMaterialsWWCA.ms"
			) catch (
				filein "$scripts/WallWorm.com/WallWormUtilities/giveSelectedSlateMaterialsWWCA.ms"
			)
			
		) else (
			messagebox "The Wall Worm material assignment script is missing..."
		)
	)
)






macroScript WallWormEntityOutputsMCR
category:"wallworm.com"
tooltip:"Manage Source Entity Outputs"
buttontext:"Entity Manager"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/common/mse/entityOutputs.mse" then (
			filein "$scripts/WallWorm.com/common/mse/entityOutputs.mse"
		) else (
			messagebox "The WWMT Entity Outputs is missing. Please reinstall WWMT."
		)
	)
)


macroScript WallWormModelToolsCreateProxyiesMCR
category:"wallworm.com"
tooltip:"Create Proxies from Selected WWMT"
buttontext:"Create WWMT Proxies"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/makeProxiesFromSelection.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/makeProxiesFromSelection.ms"
		) else (
			messagebox "The Proxy Function is missing. Please reinstall WWMT."
		)
	)
)

macroScript WallWormModelToolsProxyToolsMCR
category:"wallworm.com"
tooltip:"WWMT Proxy Tools"
buttontext:"WWMT Proxy Tools"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ProxyTools.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/ProxyTools.ms"
		) else (
			messagebox "The Proxy Tools are missing. Please reinstall WWMT."
		)
	)
)

macroScript WallWormLightToolsMCR
category:"wallworm.com"
tooltip:"Light Properties"
buttontext:"Light Properties"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/SetLightProperties.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/SetLightProperties.ms"
		) else (
			messagebox "The Light Properties Tools are missing. Please reinstall WWMT."
		)
	)
)


macroScript WallWormWebDocsMCR
category:"wallworm.com"
tooltip:"Wall Worm Documentation"
buttontext:"Wall Worm Documentation"
(
	on execute do (
		shellLaunch "http://dev.wallworm.com" ""
	)
)

macroScript WallWormWebChangelogMCR
category:"wallworm.com"
tooltip:"Wall Worm Changelog"
buttontext:"Wall Worm Changelog"
(
	on execute do (
		if wallworm_getMaxVersion == undefined then (
			include "$scripts/WallWorm.com/common/config.ms"
			include "$scripts/WallWorm.com/common/version_funcs.ms"
		)
		local maxInfo =  wallworm_getMaxVersion()
		shellLaunch ("http://dev.wallworm.com/topic/33/wwmt_changelog.html?previous="+(wwmt_installedversion as string)+"&installed="+(ww_wwmt_version as string)+"&maxversion="+(maxInfo[1] as string)+"&maxupdateversion="+(maxInfo[2] as string)) ""
	)
)

macroScript WallWormWebForumMCR
category:"wallworm.com"
tooltip:"Wall Worm Forums"
buttontext:"Wall Worm Forums"
(
	on execute do (
		shellLaunch "http://www.wallworm.net" ""
	)
)

macroScript WallWormFacebookMCR
category:"wallworm.com"
tooltip:"Wall Worm Facebook Group"
buttontext:"Wall Worm Facebook Group"
(
	on execute do (
		
		shellLaunch "https://www.facebook.com/groups/wallworm" ""	
		
	)
)



macroScript WallWormWebDonateMCR
category:"wallworm.com"
tooltip:"Donate to Wall Worm"
buttontext:"Donate to Wall Worm"
(
	on execute do (
		shellLaunch "http://dev.wallworm.com/topic/42/donate.html" ""
	)
)

macroScript WallWormHammeredMCR
category:"wallworm.com"
tooltip:"Hammered to the Max"
buttontext:"Hammered to the Max"
(
	on execute do (
		shellLaunch "http://www.wallworm.com/projects/utilities/Hammered-to-the-Max.pdf" ""
	)
)



macroScript WallWormWebProductsMCR
category:"wallworm.com"
tooltip:"Commercial Plugins by Wall Worm"
buttontext:"Commercial Plugins by Wall Worm"
(
	on execute do (
		shellLaunch "http://dev.wallworm.com/topic/65/products.html" ""
	)
)



macroScript WallWormWebYoutubeMCR
category:"wallworm.com"
tooltip:"Wall Worm Youtube Channel"
buttontext:"Wall Worm Youtube Channel"
(
	on execute do (
		shellLaunch "http://www.youtube.com/user/webonizer" ""
	)
)

macroScript WallWormWebGooglePlusMCR
category:"wallworm.com"
tooltip:"Wall Worm Google+ Community"
buttontext:"Wall Worm Google+ Community"
(
	on execute do (
		shellLaunch "https://plus.google.com/u/0/communities/100151559196798399920" ""
	)
)




macroScript WallWormBoneToolsMCR
category:"wallworm.com"
tooltip:"Bone Tools"
buttontext:"Bone Tools"
(
	on execute do (
		if doesFileExist  "$scripts\\WallWorm.com\\WallWormUtilities\\BoneTools.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\BoneTools.ms"
		
		) else (
			
			messagebox "Bone Tools are missing. Re-Install WWMT."
			
			)

	)
)





fileIn 	"$scripts\\WallWorm.com\\WallWormSkyWriter\\wwsw_mcr.mcr"
fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\wormface_mcr.ms"
fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\radworm_mcr.ms"
fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\wwmatgen_mcr.ms"
fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\soundscaper_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_mcr.mcr"
fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\HullHelper_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\AlphaSpec_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\WormFlex_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\clearWWMT_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\WormRES_mcr.ms"
fileIn 	"$scripts\\WallWorm.com\\general_purpose\\wallworm_quick_parent.ms"

fileIn 	"$scripts\\WallWorm.com\\general_purpose\\nudge_macros.mcr"
try(
	if (maxVersion())[1] >=12000 do (
		fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\WalkableXView.ms"
		fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\WalkableXView_mcr.ms"
	)
) catch()

 macroscript WallWormMaterialMerger
category:"wallworm.com"
tooltip:"Material Merger"
buttontext:"Material Merger"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/general_purpose/wallworm_material_merge.ms" then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_material_merge.ms"
		) else (
			messagebox "Material Merger not present... not installed."
		)
	)
)

 macroscript WallWormSprites
category:"wallworm.com"
tooltip:"Sprite Tools"
buttontext:"Sprite Tools"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/general_purpose/wallworm_sprites.ms" then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_sprites.ms"
		) else (
			messagebox "Wall Worm Sprites not present... not installed."
		)
	)
)

 macroscript WallWormSpritesDrop
category:"wallworm.com"
tooltip:"Place Sprite"
buttontext:"Place Sprite"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/general_purpose/wallworm_sprites.ms" then (
			
			global wallwormSpriteTex
			
			if wallwormSpriteTex == undefined then (
				macros.run  "wallworm.com" "WallWormSprites"
				
				) else (
				
				wallwormSpriteTex.placeSpriteAtPoint()
				)
			
		) else (
			messagebox "Wall Worm Sprites not present... not installed."
		)
	)
)







 macroscript WallWormScaleFix
category:"wallworm.com"
tooltip:"Scale Fix"
buttontext:"Scale Fix"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/general_purpose/scale_fix.ms" then (
			filein "$scripts/WallWorm.com/general_purpose/scale_fix.ms"
		) else (
			messagebox "Wall Worm Scale Fix not present... not installed."
		)
	)
)

macroScript WallWormBodyGroupsMCR
category:"wallworm.com"
tooltip:"Body Groups"
buttontext:"Body Groups"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\bodygroups.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormModelTools\\bodygroups.ms"
		) else (
						messagebox "Wall Worm Model Tools is not installed properly. Please reinstall WWMT."
			)
	)

)


 macroscript WallWormSMDImporter
category:"wallworm.com"
tooltip:"SMD and QC Importer"
buttontext:"SMD and QC Importer"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/SMDImporterUI.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/SMDImporterUI.ms"
		) else (
			messagebox "SMD Importer not present... not installed."
		)
	)
)

 macroscript WallWormVMTImporter
category:"wallworm.com"
tooltip:"VMT Importer"
buttontext:"VMT Importer"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ImportVMTFile.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/ImportVMTFile.ms"
		) else (
			messagebox "VMT Importer not present... not installed."
		)
	)
)

macroscript WallWormHideLODS
category:"wallworm.com"
toolTip:"Hide LODs"
buttontext:"Hide LODs"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/HideLODs.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/HideLODs.ms"
		) else (
			messagebox "Oops... Hide LODs script not found... not installed."
		)
		
	)
	
)

