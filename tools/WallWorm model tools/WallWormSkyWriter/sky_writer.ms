/*  
Wall Worm Productions
http://www.wallworm.com

Wall Worm Sky Writer
by Shawn Olson
http://www.shawnolson.net


Get the latest version at:
http://dev.wallworm.com/topic/43/sky_writer.html


Special Thanks to Fabian Groﬂ of 48Design.de for writing the PFM Exporter.
http://www.zwischendrin.com

*/


include "$scripts/WallWorm.com/common/config.ms"
include "$scripts/WallWorm.com/common/ww_common_funcs.ms"
include "$scripts/WallWorm.com/common/write_pfm.ms"

if wwmt_exportMats == undefined OR wwmt_exportMats == ""  OR wwmt_binDir == undefined OR wwmt_binDir == "" then (
	
	messagebox "In order to use Sky Writer, you must make sure to set the Material root for your mod and the Bin Directory.\n\nSet them then restart Sky Writer."
	filein "$scripts\\WallWorm.com\\WallWormModelTools\\wwmtconfigutility.ms"
	
	) else (
	
	


global ww_wwsw_version = 1.1
global ww_wwsw_sky_box
global ww_wwsw_sky_resolutions = #(128,256,512, 1024, 2048, 4096) 
global ww_wwsw_sides = #("rt","lf","ft","bk")			
/*
				#((quat 0.707107 0.707107 0 0),"up"), 
				#((quat 0 0 0.707107 0.707107),"dn"),	
				#((quat -0.5 -0.5 -0.5 -0.5),"rt"),
				#((quat 0.5 -0.5 -0.5 0.5),"lf"),
				#((quat 0 0.707107 0.707107 0),"bk"),
				#((quat 0.707107 0 0 0.707107),"ft")
*/
global 	ww_wwsw_cubeFaces = #(	
				#((quat -0.707107 0.707107 0 0),"up"), 
				#((quat 0 0 -0.707107 0.707107),"dn"),	
				#((quat 0.5 -0.5 -0.5 0.5),"rt"),
				#((quat -0.5 -0.5 -0.5 -0.5),"lf"),
				#((quat 0.707107 0 0 0.707107),"bk"),
				#((quat 0 0.707107 0.707107 0),"ft")
				
			)
/*
global ww_wwsw_defaultGamma = fileOutGamma
			
	if IDisplayGamma.colorCorrectionMode == #none do (
		if (classOf SceneExposureControl.exposureControl == mr_Photographic_Exposure_Control ) then (		
			ww_wwsw_defaultGamma = 2.2		
		) else (
			ww_wwsw_defaultGamma = 1.0	
			)
	)		
*/
global ww_wwsw_defaultGamma = 2.2			
			

function ww_wwsw_getGamma = (

				local g = getUserProp ww_wwsw_sky_box "wwsw_gamma"
				   
				if g != undefined AND g != "" then (
					g =((getUserProp ww_wwsw_sky_box "wwsw_gamma") as float)
					
					
				) else (
					g = ww_wwsw_defaultGamma
				)
				return g
	)

	
function ww_wwsw_getGammaHDR = (

				local g = getUserProp ww_wwsw_sky_box "wwsw_gamma_hdr"
				   
				if g != undefined AND g != "" then (
					g =((getUserProp ww_wwsw_sky_box "wwsw_gamma_hdr") as float)
					
					
				) else (
					g = 1
				)
				return g
	)
	
	
	function ww_wwsw_runSkyBatch = (


		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false then (
		
			local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
			batchName  = wwmt_exportMats+"\\skybox\\"+sn+".bat"	

			studiopath = wwmt_binDir+"\\"+"vtex.exe"
			if doesFileExist (studiopath) then (
				
				if ((maxVersion())[1] >= 14000) then (
					shellLaunch (wwmt_exportMats+"\\skybox\\"+sn+"_2012.bat") ""
				) else (
					shellLaunch batchName ""	
				)
			)	 else (
			
				messagebox "The batch Compiler cannot run because VTEX.exe isn't in the specified directory."
			)	
			
		) else (
			
			messagebox "The sky doesn't exist"
			
			)
		
		
	)
			
		
function ww_wwsw_createHalfSizes = (
	

		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
		
		
		
		
		)
	
	
	
	)

function ww_wwsw_makeCubeCross b s  =  (

	if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false then (
				
				
				local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
				if sn==undefined do (
					sn=""
					)
				
				local hdrfile = wwmt_exportMats+"\\skybox\\"+(sn as string)+".tga"
				--local ldrfile = wwmt_exportMats+"\\skybox\\"+(sn as string)+".tga"
				try (
					Targa.setColorDepth 32
					Targa.setAlphaSplit true
					Targa.setPreMultAlpha true
					
					try (
					local g = (ww_wwsw_getGammaHDR() as float)
					) catch (
						g = 1
						)
						hdrCross = undefined
						hdrCross = bitmap (s * 4) (s * 3) filename:hdrfile gamma:g HDR:true Color:(color 128 128 128 0) PixelAspect:1 colorDepth:32


						freeSceneBitmaps()


						--Top
						pasteBitmap  b[1] hdrCross (box2 0 0 s s) [s*3,0] 
						--Back
						pasteBitmap  b[6] hdrCross (box2 0 0 s s) [0,s]
						--Left
						pasteBitmap  b[4] hdrCross (box2 0 0 s s) [s,s] 
						--Front
						pasteBitmap  b[5] hdrCross (box2 0 0 s s) [s*2,s]
						--Right
						pasteBitmap  b[3] hdrCross (box2 0 0 s s) [s*3,s]
						--bottom
						pasteBitmap  b[2] hdrCross (box2 0 0 s s) [s*3,s*2]
						



						wallwormWritePFM hdrCross 2 filename:(wwmt_exportMats+"\\skybox\\"+(sn as string)+".hdr.pfm")

						save hdrCross 





-- 						ldrCross = undefined
-- 						ldrCross = bitmap (s * 4) (s * 3) \
-- 						filename:ldrfile \
-- 						gamma:g \ 
-- 						HDR:false \
-- 						Color:(color 128 128 128 0) \
-- 						PixelAspect:1 --\


-- 						freeSceneBitmaps()


-- 						--Top
-- 						pasteBitmap  b[1][2] ldrCross (box2 0 0 s s) [s*3,0] 
-- 						--Front
-- 						pasteBitmap  b[5][2] ldrCross (box2 0 0 s s) [0,s]
-- 						--Left
-- 						pasteBitmap  b[4][2] ldrCross (box2 0 0 s s) [s,s] 
-- 						--back
-- 						pasteBitmap  b[6][2] ldrCross (box2 0 0 s s) [s*2,s]
-- 						--Right
-- 						pasteBitmap  b[3][2] ldrCross (box2 0 0 s s) [s*3,s]
-- 						--bottom
-- 						pasteBitmap  b[2][2] ldrCross (box2 0 0 s s) [s*3,s*2]
-- 						

-- 						save ldrCross 					
					
					
					
					
					
					
					
					
					) catch(
						print (getCurrentException() as string)
						messagebox ("There was an error making the cube cross image:\n\n"+(getCurrentException()))
						  
					
					)


	 ) else (
		messagebox "Please pick a Sky Writer Helper first or create a new one."
	 
	 )

	
	)



