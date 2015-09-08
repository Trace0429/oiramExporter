(
	local scriptDir = (getDir #scripts) + "\\oiramExporter\\"
	fileIn (scriptDir + "Merge.ms")
	fileIn (scriptDir + "ResetNodeScale.ms")
)

fn oiramExport selected =
(
	try
	(
		if oiram.optionDialog() do
		(
			oiramResetNodeScale()
			oiramMerge()
			oiram.export(selected)
		)
	)
	catch()
)
