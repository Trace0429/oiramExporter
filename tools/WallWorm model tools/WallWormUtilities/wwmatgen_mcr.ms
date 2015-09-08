macroScript WallWormMaterialGeneratorMCR
category:"wallworm.com"
tooltip:"Convert a collection of VMT and TGA files to 3ds Max material libraries."
buttontext:"Material Library Generator"
(
	on execute do (
		if doesFileExist "$scripts\\WallWorm.com\\common\\wwmt_material_library_generator.ms" then (
			fileIn  "$scripts\\WallWorm.com\\common\\wwmt_material_library_generator.ms"
		) else (
			messagebox "The WWMT Material Library Generator is missing. Reinstall WWMT."
		)
	)

)