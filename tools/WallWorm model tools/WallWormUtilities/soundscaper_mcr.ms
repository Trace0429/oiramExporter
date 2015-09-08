macroScript WallWormSoundscaperMCR
category:"wallworm.com"
tooltip:"Soundscaper"
buttontext:"Soundscaper"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormUtilities\\soundscaper.ms" then (
			fileIn  "$scripts\\WallWorm.com\\WallWormUtilities\\soundscaper.ms"
		) else(
			messagebox "Soundscaper is missing. Reinstall WWMT."
			)
	)

)
