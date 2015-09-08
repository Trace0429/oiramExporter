fileIn "oiram.ms"
pluginPath = GetDir #maxroot + "plugins\\elvishrender\\maxconnection.dlr"
if not (doesFileExist pluginPath) then
	oiram_install "elvishrender"
else
	callbacks.addScript #preSystemShutdown "oiram_clean()" id:#oiram_install
