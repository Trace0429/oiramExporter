struct wwmt_weightlist (
	name,
	bns=#(),
	weights=#(),
	function getWeightByBoneName boneName = (
		bnIndex = findItem bns boneName 
		if  bnIndex != 0 AND (weights.count >= bnIndex) then (
			return (weights[bnIndex])
		)
	),
	function setWeightByBoneName boneName val= (
		bnIndex = findItem bns boneName 
		
		if  bnIndex == 0  then (
			append bns boneName
			bnIndex = bns.count
		) else (
			
		)
		
		if  (weights.count >= bnIndex) then (
				weights[bnIndex] = val
		) else (
				--assuming to add the next item in array
				append weights val
		)
	),
	function writeWeightListToObject obj = (
		
			if obj != undefined AND isDeleted obj==false do (
			
				propName = "wwmt_weightlist_"+name+"_bones"
				
				boneList = ""
				for b in bns do (
						append boneList (b+",")
						
				)
				setUserProp obj propName  boneList
				
				
				
				propName = "wwmt_weightlist_"+name+"_weights"
				weightList = ""
				for w in weights do (
						append weightList (w as string+",")	
				)
				setUserProp obj propName  weightList
				
				
			)
		
		
	),
	
	function getWeightListFromObj obj = (
		
		if obj != undefined AND isDeleted obj==false do (
			
			
			
				propName = "wwmt_weightlist_"+name+"_bones"
				bnlist = getUserProp obj propName 
				if bnlist != undefined AND bnlist != "" then (
						bnlistA = filterString bnlist ","
						if bnlistA.count > 0 then (
							bns = for b in bnlistA where b != undefined AND (trimLeft(trimRight(b)) != "") collect b
						)
					
				)
			
			
			   propName = "wwmt_weightlist_"+name+"_weights"
				
				weightlist = getUserProp obj propName 
				if weightlist != undefined AND weightlist != "" then (
						weightlistA = filterString weightlist ","
						if weightlistA.count > 0 then (
							weights = for w in weightlistA where w != undefined AND (trimLeft(trimRight(w)) != "") collect (w as float)
						)
					
				)
			
		)
		
	)
	
	
)


