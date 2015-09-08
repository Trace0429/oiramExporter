oiramMenuID = genClassID returnValue:true;

macroScript Export
category: "oiramExport"
tooltip: "oiramExport"
(
	on execute do
	(
		try
		(
			if oiram.optionDialog() do
			(
				oiram.export(false)
			)
		)
		catch()
	)
)

if menuMan.registerMenuContext oiramMenuID[1] do
(
	local mainMenuBar = menuMan.getMainMenuBar()
	local subMenu = menuMan.createMenu "oiramExport"
	local exportItem = menuMan.createActionItem "Export" "oiramExport"
	subMenu.addItem exportItem -1
	local subMenuItem = menuMan.createSubMenuItem "Export" subMenu
	local subMenuIndex = mainMenuBar.numItems() - 1
	mainMenuBar.addItem subMenuItem subMenuIndex
	menuMan.updateMenuBar()
)

