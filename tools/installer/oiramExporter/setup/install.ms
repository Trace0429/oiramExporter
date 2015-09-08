fn oiram_install plugin_name =
(
	pluginPath = GetDir #maxroot + "plugins\\" + plugin_name
	-- 如果插件路径已存在的话, 将其改名备份
	if doesFileExist pluginPath do
	(
		pluginBackupPath = pluginPath + timeStamp() as string
		renameFile pluginPath pluginBackupPath
	)
	
	-- 得到plugin.ini的路径
	pluginIniFile = (GetDir #maxData)
	
	-- plugin.ini从Max2010开始改名为Plugin.UserSettings.ini
	if ((maxVersion())[1]) > 11000 then
		pluginIniFile += "Plugin.UserSettings.ini"
	else
		pluginIniFile += "plugin.ini"

	-- 将插件路径添加到plugin.ini中
	setINISetting pluginIniFile "Directories" plugin_name pluginPath
	
	-- 将安装路径改名为执行路径
	renameFile (GetDir #maxroot + "plugins\\module") pluginPath

	-- 重启3dsmax
	ShellLaunch (GetDir #maxroot + "3dsmax.exe") ""
	quitMAX #noPrompt
)

oiram_install "oiramExporter"
