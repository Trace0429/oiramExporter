-- tries to load oiramExporter:
(
	local scriptDir = (getDir #scripts) + "\\oiramExporter\\"
	fileIn (scriptDir + "Export.ms")
	fileIn (scriptDir + "BatchExport.ms")
	fileIn (scriptDir + "MissingMaps.ms")
	fileIn (scriptDir + "ResetNodeUnit.ms")
	fileIn (scriptDir + "Reboot.ms")
)

fn createOiramExporterToolbar =
(
	ctrlDescs = #(
				#button,	"Export",				"Export", 					"",			"oiramExport(false)", 
				#button,	"ExportSelected",		"Export Selected", 			"",			"oiramExport(true)", 
				#button,	"BatchExport",			"Batch Export", 			"",			"oiramBatchExport()", 
				#button,	"BatchExportResume",	"Batch Export Resume", 		"",			"oiramBatchExportResume()", 
				#checkbox,	"Merge",				"Merge", 					"state ",	"oiram.merge = state", 
				#checkbox,	"ResetScale",			"Reset Scale", 				"state ",	"oiram.resetNodeScale = state", 
				#button,	"MissingMaps",			"Missing Maps", 			"",			"oiramMissingMaps()", 
				#button,	"ResetSelectionUnit",	"Reset Selection Unit", 	"",			"oiramResetSelectionNodeUnit()", 
				#button,	"Reboot",				"Reboot",					"",			"oiramReboot()"
				)
				
	px = 0
	py = 3

	rci = rolloutCreator "oiramToolbar" "oiram toolbar"
	rci.begin()
	rci.addControl #edittext editRename "Rename:" paramStr:"pos:[5, 6]"
	rci.addHandler editRename #entered paramStr:"name " codeStr:"oiram.rename name"
	px += 160
	for i in 1 to ctrlDescs.count by 5 do
	(
		ctrlType = ctrlDescs[i]
		ctrlName = ctrlDescs[i + 1]
		ctrlCaption = ctrlDescs[i + 2]
		ctrlParamStr = ctrlDescs[i + 3]
		ctrlEvent = ctrlDescs[i + 4]
		
		nameLength = (GetTextExtent ctrlCaption)[1] + 20
		pstr = ("pos:[" + px as string + ", " + py as string + "] width:" + nameLength as string + " height:22")
		px += nameLength

		rci.addControl ctrlType ctrlName ctrlCaption paramStr:pstr align:#center
		
		if ctrlEvent != "" do
		(
			eventType = case ctrlType of
			(
				#button: #pressed
				#checkbox: #changed
			)
			rci.addHandler ctrlName eventType paramStr:ctrlParamStr codeStr:ctrlEvent
		)
			
		px += 20
	)
	
	createDialog(rci.end())
	cui.RegisterDialogBar rci.def style:#(#cui_floatable, #cui_handles,#cui_max_sized)
	cui.DockDialogBar rci.def #cui_dock_top
)

createOiramExporterToolbar()
