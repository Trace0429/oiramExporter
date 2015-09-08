
function wallworm_getMaxVersion = (
	local versinfo = dotnetclass "System.Diagnostics.FileVersionInfo"
	local myFI = versinfo.GetVersionInfo (pathConfig.appendPath (pathConfig.GetDir #maxroot) "3dsmax.exe")
	local maxExeVersion = myFI.FileVersion
	maxExeVersionArr = filterString maxExeVersion "."
) 

function wallworm_need_update = (
	try (
		global ww_wwmt_version
		global wallworm_userIni
		ww_wwmt_version_new = (dotNetObject "System.Net.WebClient").downloadString "http://wallworm.com/projects/utilities/wwmt_version.txt"
		
		if ww_wwmt_version_new != undefined AND ww_wwmt_version_new != "" then (
			setINISetting wallworm_userIni "Version" "wwmt_newversion" (ww_wwmt_version_new as string)
			if (ww_wwmt_version_new as number > ww_wwmt_version) then (
				
				return true
			) else (
				return false
			)
		) else(
			return undefined
		)
	) catch ()
	undefined
)