function ww_wwsw_setSkyName n = (
		include "$scripts/WallWorm.com/common/config.ms"
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
			
			n = wallworm_makeStringSafe(n)
			setUserProp ww_wwsw_sky_box "wwsw_skyname" n
			
			
						local skyname = wwmt_exportMats+"\\skybox\\"+(n as string)+"_hdr.tga"
						ww_wwsw_sky_box.mat.reflectionMap.outputname = skyname
			
		)
		return n
	)
	
	
	function ww_wwsw_giveDiffuseMap &mat = (

		if mat.diffuseMap == undefined do (

			mat.diffuseMap = BitMapTexture filename:"$scripts\\WallWorm.com\assets\\wwsw_helper_diffuse.png"
			
			--mat.diffuseMap.coords.U_Angle = 180
			--mat.diffuseMap.coords.W_Angle = 180
			--mat.twoSided = on
				
			
			
			)
			
			
			if mat.selfillumMap == undefined do (
				
				mat.selfillumMap = mat.diffuseMap 
				mat.useSelfIllumColor = on

				
				)

		
		mat.showInViewport = true

		)
		
		
	function ww_wwsw_checkExposureSettings = (
		

		if ( (classOf SceneExposureControl.exposureControl == Automatic_Exposure_Control) OR (classOf SceneExposureControl.exposureControl == Linear_Exposure_Control) ) then (
			
			return false
			
			) else (
			
			return true
			
			)
		)	
		
		function ww_wwsw_checkGamma = (
			
			
			if (classOf SceneExposureControl.exposureControl == Logarithmic_Exposure_Control) do (
				
				
				
				
				
				
				)
			
			
			
			)
		
		
	