Struct wwmt_sequence(
	sequence="idle",
	start=0,
	end=100,
	fps=(frameRate as float),
	type="Reference",
	expReverse=0,
	loop=1,
	events=#(),
	activity="",
	activityWeight=-1.0,
	nd="",
	autoplay=false,
	snap=false,
	realtime=false,
	hidden=false,
	addlayer ="",
	fadeIn=0.2,
	fadeOut=0.2,
	weightlist="",
	animations="",
	asAnimation = false,
	makeSMD = true,
	function setSequence targ = (

			if targ != undefined AND isDeleted targ==false do (
				
				--targ.getWWMT()
				
				--targ.wwmt.setSeqListCust()
				
				
		/*			
				propName = "wwmt_sequence_"+sequence+"_reverse"
				setUserProp targ propName  expReverse
			
			
				propName = "wwmt_sequence_"+sequence+"_end"
				setUserProp targ propName  end
			
				propName = "wwmt_sequence_"+sequence+"_start"
				setUserProp targ propName  start
			
				propName = "wwmt_sequence_"+sequence+"_type"
				setUserProp targ propName  type	
			
				propName = "wwmt_sequence_"+sequence+"_fps"
				setUserProp targ propName fps	
			
				propName = "wwmt_sequence_"+sequence+"_loop"
				setUserProp targ propName loop	
				

				propName = "wwmt_sequence_"+sequence+"_animations"
				setUserProp targ propName  animations
			
			
				propName = "wwmt_sequence_"+sequence+"_asAnimation"
				setUserProp targ propName asAnimation


				
				propName = "wwmt_sequence_"+sequence+"_activity"
				setUserProp targ propName  activity
			
			
				propName = "wwmt_sequence_"+sequence+"_activityWeight"
				setUserProp targ propName  activityWeight
			
				propName = "wwmt_sequence_"+sequence+"_nd"
				setUserProp targ propName  nd
			
				propName = "wwmt_sequence_"+sequence+"_snap"
				setUserProp targ propName  snap	
			
				propName = "wwmt_sequence_"+sequence+"_realtime"
				setUserProp targ propName realtime	
			
				propName = "wwmt_sequence_"+sequence+"_hidden"
				setUserProp targ propName hidden	
				
				
				propName = "wwmt_sequence_"+sequence+"_addlayer"
				setUserProp targ propName  addlayer
			
				propName = "wwmt_sequence_"+sequence+"_fadeIn"
				setUserProp targ propName  fadeIn	
			
				propName = "wwmt_sequence_"+sequence+"_fadeOut"
				setUserProp targ propName fadeOut	
			
				propName = "wwmt_sequence_"+sequence+"_weightlist"
				setUserProp targ propName weightlist	
				
				propName = "wwmt_sequence_"+sequence+"_makeSMD"
				setUserProp targ propName makeSMD	
				
				
				
				
		*/				
				
			)

		),
		
		function sanitize = (
			
			if activity == undefined then (
					activity = ""
			)
			if activityWeight == undefined OR activityWeight == "" then (
				activityWeight=-1.0
			) else (
					activityWeight = activityWeight as float
			)
			if nd == undefined then (
					nd = ""
			)

			if autoplay == undefined then (
				autoplay=false
			) else (
				if autoplay == "true" OR autoplay==true then (
					autoplay=true
				) else (
					autoplay=false
				)
			)
			
			
			
			if snap == undefined then (
				snap=false
			) else (
				if snap == "true" OR snap==true then (
					snap=true
				) else (
					snap=false
				)
			)
			
			if realtime == undefined then (
				realtime=false
			) else (
				if realtime == "true" OR realtime==true then (
					realtime=true
				) else (
					realtime=false
				)
			)
			
			
			
			if hidden == undefined then (
				hidden=false
			) else (
				if hidden == "true" OR hidden==true then (
					hidden=true
				) else (
					hidden=false
				)
			)
			
			if asAnimation == undefined then (
				asAnimation=false
			) else (
				if asAnimation == "true" OR asAnimation==true then (
					asAnimation=true
				) else (
					asAnimation=false
				)
			)
			
			if makeSMD == undefined then (
				makeSMD=true
			) else (
				if makeSMD == "true" OR makeSMD==true then (
					makeSMD=true
				) else (
					makeSMD=false
				)
			)


			

			if addlayer == undefined OR addlayer == "undefined" then (
				addlayer =""
			)
			
			if animations == undefined  OR animations == "undefined" then (
				animations =""
			)
			
			
			if fadeIn == undefined OR fadeIn == "" then (
				fadeIn=0.2
			) else (
					fadeIn = fadeIn as float
			)
			
			if fadeOut == undefined OR fadeOut == "" then (
				fadeOut=0.2
			) else (
					fadeOut = fadeOut as float
			)
			
			if weightlist == undefined OR weightlist=="undefined" then (
				weightlist =""
			)
			if animations == undefined OR animations == "undefined" then (
				animations =""
			)
			
			
			
			
		),
		
		
		
		function getSequenceFromCust targ = (
			if targ != undefined AND isDeleted targ==false do (
				propName = "wwmt_sequence_"+sequence+"_reverse"
				expReverse = getUserProp targ propName 
				
				propName = "wwmt_sequence_"+sequence+"_end"
				end = getUserProp targ propName  
				
				propName = "wwmt_sequence_"+sequence+"_start"
				start = getUserProp targ propName  
				
				propName = "wwmt_sequence_"+sequence+"_type"
				type =  getUserProp targ propName  	
				
				propName = "wwmt_sequence_"+sequence+"_fps"
				fps = getUserProp targ propName 	
					
				propName = "wwmt_sequence_"+sequence+"_loop"
				loop = getUserProp targ propName 	
					
				propName = "wwmt_sequence_"+sequence+"_activity"
				activity = getUserProp targ propName  
			
				propName = "wwmt_sequence_"+sequence+"_activityWeight"
				activityWeight = getUserProp targ propName
			
				propName = "wwmt_sequence_"+sequence+"_nd"
				nd= getUserProp targ propName  
			
				propName = "wwmt_sequence_"+sequence+"_snap"
				snap = getUserProp targ propName  	
			
				propName = "wwmt_sequence_"+sequence+"_realtime"
				realtime = getUserProp targ propName 	
			
				propName = "wwmt_sequence_"+sequence+"_hidden"
				hidden = getUserProp targ propName 	
				
				propName = "wwmt_sequence_"+sequence+"_addlayer"
				addlayer = getUserProp targ propName  
			
				propName = "wwmt_sequence_"+sequence+"_fadeIn"
				fadeIn = getUserProp targ propName  	
			
				propName = "wwmt_sequence_"+sequence+"_fadeOut"
				fadeOut = getUserProp targ propName 	
			
				propName = "wwmt_sequence_"+sequence+"_weightlist"
				weightlist = getUserProp targ propName 	

				propName = "wwmt_sequence_"+sequence+"_animations"
				animations = getUserProp targ propName  
			
				propName = "wwmt_sequence_"+sequence+"_asAnimation"
				asAnimation = getUserProp targ propName 

				propName = "wwmt_sequence_"+sequence+"_makeSMD"
				makeSMD = getUserProp targ propName 



				sanitize()
			)
		)
	
	)