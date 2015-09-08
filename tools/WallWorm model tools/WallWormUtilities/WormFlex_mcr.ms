include "$scripts/WallWorm.com/common/flexfuncs.ms"

macroScript WallWormWormFlexMCR
category:"wallworm.com"
tooltip:"Prepare Morpher for VTA UI"
buttontext:"WW Morpher UI"
(
	on execute do (
		if doesFileExist  "$scripts\\WallWorm.com\\WallWormUtilities\\WormFlex.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\WormFlex.ms"
		) else (
			messagebox "Worm Flex Utilities Missing. Reinstall WWMT."
			
			)
	)

)


macroScript WallWormVTAPrepSelMCR
category:"wallworm.com"
tooltip:"Prepare Selected Meshes for VTA"
buttontext:"WW Keyframe Morphers"
(
	on execute do (
		
		if doesFileExist "$scripts/WallWorm.com/common/flexfuncs.ms" then (
			include "$scripts/WallWorm.com/common/flexfuncs.ms"
		
			if selection.count > 0 then (
				local converted = wwmt_prepare_morphs selection
				messagebox ((converted as string)+" objects prepared.")
			) else (
				 messagebox "No objects selected"
			)
		) else (
			messagebox "Worm Flex Utilities Missing. Reinstall WWMT."
		)
	)
)