function ww_wwsw_setSkyOutputName state = (
	
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
			--include "$scripts/WallWorm.com/common/config.ms"
			
			local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
			if sn==undefined do (
				sn=""
				)
			
			local skyname = wwmt_exportMats+"\\skybox\\"+(sn as string)+"_hdr.tga"
							ww_wwsw_sky_box.mat.reflectionMap.outputname = skyname
			
-- 			if state ==true then (
-- 				
-- 				skyname+= "dds"
-- 				) else (
				
				--skyname+= "tga"
				
				--)
			
				

				
			)
			
	
	)
	
			
					
					function writeSkyVMT texname side ldr:false oldcubepath:true valveShader:"Sky"= (
						global wwmt_gameInfoDir
						if ldr == true OR oldcubepath==false then (
							local hdrext = ""
							) else (
								local hdrext = "_hdr"
							)
						
							vmtfilename = wwmt_gameInfoDir+"/materials/skybox/"+texname+side+hdrext+".vmt"
						
							if doesFileExist vmtfilename == true then (
								local vmtfile = OpenFile (vmtfilename) mode:"w"
								) else (
								local vmtfile = CreateFile(vmtfilename)	
							)
							local extra = ""
							
							
							if ldr == true then (
								local extra = "basetexture\t\"skybox/"+texname+side+"\"\n"
								append extra ("hdrbasetexture\t\"skybox/"+texname+"_hdr"+side+"\"\n")
								
								
							) else (
								local extra = "basetexture\t\"skybox/"+texname+"_hdr"+side+"\"\n"
								
							)
							
							
							
							
							bt = ("\""+valveShader+"\"\n{\n$nofog 1\n$ignorez 1\n"+extra+"}")
							Format bt to:vmtfile
						
						
							close vmtfile
						)
						
	function writeBatchFile = (
		    local errors = #()
		
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
				
					--include "$scripts/WallWorm.com/common/config.ms"
					local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
					batchName  = (wwmt_exportMats)+"\\skybox\\"+sn+".bat"	
				
					
					
						if (makeDir (wwmt_exportMats+"\\skybox") all:true) == false do (
						
							append errors ("The Path you want to export to does not exist. Please make sure to create the following path.:\n\n" +wwmt_exportMats+"\\skybox")
						
						)
						try (					
							if doesFileExist batchName == true then (
								local newBatch = OpenFile (batchName) mode:"w"
							) else (
								local newBatch = CreateFile(batchName)
							
							)

						
					) catch(
						
						append errors ("Sky writer does not have permission to write to this directory:\n\n" +wwmt_exportMats+"\\skybox")
						
						)
				if errors.count == 0 then(
					
					
					

					
					useSkyShader = getUserProp ww_wwsw_sky_box "wwsw_use_skyshader"
					local valveShader = "Sky"
					if useSkyShader == undefined OR useSkyShader == "true" OR useSkyShader==true then (
						
						valveShader = "Sky"
						
					) else (
						valveShader = "UnlitGeneric"
					)
					
					
					local gameInfoParam = ""
					if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
						append gameInfoParam (" -game \""+wwmt_gameInfoDir+"\"")
					) 
						
					local tFormat = getUserProp ww_wwsw_sky_box "wwsw_tformat"
					if tFormat == undefined OR tFormat == "" do (
						tFormat = false
					)	
					
					local usetFormat = getUserProp ww_wwsw_sky_box "wwsw_use_tformat"
					if usetFormat == undefined OR usetFormat == "" do (
						usetFormat = false
					)	
					
						
					if tFormat == true AND usetFormat == false do (

						append gameInfoParam "  -oldcubepath"
					)
			

					--local	usePFM = true

					Format "@echo on\n" to:newBatch	
							
					--local bt = "cd \""+wwmt_binDir+">\"\n" 
					--Format bt to:newBatch
					
						
						
						
					local fytext = ""
					--if (usePFM != undefined AND usePFM == true) do (
						
						local pfmscale = getUserProp ww_wwsw_sky_box "wwsw_pfm_brightness"
						if pfmscale == undefined OR pfmscale == "" do (
							pfmscale = 1
							)
						
							fytext = "pfm 1\npfmscale "+(pfmscale as string)+"\n"
						
						--)  
						
				local useHalf = getUserProp ww_wwsw_sky_box "wwsw_halfsides"	
				if useHalf == undefined then (
					useHalf = false
				)
				
				--local	usePFM = getUserProp ww_wwsw_sky_box "wwsw_pfm"
				local mkTiny = getUserProp ww_wwsw_sky_box "wwsw_tinyb"	
				if mkTiny == undefined then (
					mkTiny = false
				)
				
				local useSkyFlag = true
				local skyboxLine = "skybox 1\n"
				if useHalf == true or mkTiny == true then (
					useSkyFlag = false
					skyboxLine = ""
				)
					
					/*Text to control compiling parameters for images. Written to skytextfile and skytextfileL below.*/
				append fytext ("clamps 1\nclampt 1\n"+skyboxLine+"nocompress 1\nnomip 1\nnolod 1\nnonice 1")
				local fytextL = ("clamps 1\nclampt 1\n"+skyboxLine+"nomip 1\nnolod 1\nnonice 1\nnocompress 1")
				
				if usetFormat == true then (
					
					
							local sideName = sn+"_hdr"
							local sideNameHDR = sn+"_hdr.hdr"
							local sideNameL = sn
							local textName  = wwmt_exportMats+"\\skybox\\"+sideName+".txt"		
							local textNameL  = wwmt_exportMats+"\\skybox\\"+sideNameL+".txt"							
							
							/*Create text files to store compile flags for the sky images.*/
							
							if doesFileExist textName == true then (
								local skytexfile = OpenFile (textName) mode:"w"
								) else (
								local skytexfile = CreateFile(textName)	
							)

							if doesFileExist textNameL == true then (
								local skytexfileL = OpenFile (textNameL) mode:"w"
							) else (
								local skytexfileL = CreateFile(textNameL)	
							)

							
							Format fytext to:skytexfile
							close skytexfile
							
							
							Format fytextL to:skytexfileL
							close skytexfileL
							

							fname = wwmt_exportMats+"\\skybox\\"+sideName+".hdr.pfm"
							fnameGO = wwmt_exportMats+"\\skybox\\"+sideName+".hdr.pfm"
							bname = wwmt_exportMats+"\\skybox\\"+sideNameL
/*
							vmts = ""

							fname2 = wwmt_exportMats+"\\skybox\\half_"+sideName+".hdr.pfm"
							bname2 = wwmt_exportMats+"\\skybox\\half_"+sideNameL+".tga"
							
							
							fname3 = wwmt_exportMats+"\\skybox\\tiny_"+sideName+".hdr.pfm"
							bname3 = wwmt_exportMats+"\\skybox\\tiny_"+sideNameL+".tga"
							
						
						*/

/*
						bt = "vtex.exe"+gameInfoParam+" -nopause -mkdir -shader Sky -vmtparam $nofog 1 -vmtparam $ignorez 1 -vmtparam $hdrbasetexture \"skybox/"+sideNameHDR+"\""+vmts+"  \""+ bname+"\"\n"
						Format bt to:newBatch
						*/
						bt = "\""+wwmt_binDir+"\vtex.exe\""+gameInfoParam+" -nopause -mkdir -shader "+valveShader+" -vmtparam $nofog 1 -vmtparam $ignorez 1 \""+ fnameGO+"\"\n"
						Format bt to:newBatch
					
					
					/*
						bt = "vtex.exe"+gameInfoParam+" -oldcubepath -nopause -mkdir \""+ bname+"ft.tga\" \""+ bname+"lf.tga\" \""+ bname+"bk.tga\" \""+ bname+"rt.tga\" \""+ bname+"up.tga\" \""+ bname+"dn.tga\"\n"
						Format bt to:newBatch
						*/		

						--format  ("rename \""+wwmt_exportMats+"\\skybox\\"+sn+"_hdr.pfm"+"\" \""+wwmt_exportMats+"\\skybox\\"+sn+"_hdr.hdr.pfm\"\n")  to:newBatch

						--bt = "vtex.exe"+gameInfoParam+" -nopause -mkdir \""+ wwmt_exportMats+"\\skybox\\"+sn+"_hdr.pfm\"\n"
						--Format bt to:newBatch
						
						writeSkyVMT sn "" ldr:false oldcubepath:false valveShader:valveShader
						
						
						--format  ("rename \""+wwmt_exportMats+"\\skybox\\"+sn+"_hdr.hdr.pfm"+"\" \""+wwmt_exportMats+"\\skybox\\"+sn+"_hdr.pfm\"\n")  to:newBatch

			/*
						bt = "vtex.exe"+gameInfoParam+" -oldcubepath -nopause -mkdir \""+ bname+"_hdrft.pfm\" \""+ bname+"_hdrlf.pfm\" \""+ bname+"_hdrbk.pfm\" \""+ bname+"_hdrrt.pfm\" \""+ bname+"_hdrup.pfm\" \""+ bname+"_hdrdn.pfm\"\n"
						Format bt to:newBatch
					*/
					
					) else (
			
						index = 1
						for face in ww_wwsw_cubeFaces do (
							
			
							
							
							--local baseName = sn+(ww_wwsw_cubeFaces[index][2])
							/*
							local sideName = sn+"_hdr"+(ww_wwsw_cubeFaces[index][2])
							local sideNameHDR = sn+"_hdr"+(ww_wwsw_cubeFaces[index][2])+".hdr"*/
							
							local sideName = sn+(ww_wwsw_cubeFaces[index][2])
							local sideNameHDR = sn+(ww_wwsw_cubeFaces[index][2])+".hdr"
							
							local sideNameL = sn+(ww_wwsw_cubeFaces[index][2])
							local textName  = wwmt_exportMats+"\\skybox\\"+sideName+".hdr.txt"		
							local textNameL  = wwmt_exportMats+"\\skybox\\"+sideNameL+".txt"							
							
							/*Create text files to store compile flags for the sky images.*/
							
							if doesFileExist textName == true then (
								local skytexfile = OpenFile (textName)mode:"w"
								) else (
								local skytexfile = CreateFile(textName)	
							)
							Format fytext to:skytexfile
							close skytexfile
							if doesFileExist textNameL == true then (
								local skytexfileL = OpenFile (textNameL)mode:"w"
							) else (
								local skytexfileL = CreateFile(textNameL)	
							)
							--

							

							
							
							Format fytextL to:skytexfileL
							close skytexfileL
							

							fname = wwmt_exportMats+"\\skybox\\"+sideName+".hdr.pfm"

							bname = wwmt_exportMats+"\\skybox\\"+sideNameL+".tga"


							
							
							vmts = ""

							fname2 = wwmt_exportMats+"\\skybox\\half_"+sideName+".hdr.pfm"
							bname2 = wwmt_exportMats+"\\skybox\\half_"+sideNameL+".tga"
							
							
							fname3 = wwmt_exportMats+"\\skybox\\tiny_"+sideName+".hdr.pfm"
							bname3 = wwmt_exportMats+"\\skybox\\tiny_"+sideNameL+".tga"
							
							
							
						/*Rename the actual sides to temporary names and use the half-height sides instead of real sides during the compile*/			
						if  (useHalf != undefined AND useHalf != "false" AND useHalf != false ) AND (findItem ww_wwsw_sides face[2]) != 0 then (
							append vmts " -vmtparam $basetexturetransform \"center 0 0 scale 1 2 rotate 0 translate 0 0\""
							format ("rename \""+fname+"\" \""+sideName+".hdr.pfm.temp\"\n") to:newBatch
							format  ("rename \""+bname+"\" \""+sideNameL+".tga.temp\"\n") to:newBatch
							
							format  ("rename \""+fname2+"\" \""+sideName+".hdr.pfm\"\n") to:newBatch
							format  ("rename \""+bname2+"\" \""+sideNameL+".tga\"\n")  to:newBatch
						)
						
						/*Rename the actual bottom to temporary name and use thetiny bottom instead of real bottom during the compile*/	
						if index == 2 AND mkTiny == true then (
							format  ("rename \""+fname+"\" \""+sideName+".hdr.pfm.temp\"\n")  to:newBatch
							format  ("rename \""+bname+"\" \""+sideNameL+".tga.temp\"\n") to:newBatch
							format  ("rename \""+fname3+"\" \""+sideName+".hdr.pfm\"\n") to:newBatch
							format  ("rename \""+bname3+"\" \""+sideNameL+".tga\"\n") to:newBatch
						)

						
						if usetFormat == false then (
							bt = "\""+wwmt_binDir+"\vtex.exe\""+gameInfoParam+" -nopause -mkdir -shader "+valveShader+" -vmtparam $nofog 1 -vmtparam $ignorez 1 -vmtparam $hdrbasetexture \"skybox/"+sideNameHDR+"\""+vmts+"  \""+ bname+"\"\n"
							Format bt to:newBatch
							bt = "\""+wwmt_binDir+"\vtex.exe\""+gameInfoParam+" -nopause -mkdir -shader "+valveShader+" -vmtparam $nofog 1 -vmtparam $ignorez 1"+vmts+" \""+ fname+"\"\n"
							Format bt to:newBatch
						) else (
							
							writeSkyVMT sn face[2] ldr:true
							writeSkyVMT sn face[2] ldr:false
							
						)
						
						/*Rename the actual sides as the sides instead of half-height sides after the compile is complete.*/	
						if  (useHalf != undefined AND useHalf != "false" AND useHalf != false ) AND (findItem ww_wwsw_sides face[2]) != 0 then (
							format ("rename \""+fname+"\" \"half_"+sideName+".hdr.pfm\"\n") to:newBatch
							format  ("rename \""+bname+"\" \"half_"+sideNameL+".tga\"\n")  to:newBatch
							format  ("rename \""+fname+".temp\" "+sideName+".hdr.pfm\"\n") to:newBatch
							format  ("rename \""+bname+".temp\" "+sideNameL+".tga\"\n")  to:newBatch
						)
						
						/*Rename the actual bottom as the bottom instead of tiny bottom after the compile is complete.*/
						if index == 2 AND mkTiny == true then (
							format  ("rename \""+fname+"\" \"tiny_"+sideName+".hdr.pfm\"\n")  to:newBatch
							format  ("rename \""+bname+"\" \"tiny_"+sideNameL+".tga\"\n")  to:newBatch
							format  ("rename \""+fname+".temp\" "+sideName+"\".hdr.pfm\n")  to:newBatch
							format  ("rename \""+bname+".temp\" "+sideNameL+".tga\"\n")  to:newBatch
						)
						
						
						

						
						
						/*
									bt = "vtex.exe"+gameInfoParam+" -nopause -mkdir -shader UnlitGeneric -vmtparam $nofog 1 -vmtparam $ignorez 1"+vmts+"  \""+ bname+"\"\n"
									Format bt to:newBatch
									Format "@pause\n" to:newBatch
						*/
						
						

						
						

							index += 1
			
						)
						
						)


							textName  = wwmt_exportMats+"\\skybox\\"+sn+"_hdr.txt"		
							
						
							if doesFileExist textName == true then (
								skytexfile = OpenFile (textName) mode:"w+"
							) else (
								skytexfile = CreateFile(textName)	

							)


								
							Format fytext to:skytexfile
							close skytexfile
							

						/*
						if renameBitmaps != "" then (
							
							format renameBitmaps to:newBatch
							
							)
						
						
						format compileString to:newBatch
						
						if restoreBitmapNames != "" then (
							
							format restoreBitmapNames to:newBatch
							)
						*/
							
					Format "@pause\n" to:newBatch

					close newBatch	
				
						
						
					if ((maxVersion())[1] >= 14000) do (
						newBatch = openFile ((wwmt_exportMats)+"\\skybox\\"+sn+".bat")
						seek newBatch #eof
						maxlen=filepos newBatch
						seek newBatch 0
						res = readChars newBatch maxlen errorAtEOF:false
						close newBatch	
						(dotnetclass "System.IO.File").WriteAllText ((wwmt_exportMats)+"\\skybox\\"+sn+"_2012.bat") res		
						
					)
						
				
				)
		
		)
		
		return errors
		)
	

