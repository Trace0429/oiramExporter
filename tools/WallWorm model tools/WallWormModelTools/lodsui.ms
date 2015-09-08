		components = ""			
		picked=""				
		view = ""
		
		y1=7
		y2=21
		y2b=y2+13
		y3n4=50
		y5=66
		y6=49		
		
		if wwmt_lodLimit == undefined OR wwmt_lodLimit == "" OR wwmt_lodLimit < 1 then (
			
			wwmt_lodLimit = 1	
		)
		
		
		for c = 1 to wwmt_lodLimit do (
			
		str = "GroupBox grpLOD"+c as string+" \"LOD "+c as string+"\" pos:[3,"+y1 as string+"] width:240 height:99\n"
		append components str
		str = "pickbutton pickLOD"+c as string+" \"Pick LOD "+c as string+" Model\" pos:[9,"+y2 as string+"] width:100 height:24 enabled:false toolTip:\"Pick a mesh for the root of your LOD.\"\n"
		append components str
			
		str = "pickbutton appendLOD"+c as string+" \"Append LOD "+c as string+" \" pos:[116,"+y2 as string+"] width:71 height:12 enabled:false toolTip:\"Add all selected meshes to this LOD.\"\n"
		append components str	
		
		str = "button addSelLOD"+c as string+" \"+ Sel to LOD "+c as string+" \" pos:[116,"+y2b as string+"] width:71 height:12 enabled:false toolTip:\"Add selected meshes to this LOD model.\"\n"
		append components str		
			
		str = "button delLOD"+c as string+" \"DELETE\" pos:[190,"+y2b as string+"] width:51 height:12 enabled:false toolTip:\"Delete this LOD entirely. Deletes ALL meshes and helpers for this LOD.\"\n"
		append components str		
			
		str = "button delSelLOD"+c as string+" \"Rem Sel\" pos:[190,"+y2 as string+"] width:51 height:12 enabled:false toolTip:\"Remove selected meshes from this LOD.\"\n"
		append components str	
			
		str = "button btnPickLOD"+c as string+"Helper \"Button\" pos:[9,"+y3n4 as string+"] width:48 height:32 toolTip:\"Select Distance Helper.\" enabled:false images:wwmt_lodhelperIcons\n"
		append components str
		str = "button btnViewLOD"+c as string+" \"Button\" pos:[56,"+y3n4 as string+"] width:48 height:32 toolTip:\"Show/Hide the LOD and its Radius Gizmo.\" enabled:false images:wwmt_lodHideIcons\n"
		append components str
		str = "spinner spnLOD"+c as string+" \"\" pos:[110,"+y5 as string+"] width:80 height:16 enabled:false\n"
		append components str
		str = "label lblLOD"+c as string+" \"Detail Percent\" pos:[111,"+y6 as string+"] width:80 height:16\n"
		append components str
			

		str = "materialButton btnMatLOD"+c as string+" \"Material\" pos:[190,"+y6 as string+"] width:50 height:36 enabled:false toolTip:\"Browse your materials to select LOD materials to swap out with the main model's materials for this LOD.\""	
		append components str
			
		str = "spinner spnLODMetric"+c as string+" \"LOD Threshold\" pos:[12,"+(y5 + 18) as string+"] range:[0.01,1024,1] width:100 height:16 enabled:false\n"
		append components str
		
		str = "button spnLODMetricGet"+c as string+" \"Get Metric\" pos:[115,"+(y5 + 18) as string+"] width:80 height:16  toolTip:\"Reset the value after changing the helper in the scene.\" enabled:false\n"
		append components str


			
			y1=y1+106 
			y2=y2+106
			y3n4=y3n4+106
			y5=y5+106
			y6=y6+106	
			y2b = y2b+106
			
			
			
			n = "on btnViewLOD"+c as string+" pressed do\n"
			append view n
			n = "(\ntry(\n"
			append view n
			n ="if ww_scene_lods.lods["+c as string+"].helperGizmo.isNodeHidden  then ( \n"
			append view n
			n ="ww_scene_lods.unhideLod "+c as string+"\n"
			append view n
			n ="ww_scene_lods.selectSelectionSets "+c as string+"\n"
			append view n
			n ="unhide ww_scene_lods.lods["+c as string+"].helperGizmo\n"
			append view n
			n ="wwToolsFloater.rollouts[4].btnViewLOD"+c as string+".images = wwmt_lodViewIcons\n"
			append view n
			n ="hide ww_scene_lods.targets\n"
			append view n
			
			--n ="ww_scene_lods.target.xray = on\n"
			--append view n
			--n ="freeze ww_scene_lods.targets\n"
			--append view n
			n =") else (\n"
			append view n
			n ="hide ww_scene_lods.lods["+c as string+"].items\n"
			append view n
			n ="hide ww_scene_lods.lods["+c as string+"].helperGizmo\n"
			append view n
			n ="wwToolsFloater.rollouts[4].btnViewLOD"+c as string+".images = wwmt_lodHideIcons\n"
			append view n
			--n ="ww_scene_lods.target.xray = off\n"
			--append view n
			
			
		
			
			n ="unhide ww_scene_lods.targets\n"
			append view n
			
			n ="unfreeze ww_scene_lods.targets\n"
			append view n
			n =")\n"
			append view n
			n ="redrawviews()\n"
			append view n
			
			n ="\n)catch()\n)\n"
			append view n
			
			

		str="on btnMatLOD"+c as string+" picked mat do (\n"
		append picked str
		str="if (ww_scene_lods.lods[ "+c as string+"].setLODMaterial mat == false) do (\nmessagebox \"You can only choose a Standard, Shell or Multi/Sub-Object Material.\"\n)\n"
		append picked str
		str=")\n"
		append picked str
				
			
			
		str="on delSelLOD"+c as string+" pressed do (\n"
		append picked str
		str="if (ww_scene_lods.lods[ "+c as string+"].removeItem selection > 0) then (\nmessagebox \"The selected items were deleted from this LOD.\"\n)\nelse\n(\nmessagebox \"None of the selected items were part of this LOD. None were removed.\"\n)\n"
		append picked str
		
		
		str=")\n"
		append picked str
		


		str="on delLOD"+c as string+" pressed do (\n"
		append picked str
		str="if ww_scene_lods.lods[ "+c as string+"] != undefined then (\nww_scene_lods.lods[ "+c as string+"].deleteLOD()\n"
		append picked str
		
		str = "delLOD"+c as string+".enabled = false\n"	
		append picked str
		str = "delSelLOD"+c as string+".enabled = false\n"	
		append picked str
		str = "btnPickLOD"+c as string+"Helper.enabled = false\n"
		append picked str
		str = "btnViewLOD"+c as string+".enabled = false\n"
		append picked str
		str = "spnLOD"+c as string+".enabled = false\n"
		append picked str
		str = "pickLOD"+c as string+".caption = \"Pick LOD "+c as string+"\"\n"
		append picked str
		
		
		str = "if wwmt_activateLODMenus != undefined then (\nwwmt_activateLODMenus ww_scene_lods.lods\n)\n"
		append picked str
		
		
		
		str=")\n)\n"
		append picked str
		


			
		str="on pickLOD"+c as string+" picked obj do (\n"
		append picked str
		str="ww_scene_lods.setLod "+c as string+" obj ww_scene_lods\n"
		append picked str
		str = "delLOD"+c as string+".enabled = true\n"
		append picked str
		str = "appendLOD"+c as string+".enabled = true\n"
		append picked str
		str = "addSelLOD"+c as string+".enabled = true\n"
		append picked str
		str = "btnViewLOD"+c as string+".enabled = true\n"
		append picked str


		str = "btnPickLOD"+c as string+"Helper.enabled = true\n"
		append picked str

		str = "spnLOD"+c as string+".enabled = true\n"
		append picked str
		str = "spnLODMetric"+c as string+".enabled = true\n"
		append picked str
		str = "spnLODMetricGet"+c as string+".enabled = true\n"
		append picked str
		
		
			

		
		str = "btnMatLOD"+c as string+".enabled = true\n"
		append picked str
		
		str = "pickLOD"+c as string+".caption = \"LOD "+c as string+"\"\n"
		append picked str
		
		if c < wwmt_lodLimit then (
				
			str = "pickLOD"+( c + 1 ) as string+".enabled = true\n"
			append picked str
				
		)
		
		
		str=")\n"
		append picked str
		

		
		str="on addSelLOD"+c as string+" pressed do (\n"
		append picked str
		
		str="tempsel = (for obj in selection WHERE superclassof obj == GeometryClass collect obj) as array\n"
		append picked str
		

		str = "if tempsel.count > 0 then ("
		append picked str
		
		str="if ww_scene_lods.lods[ "+c as string+"] == undefined OR (classof ww_scene_lods.lods[ "+c as string+"] != ww_lod) then (ww_scene_lods.setLod "+c as string+" tempsel[1] ww_scene_lods\ndeleteItem tempsel 1\n tempsel = for obj in tempsel WHERE isvalidnode obj == true collect obj\n)\n"
		append picked str
		
		

		str = "if tempsel.count > 0 then ("
		append picked str
		
		str="for obj in tempsel do (\n"
		append picked str
		str="ww_scene_lods.lods[ "+c as string+"].appendItem obj\n"
		append picked str
		str=")\n"
		
		append picked str
		str=")\n"
		
		append picked str
		str=")\n"
		append picked str
		str=")\n"
		append picked str
		
		str="on appendLOD"+c as string+" picked obj do (\n"
		append picked str
		str="ww_scene_lods.lods[ "+c as string+"].appendItem obj\n"
		append picked str
		str=")\n"
		append picked str
		
		str="on spnLOD"+c as string+" changed val do (\n"
		append picked str	
		str="ww_scene_lods.lods["+c as string+"].setMyRes val\n"
		append picked str
		str=")\n"
		append picked str
		
		
		str="on spnLODMetric"+c as string+" changed val do (\n"
		append picked str	
		str="ww_scene_lods.lods["+c as string+"].setRadiusFromMetric val\n"
		append picked str
		str=")\n"
		append picked str
		
		str="on spnLODMetricGet"+c as string+" pressed do (\n"
		append picked str	
		str="spnLODMetric"+c as string+".value = ww_scene_lods.lods["+c as string+"].getMetric()\n"
		append picked str
		str=")\n"
		append picked str
		
		
		
		str="on btnPickLOD"+c as string+"Helper pressed do (\n"
		append picked str
		str="try (\n"
		append picked str
		str="if ww_scene_lods.lods["+c as string+"].helperTape.isNodeHidden do (\n"
		append picked str
		str="unhide ww_scene_lods.lods["+c as string+"].helperTape\n"
		append picked str
		str=")\n"
		append picked str
		str="select ww_scene_lods.lods["+c as string+"].helperTape\n"
		append picked str
		str=") catch (\n"
		append picked str
				
		str=")\n"
		append picked str
		
		str ="redrawviews()\n"
		append picked str
		
		str=")\n"
		append picked str
		
		
		c=c+1
		
	)
		
			

		
		lodstring = "rollout wwmt_lodslistrollouta \"LOD List\" width:240 height:658\n"
		append lodstring "(\n"
		append lodstring components
		append lodstring view
		append lodstring picked
		append lodstring ")\n"
