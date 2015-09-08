macroScript WallWormFaceMCR
category:"wallworm.com"
tooltip:"Worm Face"
buttontext:"Worm Face"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormUtilities\\wallwormface.ms" then (
		fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\wallwormface.ms"
		) else(
			messagebox "Worm Face is missing. Reinstall WWMT."
			)
	)

)
