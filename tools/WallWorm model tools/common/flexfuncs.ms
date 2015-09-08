/*
Wall Worm VTA Helper Function
http://www.wallworm.com

Make a keyframe for every slot in a Morph or Morph-O-Matic modifier

Copyright (c) 2011 by Shawn Olson http://www.shawnolson.net


Function will find a Morph modifier (or Di-O-Matic's Morph-O-Matic modifier)
and apply a keyframe for each channel at 100 weight.

Steps to quicken the creation of VTA flex files for Source.
*/



function wwmt_vta_keyframes obj = (
	local notFound = true
	local i = 1
	for i=1 to obj.modifiers.count while notFound do (
		if classOf obj.modifiers[i] == Morpher OR classOf obj.modifiers[i]  == Morph_O_Matic do (
			notFound = false
		) 
	)
	if notFound == false then (
		
		
		if classOf obj.modifiers[i] == Morpher then (
		  --do morpher code
			
			local usedChannels = #()
			for uc = 1 to 100 do (
				
				if WM3_MC_HasData obj.modifiers[i] uc do (
					append usedChannels uc
					)
					
				)
			
			if usedChannels.count > 0 then (
				set animate on
				for f = 0 to usedChannels.count do (
					

						sliderTime = f
						for c  in usedChannels do (
							
							if f==0 then (

								WM3_MC_SetValue obj.modifiers[i] c 0.0
							) else (
								
								if f == c then (
										WM3_MC_SetValue obj.modifiers[i] c 100.0
									) else (
									
										WM3_MC_SetValue obj.modifiers[i] c 0.0
									)
								
								)
							)
						)

					set animate off
					return true
			) else (
				--no channels uses
				return false
				)
			
			
			
		) else if classOf obj.modifiers[i] == Morph_O_Matic then (
			--do morph-o-matic code
			MOM_HoldLicense()   
			local channels = MOM_GetNumChannels obj.modifiers[i]
			if channels > 0 then (
				set animate on
				for f = 0 to (channels) do (
					sliderTime = f
					for c = 1 to (channels) do (
						
						if f==0 then (
							obj.modifiers[i][c].progressive = 0
							
						) else (
							
							if f == c then (
								obj.modifiers[i][c].progressive = 100
								) else (
								
								obj.modifiers[i][c].progressive = 0
								)
							
							)
						
						
						)
					
					)
					set animate off
					return true
			) else (
					  return false
			)
		)  else (
			  return false
			)
		
		
		) else (
		  return false
		)
	
)


function wwmt_prepare_morphs sel = (
	
	if sel.count > 0 then (
		
		local c = 0
		
		for obj in sel do (
			
			if (wwmt_vta_keyframes obj) do (
				c+=1
				) 
			
			)
			return c
		) else (
			
			return 0
			)
)