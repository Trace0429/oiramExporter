fn oiramFilenameFromPathNew p = getfilenamefile p + getfilenametype p 
rollout oiramMissingMapDlg "Missing Maps" width:460 height:305
(
	local Objs,missMaps,missingMapsTemp,missingMapsObjs
	fn trim_dupsOne a = (
		for i in a.count to 1 by -1 do 
		(
			idx = findItem a a[i]
			if (idx != 0) AND (idx != i) do 
				deleteItem a i
		)
		a
	)

	fn getMissingMaps = 
	(
		local mapfiles = #()
		local mapfileN = #()
		local mapWebfile = #()
		local mBitmaps = getClassInstances BitmapTexture		-- gets all bitmapTextures in the scene

		mapfiles = mBitmaps										-- copies the array instance to "mapfiles"
		for m in mapfiles do (
			-- for every bitmap texture in the scene
			if (isProperty m #filename) then (
				-- that has a #filename property	
				if m.filename != "" then (
					-- that isn't blank
					if not (doesFileExist m.filename) then		-- if it doesn't exist, add to the array mapfileN
						append mapfileN m.filename
				)
			)
		)
		if (not(doesFileExist(backgroundImageFilename))) then
			append mapfileN backgroundImageFilename
		trim_dupsOne mapfileN
		sort mapfileN
		--Collect missing webfiles
		for l in lights do
			if matchPattern (classof l as string) pattern:"Target_*" then
			(	local p = l.webfile
				if p != "" and not doesfileexist p then
					append mapWebfile p
			)
		if mapWebfile.count !=0 then
		(	trim_dupsOne mapWebfile
			sort mapWebfile
			join mapfileN mapWebfile
		)

		for i = 1 to mapfileN.count where mapfileN[i] == "" do deleteItem mapfileN i
		mapfileN											-- returns the new array of only missing bitmaptextures
	) 

	fn getMissingMapsObjs = 
	(
		missingMapsTemp = missMaps
		missingMapsObjs = #()
		if 	missingMapsTemp.count != 0 then
		(	
			-- initialize missingMapsObjs
			for o = 1 to missingMapsTemp.count do
				append missingMapsObjs #()
			-- called for enumerateFiles()
			fn addmapObjs map obj = 
			(
				local missingMapfilename = map as string
				local Idx = findItem missingMapsTemp missingMapfilename 
				if Idx != 0 do append missingMapsObjs[Idx] obj 
			)
			for i = 1 to objects.count where objects[i].material != undefined do		-- cycle through the scene objects
				enumerateFiles objects[i] addmapObjs objects[i] #missing	
			for j in lights where matchPattern (classof j as string) pattern:"Target_*" do
				enumerateFiles j addmapObjs j #missing
		)
		for k in missingMapsObjs do trim_dupsOne k 
		missingMapsObjs 										-- return the array of only missing bitmaptextures
	)
	
	--Clear selected missing maps
	fn clrMissingMaps = 
	(	
		local mapfiles = #()
		local mBitmaps = getClassInstances BitmapTexture
		
		if (not(doesFileExist(backgroundImageFilename))) then
			append mBitmaps backgroundImageFilename
		
		mapfiles = mBitmaps
		local clrSelection = oiramMissingMapDlg.lbx_missingMaps.selection as array
		if clrSelection.count != 0 then
		(	local clrMissingMaps = #()
			for c = 1 to clrSelection.count do
				append clrMissingMaps (oiramFilenameFromPathNew oiramMissingMapDlg.lbx_missingMaps.items[c]) --Get the map than will be cleared
			with redraw off (
				for i=1 to mapfiles.count do (
					-- for all bitmapTextures in the scene
					if (isProperty mapfiles[i] #filename) then (
						local curFile = oiramFilenameFromPathNew mapfiles[i].filename
						if (index = findItem clrMissingMaps curFile) != 0 then 	-- check if the current file is missing
								mapfiles[i].filename = ""		-- Clear the current file
					)
				)
				if (not(doesFileExist(backgroundImageFilename))) then (
					for i=1 to mapfiles.count do (
						local curFile = oiramFilenameFromPathNew (mapfiles[i] as string)
						if (index = findItem clrMissingMaps  curFile) != 0 then
							backgroundImageFilename = ""  -- Clear the background
					)
				)
			)
		)
	)

	--Display the objects relective to the missing map
	fn displayObjs sel =
	(
		s = sel
		if s != 0 then
		(
			if Objs[s].count != 0 then
			(
				objsNamesString = ""
				n = 0
				for o in 1 to Objs[s].count-1 while objsNamesString.count<100 do 
				(
					append objsNamesString (Objs[s][o].name+", ")
					n+=1
				)
				append objsNamesString Objs[s][n+1].name
				oiramMissingMapDlg.edt_missingmapObjs.text = objsNamesString 
			) 
			else oiramMissingMapDlg.edt_missingmapObjs.text = "Cannot find object with the map."
		)
	)

	multiListBox lbx_missingMaps "Missed Maps Path:" pos:[5,35] width:450 height:15
	button btn_refeshMaps "Refresh" pos:[388,12] width:65 height:25
	button btn_missMapObjs "Select" pos:[299,12] width:65 height:25
	edittext edt_missingmapObjs "Object with missed map:" pos:[5,260] width:450 height:20 readOnly:true labelOnTop:true
	button btn_delSelectedMaps "Delete" pos:[210,12] width:65 height:25

	on oiramMissingMapDlg open do	--Initialize this dialog
		btn_refeshMaps.pressed()

	on lbx_missingMaps selected sel do
	(
		local selItem = (lbx_missingMaps.selection as array)[1]
		if selItem != undefiend then
			if missMaps[selItem] != "" then displayObjs selItem
	)
	
	on lbx_missingMaps doubleClicked sel do
		btn_missMapObjs.pressed()
		
	on btn_refeshMaps pressed do
	(	
		missMaps = getMissingMaps()
		if missMaps[1] == undefiend then
		(
			lbx_missingMaps.items = #()
			edt_missingmapObjs.text = "Cannot find any missing maps."
		)
		else
		(	
			lbx_missingMaps.items = missMaps
			Objs = getMissingMapsObjs()
			if missMaps.count !=0 then 
			(	
				lbx_missingMaps.selection = 1
				displayObjs 1
			)
		)
	)
	
	on btn_missMapObjs pressed do
	(
		index = (lbx_missingMaps.selection as array)[1]
		if index != undefiend then
			if missMaps[index] != "" then
			(
				popup = false
				if Objs[index].count != 0 then try select Objs[index] catch popup = true
				else popup = true
				if popup then messagebox "May use the map object has been deleted, please refresh." title:"oiramAssistant" beep:off
			)
	)

	on btn_delSelectedMaps pressed do
	(
		clrMissingMaps ()
		btn_refeshMaps.pressed()
	)
)


fn oiramMissingMaps =
(
	try destroydialog oiramMissingMapDlg catch()
	createdialog oiramMissingMapDlg style:#(#style_titlebar, #style_border, #style_sysmenu)
)
