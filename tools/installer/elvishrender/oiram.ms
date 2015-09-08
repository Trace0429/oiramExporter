fn oiram_install plugin_name =
(
	-- 查找插件是否已存在
	pluginExists = false
	pluginCount = pluginPaths.count()
	for n = 1 to pluginCount do
	(
		path = pluginPaths.get(n)
		if findString path plugin_name != undefined do
		(
			pluginExists = true
			exit
		)
	)
	
	-- 得到plugin.ini的路径
	pluginIniFile = (GetDir #maxData)
	-- plugin.ini从Max2010开始改名为Plugin.UserSettings.ini
	if ((maxVersion())[1]) > 11000 then
		pluginIniFile += "Plugin.UserSettings.ini"
	else
		pluginIniFile += "plugin.ini"

	-- 如果插件已存在
	if pluginExists then
	(
		-- 将插件路径从plugin.ini中去掉
		delIniSetting pluginIniFile "Directories" plugin_name

		callbacks.removeScripts #preSystemShutdown id:#oiram_install
	)
	-- 如果不存在
	else
	(
		pluginPath = GetDir #maxroot + "plugins\\" + plugin_name
		-- 如果插件路径已存在的话, 将其改名备份
		if doesFileExist pluginPath do
		(
			pluginBackupPath = pluginPath + timeStamp() as string
			renameFile pluginPath pluginBackupPath
		)
		
		-- 将插件路径添加到plugin.ini中
		setINISetting pluginIniFile "Directories" plugin_name pluginPath
		
		-- 将安装路径改名为执行路径
		renameFile (pluginPath + "_install") pluginPath
		
		files = getFiles (pluginPath + "\\bin\\*.*")
		for f in files do
		(
			copyFile (f) (GetDir #maxroot)
		)
	)

	-- 重启3dsmax
	ShellLaunch (GetDir #maxroot + "3dsmax.exe") ""
	quitMAX #noPrompt
)


fn oiram_clean =
(
	deleteFile (GetDir #startupScripts + "\\oiram.ms")
	deleteFile (GetDir #startupScripts + "\\oiram_startup.ms")
)
