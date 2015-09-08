		if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms" then (
	
			fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms"
	
			local mainMenuBar = menuMan.getMainMenuBar()			
			
			
			
			/*
			These while loops to unregister menus is here because there can be a long line of repeating menus in Customize UI each time
			you update WW if they are not.
			
			*/

			while  (menuMan.findMenu "Wall Worm") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			
			while 	(menuMan.findMenu "Wall Worm Model Tools") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Model Tools"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			while 	(menuMan.findMenu "Wall Worm Level Design") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Level Design"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)

			while 	(menuMan.findMenu "Wall Worm Online") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Online"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			while 	(menuMan.findMenu "Wall Worm Importers") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Importers"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			

			while 	(menuMan.findMenu "Wall Worm Utilities") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Utilities"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			while 	(menuMan.findMenu "Wall Worm Materials") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Materials"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			

			while 	(menuMan.findMenu "Wall Worm Exporters") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Exporters"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
						
			while 	(menuMan.findMenu "Wall Worm Extras") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Extras"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			
						
			while 	(menuMan.findMenu "Wall Worm Map Compile Tools") != undefined do (
				
						subMenu = menuMan.findMenu "Wall Worm Map Compile Tools"
						if subMenu != undefined do (
							menuMan.unRegisterMenu subMenu
							subMenu = undefined
						)
						
			)
			
			

			
			
			
			subMenu = menuMan.findMenu "Wall Worm"
			if subMenu != undefined do (
				menuMan.unRegisterMenu subMenu
				subMenu = undefined
			)
			if subMenu == undefined then (
				local classId = genClassID returnValue:true
				menuMan.registerMenuContext classId[1]
				-- Get the main menu bar
	
	
	
				 local wwSep = menuMan.createSeparatorItem()
	
				-- Create a new menu
	
				local subMenu = menuMan.createMenu "Wall Worm"
	
				local subMenuMapCompile = menuMan.createMenu "Wall Worm Map Compile Tools"
				
				local subMenuMapCompileSub = menuMan.createSubMenuItem  "Wall Worm Map Compile Tools" subMenuMapCompile
				
				
				local supMenuLeakFileVMF = menuMan.createActionItem "WallWormLoadLeakFileMCR" "wallworm.com"
				subMenuMapCompile.addItem supMenuLeakFileVMF -1
				
				local supMenuBrushIDVMF = menuMan.createActionItem "WallWormGetBrushByIDMCR" "wallworm.com"
				subMenuMapCompile.addItem supMenuBrushIDVMF -1
				
				local supMenuPRT = menuMan.createActionItem "WallWormLoadPRTFileMCR" "wallworm.com"
				subMenuMapCompile.addItem supMenuPRT -1
				
				
				
				
				
				
				
				

	
				local subMenu4 = menuMan.createMenu "Wall Worm Online"
				
				
				local subMenuImport = menuMan.createMenu "Wall Worm Importers"
				
				local subMenuExtras = menuMan.createMenu "Wall Worm Extras"
				
				
				local subMenuWWMT = menuMan.createMenu "Wall Worm Model Tools"
				local subMenuWWLD= menuMan.createMenu "Wall Worm Level Design"
				local subMenuWWMats= menuMan.createMenu "Wall Worm Materials"
				
				
				local MenuBUYWW = menuMan.createActionItem "WallWormWebProductsMCR" "wallworm.com"
				
				

				local supMenuImportSMD = menuMan.createActionItem "WallWormSMDImporter" "wallworm.com"
				subMenuImport.addItem supMenuImportSMD -1	
				
				local supMenuImportVMF = menuMan.createActionItem "WallWormImportVMFMCR" "wallworm.com"
				subMenuImport.addItem supMenuImportVMF -1
				
				
				local supMenuImportVBSP = menuMan.createActionItem "WallWormImportVBSPMCR" "wallworm.com"
				subMenuImport.addItem supMenuImportVBSP -1
				

				
				
				local vmtimptmenu = menuMan.createActionItem "WallWormVMTImporter" "wallworm.com"
				subMenuImport.addItem vmtimptmenu -1
				
				
				subMenuImport.addItem wwSep -1

				
				local supMenuImportDXF = menuMan.createActionItem "WallWormImportDXFMCR" "wallworm.com"
				subMenuImport.addItem supMenuImportDXF -1							
				
				
				
				local configMenu = menuMan.createActionItem "WallWormModelToolsConfigMCR" "wallworm.com"
				local WallWormWebDonateMCRMenu = menuMan.createActionItem "WallWormWebDonateMCR" "wallworm.com"				


				
				local docsMenu1 = menuMan.createActionItem "WallWormWebDocsMCR" "wallworm.com"
				subMenu4.addItem docsMenu1 -1
				
				local WallWormWebChangelogMCRMenu = menuMan.createActionItem "WallWormWebChangelogMCR" "wallworm.com"
				subMenu4.addItem WallWormWebChangelogMCRMenu -1			

				local WallWormHammeredMCRMenu = menuMan.createActionItem "WallWormHammeredMCR" "wallworm.com"
				subMenu4.addItem WallWormHammeredMCRMenu -1		

				
				local WallWormWebForumMCRMenu = menuMan.createActionItem "WallWormWebForumMCR" "wallworm.com"
				subMenu4.addItem WallWormWebForumMCRMenu -1
				
				subMenu4.addItem wwSep -1
				
				local WallWormFacebookMCRMenu = menuMan.createActionItem "WallWormFacebookMCR" "wallworm.com"
				subMenu4.addItem WallWormFacebookMCRMenu -1		
				
				
				local WallWormWebGooglePlusMCRMenu = menuMan.createActionItem "WallWormWebGooglePlusMCR" "wallworm.com"
				subMenu4.addItem WallWormWebGooglePlusMCRMenu -1	
				


				
				local WallWormWebYoutubeMCRMenu = menuMan.createActionItem "WallWormWebYoutubeMCR" "wallworm.com"
				subMenu4.addItem WallWormWebYoutubeMCRMenu -1


				subMenu4.addItem wwSep -1

				subMenu4.addItem WallWormWebDonateMCRMenu -1		
				 subMenu4.addItem MenuBUYWW -1
				 

				 
				
				
				local subMenuItem = menuMan.createSubMenuItem "Wall Worm" subMenu
	
	

	
				/*WWMT*/
				local testItem = menuMan.createActionItem "WallWormModelToolsMCR" "wallworm.com"
				subMenuWWMT.addItem testItem -1
				local hullMenu = menuMan.createActionItem "WallWormHullHelperMCR" "wallworm.com"
				subMenuWWMT.addItem hullMenu -1	
				local bodygroupsMenu = menuMan.createActionItem "WallWormBodyGroupsMCR" "wallworm.com"
				subMenuWWMT.addItem bodygroupsMenu -1	
				local bnMenu = menuMan.createActionItem "WallWormBoneToolsMCR" "wallworm.com"
				subMenuWWMT.addItem bnMenu -1
				local vtaMenu = menuMan.createActionItem "WallWormWormFlexMCR" "wallworm.com"
				subMenuWWMT.addItem vtaMenu -1	
				
				local selWWMTMenu = menuMan.createActionItem "WallWormModelToolsSelectAllWWMTMCR" "wallworm.com"
				subMenuWWMT.addItem selWWMTMenu -1	

				local extWWMTMenu = menuMan.createActionItem "WallWormModelToolsExtrudeHelpersMCR" "wallworm.com"
				subMenuWWMT.addItem extWWMTMenu -1	




				local skyWriterMenu = menuMan.createActionItem "WallWormSkyWriterMCR" "wallworm.com"
				
				
				
				
				/*Anvil*/
				

				
				
				local testItem2 = menuMan.createActionItem "WallWormSimpleDisplacementMCR" "wallworm.com"
				subMenuWWLD.addItem testItem2 -1
				
				local crvItem1 = menuMan.createActionItem "WallWormCorVexUtilities" "wallworm.com"
				subMenuWWLD.addItem crvItem1 -1
				
				
				local carvItem1 = menuMan.createActionItem "WallWormCarver" "wallworm.com"
				subMenuWWLD.addItem carvItem1 -1
				
				
				
				
				
				subMenuWWLD.addItem wwSep -1
				
				
				local brushEntItem2 = menuMan.createActionItem "wallwormBrushEntities" "wallworm.com"
				subMenuWWLD.addItem brushEntItem2 -1
				
				local entMenu = menuMan.createActionItem "WallWormEntityOutputsMCR" "wallworm.com"
				subMenuWWLD.addItem entMenu -1			
				
				local pointEntItem2 = menuMan.createActionItem "wallwormPointEntities" "wallworm.com"
				subMenuWWLD.addItem pointEntItem2 -1
				
				subMenuWWLD.addItem wwSep -1
				
				local cordonmenu = menuMan.createActionItem "WallWormCordonManagerMCR" "wallworm.com"
				subMenuWWLD.addItem cordonmenu -1

				local lightMenu = menuMan.createActionItem "WallWormLightToolsMCR" "wallworm.com"
				subMenuWWLD.addItem lightMenu -1	
	
		
				

				
				
				local radMenu = menuMan.createActionItem "WallWormRadMCR" "wallworm.com"
				subMenuWWLD.addItem radMenu -1
				
				local resMenu = menuMan.createActionItem "WallWormWormResMCR" "wallworm.com"
				subMenuWWLD.addItem resMenu -1	
				
				subMenuWWLD.addItem skyWriterMenu -1
				
				local soundMenu = menuMan.createActionItem "WallWormSoundscaperMCR" "wallworm.com"
				subMenuWWLD.addItem soundMenu -1	
				
				local testItem4 = menuMan.createActionItem "WallWormFaceMCR" "wallworm.com"
				subMenuWWLD.addItem testItem4 -1
			
				local proxMenu = menuMan.createActionItem "WallWormModelToolsProxyToolsMCR" "wallworm.com"
				subMenuWWLD.addItem proxMenu -1
				
				
				
				
				subMenuWWLD.addItem wwSep -1
				
				
				
				local tgBrMode = menuMan.createActionItem "wallwormbrushmodetoggle" "wallworm.com"
				subMenuWWLD.addItem tgBrMode -1
				
				local setAsBrush = menuMan.createActionItem "WallWormDesignateSelectionAsBrushes" "wallworm.com"
				subMenuWWLD.addItem setAsBrush -1
				
				
				local setAsCCBrush = menuMan.createActionItem "WallWormDesignateSelectionAsConcave" "wallworm.com"
				subMenuWWLD.addItem setAsCCBrush -1
				
				
				local setAsCVBrush = menuMan.createActionItem "WallWormDesignateSelectionAsConvex" "wallworm.com"
				subMenuWWLD.addItem setAsCVBrush -1
				
				
				local setAsDetail = menuMan.createActionItem "WallWormDesignateSelectionAsFuncDetail" "wallworm.com"
				subMenuWWLD.addItem setAsDetail -1
				
				local setAsFroupDetail = menuMan.createActionItem "WallWormDesignateSelectionAsFuncDetailGroup" "wallworm.com"
				subMenuWWLD.addItem setAsFroupDetail -1
				
				local setAsSky = menuMan.createActionItem "WallWormDesignateSelectionAsSky" "wallworm.com"
				subMenuWWLD.addItem setAsSky -1


				local vmfIncludeWWMT = menuMan.createActionItem "WallWormVMFIncludeWWMT" "wallworm.com"
				subMenuWWLD.addItem vmfIncludeWWMT -1
				
				
				subMenuWWLD.addItem wwSep -1
				
				local removeBrush = menuMan.createActionItem "WallWormRemoveSelectionFromBrushes" "wallworm.com"
				subMenuWWLD.addItem removeBrush -1
				
				local removeDetail = menuMan.createActionItem "WallWormRemoveSelectionFromFuncDetail" "wallworm.com"
				subMenuWWLD.addItem removeDetail -1
				
				local removeSky = menuMan.createActionItem "WallWormRemoveSelectionFromSky" "wallworm.com"
				subMenuWWLD.addItem removeSky -1
				
				local vmfExluceWWMT = menuMan.createActionItem "WallWormVMFExcludeWWMT" "wallworm.com"
				subMenuWWLD.addItem vmfExluceWWMT -1
				
				
				subMenuWWLD.addItem wwSep -1
				
				subMenuWWLD.addItem subMenuMapCompileSub -1
				
				
				local vmfMenu = menuMan.createActionItem "WallWormExportVMFMCR" "wallworm.com"
				subMenuWWLD.addItem vmfMenu -1
				

				
				
				
				
				
				local ovrWWCAmenu = menuMan.createActionItem "WallWormModelToolsWWMaterialsCAMCR" "wallworm.com"
				local ovrMenu = menuMan.createActionItem "WallWormExportOverviewMCR" "wallworm.com"
				local vtfMenu2 = menuMan.createActionItem "WallWormAnvilCompileVTFMCR" "wallworm.com"
				local vtfMenu = menuMan.createActionItem "WallWormModelToolsQuickCompileVTFMCR" "wallworm.com"
				
				local remapMats = menuMan.createActionItem "WallWormRemapMaterialsMCR" "wallworm.com"
				
				/*Materials*/
				
				subMenuWWMats.addItem skyWriterMenu -1
				subMenuWWMats.addItem testItem4 -1
				
				local alphaSpecMenu = menuMan.createActionItem "WallWormAlphaSpecMCR" "wallworm.com"
				subMenuWWMats.addItem alphaSpecMenu -1	
				
				
				subMenuWWMats.addItem wwSep -1
				
				
				
				local wwSlateMenu = menuMan.createActionItem "WallWormModelToolsWWMaterialsSlateCAMCR" "wallworm.com"
				subMenuWWMats.addItem wwSlateMenu -1	
				
				
				
				subMenuWWMats.addItem ovrWWCAmenu -1
				subMenuWWMats.addItem wwSep -1
				
				
				subMenuWWMats.addItem vmtimptmenu -1
				local testItem5 = menuMan.createActionItem "WallWormMaterialGeneratorMCR" "wallworm.com"
				subMenuWWMats.addItem testItem5 -1
				
				subMenuWWMats.addItem wwSep -1
				local testItem6 = menuMan.createActionItem "WallWormMaterialMerger" "wallworm.com"
				subMenuWWMats.addItem testItem6 -1
				

				subMenuWWMats.addItem remapMats -1

				subMenuWWMats.addItem wwSep -1
				
				subMenuWWMats.addItem wwSep -1
				subMenuWWMats.addItem vtfMenu2 -1	
				subMenuWWMats.addItem ovrMenu -1 
				subMenuWWMats.addItem vtfMenu -1	
				 
				 
				local subMenuWWMTS = menuMan.createSubMenuItem "Wall Worm Model Tools" subMenuWWMT
				subMenu.addItem subMenuWWMTS -1
				local subMenuWWLDS = menuMan.createSubMenuItem "Wall Worm Level Design" subMenuWWLD
				subMenu.addItem subMenuWWLDS -1
				local subMenuWWMatsS = menuMan.createSubMenuItem "Wall Worm Materials" subMenuWWMats
				subMenu.addItem subMenuWWMatsS -1
				 
				 
				 
				 
				/*Utilities*/
				local subMenu2 = menuMan.createMenu "Wall Worm Utilities"
				
				local upMenu1 = menuMan.createActionItem "WallWormCheckForUpdateMCR" "wallworm.com"
				subMenu2.addItem upMenu1 -1
				
				local problemMenu = menuMan.createActionItem "WallWormCheckForProblemsMCR" "wallworm.com"
				subMenu2.addItem problemMenu -1
				

				
				local HideBrushes = menuMan.createActionItem "wallwormHideAllBrushes" "wallworm.com"
				subMenu2.addItem HideBrushes -1
				
				local HideLODs = menuMan.createActionItem "WallWormHideLODS" "wallworm.com"
				subMenu2.addItem HideLODs -1
				
				subMenu2.addItem configMenu -1

				
				subMenu2.addItem MenuBUYWW -1

				
				local subMenuUtil = menuMan.createSubMenuItem "Wall Worm Utilities" subMenu2
				 subMenu.addItem subMenuUtil -1
				 
				 
				local subMenuImp = menuMan.createSubMenuItem "Wall Worm Importers" subMenuImport
				 subMenu.addItem subMenuImp -1
				 
				 
				 
				local subMenu3 = menuMan.createMenu "Wall Worm Exporters"
				
				local smdMenu1 = menuMan.createActionItem "WallWormModelToolsExportSMDMCR" "wallworm.com"
				subMenu3.addItem smdMenu1 -1
				
				
				local smdMenu = menuMan.createActionItem "WallWormModelToolsQuickCompileMCR" "wallworm.com"
				subMenu3.addItem smdMenu -1
				
				
				
				subMenu3.addItem vtfMenu2 -1
				
				subMenu3.addItem ovrMenu -1
				subMenu3.addItem vtfMenu -1 
				

				subMenu3.addItem vmfMenu -1
				
				
				
				

				local subMenuExp = menuMan.createSubMenuItem "Wall Worm Exporters" subMenu3
				 subMenu.addItem subMenuExp -1
				 
				 
				 
				 

				 


				local testItemNudge = menuMan.createActionItem "wallwormOpenNudgeRollout" "wallworm.com"
				subMenuExtras.addItem testItemNudge -1

				
				local testItemSprites = menuMan.createActionItem "WallWormSprites" "wallworm.com"
				subMenuExtras.addItem testItemSprites -1
			
				local testItemScale = menuMan.createActionItem "WallWormScaleFix" "wallworm.com"
				subMenuExtras.addItem testItemScale -1
				
				local testItemQP = menuMan.createActionItem "WallWormQuickParentPick" "wallworm.com"
				subMenuExtras.addItem testItemQP -1
				
				local testItemQPS = menuMan.createActionItem "WallWormQuickParentSelection" "wallworm.com"
				subMenuExtras.addItem testItemQPS -1
				
				subMenuExtras.addItem MenuBUYWW -1
				
				
				local subMenuExt = menuMan.createSubMenuItem "Wall Worm Extras" subMenuExtras
				subMenu.addItem subMenuExt -1
				
				local subMenuOn = menuMan.createSubMenuItem "Wall Worm Online" subMenu4
				subMenu.addItem subMenuOn -1
				
				
				subMenu.addItem wwSep -1
		
		
				subMenu.addItem WallWormWebDonateMCRMenu -1		
		
				subMenu.addItem configMenu -1
				--subMenu.addItem WallWormWebDonateMCRMenu -1		
				
				

				
				
				local subMenuItem = menuMan.createSubMenuItem "Wall Worm" subMenu
				-- compute the index of the next-to-last menu item in the main menu bar
				local subMenuIndex = mainMenuBar.numItems() - 1
				mainMenuBar.addItem subMenuItem subMenuIndex
	
				menuMan.updateMenuBar()
				global wallwormInstallation
				
				if wallwormInstallation == undefined then (
					messagebox "The menu bar has been updated with the most recent Wall Worm menus."
				)
			) else (
			
			try (
				subMenu = menuMan.findMenu "Wall Worm"
				local testItem = menuMan.createActionItem "WallWormModelToolsMCR" "wallworm.com"
				subMenu.addItem testItem -1
				
				local testItem1 = menuMan.createActionItem "WallWormSimpleDisplacementMCR" "wallworm.com"
				subMenu.addItem testItem1 -1
				
				
				local testItem2 = menuMan.createActionItem "WallWormSkyWriterMCR" "wallworm.com"
				subMenu.addItem testItem2 -1
				
				
				local testItem3 = menuMan.createActionItem "WallWormFaceMCR" "wallworm.com"
				subMenu.addItem testItem3 -1
				
				
				local testItem4 = menuMan.createActionItem "WallWormMaterialGeneratorMCR" "wallworm.com"
				subMenu.addItem testItem4 -1

				menuMan.updateMenuBar()
				messagebox "The menu bar has been updated with the most recent Wall Worm menus."
				) catch (
					 messagebox "There was a problem updating the Wall Worm menu."
					)
			
			
			)
	
		) else (
		
			messageBox "The installer only works if you have placed the Wall Worm Model Tools into the correct folder in the Max Scripts directory. Please read the installation instructions."
		)	
	