rollout SkyWriter "Sky Writer" width:326 height:436
(
	edittext edt_skyName "Sky Name" pos:[7,6] width:180 height:18 toolTip:"Enter the name of this sky (omitting the `_hdr`)"
	button btn_createSky "Create New Sky" pos:[7,66] width:110 height:40 toolTip:"Create a new Sky Writer Helper."
	pickbutton btn_pickSky "Pick Existing Sky" pos:[121,66] width:117 height:40 toolTip:"Pick an existing Sky Writer Helper."
	button btn3 "Render" pos:[243,66] width:71 height:40 toolTip:"Click here to render the 6 sky textures from the point of view of the SKy Writer Helper."
	radiobuttons rdo_resolution "Sky Resolution" pos:[8,32] width:47 height:110 labels:#("128", "256", "512", "1024", "2048", "4096") default:3
	button btn10 "Compile Sky to VTFs" pos:[134,142] width:111 height:30 toolTip:"Click here to run the batch file that will compile the sky into Source."
	checkbutton ckb1 "Old Cube Path" pos:[7,112] width:79 height:25 toolTip:"Turn on Old Cube Path (-oldcubepath) to compile this sky in mods that expect a single 4x3 texture... which is required for some mods like Left For Dead."
	button btn_open "Open Folder" pos:[249,143] width:66 height:29 toolTip:"Open the folder where the raw TGA bitmaps, text files and batch files are written to (Generally in your Mod's material > skybox folder)."
	bitmap bmp1 "Bitmap" pos:[6,176] width:315 height:180 fileName:"$scripts\WallWorm.com\assets\wwsw_logo.png"
	
	label lbl1 "Wall Worm Sky Writer (c) 2012-2014 by" pos:[7,369] width:197 height:16
	HyperLink hyperLinkShawn "Shawn Olson" pos:[204,369] width:70 height:16 address:"http://www.shawnolson.net" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	label lbl_version "Version " pos:[7,388] width:71 height:16
	HyperLink hyperLinkWallWorm "WallWorm.com" pos:[83,389] width:100 height:16 address:"http://www.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	HyperLink hyperLinkWallWormForum "Forums" pos:[191,388] width:40 height:16 address:"http://www.wallworm.net" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	button btn_configure "Settings" pos:[256,410] width:61 height:16 toolTip:"Click here to configure output paths."
	checkbutton ckb_halfHeight "Half-Height Sides" pos:[155,112] width:88 height:24 toolTip:"Check here if you want to use half-height images. This adds a line into the VMT (Material File) that will allow you to have a material that is wide instead of square. You will need to manually crop the bitmaps in another app."
	checkbutton ckb_tinyB "Tiny Bottom" pos:[245,112] width:69 height:24 toolTip:"Check here if you want to use a reduced-size bitmap for the bottom."
	spinner spn_gamma "LDR Gamma" pos:[245,6] width:70 height:16 range:[0.1,100,1] scale:0.1 toolTip:"Set the gamma for the LDR bitmaps."
	spinner spn_hdr_gamma "HDR Gamma" pos:[245,26] width:70 height:16 range:[0.1,100,1] scale:0.1 toolTip:"Set the gamma for the HDR bitmaps."
	spinner spn_pfmBrightness "" pos:[8,155] width:72 height:16 range:[0,100,1] type:#float
	label lblPFM "PFM Brightness" pos:[7,138] width:78 height:15

	HyperLink cust4 "zwischendrin.com" pos:[110,410] width:137 height:16 address:"http://www.zwischendrin.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	label lbl4 "Special Thanks to " pos:[10,410] width:92 height:19
	checkbutton ckb4 "Cube Cross" pos:[88,112] width:63 height:25 enabled:true toolTip:"Use this to compile with the Cube Cross. Not yet implemented."
	checkButton ckbShaderSky "Sky" pos:[87,141] width:41 height:29 toolTip:"Use the Sky Shader when checked. If off, use the Unlitgeneric shader."
	on edt_skyName entered text do
	(
		
		n = ww_wwsw_setSkyName(text)
		if n != text do (
			edt_skyName.text = n
		)
	)
	on btn_createSky pressed do
	(
	
	
	  ww_wwsw_sky_box = box length: 32 width:32 height: 32 isSelected:true mapcoords:on
	  ww_wwsw_sky_box.name = uniqueName "SkyWriter"
	  ww_wwsw_sky_box.pos = [0,0,0] 
	
	
	if edt_skyName.text == "" do (
		
		edt_skyName.text = uniqueName "Custom_Sky"
		
		)	
		
	ww_wwsw_sky_box.mat = Standard name:(uniqueName (ww_wwsw_sky_box.name+"_Material_")) reflectionMap:(reflectRefract source:1 size:1024)
	ww_wwsw_giveDiffuseMap ww_wwsw_sky_box.mat
	ww_wwsw_setSkyOutputName false
	ww_wwsw_sky_box.renderable = false	
	
	
		
	ww_wwsw_setSkyName edt_skyName.text
	
	--skyname = "$exports\\sky\\"+uniqueName ("wwsw_sky_"+edt_skyName.text)+".tga"
	
		
	
	
		setUserProp ww_wwsw_sky_box "wwsw_gamma" (spn_gamma.value as string)
		setUserProp ww_wwsw_sky_box "wwsw_gamma_hdr" (spn_hdr_gamma.value as string)
		--setUserProp ww_wwsw_sky_box "wwsw_pfm" (ckb_pfm.state as string)
		setUserProp ww_wwsw_sky_box "wwsw_tformat" (ckb1.state as string)
		setUserProp ww_wwsw_sky_box "wwsw_use_tformat" (ckb4.state as string)
		setUserProp ww_wwsw_sky_box "wwsw_pfm_brightness" (spn_pfmBrightness.value as string)
		setUserProp ww_wwsw_sky_box "wwsw_use_skyshader" (ckbShaderSky.state as string)


	
	)
	on btn_pickSky picked obj do
	(
	   local sn = getUserProp obj "wwsw_skyname"
	   if classOf obj == Box AND sn != undefined AND sn != "" then (
	
			   ww_wwsw_sky_box = obj
				try(
					edt_skyName.text = sn
				) catch()
			   try (
				   
				   rdo_resolution.state =(findItem ww_wwsw_sky_resolutions ww_wwsw_sky_box.mat.reflectionMap.size)
				   
				) catch(
				   
				    rdo_resolution.state = 2
				   
				)
			   try (
					ckb1.state = getUserProp ww_wwsw_sky_box "wwsw_tformat"
	
	
	
			   ) catch (
				   
					setUserProp ww_wwsw_sky_box "wwsw_tformat" (ckb1.state as string)
				)
			   
			   try (
					ckbShaderSky.state = getUserProp ww_wwsw_sky_box "wwsw_use_skyshader"

			   ) catch (
					setUserProp ww_wwsw_sky_box "wwsw_use_skyshader" (ckbShaderSky.state as string)
				)   
				   		   
			   
			   try (
					ckb4.state = getUserProp ww_wwsw_sky_box "wwsw_use_tformat"
	
	
	
			   ) catch (
				   
				   			setUserProp ww_wwsw_sky_box "wwsw_use_tformat" (ckb4.state as string)
				   )
			   
			   try (
					ckb_halfHeight.state = getUserProp ww_wwsw_sky_box "wwsw_halfsides"
	
	
	
			   ) catch ()
			   
			   
			   try (
					ckb_tinyB.state = getUserProp ww_wwsw_sky_box "wwsw_tinyb"
	
	
	
			   ) catch ()
			   
			   
			   
			   
			   
			   
			   try (
				   
				   local g = getUserProp ww_wwsw_sky_box "wwsw_gamma"
				   
				   if g == undefined OR g == "" then (
					   
						g = ww_wwsw_defaultGamma
						setUserProp ww_wwsw_sky_box "wwsw_gamma" (g as string)
					   )
					   
				   spn_gamma.value =(g as float)
				   
				   
				   )catch()
				   
				   
				   
			   try (
				   
				   local g = getUserProp ww_wwsw_sky_box "wwsw_gamma_hdr"
				   
				   if g == undefined OR g == "" then (
					   
						g = ww_wwsw_getGammaHDR()
						setUserProp ww_wwsw_sky_box "wwsw_gamma_hdr" (g as string)
					   )
					   
				   spn_hdr_gamma.value =(g as float)
				   
				   
				   )catch()
				   
				   
				
				   
			   try (
				   
				   local g = getUserProp ww_wwsw_sky_box "wwsw_pfm_brightness"
				   
				   if g == undefined OR g == "" then (
					   
						g = 1
					   setUserProp ww_wwsw_sky_box "wwsw_pfm_brightness" "1"
					)
					   
					spn_pfmBrightness.value =(g as float)
				   
				   
				   )catch()
				   
				   
				   
				   
				   
	
				   
				   
				   
			   
			   ww_wwsw_giveDiffuseMap ww_wwsw_sky_box.mat
	
	   ) else (
	
	     messagebox "You did not pick an existing Sky Writer Helper."
	   )
	
	
	)
	on btn3 pressed do
	(		
		errors = #()
	
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false then (
						
			include "$scripts/WallWorm.com/common/config.ms"
			errors = writeBatchFile()
			if ww_wwsw_checkExposureSettings() == false do (
				append errors "You have an invalid Exposure Control in the Environment Settings. Do not use Automatic Exposure Control or Linear Exposure Control for Skybox creation."
				if (envEffectsDialog.isOpen()==false) do (
					editAtmosphere()
				)
				
			)
		if errors.count == 0 then(
			 local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
	
	
			local oldComment1 = Targa.getComment1()
			local oldComment2 = Targa.getComment2()
			local oldComment3 = Targa.getComment3()
			local oldAlphaSplit = Targa.getAlphaSplit()
			local oldAlphaPre = Targa.getPreMultAlpha()
			
			Targa.setComment1 "sky"
			Targa.setComment2 "hdr"
			Targa.setComment3 "wallworm.com sky writer"
			Targa.setAlphaSplit false
			Targa.setPreMultAlpha true
			
			
			--Cube map renderer
			
	
			local ldrGamma = ww_wwsw_getGamma()
			local hdrGamma =  ww_wwsw_getGammaHDR()
	
			local cubeCamera = freeCamera()
	
			
			cubeCamera.fov = 90
	
			local raw = #()
			local bitmaps = #()
			local ldrs = #()
			--local altLdr = #()
			--local altHdr = #()
			local	index = 1
				
			/*	
			local useHalf = getUserProp ww_wwsw_sky_box "wwsw_halfsides"	
			if useHalf == undefined then (
				useHalf = false
				)
			--local	usePFM = getUserProp ww_wwsw_sky_box "wwsw_pfm"
			local mkTiny = getUserProp ww_wwsw_sky_box "wwsw_tinyb"	
			if mkTiny == undefined then (
				mkTiny = false
				)
				local useSkyFlag = true
			if useHalf == true or mkTiny == true then (
				useSkyFlag = false
				)
				*/
				for face in ww_wwsw_cubeFaces do (
					
					--bitmaps[index] = #()
					
					cubeCamera.pos = ww_wwsw_sky_box.center
					
					cubeCamera.rotation = face[1]
					
					cubeCamera.pos = ww_wwsw_sky_box.center
					
					redrawViews()
					
					--local sideName = sn+"_hdr"+(face[2])
					local sideName = sn+"_hdr"+(face[2])
					local ldrName = sn+(face[2])
	
					
	
					
					local fname = wwmt_exportMats+"\\skybox\\"+sideName+".tga"
					
					
					local fnameL = wwmt_exportMats+"\\skybox\\"+ldrName+".tga"
					
					
					
	
					raw[index] =  bitmap ww_wwsw_sky_box.mat.reflectionMap.size ww_wwsw_sky_box.mat.reflectionMap.size HDR:true PixelAspect:1 gamma:hdrGamma colorDepth:32
					
					
					
					
					
					
					bitmaps[index] = bitmap ww_wwsw_sky_box.mat.reflectionMap.size ww_wwsw_sky_box.mat.reflectionMap.size HDR:true PixelAspect:1 gamma:hdrGamma filename:fname colorDepth:32
					
					vmts = ""
					Targa.setColorDepth 32
					
	
					/*This chunk of code for Vray provided by Fabian Groﬂ*/
					-- vray switch!
					local vr = renderers.current
					local vray_render = (matchPattern (vr as string) pattern:"V_Ray_*")
					if vray_render == true then 
					(
						/* VRay recognized */
						vr.output_force32bit_3dsmax_vfb = true
						vr.output_on = true
						vr.output_splitgbuffer = true
						vr.output_splitRGB = true
						vr.output_splitAlpha = false
						vr.output_splitfilename = fnameL
						rendOutputFilename = (wwmt_exportMats+"\\skybox\\"+sideName+"_vr_temp.tga") --can be deleted afterwards!
						rendSaveFile = true						
					) 
					
					-- render cubemap images
					render camera:cubeCamera outputHDRbitmap:true vfb:(not vray_render) to:raw[index]
			
	
					
	
	
	
					
					
					--if (usePFM != undefined AND usePFM == true) then ( 
						
	
						
								wallwormWritePFM raw[index] 2 filename:(wwmt_exportMats+"\\skybox\\"+(sn+(face[2]))+".hdr.pfm")
						--try () catch (
						
						/*
						try (						
	
							fopenexr.SetCompression 0
							raw[index].filename = wwmt_exportMats+"\\skybox\\"+sideName+".exr"
							save raw[index]
						) catch(
							--openexr not supported
							print "OpenEXR not supported in this version of Max. Falling back to DDS... but DDS does not have a MAXScript interface...\n\nYou may need to manually save a DDS file before export to get the right settings."
							try (
	
								raw[index].filename = wwmt_exportMats+"\\skybox\\"+sideName+".dds"
								save raw[index]
								
								
								
								) catch (
								print "DDS File not created."
								
								)
							
							
							)*/
						--)
						--) else (
						
						
						
						--)
					
					
					
					
						--this block strips any alpha
						local w = raw[index].width
						for y = 0 to raw[index].height-1 do (
							local sourceRow = getPixels raw[index] [0,y] w
							local destRow = getPixels bitmaps[index]  [0,y] w
							
							
							for x = 1 to sourceRow.count do (
								
								destRow[x].r = sourceRow[x].r 
								destRow[x].g = sourceRow[x].g 
								destRow[x].b = sourceRow[x].b 
								
								
								destRow[x].alpha = 0
							)
	
							setPixels bitmaps[index]  [0,y] destRow 	
	
						)
	
					
					
					
					
					
					save bitmaps[index]
					
					
					ldrs[index] = bitmap ww_wwsw_sky_box.mat.reflectionMap.size ww_wwsw_sky_box.mat.reflectionMap.size HDR:false PixelAspect:1 gamma:ldrGamma filename:fnameL colorDepth:32
					pasteBitmap  bitmaps[index] ldrs[index] (box2 0 0 ww_wwsw_sky_box.mat.reflectionMap.size (ww_wwsw_sky_box.mat.reflectionMap.size)) [0,0] 
						
							
						save ldrs[index]
					
					
	
					if face[2] != "up" do (
						
						
						if  face[2] == "dn" then (
							
							
							--if  (mkTiny == true ) do (
						
								--make a tiny copy
								--fname = wwmt_exportMats+"\\skybox\\"+sideName+"_tiny.tga"
								
									--local fnameTiny = wwmt_exportMats+"\\skybox\\tiny_"+sideName+".tga"
					
					
									local fnameTinyL = wwmt_exportMats+"\\skybox\\tiny_"+ldrName+".tga"
								
								
								
								
								local altHdr = bitmap 4 4 HDR:true PixelAspect:1 gamma:hdrGamma  colorDepth:32
								
								local altLdr = bitmap 4 4 HDR:false PixelAspect:1 gamma:ldrGamma  colorDepth:32 filename:fnameTinyL
								
								pasteBitmap bitmaps[index]  altHdr (box2 0 0 ww_wwsw_sky_box.mat.reflectionMap.size ww_wwsw_sky_box.mat.reflectionMap.size) [0,0] 
								pasteBitmap ldrs[index]  altLdr (box2 0 0 ww_wwsw_sky_box.mat.reflectionMap.size ww_wwsw_sky_box.mat.reflectionMap.size) [0,0] 
							
							
							
								wallwormWritePFM altHdr 2 filename:(wwmt_exportMats+"\\skybox\\tiny_"+sn+(face[2])+".hdr.pfm")
							
							
								--save altHdr
								save altLdr
						
							--)
						
						) else (
							
						--	if  ( useHalf == true )  do (
								
								
							--	local fnameHalf = wwmt_exportMats+"\\skybox\\half_"+sideName+".tga"
								
								
								
								
								local fnameHalfL = wwmt_exportMats+"\\skybox\\half_"+ldrName+".tga"
						
								--make a half-sized copy
								local altHdr = bitmap ww_wwsw_sky_box.mat.reflectionMap.size (ww_wwsw_sky_box.mat.reflectionMap.size/2) HDR:true PixelAspect:1 gamma:hdrGamma  colorDepth:32
								local altLdr = bitmap ww_wwsw_sky_box.mat.reflectionMap.size (ww_wwsw_sky_box.mat.reflectionMap.size/2) HDR:false PixelAspect:1 gamma:ldrGamma  colorDepth:32 filename:fnameHalfL
								
								
								pasteBitmap  bitmaps[index]  altHdr (box2 0 0 ww_wwsw_sky_box.mat.reflectionMap.size (ww_wwsw_sky_box.mat.reflectionMap.size/2)) [0,0] 
								--save altHdr
									
								pasteBitmap   ldrs[index] altLdr (box2 0 0 ww_wwsw_sky_box.mat.reflectionMap.size (ww_wwsw_sky_box.mat.reflectionMap.size/2)) [0,0] 
									
								wallwormWritePFM altHdr 2 filename:(wwmt_exportMats+"\\skybox\\half_"+sn+(face[2])+".hdr.pfm")
								save altLdr
							--save btHalf
							--) 							
							
							
							)
						
						
						
	
						
						
	
						
					)
					--copy bitmaps[index][2] bitmaps[index][1]
					
					--save bitmaps[index][1]
					
					undisplay raw[index]
					
					local sl = index
					
					if index == 3 then (
						
						sl = 4
						)else(
						
						
						if index == 4 do (
							
							sl = 3
							)
						
						)
					
					ww_wwsw_sky_box.mat.reflectionMap.bitmapName[sl] = bitmaps[index].filename
	
					index += 1
	
				)
				
				
				ww_wwsw_makeCubeCross raw ww_wwsw_sky_box.mat.reflectionMap.size
				
				
				
				
	
					
					raw = undefined
				
	
			delete cubeCamera	
				
				
			
					
			--ww_wwsw_runSkyBatch()
	
			--return TGA settings to previous	
				
			Targa.setComment1 oldComment1
			Targa.setComment2 oldComment2
			Targa.setComment3 oldComment3
			Targa.setAlphaSplit oldAlphaSplit
			Targa.setPreMultAlpha oldAlphaPre	
				
				messagebox "The images have been rendered. You can now press the Compile Sky button or click the Open button to see the files."
				
						) else (
			
			
			m ="There are errors:\n\n"
			
			for ma in errors do (
				
				append m (ma+"\n\n")
				
				)
			messagebox m
			
			)	
	) else(
	
	messagebox "Please create a Sky Writer Helper or select an existing one."
	
	)
	
	
	
	)
	on rdo_resolution changed stat do
	(
	if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
		--ww_wwsw_sky_box.mat.reflectRefract.size = (state as int)
		
		
		
	  ww_wwsw_sky_box.mat.reflectionMap.size = ww_wwsw_sky_resolutions[stat]
	)
	)
	on btn10 pressed do
	(
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false then (
		
			local proceed = true
			--local usePFM = getUserProp ww_wwsw_sky_box "wwsw_pfm" 
	
			--if usePFM != undefined AND (usePFM=="true" OR usePFM == true) do (
					local sn = getUserProp ww_wwsw_sky_box "wwsw_skyname"
		
							
							for face in ww_wwsw_cubeFaces while proceed==true do (
					
								local fname = wwmt_exportMats+"\\skybox\\"+sn+(face[2])+".hdr.pfm"
								local fnamel = wwmt_exportMats+"\\skybox\\"+sn+(face[2])+".tga"
								if (doesFileExist fname) == false OR (doesFileExist fnamel) == false do (
									proceed = false
									)
								
							)
			
			
			
			--)
			if proceed == true then (
				ww_wwsw_runSkyBatch()
				--messagebox "Export complete. Note that you may need to edit the VMT to remove a duplicate $basetexture; if so... remove the $basetexture that matches the $hdrbasetexture."
			) else(
				messagebox "The compiler failed to run because you the TGA and PFM files do not exist. You must render the sky first."
			)
		) else (
			messagebox "You cannot compile the sky because you have not created and/or selected a sky."
			)
	)
	on ckb1 changed state do
	(
	
	if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
		
		
			if state == true then (
				local s = "true"
			) else(
		   
				local s = "false"
			)
			setUserProp ww_wwsw_sky_box "wwsw_tformat" s	
	   
	         writeBatchFile()
	)
	)
	on btn_open pressed do
	(
			
				try (
	
				
					folderOpen ="ShellLaunch \"explorer.exe\" @\""+(wwmt_exportMats+"\\skybox")+"\""
					execute folderOpen
				
				) catch(
				
					messagebox "The Material Export Path hasn't been set. Click the settings button in the Sky Writer UI and set the Material Root folder."
				
				)
			
			)
	on btn_configure pressed do
	(
	try (
		macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
		) catch (
			if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms" then (
				fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms"
				macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
			) else (
				messageBox "The settings are now integrated with Wall Worm Model Tools. Please run the WWMT install script."
			)
		)
	
	)
	on ckb_halfHeight changed state do
	(
	
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
			
			
				if state == true then (
					local s = "true"
				) else(
			   
					local s = "false"
				)
				setUserProp ww_wwsw_sky_box "wwsw_halfsides" s	
		   
		         writeBatchFile()
		)
	
	
	
	)
	on ckb_tinyB changed state do
	(
	
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
			
			
				if state == true then (
					local s = "true"
				) else(
			   
					local s = "false"
				)
				setUserProp ww_wwsw_sky_box "wwsw_tinyb" s	
		   
		         writeBatchFile()
		)
	
	)
	on spn_gamma changed val do
	(
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do(
			
			setUserProp ww_wwsw_sky_box "wwsw_gamma" (val as string)
			writeBatchFile()
			)
	)
	on spn_hdr_gamma changed val do
	(
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do(
			
			setUserProp ww_wwsw_sky_box "wwsw_gamma_hdr" (val as string)
			writeBatchFile()
			)
	)
	on spn_pfmBrightness changed val do
	(
				if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do(
				
					setUserProp ww_wwsw_sky_box "wwsw_pfm_brightness" (val as string)
					writeBatchFile()
				)
			
			
			)
	on ckb4 changed state do
	(
	
	if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
		
		
			if state == true then (
				local s = "true"
			) else(
		   
				local s = "false"
			)
			setUserProp ww_wwsw_sky_box "wwsw_use_tformat" s	
	   
	         writeBatchFile()
	)
	)
	on ckbShaderSky changed state do
(
		if ww_wwsw_sky_box != undefined AND isDeleted ww_wwsw_sky_box == false do (
			
			
				if state == true then (
					local s = "true"
				) else(
			   
					local s = "false"
				)
				setUserProp ww_wwsw_sky_box "wwsw_use_skyshader" s	
		   
		         writeBatchFile()
		)
	)
)

	


createDialog SkyWriter
--addRollout SkyWriter wwSkyWriterFloater rolledUp:false

SkyWriter.spn_gamma.range = [0,10,ww_wwsw_defaultGamma]

SkyWriter.spn_hdr_gamma.range = [0,10,1]

SkyWriter.lbl_version.caption+= (ww_wwsw_version as string)

)