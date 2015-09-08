macroScript WallWormSkyWriterMCR
category:"wallworm.com"
tooltip:"Sky Writer"
buttontext:"Sky Writer"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\WallWormSkyWriter\sky_writer.ms" then (
			sysinfo.currentdir = "$scripts\\WallWorm.com\\WallWormSkyWriter"
			fileIn  "sky_writer.ms"
		) else (
			messagebox "Sky Writer is missing. Reinstall WWMT."
			
		)
	)

)