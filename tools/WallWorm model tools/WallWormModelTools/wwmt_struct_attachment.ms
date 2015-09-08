Struct wwmt_attachment(
	attachment,
	pb,
	absolute=true,
	rigid=true,
	--rot,
	atPoint,
	
	function setAsWWMTAttachment = (
		if atPoint != undefined AND isDeleted atPoint == false then (
			
			setUserProp atPoint "wwmt_is_attachment" true
			setUserProp atPoint "wwmt_attachment_name" attachment
			)
		
	),
	function setAttachment targ = (
		
		--if targ != undefined do (
		
			propName = "wwmt_attachment_"+attachment+"_attachment"
			setUserProp targ propName  attachment
		
		
			propName = "wwmt_attachment_"+attachment+"_pb"
			if pb != undefined  then (
				--AND classOf pb==Bone  AND pb.isDeleted==false
				setUserProp targ propName  pb
				
			) else (
				setUserProp targ propName  ""
				)
		
			propName = "wwmt_attachment_"+attachment+"_absolute"
			setUserProp targ propName  absolute
		
			propName = "wwmt_attachment_"+attachment+"_rigid"
			setUserProp targ propName  rigid	
		
			--propName = "wwmt_attachment_"+attachment+"_rot"
			--setUserProp targ propName rot	
		
			propName = "wwmt_attachment_"+attachment+"_atPoint"
			setUserProp targ propName atPoint.name	
		--)
		
		),
		
		function getAttachmentFromCust targ = (
			
		propName = "wwmt_attachment_"+attachment+"_absolute"
		absolute = getUserProp targ propName 
		
		
		propName = "wwmt_attachment_"+attachment+"_pb"
		tempPb = getUserProp targ propName  
		if tempPb != undefined AND tempPb != 0 do (	
		local b = getNodeByName (tempPb as string)
		if b != undefined AND isDeleted b == false do (
			-- AND classOf b ==Bone
			if isDeleted b == false do (
				
				pb = tempPb
				
				)
			
			)
		)
		
		
		propName = "wwmt_attachment_"+attachment+"_rigid"
		rigid= getUserProp targ propName  
		
		--propName = "wwmt_attachment_"+attachment+"_rot"
		--rot =  getUserProp targ propName  	
		
		propName = "wwmt_attachment_"+attachment+"_atPoint"
		local tempPt = getUserProp targ propName 	
			
		tp = getNodeByName tempPt
		if tp != undefined do (
			--if isDeleted tp== false AND classOf tp == Point do (	
			if isDeleted tp== false do (
				
				atPoint = tp
				setAsWWMTAttachment()
				)
			
			)
			
			
			),
	
	
			
			function getMyRotation = (
				
				/*
				!TODO
				
				This function is not really returning the needed rotations for all props.
				*/
				return (in coordsys parent atPoint.transform.rotationPart as eulerAngles)
				
				if atPoint.controller != undefined then (
						--print "got controller rot"
						return (atPoint.controller.rotation as eulerAngles)


				) else (
					
						--print "got rot"
						return (atPoint.rotation as eulerAngles)
						

					
					)
			)
	
	
	)