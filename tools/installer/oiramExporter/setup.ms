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

-- 安装对话框
rollout oiram_setup_dialog ""
(
	HyperLink hy "www.flagon.cn" pos:[10,5] address:"http://www.flagon.cn" color:(color 255 255 255) hovercolor:(color 0 255 0)
	button btInstall "Install" pos:[oiram_setup_dialog.width - 160, oiram_setup_dialog.height - 35] width:70 height:25
	button btExit "Exit" pos:[oiram_setup_dialog.width - 80, oiram_setup_dialog.height - 35] width:70 height:25
	
	local mPluginName = "oiramExporter"
	local mWorkDirectory;
	
	on oiram_setup_dialog open do
	(
		-- 根据插件是否安装, 决定是安装还是卸载
		if (execute mPluginName) != undefined do
			btInstall.text = "UnInstall"
			
		mWorkDirectory = getSourceFileName()
		findPos = findString mWorkDirectory "\\setup.ms"
		mWorkDirectory = substring mWorkDirectory 1 findPos
	)
	
	on btInstall pressed do
	(
		destroydialog oiram_setup_dialog

		if (execute mPluginName) != undefined then
		(
			--UnInstall--
			-- 得到plugin.ini的路径
			pluginIniFile = (GetDir #maxData)
			
			-- plugin.ini从Max2010开始改名为Plugin.UserSettings.ini
			if ((maxVersion())[1]) > 11000 then
				pluginIniFile += "Plugin.UserSettings.ini"
			else
				pluginIniFile += "plugin.ini"

			-- 将插件路径从plugin.ini中去掉
			delIniSetting pluginIniFile "Directories" mPluginName

			-- 删除插件的启动脚本
			deleteFile (GetDir #startupScripts + "\\oiramExporter.ms")
			
			-- 移除菜单
			try (menuMan.unRegisterMenu (menuMan.findMenu "oiramExport") ) catch();
			menuMan.updateMenuBar()
			
			-- 重启3dsmax
			ShellLaunch (GetDir #maxroot + "3dsmax.exe") ""
			quitMAX #noPrompt
		)
		else
		(
			--Install--
			-- 注册菜单
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
			
			-- 确认安装, 将嵌套执行setup.zip(其实是个mzp)
			zipPath = mWorkDirectory + "setup.zip"
			extractDir = ""
			msZip.fileInPackage zipPath &extractDir
		)
	)

	on btExit pressed do
	(
		destroydialog oiram_setup_dialog
	)
)


-- 弹出安装对话框
fn oiram_setup_main =
(
	-- 加载同级目录下的banner图片
	sourcePath = getSourceFileName()
	fromPos = findString sourcePath "setup.ms"
	bannerPath = replace sourcePath fromPos "setup.ms".count "banner.png"
	banner_bitmap = openBitMap bannerPath
	CreateDialog oiram_setup_dialog bitmap:banner_bitmap width:banner_bitmap.width height:banner_bitmap.height modal:true style:#()
)

oiram_setup_main()
