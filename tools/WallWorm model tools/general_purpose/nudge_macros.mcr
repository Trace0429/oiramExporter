macroscript wallwormNudgeUp
category:"wallworm.com"
tooltip:"Nudge UP"
buttontext:"Nudge UP"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Up" on
		(
			wallworm_nudge [0,0,wallworm_nudge_amount] 
		)
	)
	
)

macroscript wallwormNudgeDown
category:"wallworm.com"
tooltip:"Nudge DOWN"
buttontext:"Nudge DOWN"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Down" on
		(
			wallworm_nudge [0,0,(wallworm_nudge_amount * -1)] 
		)
	)
	
)

macroscript wallwormNudgeLeft
category:"wallworm.com"
tooltip:"Nudge LEFT"
buttontext:"Nudge LEFT"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Left" on
		(
			wallworm_nudge  [(wallworm_nudge_amount * -1),0,0]  
		)
	)
	
)

macroscript wallwormNudgeRight
category:"wallworm.com"
tooltip:"Nudge RIGHT"
buttontext:"Nudge RIGHT"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Right" on
		(
			wallworm_nudge [wallworm_nudge_amount,0,0] 
		)
	)
	
)


macroscript wallwormNudgeForward
category:"wallworm.com"
tooltip:"Nudge FORWARD"
buttontext:"Nudge FORWARD"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Forward" on
		(
			wallworm_nudge [0,wallworm_nudge_amount,0] 
		)
		
	)
	
)

macroscript wallwormNudgeBack
category:"wallworm.com"
tooltip:"Nudge BACK"
buttontext:"Nudge BACK"
(
	on execute do (
		global wallworm_nudge_amount
		
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Back" on
		(
			wallworm_nudge [0,(wallworm_nudge_amount * -1),0] 
		)
	)
	
)


macroscript wallwormSuperNudgeUp
category:"wallworm.com"
tooltip:"Nudge UP"
buttontext:"Nudge UP"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		
		undo "Nudge Up" on
		(
			wallworm_nudge [0,0,(wallworm_nudge_amount * wallworm_super_nudge_mult)] 
		
		)
	)
	
)

macroscript wallwormSuperNudgeDown
category:"wallworm.com"
tooltip:"Super Nudge DOWN"
buttontext:"Super Nudge DOWN"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Down" on
		(
			wallworm_nudge [0,0,(wallworm_nudge_amount  * wallworm_super_nudge_mult * -1)] 
		)
	)
	
)

macroscript wallwormSuperNudgeLeft
category:"wallworm.com"
tooltip:"Super Nudge LEFT"
buttontext:"Super Nudge LEFT"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Left" on
		(
			wallworm_nudge  [(wallworm_nudge_amount * wallworm_super_nudge_mult * -1),0,0]  
		)
	)
	
)

macroscript wallwormSuperNudgeRight
category:"wallworm.com"
tooltip:"Super Nudge RIGHT"
buttontext:"Super Nudge RIGHT"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Right" on
		(
			wallworm_nudge [(wallworm_nudge_amount * wallworm_super_nudge_mult),0,0] 
		)
	)
	
)


macroscript wallwormSuperNudgeForward
category:"wallworm.com"
tooltip:"Super Nudge FORWARD"
buttontext:"Super Nudge FORWARD"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Forward" on
		(
			wallworm_nudge [0,(wallworm_nudge_amount * wallworm_super_nudge_mult),0] 
		)
	)
	
)

macroscript wallwormSuperNudgeBack
category:"wallworm.com"
tooltip:"Super Nudge BACK"
buttontext:"Super Nudge BACK"
(
	on execute do (
		global wallworm_nudge_amount
		global wallworm_super_nudge_mult
		if wallworm_nudge_amount == undefined then (
			filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"			
		)
		undo "Nudge Back" on
		(
			wallworm_nudge [0,(wallworm_nudge_amount * wallworm_super_nudge_mult * -1),0] 
		)
	)
	
)








macroscript wallwormOpenNudgeRollout
category:"wallworm.com"
tooltip:"Nudge UI"
buttontext:"Nudge UI"
(
	on execute do (
		
		global wallwormNudgeRollout
		global wallworm_userIni
		
		if wallworm_userIni == undefined then (
			fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
		)
		
		/*See if the UI position was set before*/
		thePos = getINISetting wallworm_userIni "Nudge" "ui_pos"
		if thePos != undefined AND thePos != "" then (
			execute ("wwNudgeUILocation =  "+ thePos)
		)
		global wwNudgeUILocation
		if wwNudgeUILocation == undefined OR classOf wwNudgeUILocation != Point2 then (
			wwNudgeUILocation = [20,20]
		) else ()
		
		
		filein "$scripts/WallWorm.com/general_purpose/wallworm_nudge.ms"
		rollout wallwormNudgeRollout "Nudge Settings" width:249 height:270
		(
			spinner spnNudgeAmount "Nudge Amount" pos:[84,13] width:141 height:16 range:[1,16000,8] type:#integer scale:1
			spinner spnSuperMult "Super Nudge Multiplier" pos:[76,37] width:148 height:16 enabled:true range:[2,1024,16] type:#integer scale:1
			button btnX "X" pos:[123,87] width:91 height:15
			button btnXmin "-X" pos:[28,87] width:91 height:15
			button btnY "Y" pos:[123,108] width:91 height:15
			button btnYmin "-Y" pos:[28,108] width:91 height:15
			button btnZ "Z" pos:[123,130] width:91 height:15
			button btnZmin "-Z" pos:[28,130] width:91 height:15
			button btnXSup "X *" pos:[124,186] width:91 height:15
			button btnXminSup "-X *" pos:[29,186] width:91 height:15
			button btnYSup "Y *" pos:[124,207] width:91 height:15
			button btnYminSup "-Y *" pos:[29,207] width:91 height:15
			button btnZSup "Z *" pos:[124,229] width:91 height:15
			button btnZminSup "-Z *" pos:[29,229] width:91 height:15
			GroupBox grp1 "Super Nudge" pos:[16,167] width:210 height:88
			GroupBox grp2 "Nudge" pos:[15,68] width:211 height:92
			
			on wallwormNudgeRollout moved pos do
			(
							global wallworm_userIni
							setINISetting wallworm_userIni "Nudge" "ui_pos" (pos as string)
						)
			on spnNudgeAmount entered do
			(
							global wallworm_userIni
							global wallworm_nudge_amount = spnNudgeAmount.value
							setINISetting wallworm_userIni "Nudge" "nudgeAmount" (spnNudgeAmount.value as string)
					
			)
			on spnSuperMult entered do
			(
				global wallworm_userIni
				global wallworm_super_nudge_mult = spnSuperMult.value
				setINISetting wallworm_userIni "Nudge" "superNudgeAmount" (spnSuperMult.value as string)
			)
			on btnX pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeRight"	
			)
			on btnXmin pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeLeft"	
			)
			on btnY pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeForward"	
			)
			on btnYmin pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeBack"	
			)
			on btnZ pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeUp"	
			)
			on btnZmin pressed do
			(
				macros.run "wallworm.com" "wallwormNudgeDown"	
			)
			on btnXSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeRight"	
			)
			on btnXminSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeLeft"	
			)
			on btnYSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeForward"	
			)
			on btnYminSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeBack"	
			)
			on btnZSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeUp"	
			)
			on btnZminSup pressed do
			(
				macros.run "wallworm.com" "wallwormSuperNudgeDown"	
			)
		)
		
		createDialog wallwormNudgeRollout pos:wwNudgeUILocation
		
	)
)
