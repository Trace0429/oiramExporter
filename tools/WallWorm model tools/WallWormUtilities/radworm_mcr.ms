macroScript WallWormRadMCR
category:"wallworm.com"
tooltip:"Rad Worm"
buttontext:"Rad Worm"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormUtilities\\radworm.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\radworm.ms"
		) else (
			messagebox "Rad Worm is missing. Reinstall WWMT."
			
			)
	)

)
