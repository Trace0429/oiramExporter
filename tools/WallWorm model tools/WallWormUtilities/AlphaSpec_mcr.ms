macroScript WallWormAlphaSpecMCR
category:"wallworm.com"
tooltip:"Alpha Spec - Merge Specular Level into Alpha of other Bitmaps."
buttontext:"Alpha Spec"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormUtilities\\AlphaSpec.ms" then (
		fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\AlphaSpec.ms"
		) else (
			messagebox "Alpha Spec is missing. Re-Install WWMT."
			
			) 
	)

)
