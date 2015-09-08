macroScript WallWormHullHelperMCR
category:"wallworm.com"
tooltip:"Hull Helper"
buttontext:"Hull Helper"
(
	on execute do (
		if doesFileExist  "$scripts\\WallWorm.com\\WallWormUtilities\\HullHelper.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\HullHelper.ms"
		
		) else (
			
			messagebox "Hull Helper is missing. Re-Install WWMT."
			
			)

	)
)
