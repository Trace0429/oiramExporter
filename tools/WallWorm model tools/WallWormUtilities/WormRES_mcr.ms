macroScript WallWormWormResMCR
category:"wallworm.com"
tooltip:"Create Res File"
buttontext:"RES File"
(
	on execute do (
		if doesFileExist  "$scripts\\WallWorm.com\\WallWormUtilities\\WormRES.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\WormRES.ms"
		) else (
			messagebox "Worm Res Utilities Missing. Reinstall WWMT."
			
			)
	)

)