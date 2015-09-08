/*
Wall Worm Model Tools 
Copyright (c) 2010-2014 by Shawn Olson
http://www.shawnolson.net

A Wall Worm Project
http://www.wallworm.com
*/
--(
global wwToolsFloater


fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
intro =  "Loading...\nWall Worm Model Tools\n"
append intro "Version "
append intro (ww_wwmt_version as string)
append intro "\n\n"
append intro "www.wallworm.com\n\n" 
	
append intro "Copyright (c) 2010-2014 by Shawn Olson\n" 
append intro "http://www.shawnolson.net \n\n" 
append intro "Forums now up at http://www.wallworm.net" 

print intro


if wwmt_activateLODMenus == undefined then (
		wwmt_activateLODMenus = function wwmt_activateLODMenus ar = ()
)

global wallworm_reset_wwmt

if wallworm_reset_wwmt == true AND ww_scene_lods != undefined then (
	

) else (
	global ww_scene_lods = ww_LOD_wrapper()
	ww_scene_lods.init()	
	try(closeRolloutFloater  wwToolsFloater)catch()
)






		/*See if the UI position was set before*/
		thePos = getINISetting wallworm_userIni "Layout" "wwmt_ui_pos"
		if thePos != undefined AND thePos != "" then (
			execute ("wwmtUILocation =  "+ thePos)
		)
		global wwmtUILocation
		if wwmtUILocation == undefined OR classOf wwmtUILocation != Point2 then (
			wwmtUILocation = [20,20]
		) else ()

wwToolsFloater = newRolloutFloater "Wall Worm Model Tools" 260 1040 wwmtUILocation.x wwmtUILocation.y
global wwmt_lodhelperIcons = #("$scripts\Wallworm.com\assets\lod_helper_icon_buttons.png",undefined,2,1,1,2,2,false)
global wwmt_lodViewIcons = #("$scripts\Wallworm.com\assets\lod_view_icon_buttons.png",undefined,2,1,1,2,2,false)
global wwmt_lodHideIcons = #("$scripts\Wallworm.com\assets\lod_hide_icon_buttons.png",undefined,2,1,1,2,2,false)


include "$scripts/WallWorm.com/WallWormModelTools/lodsui.ms"
execute lodstring

--percentages for MultRes modifiers applied to items in the iterations
--each number is 25% less than the last where the first item is 25% less than the original (which is 100%)
--consider making this dynamic... but at the moment the lodSpinner has a max value of 10



function disableUI = (
	
			wwToolsFloater.rollouts[1].addModel.caption = "Pick Model"
			wwToolsFloater.rollouts[1].ddlNormals.enabled = false
			wwToolsFloater.rollouts[2].addPhys.enabled = false
			wwToolsFloater.rollouts[4].pickLOD1.enabled = false
			wwToolsFloater.rollouts[1].edt1_modelPath.enabled = false
			wwToolsFloater.rollouts[1].edt2_materialFolder.enabled = false
			wwToolsFloater.rollouts[1].ddl1.enabled = false
			wwToolsFloater.rollouts[1].btn_appendModels.enabled =false
			wwToolsFloater.rollouts[1].btn_addSelection.enabled = false
			wwToolsFloater.rollouts[1].btn_removeSelFromTargets.enabled = false
			wwToolsFloater.rollouts[1].chk_staticprop.enabled = false
			wwToolsFloater.rollouts[1].chk_alwayscollapse.enabled = false
	
			wwToolsFloater.rollouts[1].chk_opaque.enabled = false
			wwToolsFloater.rollouts[1].btn_tex.enabled = false
			wwToolsFloater.rollouts[1].ddl_shader.enabled = false
			wwToolsFloater.rollouts[1].ddl_compression.enabled = false
			wwToolsFloater.rollouts[1].chk_mostlyopaque.enabled = false
			wwToolsFloater.rollouts[1].edt2_materialFolder.enabled = false
			wwToolsFloater.rollouts[1].edt1_modelPath.enabled = false
			wwToolsFloater.rollouts[1].runExport.enabled = false
			wwToolsFloater.rollouts[1].runQC.enabled = false
			wwToolsFloater.rollouts[1].runSMD.enabled = false
			wwToolsFloater.rollouts[1].btn_SelectModel.enabled = false
			wwToolsFloater.rollouts[1].btn_illum.enabled = false
			wwToolsFloater.rollouts[1].chk_altOrigin.enabled = false					
			wwToolsFloater.rollouts[1].chk_localOrigin.enabled = false
			wwToolsFloater.rollouts[1].chkRotateOrigin.enabled = false
			wwToolsFloater.rollouts[1].edt_modelName.enabled = false
			wwToolsFloater.rollouts[1].edt_modelName.text = "MyModel"
			wwToolsFloater.rollouts[1].spn_scale.enabled = false			
			wwToolsFloater.rollouts[1].btn_setSkyScale.enabled = false	
			wwToolsFloater.rollouts[1].btn_setSkyScale2.enabled = false	
			wwToolsFloater.rollouts[1].chkInternalOrigin.enabled = false
			wwToolsFloater.rollouts[2].ddl_contents.enabled = false
	    	wwToolsFloater.rollouts[2].spn_inertia.enabled = false
	    	wwToolsFloater.rollouts[2].spn_damping.enabled = false
	    	wwToolsFloater.rollouts[2].spn_phdrag.enabled = false
			wwToolsFloater.rollouts[2].chk_jointrestrain.enabled = false
			wwToolsFloater.rollouts[2].chk_noselfcollisions.enabled = false
			wwToolsFloater.rollouts[2].edt_animatedfriction.enabled = false
			
			wwToolsFloater.rollouts[2].spn_rotDamping.enabled = false
			wwToolsFloater.rollouts[2].btn_deleteHulls.enabled = false
			wwToolsFloater.rollouts[2].btn_mass.enabled = false
			wwToolsFloater.rollouts[2].chk_automass.enabled = false
			wwToolsFloater.rollouts[2].btn_update_count.enabled = false
			wwToolsFloater.rollouts[2].spn_mass.enabled = false
			wwToolsFloater.rollouts[2].chk_concave.enabled = false
			wwToolsFloater.rollouts[2].btn_addCM.enabled = false
			wwToolsFloater.rollouts[2].btn_appendCM.enabled = false
			wwToolsFloater.rollouts[2].chk_autoHull.enabled = false
			wwToolsFloater.rollouts[3].lodSpinner.enabled = false
			wwToolsFloater.rollouts[3].generateLODbtn.enabled = false
			wwToolsFloater.rollouts[3].chk_shadow.enabled = false	
			
			

			wwToolsFloater.rollouts[6].chk_collapsebones.enabled = false
			
			
			
			
			wwToolsFloater.rollouts[5].chk_idleSequence.enabled = false
			wwToolsFloater.rollouts[5].cbx_sequences.enabled = false
			wwToolsFloater.rollouts[5].btn_addSeq.enabled = false
			wwToolsFloater.rollouts[5].btn_delSeq.enabled = false
			wwToolsFloater.rollouts[5].cbx_sequences.items = ww_scene_lods.sequencelist	

			wwToolsFloater.rollouts[5].spn_expStart.enabled = false
			wwToolsFloater.rollouts[5].spn_expEnd.enabled = false
			wwToolsFloater.rollouts[5].chk_expReverse.enabled = false
			wwToolsFloater.rollouts[5].chk_loop.enabled = false
			wwToolsFloater.rollouts[7].chk_expHL1Format.enabled = false				
			wwToolsFloater.rollouts[7].btn_illum.enabled = false		
			wwToolsFloater.rollouts[7].spn_constantdirectionallight.enabled = false	
			wwToolsFloater.rollouts[7].chk_ambientboost.enabled = false	
			wwToolsFloater.rollouts[6].cbx_attachmentList.enabled = false
			wwToolsFloater.rollouts[6].ddl_attachmentBone.enabled = false
			wwToolsFloater.rollouts[6].chk_attachmentAbsolute.enabled = false
			wwToolsFloater.rollouts[6].chk_attachmentRigid.enabled = false
			wwToolsFloater.rollouts[6].btn_createAttachment.enabled = false
			wwToolsFloater.rollouts[6].btn_deleteAttachment.enabled = false
			wwToolsFloater.rollouts[6].btn_attachUpdateBoneList.enabled = false
			wwToolsFloater.rollouts[6].btn_selectPoint.enabled = false
			wwToolsFloater.rollouts[8].btnSkins.enabled = false
			wwToolsFloater.rollouts[8].ckb_expMorphsAsVTA.enabled = false
			wwToolsFloater.rollouts[8].btn_expVTAs.enabled = false
			wwToolsFloater.rollouts[8].btnCollectSkins.enabled = false
			wwToolsFloater.rollouts[8].btnCreateProxy.enabled = false
			
			wwToolsFloater.rollouts[9].chk_allowstatic.enabled = false
			wwToolsFloater.rollouts[9].chk_blockLOS.enabled = false
			wwToolsFloater.rollouts[9].chk_AIWalkable.enabled = false
			wwToolsFloater.rollouts[9].chk_ignite.enabled = false
			wwToolsFloater.rollouts[9].chk_explosive_resist.enabled = false
			wwToolsFloater.rollouts[9].chk_flammable.enabled = false
			wwToolsFloater.rollouts[9].btn_custGibs.enabled = false
			wwToolsFloater.rollouts[9].spn_health.enabled = false		
			wwToolsFloater.rollouts[9].spn_breakable_skin.enabled = false	
			wwToolsFloater.rollouts[9].spn_dmg_bullets.enabled = false
			wwToolsFloater.rollouts[9].spn_dmg_club.enabled = false
			wwToolsFloater.rollouts[9].spn_dmg_explosive.enabled = false			
			wwToolsFloater.rollouts[9].spn_breakable_count.enabled = false			
			wwToolsFloater.rollouts[9].spn_explosive_damage.enabled = false
			wwToolsFloater.rollouts[9].spn_explosive_radius.enabled = false		
			wwToolsFloater.rollouts[9].chk_motiondisabled.enabled = false
			wwToolsFloater.rollouts[9].spn_fadetime.enabled = false
			wwToolsFloater.rollouts[9].ddl_physicsmode.enabled = false	
			wwToolsFloater.rollouts[9].ddl_base.enabled = false
			wwToolsFloater.rollouts[9].ddl_breakable_model.enabled = false
			wwToolsFloater.rollouts[9].ddl_multiplayer_break.enabled = false
			wwToolsFloater.rollouts[9].btn_custGibs.enabled = false
			wwToolsFloater.rollouts[9].btn_compileGibsVTFs.enabled = false
			wwToolsFloater.rollouts[9].btn_removeGibs.enabled = false
			wwToolsFloater.rollouts[9].btn_compileGibs.enabled = false

	)
	
	
	function wallworm_setWWMUI = (
		
		
			
		
			wwToolsFloater.rollouts[2].addPhys.enabled = true
	    
			 wwToolsFloater.rollouts[4].pickLOD1.enabled = true
	
			 wwToolsFloater.rollouts[1].edt1_modelPath.enabled = true
			 wwToolsFloater.rollouts[1].edt2_materialFolder.enabled = true
			 wwToolsFloater.rollouts[1].ddl1.enabled = true
			 
			 wwToolsFloater.rollouts[1].btnShowModel.enabled = true
			 wwToolsFloater.rollouts[1].btnHideModel.enabled = true
			 wwToolsFloater.rollouts[1].chk_staticprop.enabled = true
			 wwToolsFloater.rollouts[1].chk_alwayscollapse.enabled = true
			 wwToolsFloater.rollouts[1].chk_opaque.enabled = true
			 wwToolsFloater.rollouts[1].chk_lockQC.enabled = true
			 wwToolsFloater.rollouts[1].ddl_shader.enabled = true
			wwToolsFloater.rollouts[1].ddl_compression.enabled = true
			 wwToolsFloater.rollouts[1].btn_tex.enabled = true
			 
			 --wwToolsFloater.rollouts[1].btn_removeSelFromTargets.enabled = true
	
			 wwToolsFloater.rollouts[1].chk_mostlyopaque.enabled = true
			wwToolsFloater.rollouts[1].edt2_materialFolder.enabled = true
			wwToolsFloater.rollouts[1].edt1_modelPath.enabled = true
			wwToolsFloater.rollouts[1].runExport.enabled = true
			wwToolsFloater.rollouts[1].runQC.enabled = true
			wwToolsFloater.rollouts[1].runSMD.enabled = true
			wwToolsFloater.rollouts[1].btn_SelectModel.enabled = true
			wwToolsFloater.rollouts[1].btn_illum.enabled = true
			wwToolsFloater.rollouts[1].chk_altOrigin.enabled = true					
			wwToolsFloater.rollouts[1].chk_localOrigin.enabled = true
			wwToolsFloater.rollouts[1].chkInternalOrigin.enabled = true
			wwToolsFloater.rollouts[1].chkRotateOrigin.enabled = true
			wwToolsFloater.rollouts[1].chk_lock_origin.enabled = true
			wwToolsFloater.rollouts[1].edt_modelName.enabled = true
			wwToolsFloater.rollouts[1].edt_modelName.text = ww_scene_lods.modelName
			wwToolsFloater.rollouts[1].spn_scale.enabled = true			
			wwToolsFloater.rollouts[1].btn_setSkyScale.enabled = true	
			wwToolsFloater.rollouts[1].btn_setSkyScale2.enabled = true	
			wwToolsFloater.rollouts[1].spn_mapChannel.enabled = true	
		
			wwToolsFloater.rollouts[1].ddlNormals.enabled = true
		
			wwToolsFloater.rollouts[2].ddl_contents.enabled = true
	    	wwToolsFloater.rollouts[2].spn_inertia.enabled = true
	    	wwToolsFloater.rollouts[2].spn_damping.enabled = true
	    	wwToolsFloater.rollouts[2].spn_phdrag.enabled = true
			wwToolsFloater.rollouts[2].chk_noselfcollisions.enabled = true
			wwToolsFloater.rollouts[2].edt_animatedfriction.enabled = true
	/*
			if wwmt_hull_tool == 2  AND Maple3D_HullFnsAvailable() == true do (
				wwToolsFloater.rollouts[2].btnAdvHull.enabled = true
				
			)*/
			wwToolsFloater.rollouts[2].createPhys.enabled = true
			wwToolsFloater.rollouts[2].chk_jointrestrain.enabled = true
			wwToolsFloater.rollouts[2].spn_rotDamping.enabled = true
			wwToolsFloater.rollouts[2].btn_deleteHulls.enabled = true
			wwToolsFloater.rollouts[2].btn_mass.enabled = true
			wwToolsFloater.rollouts[2].chk_automass.enabled = true
			wwToolsFloater.rollouts[2].spn_mass.enabled = true
			wwToolsFloater.rollouts[2].chk_concave.enabled = true
			
			wwToolsFloater.rollouts[2].btn_addCM.enabled = true
	
			wwToolsFloater.rollouts[2].btn_appendCM.enabled = true
	
			wwToolsFloater.rollouts[2].chk_autoHull.enabled = true
			wwToolsFloater.rollouts[2].btn_update_count.enabled = true
			--wwToolsFloater.rollouts[5].chk1.enabled = true
			--wwToolsFloater.rollouts[5].opt_exportTGA.enabled = true
			 
			 wwToolsFloater.rollouts[3].lodSpinner.enabled = true
			 wwToolsFloater.rollouts[3].generateLODbtn.enabled = true
			wwToolsFloater.rollouts[3].chk_shadow.enabled = true	
	

	
			wwToolsFloater.rollouts[5].chk_idleSequence.enabled = true

			wwToolsFloater.rollouts[6].chk_collapsebones.enabled = true
			wwToolsFloater.rollouts[5].cbx_sequences.enabled = true
			wwToolsFloater.rollouts[5].btn_addSeq.enabled = true
			wwToolsFloater.rollouts[5].btn_delSeq.enabled = true
	
			wwToolsFloater.rollouts[5].cbx_sequences.items = ww_scene_lods.sequencelist	
			wwToolsFloater.rollouts[5].cbxSeqWeightlist.items = ww_scene_lods.weightlistnames		
			wwToolsFloater.rollouts[5].cbxWeightLists.items = ww_scene_lods.weightlistnames		
			
			wwToolsFloater.rollouts[5].spn_expStart.enabled = true
			wwToolsFloater.rollouts[5].spn_expEnd.enabled = true
			--wwToolsFloater.rollouts[5].edt_expSequenceName.enabled = true
			wwToolsFloater.rollouts[5].chk_expReverse.enabled = true
			wwToolsFloater.rollouts[5].chk_loop.enabled = true
	
			
	
			 wwToolsFloater.rollouts[7].chk_expHL1Format.enabled = true				
	
			 wwToolsFloater.rollouts[7].btn_illum.enabled = true		
			 wwToolsFloater.rollouts[7].spn_constantdirectionallight.enabled = true	
			 wwToolsFloater.rollouts[7].chk_ambientboost.enabled = true	
			
	
			
		wwToolsFloater.rollouts[6].cbx_attachmentList.enabled = true
		wwToolsFloater.rollouts[6].ddl_attachmentBone.enabled = true
		wwToolsFloater.rollouts[6].chk_attachmentAbsolute.enabled = true
		wwToolsFloater.rollouts[6].chk_attachmentRigid.enabled = true
		wwToolsFloater.rollouts[6].btn_createAttachment.enabled = true
		wwToolsFloater.rollouts[6].btn_deleteAttachment.enabled = true
		wwToolsFloater.rollouts[6].btn_attachUpdateBoneList.enabled = true
		wwToolsFloater.rollouts[6].btn_selectPoint.enabled = true
			
		wwToolsFloater.rollouts[1].addModel.caption = ww_scene_lods.modelName
			
			
			if ww_scene_lods.collapsebones != undefined then  (
				
				 wwToolsFloater.rollouts[6].chk_collapsebones.checked = ww_scene_lods.collapsebones
				 
			) else (
				wwToolsFloater.rollouts[6].collapsebones.checked = false
				)
			
			
			
		if ww_scene_lods.particlesystems.count	> 0 do (
			--include "$scripts/WallWorm.com/common/wwmt_particles.ms"
			local theSystems = #()
			for sys in ww_scene_lods.particlesystems do (
				--sys = (sys as wwmt_particles)
				append theSystems sys.systemname
				
	
				
				)
			
				wwToolsFloater.rollouts[6].cbxParticles.items =theSystems
			)
			
		wwToolsFloater.rollouts[6].ddlSeqList.items = ww_scene_lods.sequencelist		
			
	
			


			
		wwToolsFloater.rollouts[6].setParticleButtons()	
			
			
		
		wwToolsFloater.rollouts[8].ckb_expMorphsAsVTA.enabled = true
		wwToolsFloater.rollouts[8].btn_expVTAs.enabled = true
			wwToolsFloater.rollouts[8].btnCollectSkins.enabled = true
			wwToolsFloater.rollouts[8].btnCreateProxy.enabled = true
			wwToolsFloater.rollouts[8].btnSkins.enabled = true
			if ww_scene_lods.morphasvta != undefined then  (
				
				 wwToolsFloater.rollouts[8].ckb_expMorphsAsVTA.checked = ww_scene_lods.morphasvta
				 
			) else (
				
				wwToolsFloater.rollouts[8].ckb_expMorphsAsVTA.checked = true
				)		
			
	
	
	wwToolsFloater.rollouts[9].chk_allowstatic.enabled = true
	wwToolsFloater.rollouts[9].chk_blockLOS.enabled = true
	wwToolsFloater.rollouts[9].chk_AIWalkable.enabled = true
	wwToolsFloater.rollouts[9].chk_ignite.enabled = true
	wwToolsFloater.rollouts[9].chk_explosive_resist.enabled = true
	wwToolsFloater.rollouts[9].chk_flammable.enabled = true
	
			if ww_scene_lods.allowstatic != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_allowstatic.checked = ww_scene_lods.allowstatic
				 
			) else (
				wwToolsFloater.rollouts[9].chk_allowstatic.checked = false
				)
			if ww_scene_lods.blockLOS != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_blockLOS.checked = ww_scene_lods.blockLOS
				 
			) else (
				wwToolsFloater.rollouts[9].chk_blockLOS.checked = false
				
				)
	
				
			if ww_scene_lods.AIWalkable != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_AIWalkable.checked = ww_scene_lods.AIWalkable
				 
			) else (
				
				wwToolsFloater.rollouts[9].chk_AIWalkable.checked = false
				)
			if ww_scene_lods.ignite != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_ignite.checked = ww_scene_lods.ignite
				 
			) else (
				wwToolsFloater.rollouts[9].chk_ignite.checked = false
				)
				
			if ww_scene_lods.explosive_resist != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_explosive_resist.checked = ww_scene_lods.explosive_resist
				 
			) else (
				wwToolsFloater.rollouts[9].chk_explosive_resist.checked = false
				)
			if ww_scene_lods.flammable != undefined then  (
				
				 wwToolsFloater.rollouts[9].chk_flammable.checked = ww_scene_lods.flammable
				 
			) else (
				
				wwToolsFloater.rollouts[9].chk_flammable.checked = false
				)
	
	
	
	
	
	
	
	wwToolsFloater.rollouts[9].ddl_physicsmode.enabled = true	
	wwToolsFloater.rollouts[9].ddl_base.enabled = true
	wwToolsFloater.rollouts[9].ddl_breakable_model.enabled = true
	wwToolsFloater.rollouts[9].ddl_multiplayer_break.enabled = true
			
		wwToolsFloater.rollouts[9].btn_custGibs.enabled = true
		wwToolsFloater.rollouts[9].btn_compileGibsVTFs.enabled = true
		wwToolsFloater.rollouts[9].btn_removeGibs.enabled = true
		wwToolsFloater.rollouts[9].btn_compileGibs.enabled = true
	
					
		if ww_scene_lods.physicsmode != undefined do  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				try (
				 wwToolsFloater.rollouts[9].ddl_physicsmode.selection =  ww_scene_lods.physicsmode 
				)catch()
				 
		)
	
		if ww_scene_lods.base != undefined do  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				try(
				
				 if findItem wwToolsFloater.rollouts[9].ddl_base.items ww_scene_lods.base == 0 then (
						
					 oldBaseItems = wwToolsFloater.rollouts[9].ddl_base.items
					 appendIfUnique oldBaseItems ww_scene_lods.base
					 wwToolsFloater.rollouts[9].ddl_base.items = oldBaseItems
					 
				)
				 wwToolsFloater.rollouts[9].ddl_base.selection =  findItem wwToolsFloater.rollouts[9].ddl_base.items ww_scene_lods.base 
					
				 )catch(
					
					wwToolsFloater.rollouts[9].ddl_base.selection = 1
				)
		)
		if ww_scene_lods.breakable_model != undefined do  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				try(
				 wwToolsFloater.rollouts[9].ddl_breakable_model.selection =  findItem wwToolsFloater.rollouts[9].ddl_breakable_model.items ww_scene_lods.breakable_model 
				 )catch(
					wwToolsFloater.rollouts[9].ddl_breakable_model.selection = 1
					)
		)
		if ww_scene_lods.multiplayer_break != undefined do  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				try(
				 wwToolsFloater.rollouts[9].ddl_multiplayer_break.selection =  findItem wwToolsFloater.rollouts[9].ddl_multiplayer_break.items ww_scene_lods.multiplayer_break 
				 )catch(
					wwToolsFloater.rollouts[9].ddl_multiplayer_break.selection = 1
					
					)
		)
		
			
			
	
	wwToolsFloater.rollouts[9].btn_custGibs.enabled = true
	
			
			
	wwToolsFloater.rollouts[9].spn_health.enabled = true		
	wwToolsFloater.rollouts[9].spn_breakable_skin.enabled = true	
	wwToolsFloater.rollouts[9].spn_dmg_bullets.enabled = true
	wwToolsFloater.rollouts[9].spn_dmg_club.enabled = true
	wwToolsFloater.rollouts[9].spn_dmg_explosive.enabled = true			
	wwToolsFloater.rollouts[9].spn_breakable_count.enabled = true			
	wwToolsFloater.rollouts[9].spn_explosive_damage.enabled = true
	wwToolsFloater.rollouts[9].spn_explosive_radius.enabled = true			
	wwToolsFloater.rollouts[9].spn_fadetime.enabled = true
	wwToolsFloater.rollouts[9].chk_motiondisabled.enabled = true
	
	
	
	
		
		if ww_scene_lods.fadetime != undefined AND ww_scene_lods.fadetime != "undefined" do  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				try(
				 wwToolsFloater.rollouts[9].spn_fadetime.value =  ww_scene_lods.fadetime 
				 )catch(
					
					wwToolsFloater.rollouts[9].spn_fadetime.value = wwToolsFloater.rollouts[9].spn_fadetime.range[3]
					)
		)		
		
		if ww_scene_lods.motiondisabled != undefined AND (ww_scene_lods.motiondisabled == "true" OR ww_scene_lods.motiondisabled == true) then  (
				
			wwToolsFloater.rollouts[9].chk_motiondisabled.checked = true
		)	else (
			wwToolsFloater.rollouts[9].chk_motiondisabled.checked = false
		)
		
		

		
			
			if ww_scene_lods.health != undefined AND ww_scene_lods.health != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_health.value = (ww_scene_lods.health as integer)
				 
			) else(
				
				wwToolsFloater.rollouts[9].spn_health.value = wwToolsFloater.rollouts[9].spn_health.range[3]
				)
			if ww_scene_lods.breakable_skin != undefined AND ww_scene_lods.breakable_skin != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_breakable_skin.value = (ww_scene_lods.breakable_skin as integer)
				 
			) else(
				wwToolsFloater.rollouts[9].spn_breakable_skin.value = wwToolsFloater.rollouts[9].spn_breakable_skin.range[3]
				
				)
			if ww_scene_lods.dmg_bullets != undefined AND ww_scene_lods.dmg_bullets != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_dmg_bullets.value = ww_scene_lods.dmg_bullets
				 
			) else (
				wwToolsFloater.rollouts[9].spn_dmg_bullets.value = wwToolsFloater.rollouts[9].spn_dmg_bullets.range[3]
				)
			if ww_scene_lods.dmg_club != undefined AND ww_scene_lods.dmg_club != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_dmg_club.value = ww_scene_lods.dmg_club
				 
			) else (
				wwToolsFloater.rollouts[9].spn_dmg_club.value = wwToolsFloater.rollouts[9].spn_dmg_club.range[3]
				)
			if ww_scene_lods.dmg_explosive != undefined AND ww_scene_lods.dmg_explosive != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_dmg_explosive.value = ww_scene_lods.dmg_explosive
				 
			) else(
				wwToolsFloater.rollouts[9].spn_dmg_explosive.value = wwToolsFloater.rollouts[9].spn_dmg_explosive.range[3]
				
				)
			if ww_scene_lods.breakable_count != undefined AND ww_scene_lods.breakable_count != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_breakable_count.value = ww_scene_lods.breakable_count
				 
			) else (
				wwToolsFloater.rollouts[9].spn_breakable_count.value = wwToolsFloater.rollouts[9].spn_breakable_count.range[3]
				
				)
			if ww_scene_lods.explosive_damage != undefined AND ww_scene_lods.explosive_damage != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_explosive_damage.value = ww_scene_lods.explosive_damage
				 
			) else (
				
				wwToolsFloater.rollouts[9].spn_explosive_damage.value = wwToolsFloater.rollouts[9].spn_explosive_damage.range[3]
				)
			if ww_scene_lods.explosive_radius != undefined AND ww_scene_lods.explosive_radius != "undefined" then  (
				
				 wwToolsFloater.rollouts[9].spn_explosive_radius.value = ww_scene_lods.explosive_radius
				 
			)	else (
				wwToolsFloater.rollouts[9].spn_explosive_radius.value = wwToolsFloater.rollouts[9].spn_explosive_radius.range[3]
				
				)
			
			
	
			
			wwToolsFloater.rollouts[6].cbx_attachmentList.items = ww_scene_lods.attachmentlist
			wwToolsFloater.rollouts[6].ddl_attachToAttachment.items = ww_scene_lods.attachmentlist	
				
				
			
			
			
			wwToolsFloater.rollouts[6].ddl_attachmentBone.items = ww_scene_lods.boneNameList()
	
			
			 if ww_scene_lods.modelPath != undefined do  (
				 
				local ind = findItem wwToolsFloater.rollouts[1].edt1_modelPath.items ww_scene_lods.modelPath
				 
				if ind == 0 do (
					local temp = wwToolsFloater.rollouts[1].edt1_modelPath.items
					append temp ww_scene_lods.modelPath
					sort temp
					wwToolsFloater.rollouts[1].edt1_modelPath.items = temp
					ind = findItem wwToolsFloater.rollouts[1].edt1_modelPath.items ww_scene_lods.modelPath
					) 
				 
				 wwToolsFloater.rollouts[1].edt1_modelPath.selection = ind
				 
	
				 
				 
				 )
			if ww_scene_lods.materialPath != undefined do  (
				
				
				
				local ind = findItem wwToolsFloater.rollouts[1].edt2_materialFolder.items ww_scene_lods.materialPath
				 
				if ind == 0 do (
					local temp = wwToolsFloater.rollouts[1].edt2_materialFolder.items
					append temp ww_scene_lods.materialPath
					
					sort temp
					wwToolsFloater.rollouts[1].edt2_materialFolder.items = temp
					ind = findItem wwToolsFloater.rollouts[1].edt2_materialFolder.items ww_scene_lods.materialPath
					) 
				 
				 wwToolsFloater.rollouts[1].edt2_materialFolder.selection = ind
				
				
				 
			)
			if ww_scene_lods.surfaceprop != undefined then  (
				
				 wwToolsFloater.rollouts[1].ddl1.selection =  findItem wwToolsFloater.rollouts[1].ddl1.items ww_scene_lods.surfaceprop 
				 
			) else (
				wwToolsFloater.rollouts[1].ddl1.selection = 1
				)
				
			if ww_scene_lods.shaderType != undefined then  (
				 wwToolsFloater.rollouts[1].ddl_shader.selection =  findItem wwToolsFloater.rollouts[1].ddl_shader.items ww_scene_lods.shaderType 
				 
			) else (
				wwToolsFloater.rollouts[1].ddl_shader.selection = 1
				
				)
				
			if ww_scene_lods.compression != undefined then  (
				 wwToolsFloater.rollouts[1].ddl_compression.selection =  findItem wwToolsFloater.rollouts[1].ddl_compression.items ww_scene_lods.compression 
				 
			) else (
				wwToolsFloater.rollouts[1].ddl_compression.selection = 5
				
				)
				
				
				
			if ww_scene_lods.staticprop != undefined then  (
				
				 wwToolsFloater.rollouts[1].chk_staticprop.checked = ww_scene_lods.staticprop
				 
			) else (
				wwToolsFloater.rollouts[1].chk_staticprop.checked = false
			)
			
			
			if ww_scene_lods.alwayscollapse != undefined then  (
				
				 wwToolsFloater.rollouts[1].chk_alwayscollapse.checked = ww_scene_lods.alwayscollapse
				 
			) else (
				wwToolsFloater.rollouts[1].chk_alwayscollapse.checked = false
			)
			
			

			
			
				
			if ww_scene_lods.locked != undefined then  (
				
				 wwToolsFloater.rollouts[1].chk_lockQC.checked = ww_scene_lods.locked
				 
			) else(
				wwToolsFloater.rollouts[1].chk_lockQC.checked = false
				)
				
				
				
				
	
				
			if ww_scene_lods.noselfcollisions != undefined then  (
				
				 wwToolsFloater.rollouts[2].chk_noselfcollisions.checked = ww_scene_lods.noselfcollisions
				 
			) else(
				wwToolsFloater.rollouts[2].chk_noselfcollisions.checked = false
			)
				
			if ww_scene_lods.animatedfriction != undefined then  (
				
				 wwToolsFloater.rollouts[2].edt_animatedfriction.text = ww_scene_lods.animatedfriction
				 
			) else(
				wwToolsFloater.rollouts[2].edt_animatedfriction.text = ""
			)
			
			
				
				
			if ww_scene_lods.opaque != undefined then  (
				
				 wwToolsFloater.rollouts[1].chk_opaque.checked = ww_scene_lods.opaque
				 
			) else(
				wwToolsFloater.rollouts[1].chk_opaque.checked = false
				)
			
			if ww_scene_lods.normalMethod != undefined then  (
				
				 wwToolsFloater.rollouts[1].ddlNormals.selection = ww_scene_lods.normalMethod
				 
			) else(
				wwToolsFloater.rollouts[1].ddlNormals.selection = 3
				)
	
				
				
				
			if ww_scene_lods.shadowlod != undefined then  (
				
				 wwToolsFloater.rollouts[3].chk_shadow.checked = ww_scene_lods.shadowlod
				 
			) else (
				wwToolsFloater.rollouts[3].chk_shadow.checked = false
				)
			if ww_scene_lods.mostlyopaque != undefined then  (
				
				 wwToolsFloater.rollouts[1].chk_mostlyopaque.checked = ww_scene_lods.mostlyopaque
				 
			)	else (
				
				wwToolsFloater.rollouts[1].chk_mostlyopaque.checked = false
				)
	
			if ww_scene_lods.concave != undefined then  (
				
				 wwToolsFloater.rollouts[2].chk_concave.checked = ww_scene_lods.concave
				 
			)	else (
				
				wwToolsFloater.rollouts[2].chk_concave.checked = false
				)
			
			
			if ww_scene_lods.jointConstraints != undefined then  (
				
				 wwToolsFloater.rollouts[2].chk_jointrestrain.checked = ww_scene_lods.jointConstraints
				 
			)	else (
				
				wwToolsFloater.rollouts[2].chk_jointrestrain.checked = false
				)
			
	
			
			if ww_scene_lods.mass != undefined then  (
				
				 wwToolsFloater.rollouts[2].spn_mass.value = ww_scene_lods.mass
				 
			) else (
				wwToolsFloater.rollouts[2].spn_mass.value = wwToolsFloater.rollouts[2].spn_mass.range[3]
				
				)
			
	
			
	
			
			if ww_scene_lods.inertia != undefined then  (
				
				 wwToolsFloater.rollouts[2].spn_inertia.value = ww_scene_lods.inertia
				 
			) else (
				
				wwToolsFloater.rollouts[2].spn_inertia.value = wwToolsFloater.rollouts[2].spn_inertia.range[3]
				
				)
			
			
			
	
			
			
			if ww_scene_lods.phdrag != undefined then (
				
				 wwToolsFloater.rollouts[2].spn_phdrag.value = ww_scene_lods.phdrag
				 
			) else(
				wwToolsFloater.rollouts[2].spn_phdrag.value = wwToolsFloater.rollouts[2].spn_phdrag.range[3]
				)
			
			if ww_scene_lods.damping != undefined then  (
				
				 wwToolsFloater.rollouts[2].spn_damping.value = ww_scene_lods.damping
				 
			) else (
				
				wwToolsFloater.rollouts[2].spn_damping.value = wwToolsFloater.rollouts[2].spn_damping.range[3]
				)
			
			if ww_scene_lods.rotDamping != undefined then  (
				
				 wwToolsFloater.rollouts[2].spn_rotDamping.value = ww_scene_lods.rotDamping
				 
			) else(
				wwToolsFloater.rollouts[2].spn_rotDamping.value = wwToolsFloater.rollouts[2].spn_rotDamping.range[3]
				)
			
				
			if ww_scene_lods.autoHull != undefined then (
				
				wwToolsFloater.rollouts[2].chk_autoHull.checked = ww_scene_lods.autoHull
				) else(
				wwToolsFloater.rollouts[2].chk_autoHull.checked = false
				)
	
			
			if ww_scene_lods.contents != undefined then  (
				
				--i = findItem  wwToolsFloater.rollouts[4].ddl1.items surfaceprop
				
				 wwToolsFloater.rollouts[2].ddl_contents.selection =  findItem wwToolsFloater.rollouts[2].ddl_contents.items ww_scene_lods.contents 
				 
			) else (
				
				wwToolsFloater.rollouts[2].ddl_contents.selection = 1
				)
			
			
			
			
			if ww_scene_lods.mscale != undefined then  (
				
				 wwToolsFloater.rollouts[1].spn_scale.value = ww_scene_lods.mscale
				 
			) else (
				
				wwToolsFloater.rollouts[1].spn_scale.value = wwToolsFloater.rollouts[1].spn_scale.range[3]
				)
			
			if ww_scene_lods.mapChannel != undefined then  (
				
				 wwToolsFloater.rollouts[1].spn_mapChannel.value = ww_scene_lods.mapChannel				 
			) else (
				
				wwToolsFloater.rollouts[1].spn_mapChannel.value = wwmt_mappingChannel as integer
			)
				
				
			if ww_scene_lods.lockInitialOrigin != undefined AND ww_scene_lods.lockInitialOrigin == true then  (
				
				 wwToolsFloater.rollouts[1].chk_lock_origin.state = true
				 
			) else (
				 wwToolsFloater.rollouts[1].chk_lock_origin.state = false
	
				)
			
			
	
				
	
				
				if ww_scene_lods.automass != undefined then (
					
					
					wwToolsFloater.rollouts[2].chk_automass.checked = ww_scene_lods.automass
					) else (
					
					wwToolsFloater.rollouts[2].chk_automass.checked = false
					)
				
			
			if ww_scene_lods.lods.count > 0 then (
				
				 wwToolsFloater.rollouts[3].lodSpinner.value = ww_scene_lods.lods.count
				) else (
				wwToolsFloater.rollouts[3].lodSpinner.value = wwToolsFloater.rollouts[3].lodSpinner.range[3]
				
				)
			
				
				if ww_scene_lods.hulls.count>0 AND isValidNode ww_scene_lods.hulls[1] then(
					
					wwToolsFloater.rollouts[2].addPhys.caption = ww_scene_lods.hulls[1].name
	
					
					) else (
					wwToolsFloater.rollouts[2].addPhys.caption = "Pick Hull"
					
					)
					
					
			if ww_scene_lods.useLocalOrigin != undefined then (
				
				
				wwToolsFloater.rollouts[1].chk_localOrigin.checked = ww_scene_lods.useLocalOrigin
				
				) else (
				
				wwToolsFloater.rollouts[1].chk_localOrigin.checked = false
				)
				
				
			if ww_scene_lods.internalOrigin != undefined then (
				
				
				wwToolsFloater.rollouts[1].chkInternalOrigin.checked = ww_scene_lods.internalOrigin
				
				) else (
				
				wwToolsFloater.rollouts[1].chkInternalOrigin.checked = false
				)
				
				
				
	
			if ww_scene_lods.rotateRefsystem != undefined then (
	
				wwToolsFloater.rollouts[1].chkRotateOrigin.checked = ww_scene_lods.rotateRefsystem
				
			) else (
				
				wwToolsFloater.rollouts[1].chkRotateOrigin.checked = false
			)
				
				
				if ww_scene_lods.altOrigin != undefined then (
					wwToolsFloater.rollouts[1].chk_altOrigin.checked = ww_scene_lods.altOrigin
				)	else (
					wwToolsFloater.rollouts[1].chk_altOrigin.checked  = false
				)
	
				
				if ww_scene_lods.idleSequence != undefined then (
					wwToolsFloater.rollouts[5].chk_idleSequence.checked = ww_scene_lods.idleSequence
				)	else (
					wwToolsFloater.rollouts[5].chk_idleSequence.checked  = true
				)

				
				if ww_scene_lods.expHL1Format != undefined then  (
					if (ww_scene_lods.expHL1Format == 1 ) then (
					 wwToolsFloater.rollouts[7].chk_expHL1Format.checked = true
					) else (
						wwToolsFloater.rollouts[7].chk_expHL1Format.checked = false
					)
				) else(
						wwToolsFloater.rollouts[7].chk_expHL1Format.checked = false
				)
				
				if ww_scene_lods.ambientboost != undefined then  (
					
					if (ww_scene_lods.ambientboost == 1 OR ww_scene_lods.ambientboost == true) then (
					   wwToolsFloater.rollouts[7].chk_ambientboost.checked = true
					) else (
						wwToolsFloater.rollouts[7].chk_ambientboost.checked = false
					)
				) else(
						wwToolsFloater.rollouts[7].chk_ambientboost.checked = false
				)
				
				if ww_scene_lods.constantdirectionallight != undefined then  (
					 wwToolsFloater.rollouts[7].spn_constantdirectionallight.value = ww_scene_lods.constantdirectionallight
				) else(
					 wwToolsFloater.rollouts[7].spn_constantdirectionallight.value =  wwToolsFloater.rollouts[7].spn_constantdirectionallight.range[3]
				)
						
					
		
				wwmt_activateLODMenus ww_scene_lods.lods
				if ww_scene_lods.target != undefined then (
					 wwToolsFloater.rollouts[1].btn_appendModels.enabled =true
					wwToolsFloater.rollouts[1].btn_addSelection.enabled = true
					if ww_scene_lods.targets.count >1 then (
						wwToolsFloater.rollouts[1].btn_removeSelFromTargets.enabled = true
					)
					ww_scene_lods.setTargetCust()
				)
				
			global wallworm_reset_wwmt = undefined
					
	)
	



function wwmt_CallbackLODCamMove obj = (
wwmtviewindex = 0;

								if isDeleted obj == false then (

									disablesceneredraw
									
									
									
										
								for l in ww_scene_lods.lods do (
									
									if ((distance l.helperTape.position ww_scene_lods.targets[1].pos)  < (distance obj.pos ww_scene_lods.targets[1].pos)) do (
										
											if l.level > wwmtviewindex do (
												wwmtviewindex = l.level
											)
										)
									
									
									)
								
								if wwmtviewindex == 0 then (
									unhide ww_scene_lods.targets
									) else (
									
									hide ww_scene_lods.targets
									)
								for l in ww_scene_lods.lods do (
									
									if(l.level == wwmtviewindex) then (
										
										unhide l.items
										) else (
										
										hide l.items
										
										)
									
									
									)
								enablesceneredraw

								) else()
	
	)



		function wwmt_allowedTarget obj = (
		
		if ( (superClassOf obj) == GeometryClass OR (superClassOf obj) == Shape)then (
			return true
		) else (
		return false
		)
		
		)
		
		
		
function wwmt_activateLODMenus ar = (
	
	        if ww_scene_lods.lods != undefined do (
	       -- local lodcount = ww_scene_lods.lods.count

				
				local ind = 1
				while ind <=wwmt_lodLimit do (
					nextx = ind+1				
					selStr=""
				if ar.count >= ind then (

				if nextx <=wwmt_lodLimit do (
					str = "wwToolsFloater.rollouts[4].pickLOD"+nextx as string+".enabled = true\n"
					append selStr str
				)
				
				str = "wwToolsFloater.rollouts[4].pickLOD"+ind as string+".enabled = true\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].addSelLOD"+ind as string+".enabled = true\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].appendLOD"+ind as string+".enabled = true\n"
				append selStr str
				
				str =  "wwToolsFloater.rollouts[4].btnPickLOD"+ind as string+"Helper.enabled = true\n"
				append selStr str
				str = 	"wwToolsFloater.rollouts[4].btnViewLOD"+ind as string+".enabled = true\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLOD"+ind as string+".enabled = true\n"	
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLODMetric"+ind as string+".enabled = true\n"	
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLODMetricGet"+ind as string+".enabled = true\n"	
				append selStr str
				
				
				
				str = "wwToolsFloater.rollouts[4].spnLODMetric"+ind as string+".value = (ww_scene_lods.lods["+ind as string+"].getMetric() as float) \n"	
				append selStr str
				
				str = "wwToolsFloater.rollouts[4].pickLOD"+ind as string+".caption = \"LOD "+ind as string+"\" \n"	
				append selStr str
				
				str = "wwToolsFloater.rollouts[4].btnMatLOD"+ind as string+".enabled = true\n"	
				append selStr str
				str = "wwToolsFloater.rollouts[4].delSelLOD"+ind as string+".enabled = true\n"	
				append selStr str
				str = "wwToolsFloater.rollouts[4].delLOD"+ind as string+".enabled = true\n"	
				append selStr str
				
				
				
				if ww_scene_lods.lods != undefined then (
					
					--add wrapper if missing
					try(
						lodVal = ww_scene_lods.lods[ind].getMyRes() as string
					) catch (
						lodVal = wwmt_vertexPercentages[ind]
						
						)
					) else (
					lodVal = wwmt_vertexPercentages[ind]
					
					)
				str = "wwToolsFloater.rollouts[4].spnLOD"+ind as string+".value = "+(lodVal as string)+"	\n"
			
				--str = "wwToolsFloater.rollouts[3].spnLOD"+ind as string+".value = ww_scene_lods.lods["+ind as string+"].getMyRes()	\n"
				append selStr 	str		
						
						
					

				
				
				
			) else (
					default = wwmt_vertexPercentages[ind]
					
				if nextx <=wwmt_lodLimit do (
					str = "wwToolsFloater.rollouts[4].pickLOD"+nextx as string+".enabled = false\n"
					append selStr str
				)
				
				str = "wwToolsFloater.rollouts[4].delLOD"+ind as string+".enabled = false\n"	
				append selStr str
				
				str = "wwToolsFloater.rollouts[4].btnPickLOD"+ind as string+"Helper.enabled = false\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].btnViewLOD"+ind as string+".enabled = false\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLOD"+ind as string+".enabled = false\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLODMetric"+ind as string+".enabled = false\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLODMetricGet"+ind as string+".enabled = false\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLODMetricGet"+ind as string+".enabled = false\n"
				append selStr str

				
				
				str = "wwToolsFloater.rollouts[4].pickLOD"+ind as string+".caption = \"Pick LOD "+ind as string+"\"\n"
				append selStr str
				str = "wwToolsFloater.rollouts[4].spnLOD"+ind as string+".value = "+default as string+"\n"
				append selStr str
				
				)
					try (
						execute selStr as string					
					) catch (
						
						)
					
					
					
					
					ind = ind + 1
					
					)
				
				
				
				
				
				
		)
			
			
	)
	
rollout wwmt_cm "Collision Model & Physics" width:250 height:464
(

	button btn_addCM "Add CM Sel" pos:[165,23] width:66 height:14 enabled:false toolTip:"Click to add Currently Selected mesh(es) to to the the Collision Model."
	pickbutton btn_appendCM "Append CM" pos:[165,7] width:66 height:13 enabled:false toolTip:"Click to choose another mesh to add to the Collision Model."
	button btn_deleteHulls "Del Sel" pos:[181,41] width:49 height:25 enabled:false toolTip:"Remove Selected Items from the Collision Hull List of this model."
	pickbutton addPhys "Pick Collision Model" pos:[15,7] width:146 height:30 enabled:false toolTip:"Pick a collision model you have already made for this model."
	button createPhys "Quick Hull" pos:[14,63] width:146 height:25 enabled:false toolTip:"Create a Collision Model from the model. This will automatically make a convex mesh for each element of the picked object. If there is only one element, the collision model may not be very realistic." 
 
 
 
	spinner spn_inertia "Inertia" pos:[153,207] width:75 height:16 enabled:false range:[0,1e+009,1] toolTip:"Inertial Scale"
	spinner spn_Damping "Damping" pos:[141,232] width:87 height:16 enabled:false range:[0,1e+009,1] toolTip:"Damping Scale"
	spinner spn_phdrag "Drag" pos:[158,259] width:69 height:16 enabled:false range:[0,1e+009,1] toolTip:"Drag Scale"
	spinner spn_mass "Mass" pos:[155,181] width:73 height:16 enabled:false range:[0,1e+009,0] toolTip:"Set a value for the mass of this object. This value will not be used if $automass is checked."
	checkbox chk_automass "$automass" pos:[12,180] width:69 height:17 enabled:false toolTip:"Calculate mass of object based on volume and the type of material defined by Surface Property. This will override values entered into the mass field."
	checkbox chk_concave "$concave" pos:[12,201] width:69 height:18 enabled:false
	button btn_mass "Mass" pos:[176,139] width:48 height:32 enabled:false images:#("$scripts\Wallworm.com\assets\wwmt_mass_icon_buttons.png", undefined, 2, 1, 1, 2, 1, false) toolTip:"Click Here to select the Mass Center"
	checkbox chk_jointrestrain "$jointconstrain" pos:[12,311] width:94 height:16 enabled:false toolTip:"Add $jointconstrain limits to the joints of this model based off of the bone IK info"
	dropdownList ddl_contents "Contents" pos:[12,131] width:157 height:40 enabled:false items:#("solid", "notsolid", "monster", "ladder", "grate")
	spinner spn_rotDamping "Rot Damping" pos:[121,287] width:105 height:16 enabled:false
	button btn_SelectHulls "Select Collision Hulls" pos:[12,364] width:103 height:40 toolTip:"Select in viewport all meshes belonging to the collision hull."
	pickbutton btn36 "Prepare CM" pos:[13,411] width:102 height:40 toolTip:"Pick an object that needs to be prepared to be turned into a Collision Mesh. This tool will apply a unique smoothing group to each Element sub-object of the picked object."
	button btnHideCM "Hide CM" pos:[124,364] width:50 height:40 toolTip:"Hide all meshes belonging to the collision hull."
	button btnShowCM "Show CM" pos:[182,364] width:51 height:40 toolTip:"Unhide all meshes belonging to the collision hull."
	checkbox chk_autoHull "Auto Hull" pos:[12,287] width:61 height:20 enabled:false toolTip:"Use the root model SMD for generating a Collision Hull. Should not be used with animated models."
	button btn_processCM "Process CM" pos:[122,411] width:111 height:40 toolTip:"Click here to give each element in the Hull a unique smoothing group."
	button btnAdvHull "Adv Hull" pos:[150,100] width:71 height:23 enabled:true toolTip:"Open the Convexity Advanced Hull Generator from Maple 3D."
	GroupBox grp1 "Hull Count" pos:[9,220] width:72 height:39
	button btn_update_count "^" pos:[48,235] width:24 height:19 enabled:false toolTip:"Press to update the Hull Count."
	label lbl_hullcount "?" pos:[16,234] width:27 height:20
	spinner spn_max_verts "Max Verts Hulls" pos:[53,44] width:109 height:16 range:[4,4096,44] type:#integer scale:1 toolTip:"Maximum vertices per hull in generated hull."
	button btn_hull_helper "WW Hull Helper" pos:[15,98] width:121 height:25 toolTip:"Open the Hull Helper Utility Floater; provides tools for quickly and efficiently making complex hulls from your meshes."
	checkbox chk_noselfcollisions "No Self Collisions" pos:[13,265] width:100 height:20 enabled:false toolTip:"Do not allow collision hulls in same model collide with each other."
	editText edt_animatedfriction "Animated Friction" pos:[13,335] width:222 height:18 tooltip:"<float|FrictionTimeIn> <float|FrictionTimeOut> <float|FrictionTimeHold> <float|MinAnimatedFriction> <float|MaxAnimatedFriction> Used to animate the amount of friction on joints over time.  "
	

	on edt_animatedfriction entered text do
	(		
		ww_scene_lods.setAnimatedfriction(text)
	)
	
	

	function turnOffAutoHull = (
		if ww_scene_lods.autoHull == false then (
			chk_autoHull.checked = false
		)
	)

	on btn_addCM pressed do
	(
		if subobjectLevel==undefined OR subobjectLevel == 0 then (
		
			for obj in selection do (
				ww_scene_lods.appendHull(obj)
			)
			turnOffAutoHull()
		) else (
			
			messagebox "You can only use this function if the Sub-Object Level in the Modifier Stack is set to 0.\n\n(This means you are currently at Vertex, Edge, Border, Polygon or Element level."
			
		)
	)
	on btn_appendCM picked obj  do
	(

		if (ww_scene_lods.addAHull(obj) ) then (
			turnOffAutoHull()
		) else (
			messagebox "There was a problem... do not use Grouped geometry."
		)
	)
	on btn_deleteHulls pressed do
	(
			ww_scene_lods.removeItemsFromHulls selection
	
		)
	on addPhys picked obj do
	(
	
			if (ww_scene_lods.addPhysModel obj ) then (
				addPhys.caption = ww_scene_lods.phys.name
				turnOffAutoHull()
			) else (
				messagebox "The action failed. Do not use Grouped geometry."
				)
			)
	on createPhys pressed do
	(
		if (ww_scene_lods.createHull maxVerts:spn_max_verts.value) == true then (
		
	
	-- test if hull fns are available and if so run them.
			
			
	
			
			if ww_scene_lods.hulls.count > 1 OR ww_scene_lods.concave == true do (
				chk_concave.checked = true
			)
			turnOffAutoHull()
	
		) else (
				messagebox "There was a problem:\n\n The Wall Worm Hull Helper only works if you have either:\n\n *The nVidia PhysX Plugin or MassFX (Integrated into 3ds Max 2013+)\n*Convexity 1.17+.\n\nIf you meet one of these requirements, please submit a bug report.\n\n*Unfortunately, some versions of PhysX/MassFX have broken the hull function."
			)
		)
	on spn_inertia changed val do
	(
			    	ww_scene_lods.setInertia(val)
	)
	on spn_Damping changed val do
	(
			    	ww_scene_lods.setDamping(val)
	)
	on spn_phdrag changed val do
	(
			    	ww_scene_lods.setPhdrag(val)
	)
	on spn_mass changed val do
	(
		ww_scene_lods.setMass(val)
		ww_scene_lods.setAutoMass(false)
		chk_automass.checked = false
		
	)
	on chk_automass changed state do
	(
					
					
					if state == true then (
		    	    	
		    	    	
		    				ww_scene_lods.setAutomass(true)
		    	    	
		    	    	) else (
		    	    	ww_scene_lods.setAutomass(false)
		    	    	
		    	    	)
					
		
					
					
					
					)
	on chk_concave changed state do
	(
	    	if state == true then (
	    	
	    	ww_scene_lods.setConcave(true)
	    	
	    	) else (
	    	ww_scene_lods.setConcave(false)
	    	
	    	)
			
		)
	on btn_mass pressed do
	(
		if ww_scene_lods.massorigin == undefined OR isDeleted ww_scene_lods.massorigin do (
			
			ww_scene_lods.createMassHelper()
			)
		
		
			select ww_scene_lods.massorigin 
		
	)
	on chk_jointrestrain changed state do
	(
		if state == true then (
			ww_scene_lods.setJointConstraints(true)
		) else (
			
			ww_scene_lods.setJointConstraints(false)
			)
	
	)
	on ddl_contents selected sel do
	(
	    	ww_scene_lods.setContents(ddl_contents.items[sel])
	    	
			)
	on spn_rotDamping changed val do
	(
	ww_scene_lods.setRotDamping(val)
	
	)
	on btn_SelectHulls pressed do
	(
			if ww_scene_lods.hulls.count > 0 do (
				clearSelection()
				ww_scene_lods.hulls = for obj in ww_scene_lods.hulls WHERE isValidNode obj collect obj
				select ww_scene_lods.hulls
				redrawviews()
			)
		)
	on btn36 picked obj do
	(
				convertto obj editable_poly
				wwmt_hullsmoothinggroups (#(obj)) sg
		)
	on btnHideCM pressed do
	(
		ww_scene_lods.hideCM()
		redrawviews()
	)
	on btnShowCM pressed do
	(
		ww_scene_lods.showCM()
		redrawviews()
	)
	on chk_autoHull changed state do
	(
	
		ww_scene_lods.setAutoHull state
	
	)
	on btn_processCM pressed do
	(
	
	 if ww_scene_lods.hulls.count > 0 do (
		 try (
			wwmt_hullsmoothinggroups ww_scene_lods.hulls 1
			 redrawviews()
		 ) catch (
			 local error = getCurrentException() as string
			 print (error)
			messagebox error 
		)
	 )
	
	
	
	
	)
	on btnAdvHull pressed do
	(
		
		if Maple3D_HullFnsAvailable() then (
		
			if selection.count == 0 do (
				select ww_scene_lods.targets
			)
			try(fileIn "$userscripts/Convexity/Maple3D_ConvexWrapperV0_94.mse");catch(
						messagebox "This function requires Convexity. Please go to www.maple3d.com . If you already have Convexity, you may need to get the latest version or contact Maple3D."
				)
				
		) else (
		
		messagebox "This function requires Convexity. Please go to www.maple3d.com . If you already have Convexity, you may need to get the latest version or contact Maple3D."
		
		)
	
		
	)
	on btn_update_count pressed do
	(
		
		
		if ww_scene_lods.autoHull == undefined OR ww_scene_lods.autoHull==false then (
			try (
			
				local hullcount = 0
			
				if ww_scene_lods.hulls.count > 0 then (
			
				local cc
				if ww_scene_lods.concave == undefined then (
					cc = false
					) else (
						cc = ww_scene_lods.concave
					)
					if cc == true then (
						hullcount = wwmt_count_hulls ww_scene_lods.hulls cc
					) else (
						hullcount = 1
						)
			) else (
				hullcount = 0
				)
				
				
				if hullcount != undefined AND hullcount <= 20 then (
					--wwToolsFloater.rollouts[2].ddl_hullcount.enabled = false
						if hullcount == 0 do (
							 hullcount = "0"
							)
						lbl_hullcount.caption = ((hullcount as string))
					) else(
					--wwToolsFloater.rollouts[2].ddl_hullcount.enabled = true
						lbl_hullcount.caption = ((hullcount as string)	+"!")
					)
				
				
				
				
				
				
				
			) catch (
				messagebox "There was a problem. Fress F11 for more details."
				print (getCurrentException())
			)
		) else (
			messagebox "This function only works when Auto Hull is not checked; you have to create your own hulls or use the Quick Hull or Adv Hull functions."
		)

	)
	on btn_hull_helper pressed do
	(
	macros.run "wallworm.com" "WallWormHullHelperMCR"
	
	
	)
	on chk_noselfcollisions changed state do
	(
	
	ww_scene_lods.setNoselfcollisions state
	)
)

global wallworm_wwmt_pick_fast

rollout Wall_Worm_Model_Tools "Model & Basic QC" width:250 height:677
(
-- 
	pickbutton addModel "Pick Model" filter:wallworm_allowed_wwmt_obj pos:[9,7] width:119 height:37 toolTip:"Pick your model. If your model is composed of multiple meshes, choose the root mesh that will be used to define the origin. For existing WWMT, pick the WWMT Helper Name to pre-fill details of a model you've already made." autoDisplay:false
	pickbutton btn_appendModels "Append" pos:[147,8] width:91 height:14 enabled:false toolTip:"Click to choose another mesh to add to the Model."
	button btn_addSelection "Add Sel" pos:[147,28] width:44 height:16 enabled:false toolTip:"Click to add Currently Selected mesh(es) to to the Model."
	button btn_removeSelFromTargets "Del Sel" pos:[195,28] width:42 height:15 enabled:false toolTip:"Remove selected objects from the model."
	dropdownList ddl1 "Surface Property" pos:[11,56] width:136 height:40 enabled:false
	button runExport "Export QC+Model" pos:[137,539] width:100 height:37 enabled:false toolTip:"Click to run the Model Exporter... which creates SMDs, QCs, VTAs and a batch file in sdk_content folders. Compiles the Model."
	button runQC "Write QC" pos:[8,539] width:60 height:37 enabled:false toolTip:"Click to write just the QCs. Does not compile."
	button runSMD "Write SMDs" pos:[70,539] width:66 height:37 enabled:false toolTip:"Click to write just the SMDs. Does not compile."
	
	label lbl1 "Model Folder Path" pos:[10,293] width:90 height:18 toolTip:"Enter a path that is relative to the Mod's Model folder."
	label lbl2 "Material Folder Path" pos:[12,372] width:141 height:21 toolTip:"Enter a path that is relative to the Mod's Material folder."
	combobox edt1_modelPath "" pos:[6,310] width:229 height:3 enabled:false toolTip:"Enter the folder path relative to the SDK model folder without starting or ending slashes."	    
	    
	    
	combobox edt2_materialFolder "" pos:[9,392] width:226 height:3 enabled:false toolTip:"Enter the folder path relative to the SDK material folder without starting or ending slashes."  
  
  
	GroupBox grp1 "Settings" pos:[8,99] width:228 height:86
	checkbox chk_staticprop "$staticprop" pos:[13,116] width:79 height:14 enabled:false toolTip:"Check here is this is a static prop with no animations."
	checkbox chk_opaque "$opaque" pos:[13,163] width:67 height:14 enabled:false toolTip:"Check this to tell the compiler this is an opaque model. Also forces VMTs for this model to exclude any translucency if your WWMT Settings force this."
	checkbox chk_mostlyopaque "$mostlyopaque" pos:[83,163] width:94 height:14 enabled:false
	checkbox chk_alwayscollapse "$alwayscollapse" pos:[13,133] width:98 height:14 enabled:false toolTip:"Collapse the mesh bones for skinned models. (Only keep bones in skin)."
	
	spinner spn_scale "Scale" pos:[146,127] width:84 height:16 enabled:false range:[0.01,100,1] scale:0.1		
		
		
	edittext edt_ModelName "Model Name" pos:[11,453] width:224 height:27 toolTip:"Enter the name for this model (only use letters, numbers and underscore. Avoid spaces, periods or any special characters)."
	button btn_SelectModel "Select Model" pos:[152,68] width:86 height:15 enabled:false toolTip:"Select in viewport all meshes that are part of the base model (not collision hulls or LODs)."
	button btnSelectWWMTHelper "Select WWMT" pos:[152,85] width:85 height:12 toolTip:"Select the WWMT Helper for this model in the scene."
	button btn_illum "Illumination" pos:[182,147] width:48 height:32 enabled:false images:#("$scripts\Wallworm.com\assets\wwmt_illum_icon_buttons.png", undefined, 2, 1, 1, 2, 1, false) toolTip:"Click Here to select the Illumination Origin"
	button btn_tex "Export VTFs" pos:[122,628] width:108 height:26 enabled:false toolTip:"Click here to compile the textures in your model to VMTs and VTFs."
	button btn_open_model_folder "Mdlsrc" pos:[195,292] width:40 height:16 toolTip:"Click here to open the model folder."
	button btn_open_mat_folder "Raw" pos:[197,372] width:38 height:16 toolTip:"Click here to open the material folder."
	button btn_setSkyScale "1/16" pos:[166,109] width:29 height:17 enabled:false toolTip:"Set to Skybox Scale ( 1/16 )"
	button btn_setSkyScale2 "1/32" pos:[198,109] width:32 height:17 enabled:false toolTip:"Set to L4D Skybox Scale ( 1/32 )"
	label lbl3 "Sky Scales" pos:[114,108] width:52 height:15
	checkbox chk_altOrigin "Flip" pos:[15,225] width:36 height:15 enabled:false toolTip:"Click here if the model should be flipped (mirrored)."
	GroupBox grp_Origin "$origin" pos:[9,193] width:228 height:91
	checkbox chk_localOrigin "Use Local Origin as World Origin" pos:[15,206] width:176 height:17 enabled:false toolTip:"Click here if you want the origin of the model's world set to the model's origin. This might be necessary if you are creating models inside of scenes instead of their own files."
	checkbox chk_lock_origin "Lock Origin State" pos:[56,225] width:106 height:15 enabled:false toolTip:"Check this option if the root node is animated in its own space."
	HyperLink custAltHelp "Origin Offset" pos:[163,258] width:64 height:18 address:"http://dev.wallworm.com/document/56/model__basic_qc_rollout.html#uselocalorigin" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	checkbox chk_lockQC "Lock QC" pos:[12,486] width:66 height:17 enabled:false checked:false toolTip:"Click here if you do not want to overwrite the QC for this model after it has been generated. When locked, the export process will only overwrite SMDs when you export."
	dropdownList ddl_shader "" pos:[122,602] width:108 height:21 enabled:false items:#("VertexLitGeneric", "UnlitGeneric")
	spinner spn_mapChannel "" pos:[54,509] width:37 height:16 enabled:false range:[-1,99,1] type:#integer scale:1 toolTip:"Enter the UVW Mapping Channel to use at export or 0 for fast auto detect from diffuse bitmap or -1 for slower but possibly more accurate auto-detect. Only available if using the WWMT SMD Exporter. Otherwise, only channel one is used."
	label lbl7 "Channel" pos:[11,513] width:43 height:19
	dropdownList ddl_compression "Compression" pos:[15,613] width:99 height:40 enabled:false items:#("", "DXT5", "nocompress") selection:5
	GroupBox grp5 "Materials" pos:[5,579] width:231 height:84
	button btnShowModel "Show" pos:[148,50] width:43 height:14 enabled:false toolTip:"Unhide the model if it is hidden."
	button btnHideModel "Hide" pos:[195,50] width:42 height:14 enabled:false toolTip:"Hide the model."
	dropdownList ddlNormals "Normals" pos:[100,486] width:134 height:40 enabled:false items:#("Face Render Normals", "Explicit Normals", "Auto") toolTip:"Choose the method for determining vertex normals. Defaults to Face Render Normals. But you can also choose other options."
	button btn15 "Dir" pos:[172,292] width:22 height:16 toolTip:"Open the folder where the final MDL files get compiled."
	button btn31 "VMT Dir" pos:[151,372] width:45 height:16 toolTip:"Open the folder where the final VMTs for this model export to."
	button btn48 "QC" pos:[111,292] width:30 height:16 toolTip:"Open the QC file in Notepad."
	button btnCust "QCI" pos:[142,292] width:29 height:16 toolTip:"Open the custom QCI file in Notepad."
	checkbox chkInternalOrigin "Calculate Origin in SMD" pos:[16,243] width:142 height:15 enabled:false checked:true toolTip:"When on, the Origin is calculated in the SMD. When off, calculated in the QC. Some mods do not compile the QC $origin anymore. Also, this option only works with the WW SMD Exporter."
	checkbox chkRotateOrigin "Rotate Origin" pos:[16,261] width:95 height:17 enabled:false checked:true toolTip:"Rotate the Z-Axis of the model so that it exports in same system as the Max world (and brush geometry). You may want to turn this off with some animated models."
	checkbutton ckbFastMode "^" pos:[130,8] width:14 height:35 toolTip:"Click Here to turn off comprehensive object type filters in the pick tool if picking is slow." checked:false
	
		
	function setWWMTFromOBJ obj = (
	isSource = getUserProp obj "wwmt_source_helper"	
	ww_scene_lods.init()
		
	if isProperty obj "wwmt" AND isProperty obj "getWWMT" then (
		obj.getWWMT()
		if obj.wwmt != undefined then (
			ww_scene_lods = obj.wwmt
		)
	)

	if obj.material == undefined AND isSource==undefined AND superClassOf obj  == GeometryClass AND wwmt_autoMaterialNewModel != "true" then (
		messagebox "You must first apply a material to your model."
		addModel.caption = "Pick Model"
	) else (		
		
			

		
		
			if ((ww_scene_lods.setTargetModel obj ww_scene_lods)==true) then ( 


				wallworm_setWWMUI()

			) else (
				
				messagebox "There was an unknown problem. If this error continues, please submit a bug report on the WW forums at wallworm.net ."
				
			)
		)
	)
	

	
	

	
	
	
	
	
	
	on Wall_Worm_Model_Tools open do
	(
	
		global wallworm_wwmt_pick_fast
		
		if wallworm_wwmt_pick_fast == undefined then (
			wallworm_wwmt_pick_fast = false
		)
		
		ckbFastMode.checked = wallworm_wwmt_pick_fast
		
	
	ddl1.items = wwmt_surfaceprop_list	
	if (wwmt_current_material_Paths != undefind AND wwmt_current_material_Paths.count > 0) do (	
	edt2_materialFolder.items = wwmt_current_material_Paths
	)
	if ( wwmt_current_model_Paths != undefined AND wwmt_current_model_Paths.count>0) do (
	edt1_modelPath.items = wwmt_current_model_Paths
	)
	
	
	if wwmt_def_model_path != undefined  do (
					
			edt1_modelPath.selection = 	findItem edt1_modelPath.items wwmt_def_model_path 
					
	)
	
	if wwmt_def_material_path != undefined  do (
					
			edt2_materialFolder.selection = 	findItem edt2_materialFolder.items wwmt_def_material_path 
					
	)
	
	
	
	)
	on Wall_Worm_Model_Tools moved pos do
	(
			
			
			global wallworm_userIni
			setINISetting wallworm_userIni "Layout" "wwmt_ui_pos" (pos as string)
			
			
			
	)
	on addModel picked obj do
	(
		local wws = for ww in objects WHERE isProperty ww "wallworm" AND isProperty ww "wwmt_ca" AND findItem ww.targets obj != 0 collect ww
	
		case wws.count of (
			0: (
				
				/*
				
				Fall Back  to looking for old WWMT Source name in userprop data
				*/
				sname = getUserProp obj "wwmt_source"
				if sname != undefined then (
					target = getNodeByName sname
					if (target == undefined) then (
						setWWMTFromOBJ obj
					) else (
						setWWMTFromOBJ target
						setUserProp obj "wwmt_source" undefined
					)
				) else (
						
					setWWMTFromOBJ obj		
				)
	
				
				
			)
			1: (
				setWWMTFromOBJ wws[1]
			)
			default:(
				messagebox "Because this object is part of multiple WWMT Helpers, the correct one could not be determined. Please choose the WWMT Helper for the model you want to use instead of the mesh. Hit F11 to see a list of WWMT Helpers using this mesh."
				print wws
			)
			
			
			
		)
	)
	on btn_appendModels picked obj do
	(
		
		--if obj.mat == undefined then (
			
			--messagebox "You can only add models that have a material. Remember that the export will not work if the model doesn't have a material with a Bitmap in the diffuse map slot."
			
			--) else(
		
				if ww_scene_lods.target != undefined do (
					if (ww_scene_lods.addObjToObjects obj	) then (
					ww_scene_lods.setTargetCust()
			
			
					if ww_scene_lods.targets.count >1 do (
						btn_removeSelFromTargets.enabled = true

	
					)
				) else (
					messagebox "The action failed. Some geometry cannot be used (for example, a WWMT Helper)."
				)
			)
			--)
		)
	on btn_addSelection pressed do
	(
			if (ww_scene_lods.addObjToObjects $selection) then (
			ww_scene_lods.setTargetCust()
			--for o in ww_scene_lods.targets do(
				--print o.name
				--)
			--messagebox "Action completed."
			if ww_scene_lods.targets.count >1 do (
					btn_removeSelFromTargets.enabled = true

				)
			) else (
				messagebox "The action failed. Some geometry cannot be used (for example, a WWMT Helper)."
			)
		)
	on btn_removeSelFromTargets pressed do
	(
			ww_scene_lods.removeItemsFromTargets selection
		)
	on ddl1 selected sel do
	(
		
		ww_scene_lods.setSurfaceProperty(ddl1.items[sel])
	
	)
	on runExport pressed do
	(
		if (ww_scene_lods.target == undefined  )  do (
			messageBox "You must first pick your model/mesh or a collision model."
			return messageBox
		)
		if(ww_scene_lods.modelPath==undefined OR ww_scene_lods.materialPath==undefined  )then (
			messageBox "You must set Model and Material Paths."	
			return messageBox
		) else (
			ers = ww_scene_lods.checkForProblems()
			if ers.count == 0 then (
				ww_scene_lods.outputModelQC writeSMDs:true
			) else (
				message = "There were problems you need to address:\n\n"
				for em in ers do (
					
					append message ("\t* "+em+"\n")
				)
				messageBox message
			)
		)
	)
	on runQC pressed do
	(
		if ww_scene_lods.locked then ( messagebox "The QC lock is set. You cannot overwrite the QC because of that.") else (
			if (ww_scene_lods.target == undefined  )  do (
				messageBox "You must first pick your model/mesh or a collision model."
				return messageBox
			)
			if(ww_scene_lods.modelPath==undefined OR ww_scene_lods.materialPath==undefined  )then (
				messageBox "You must set Model and Material Paths."	
				return messageBox
			) else (
				ers = ww_scene_lods.checkForProblems()
				if ers.count == 0 then (
					ww_scene_lods.outputModelQC writeSMDs:false	
				) else (
					message = "There were problems you need to address:\n\n"
					for em in ers do (
						
						append message ("\t* "+em+"\n")
					)
					messageBox message
				)
			)
		)
	)
	on runSMD pressed do
	(
		if (ww_scene_lods.target == undefined  )  do (
			messageBox "You must first pick your model/mesh or a collision model."
			return messageBox
		)
		if(ww_scene_lods.modelPath==undefined OR ww_scene_lods.materialPath==undefined  )then (
			messageBox "You must set Model and Material Paths."	
			return messageBox
		) else (
			ers = ww_scene_lods.checkForProblems()
			if ers.count == 0 then (
				if (ww_scene_lods.exportSMDS resetBnArray:true runCompile:false) == false then (
					messagebox "The SMDs were not exported."
				)	
			) else (
				message = "There were problems you need to address:\n\n"
				for em in ers do (
					
					append message ("\t* "+em+"\n")
				)
				messageBox message
			)
		)
	)
	on edt1_modelPath selected sel do
	(
		ww_scene_lods.setModelPath(edt1_modelPath.items[sel])
	)
	on edt1_modelPath entered text do
	(
		ww_scene_lods.setModelPath(text)
	)
	on edt1_modelPath changed text do
	(
			    	ww_scene_lods.setModelPath(text)
	)
	on edt2_materialFolder selected sel do
	(
		ww_scene_lods.setMaterialPath(edt2_materialFolder.items[sel])
	)
	on edt2_materialFolder entered text do
	(
		ww_scene_lods.setMaterialPath(text)
	)
	on edt2_materialFolder changed text do
	(
		ww_scene_lods.setMaterialPath(text)
	)
	
	on chk_alwayscollapse changed state do (
		ww_scene_lods.target.alwayscollapse = state
		ww_scene_lods.alwayscollapse = state
	)
	
	
	on chk_staticprop changed state do
	(
	    	if state == true then (
	    	
	
				ww_scene_lods.setStaticprop(true)
	    	
	    	) else (
	    	ww_scene_lods.setStaticprop(false)
	    	
	    	)
	)
	on chk_opaque changed state do
	(
	    	if state == true then (
	    	
	    	ww_scene_lods.setOpaque(true)
	    	
	    	) else (
	    	ww_scene_lods.setOpaque(false)
	    	
	    	)
		)
	on chk_mostlyopaque changed state do
	(
	    	if state == true then (
	    	
	    	ww_scene_lods.setMostlyOpaque(true)
	    	
	    	) else (
	    	ww_scene_lods.setMostlyOpaque(false)
	    	
	    	)
		)
	on spn_scale changed val do
	(
					
					ww_scene_lods.setScale(val)	
					
	)
	on edt_ModelName entered text do
	(
						
		ww_scene_lods.setModelName(text)
		
		if modelName != text do (
			
			edt_modelName.text = ww_scene_lods.modelName
		)
						
	)
	on btn_SelectModel pressed do
	(
			if ww_scene_lods.targets.count > 0 do (
				try (
					select ww_scene_lods.targets
				) catch (
					messagebox "There was a problem; an object was deleted from the model but is still associated to this WWMT Helper."
					
				)
			)
		)
	on btnSelectWWMTHelper pressed do
	(
		if ww_scene_lods != undefined AND ww_scene_lods.target != undefined AND NOT isDeleted ww_scene_lods.target then (
		
		 select ww_scene_lods.target
		) else (
			messagebox "The WWMT Helper has been deleted from the scene!"
		)
	
	)
	on btn_illum pressed do
	(
	
			if ww_scene_lods.illumorigin == undefined OR isDeleted ww_scene_lods.illumorigin do (
				ww_scene_lods.createIlluminationHelper()
				
				)
			
			
			
			
			select ww_scene_lods.illumorigin
	
	)
	on btn_tex pressed do
	(
			if ww_scene_lods.canCompile "tex" then (
				
				
				
					ers = ww_scene_lods.checkForProblems()
				
					if ers.count == 0 then (
						include "$scripts\\WallWorm.com\\WallWormModelTools\\textureExport.ms"
					) else (
						message = "There were problems you need to address:\n\n"
						for em in ers do (
							
								append message ("\t* "+em+"\n")
						)
						messageBox message
					)
				
				
					
					) else (
						messagebox "To compile textures, the following requirements must be met:\n\n*Set a \"Material Path\" in the Export Options rollout\n*Have valid materials on model\n*\"Bin Dir\" AND \"Material Root Directory\" set in the Global WW Settings\n*Your Mod must have VTEX.EXE in the Bin Folder"
					)
	)
	on btn_open_model_folder pressed do
	(
	
				local m = ""
	
				if edt1_modelPath.text != "" do(
					if ww_scene_lods.modelPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.modelPath
					) else(
						
						m = ww_scene_lods.FsToBs wwmt_def_model_path
						)
					if m == undefined do (
						m = ""
					)
				)
				wwDir = wwmt_export + "\\"+m		
			
			try (
				if doesFileExist wwDir == false then (
					makeDir (wwDir all:true)
				)
				
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
				) catch(
				
				
				
				)
			
			
			)
	on btn_open_mat_folder pressed do
	(
	
	
				local m = ""
	
				if edt2_materialFolder.text != "" do(
					
					if ww_scene_lods.materialPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.materialPath
					) else (
						m = ww_scene_lods.FsToBs wwmt_def_material_path
						)
				)
				wwDir = wwmt_exportMats + "\\"+m		
				if m == undefined do (
						m = ""
				)
			try (
				
					if doesFileExist wwDir == false then (
						makeDir (wwDir all:true)
					)
				
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
				) catch(
				
				
				
				)
			
			
			)
	on btn_setSkyScale pressed do
	(
			
		spn_scale.value = 0.0625
		ww_scene_lods.setScale(spn_scale.value)	
			
	)
	on btn_setSkyScale2 pressed do
	(
			
		spn_scale.value = 0.03125
		ww_scene_lods.setScale(spn_scale.value)	
			
	)
	on chk_altOrigin changed state do
	(
					
					
						if state == true then (
		    	    	
		    	
		    				ww_scene_lods.setAltOrigin(true)
		    	    	
		    	    	) else (
		    	    	ww_scene_lods.setAltOrigin(false)
		    	    	
		    	    	)
					
					
					
					
					)
	on chk_localOrigin changed state do
	(
	    	if state == true then (
	    	
	    	ww_scene_lods.setLocalOrigin(true)
	    	
	    	) else (
	    	ww_scene_lods.setLocalOrigin(false)
	    	
	    	)
		)
	on chk_lock_origin changed state do
	(
			
				ww_scene_lods.setLockOrigin state
			
			)
	on chk_lockQC changed state do
	(
	    	if state == true then (
	
	
				ww_scene_lods.setLock(true)
	    	
	    	) else (
				ww_scene_lods.setLock(false)
	    	)
		)
	on ddl_shader selected sel do
	(
	
		ww_scene_lods.setShaderType ddl_shader.selected
	
	
	)
	on spn_mapChannel changed val do
	(
					
				ww_scene_lods.setUVW(val)	
		
				if wwmtExporter != "3" then (
					
					if wwmtExporter == "2" then (
					
						messagebox "This feature is not available when using the Canonfodder Exporters. If you need this feature, you need to get Wunderboy's SMD Exporter 1.7 or later from www.wunderboy.org."
					
					) else (
					
					
						try (
						if WBSMDExportVersionNum() < 1700 do (
							messagebox "If you need this feature, you need to get Wunderboy's SMD Exporter 1.7 or later from www.wunderboy.org."
							)
					
						) catch (
							
								messagebox "If you need this feature, you need to get Wunderboy's SMD Exporter 1.7 or later from www.wunderboy.org."
					
							
							)
					
					)
				)
	)
	on ddl_compression selected sel do
	(
	
		ww_scene_lods.setCompression ddl_compression.selected
	
	
	)
	on btnShowModel pressed do
	(
			unhide ww_scene_lods.targets
		)
	on btnHideModel pressed do
	(
			hide ww_scene_lods.targets
		)
	on ddlNormals selected sel do
	(
	
	ww_scene_lods.setNormalMethod sel
	
	)
	on btn15 pressed do
	(
	
	
				local m = ""
	
				if edt1_modelPath.text != "" do(
					if ww_scene_lods.modelPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.modelPath
					) else(
						
						m = ww_scene_lods.FsToBs wwmt_def_model_path
						)
					if m == undefined do (
						m = ""
					)
				)
				wwDir = wwmt_gameInfoDir + "\\models\\"+m		
			
			try (
					if doesFileExist wwDir == false then (
						makeDir (wwDir all:true)
					)
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
				) catch(
				
				print (getCurrentException())
				
				)
	
		)
	on btn31 pressed do
	(
	
	
				local m = ""
	
				if edt2_materialFolder.text != "" do(
					
					if ww_scene_lods.materialPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.materialPath
					) else (
						m = ww_scene_lods.FsToBs wwmt_def_material_path
						)
				)
				wwDir = wwmt_gameInfoDir + "\\materials\\"+m		
				if m == undefined do (
						m = ""
				)
			try (
				
				if doesFileExist wwDir == false then (
					makeDir (wwDir all:true)
					)
				
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+wwDir+"\""
				execute folderOpen
				
				) catch(
				
				
				
				)
			
			
			)
	on btn48 pressed do
	(
		
	
				local m = ""
	
				if edt1_modelPath.text != "" do(
					if ww_scene_lods.modelPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.modelPath
					) else(
						
						m = ww_scene_lods.FsToBs wwmt_def_model_path
						)
					if m == undefined do (
						m = ""
					)
				)
				wwDir = wwmt_export + "\\"+m+"\\"+ww_scene_lods.modelName+".qc"	
			
				global wallworm_text_editor
				if doesFileExist wwDir == true then (
					folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+wwDir+"\""
					execute folderOpen
				) else (
					
					messagebox "Oops... the QC doesn't exist yet. Export the model first."
				)
	)
	on btnCust pressed do
	(
		
	
				local m = ""
	
				if edt1_modelPath.text != "" do (
					if ww_scene_lods.modelPath != undefined then (
						m = ww_scene_lods.FsToBs ww_scene_lods.modelPath
					) else(
						
						m = ww_scene_lods.FsToBs wwmt_def_model_path
						)
					if m == undefined do (
						m = ""
					)
				)
				
				wwDir = wwmt_export + "\\"+m+"\\"+ww_scene_lods.modelName+"_wwmt_custom.qci"	
			
				if doesFileExist wwDir == false then (
					
					
					ww_scene_lods.createCustomQCI()
					
				)
	
				if doesFileExist wwDir == true then (
					folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+wwDir+"\""
					execute folderOpen
				) else (
					
					messagebox "Oops... the QCI doesn't exist yet and WWMT can only create/edit it once the model name has been set."
				)
	)
	on chkInternalOrigin changed state do
	(
	ww_scene_lods.setinternalOrigin state
	
	)
	on chkRotateOrigin changed state do
	(
	
	ww_scene_lods.setRotateRefsystem state
	
	)
	on ckbFastMode changed stat do
	(
			global wallworm_wwmt_pick_fast
			wallworm_wwmt_pick_fast = stat
	)
)
	    rollout wwmt_exportRollout "Lighting & Miscellaneous Options" width:250 height:167
	    (
	    	HyperLink expHelp "Lighting & Misc Help" pos:[8,2] width:100 height:16 address:"http://dev.wallworm.com/document/62/lighting_rollout.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
 
 
			

			
	    	button btn_illum "Illumination" pos:[16,43] width:48 height:32 enabled:false images:#("$scripts\Wallworm.com\assets\wwmt_illum_icon_buttons.png", undefined, 2, 1, 1, 2, 1, false) toolTip:"Click Here to select the Illumination Origin"
	    	


	    	checkbox chk_expHL1Format "HL1 Format" pos:[11,143] width:78 height:16 enabled:false toolTip:"Only select this if you are exporting to the HL1 engine..."
			

			
			
			
	    	GroupBox grp4 "Lighting" pos:[8,20] width:235 height:70
	    	checkbox chk_ambientboost "$ambientboost" pos:[72,40] width:106 height:18 enabled:false
	    	spinner spn_constantdirectionallight "" pos:[200,59] width:38 height:16 enabled:false
	    	label lbl5 "$constantdirectionallight" pos:[71,61] width:128 height:16
						
						

						
						
			
							
	    	label lbl6 "All of the options below are optional and/or experimental. They may not work properly. Use at your own risk." pos:[8,97] width:236 height:42 enabled:true
			
			

	
	    	on btn_illum pressed do
	    	(
	    	
	    			if ww_scene_lods.illumorigin == undefined do (
	    				ww_scene_lods.createIlluminationHelper()
	    				
	    				)
	    			
	    			
	    			
	    			
	    			select ww_scene_lods.illumorigin
	    	
	    	)
	    	on chk_expHL1Format changed state do
	    	(
	    	    	if state == true then (
	    	    	
	    	
	    				ww_scene_lods.setExpHL1Format(1)
	    	    	
	    	    	) else (
	    	    	ww_scene_lods.setExpHL1Format(0)
	    	    	
	    	    	)
	    		)
	    	on chk_ambientboost changed state do
	    	(
	    		if state == true then (
	    			ww_scene_lods.setAmbientboost(true)
	    		) else(
	    			ww_scene_lods.setAmbientboost(false)
	    			)
	    	)
	    	on spn_constantdirectionallight changed val do
	    	(
	    	
	    	 ww_scene_lods.setConstantdirectionallight val
	    	
	    	)
	    )

	rollout wwmt_attachments "Attachments and Particles" width:239 height:667
	(
		local hasResetBonesArray   = false
		
		HyperLink lnkSequenceHelp "Help" pos:[80,39] width:22 height:15 address:"http://dev.wallworm.com/document/61/attachments__particle_system_ui.html" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
		combobox cbx_attachmentList "Attachements" pos:[8,39] width:221 height:6 enabled:false
		dropdownList ddl_attachmentBone "Parent Bone" pos:[8,176] width:223 height:40 enabled:false
		checkbox chk_attachmentAbsolute "Absolute" pos:[8,225] width:66 height:16 enabled:false
		checkbox chk_attachmentRigid "Rigid" pos:[81,225] width:46 height:16 enabled:false
		button btn_createAttachment "Create Attachment" pos:[9,151] width:110 height:22 enabled:false toolTip:"Click here to create a new attachment point. The name of the attachment will be the name entered in the attachments list above."
		button btn_deleteAttachment "Delete Attachment" pos:[127,151] width:101 height:22 enabled:false toolTip:"Delete the currently hilighted attachment."
		button btn_attachUpdateBoneList "Update Bone List" pos:[135,225] width:94 height:17 enabled:false toolTip:"Update the Parent Bone list for the model."
		button btn_selectPoint "Select Point" pos:[135,38] width:85 height:14 enabled:false
		label lbl1 "Attach Particle System Events" pos:[12,269] width:214 height:18
		
		combobox cbxParticles "Particle System Name" pos:[11,296] width:213 height:6
		dropdownList ddlSeqList "Use in Sequence" pos:[11,546] width:216 height:40
		spinner spnFrame "At Frame" pos:[22,600] width:208 height:16 type:#integer scale:1
		button btnAddParticle "+" pos:[159,291] width:32 height:19 toolTip:"Add Particle System Event."
		button btnRemoveParticle "-" pos:[194,291] width:28 height:19 toolTip:"Remove particle system event."
		dropdownList ddl_attachTo "Attach To:" pos:[12,446] width:214 height:40 items:#("start_at_origin", "start_at_attachment", "follow_origin", "follow_attachment")
		dropdownList ddl_attachToAttachment "Choose Attachment" pos:[12,491] width:214 height:40 
 
		checkbox chk_collapsebones "$collapsebones" pos:[10,11] width:99 height:16 enabled:false tooltip:"Remove all bones from the model that are not weighted to a vertex."
	
	
		on chk_collapsebones changed stat do (
			
				ww_scene_lods.setCollapsebones stat
		)

		radiobuttons rdoParticleType "QC Type" pos:[12,414] width:211 height:30 labels:#("keyvalue", "once", "scripted") columns:3
		button btn24 "Get" pos:[130,290] width:25 height:20 toolTip:"Get a particle system from known effects."
		spinner spnEnd "End At Frame" pos:[19,628] width:210 height:16 type:#integer scale:1

	
			function addParticles n = (
			
				local ps = wwmt_particles()
		     ps.systemname = n
		     
		     if rdoParticleType.state == 1 then (
		        ps.type = "keyvalue"
		     ) else if rdoParticleType.state == 2 then (
		
		        ps.type = "start"
		     ) else if rdoParticleType.state == 3 then (
		        ps.type = "end"
		     ) else (
		        ps.type = "keyvalue"
		     ) 
		
		     ps.attachTo =  ddl_attachTo.selected 
		
		     ps.sequence = ddlSeqList.selected
		
		     ps.pframe = spnFrame.value
			 
			 ps.pEnd = spnEnd.value
		
			ww_scene_lods.addParticleSystem ps 
			 
			local tempItems = cbxParticles.items 
			 
		
			append tempItems n
			cbxParticles.items = tempItems
			cbxParticles.selection = 0
			
			)			
	
		function setParticleNames n = (
			
			addParticles n 
			)
	    function setParticleButtons = (
			local states = #("keyvalue","once","scripted")
			if rdoParticleType.state == findItem states "keyvalue" then (
				
				spnFrame.enabled = false
				ddlSeqList.enabled = false
			) else (

				spnFrame.enabled = true
				ddlSeqList.enabled = true

			)
			ddl_attachTo.enabled = true
			
			if rdoParticleType.state == findItem states "scripted" then (
					
					spnEnd.enabled = true
					
			) else (
					spnEnd.enabled = false
					
			)
			
			if ddl_attachTo.selected == "start_at_attachment" OR ddl_attachTo.selected == "follow_attachment" then (
				
					ddl_attachToAttachment.enabled = true
					
					if cbxParticles.selection > 0 AND (ww_scene_lods.particlesystems[cbxParticles.selection].attachmentPoint == undefined OR ww_scene_lods.particlesystems[cbxParticles.selection].attachmentPoint == "") do (
						if ddl_attachToAttachment.selected != undefined do (
							ww_scene_lods.particlesystems[cbxParticles.selection].attachmentPoint = ddl_attachToAttachment.selected
							ww_scene_lods.setParticleSystems()
						)
						
					)

				) else (
				
				  -- messagebox ddl_attachTo.selected
					ddl_attachToAttachment.enabled = false
				)
			
			)
		
		
		  function getSeqList = (
			  
			  ddlSeqList.items = wwToolsFloater.rollouts[5].cbx_sequences.items
			  
			  )
		
		
			function setFormFromAttachment att = (
			--ddl_expType.
			--if att.pb != undefined do (
				--print "select bone"
			ddl_attachmentBone.selection   = findItem ddl_attachmentBone.items  att.pb
			--)

			if  att.absolute==1 then (
				chk_attachmentAbsolute.checked = true
				
				) else (
				
				chk_attachmentAbsolute.checked =false
				)
			
			
			if  att.rigid==1 then (
				chk_attachmentRigid.checked = true
				
				) else (
				
				chk_attachmentRigid.checked =false
				)
			
				
				
				cbxParticles.enabled = true	
				ddlSeqList.enabled = true	
				spnFrame.enabled = true
				btnAddParticle.enabled= true
				btnRemoveParticle.enabled=true
				spnEnd.enabled = true
				
				getSeqList()
			)

		on cbx_attachmentList selected sel do
		(
					--set other values
			
		
			
			notf = true
			for s in ww_scene_lods.attachments while notf do (
				
				    if cbx_attachmentList.items[sel] == s.attachment do (
						setFormFromAttachment s
						notf = false
					)
					
			)
					
		)
		on ddl_attachmentBone selected sel do
		(
			
		
			
						
						
		
							ww_scene_lods.setAttBone cbx_attachmentList.selected ddl_attachmentBone.items[sel] 
		
						
						
						)
		on chk_attachmentAbsolute changed state do
		(
		    	if state == true then (
		    	
					ww_scene_lods.setAttAbsolute  cbx_attachmentList.selected 1 
		    	
		    	) else (
		    	ww_scene_lods.setAttAbsolute cbx_attachmentList.selected 0 
		    	
		    	)
			)
		on chk_attachmentRigid changed state do
		(
		    	if state == true then (
		    	
					ww_scene_lods.setAttRigid  cbx_attachmentList.selected 1 
		    	
		    	) else (
		    	ww_scene_lods.setAttRigid cbx_attachmentList.selected 0 
		    	
		    	)
			)
		on btn_createAttachment pressed do
		(
			
			t=wallworm_makeStringSafe cbx_attachmentList.text
			if (t == "") then (
		
					message = "You must enter a unique name in the attachement field."
		
				    messagebox message
				
				) else (
					
					if ( (findItem  cbx_attachmentList.items t) == 0) then (
						append ww_scene_lods.attachmentlist t
						cbx_attachmentList.items = ww_scene_lods.attachmentlist
						ddl_attachToAttachment.items = ww_scene_lods.attachmentlist
						
						att = wwmt_attachment()
		
						if chk_attachmentAbsolute.checked == true then (
							att.absolute = 1
							) else (
							att.absolute = 0
							
							)
							
						if chk_attachmentRigid.checked == true then (
							att.rigid = 1
							) else (
							att.rigid = 0
							
							)
							
						att.attachment = t
						tname = t + "_att"
						
						if (att.pb == undefined OR att.pb == "") then (	
							bonestartpos = in coordsys world  ww_scene_lods.targets[1].position
						) else (
							bonestartpos =in coordsys world  att.pb.pos
						)
						
						attachementBone=(BoneSys.createBone bonestartpos (bonestartpos + [4,0,0]) [0,0,1])
						attachementBone.showLinks = true
						attachementBone.showLinksOnly = true
						bone_size = 2
						attachementBone.width = bone_size
						attachementBone.height = bone_size
						--attachementBone.transform = bone_transform
						attachementBone.boneEnable = true
						att.atPoint = attachementBone
							
						select attachementBone	
						--att.atPoint = Point pos:ww_scene_lods.targets[1].pos isSelected:on Box:on	
							
							
						att.atPoint.name = uniqueName(tname)
						
						att.pb = ddl_attachmentBone.selected
						
						if (att.pb == undefined OR att.pb == "") then (	
							att.atPoint.parent = ww_scene_lods.targets[1]
						) else (
							
							ww_scene_lods.setAttBone t att.pb
							
							)
		
		
						
						ww_scene_lods.addToAttachments att
						att.setAttachment ww_scene_lods.target
						
						ww_scene_lods.setAttListCust()
						ind = findItem  cbx_attachmentList.items t
						cbx_attachmentList.selection = ind
						setFormFromAttachment att
							
							att.setAsWWMTAttachment()
							cbx_attachmentList.text = t
						) else (
						
		
						
						)
					
					
					)
			)
		on btn_deleteAttachment pressed do
		(
		ww_scene_lods.removeAttachment cbx_attachmentList.selected
						cbx_attachmentList.items = ww_scene_lods.attachmentlist
						ddl_attachToAttachment.items = ww_scene_lods.attachmentlist
						ww_scene_lods.setAttListCust
		
		
		)
		on btn_attachUpdateBoneList pressed do
		(
		
					ww_scene_lods.resetBonesArray()
					theNames = ww_scene_lods.boneNameList()
					if theNames == undefined then (
						theNames = #()
						)
					for obj in ww_scene_lods.targets do (
						appendIfUnique theNames obj.name
						)
			
					ddl_attachmentBone.items = theNames
		
		)
		on btn_selectPoint pressed do
		(
		notf = true
			
			--include "wwmt_struct_attachment.ms"
				for s in ww_scene_lods.attachments while notf do (
						
					if s.attachment == cbx_attachmentList.selected do (
		
		                 select s.atPoint
		                 notf = false
		
		              )
		
		         )
		
		
		)
		on cbxParticles selected arg do
		(
		  rdoParticleType.enabled = true
		
		
					local states = #("keyvalue", "once", "scripted")
					
					if ww_scene_lods.particlesystems[arg]!= undefined AND ww_scene_lods.particlesystems[arg].sequence != undefined AND ww_scene_lods.particlesystems[arg].sequence != "" do (
					 ddlSeqList.selection = findItem ddlSeqList.items ww_scene_lods.particlesystems[arg].sequence
					)
					
					if ww_scene_lods.particlesystems[arg] != undefined AND ww_scene_lods.particlesystems[arg].pframe != undefined do (
						spnFrame.value = ww_scene_lods.particlesystems[arg].pframe
					)
					
					if ww_scene_lods.particlesystems[arg] != undefined AND ww_scene_lods.particlesystems[arg].pEnd != undefined do (
						spnEnd.value = ww_scene_lods.particlesystems[arg].pEnd
					)
					
					
		
					if ww_scene_lods.particlesystems[arg]!= undefined AND  ww_scene_lods.particlesystems[arg].attachmentPoint != undefined AND ww_scene_lods.particlesystems[arg].attachmentPoint != "" do (
						ddl_attachToAttachment.selection = findItem ddl_attachToAttachment.items ww_scene_lods.particlesystems[arg].attachmentPoint
					)
					if ww_scene_lods.particlesystems[arg]!= undefined AND ww_scene_lods.particlesystems[arg].attachTo != undefined AND ww_scene_lods.particlesystems[arg].attachTo != "" do (
						ddl_attachTo.selection = findItem ddl_attachTo.items ww_scene_lods.particlesystems[arg].attachTo
					)
					
					if ww_scene_lods.particlesystems[arg]!= undefined AND ww_scene_lods.particlesystems[arg].type != undefined AND ww_scene_lods.particlesystems[arg].type != "" do (
						
						
						rdoParticleType.state = findItem states ww_scene_lods.particlesystems[arg].type
					)
					
		
					setParticleButtons()
					
					
					)
		on ddlSeqList selected sel do
		(
		
			if cbxParticles.selection > 0 do (	
			
				ww_scene_lods.particlesystems[cbxParticles.selection].sequence = ddlSeqList.selected
				ww_scene_lods.setParticleSystems()
			)
		
		)
		on spnFrame changed val do
		(
		if cbxParticles.selection > 0 do (	
			
		
		       if ddlSeqList.selection > 0 do (
		         for s in ww_scene_lods.sequences do (
		          if s.sequence == ddlSeqList.selected AND val > s.end do (
		           val = s.end
		           messagebox ("The value you entered was higher than the end of the chosen sequence. The frame was lowered to "+(s.end as string)+".")
		          )
		         )
		       )
			   if val > spnEnd.value do (
		         spnEnd.value = val + 1
		        )
		        if spnFrame.value != val do  (
		          spnFrame.value = val
		         )
		
		
		
		
		
		
		
		
		
		
			ww_scene_lods.particlesystems[cbxParticles.selection].pframe = val
			
						ww_scene_lods.setParticleSystems()
		)
		
		)
		on btnAddParticle pressed do
		(
		     --append cbxParticles.items cbxParticles.text
			
			--include "$scripts/WallWorm.com/common/wwmt_particles.ms"
			if cbxParticles.text != undefined AND cbxParticles.text != "" do (
				addParticles cbxParticles.text
			)
		
		)
		on btnRemoveParticle pressed do
		(
			  if ww_scene_lods.particlesystems.count > 0 do (
				ww_scene_lods.removeParticleSystem cbxParticles.selection
				local tempItems = cbxParticles.items
				deleteItem tempItems  cbxParticles.selection
				cbxParticles.items =tempItems
			
			 )
		)
		on ddl_attachTo selected sel do
		(
		
		    if ddl_attachToAttachment.items.count == 0 AND (ddl_attachTo.selected=="start_at_attachment" OR ddl_attachTo.selected=="follow_attachment")  do (
		     ddl_attachTo.selection = 0
		     messagebox "You can only attach particles to Attachments if you have already created attachments."
		    )
		
		
		
			if cbxParticles.selection > 0 do (
				ww_scene_lods.particlesystems[cbxParticles.selection].attachTo = ddl_attachTo.selected
				ww_scene_lods.setParticleSystems()
			)
			setParticleButtons()
		)
		on ddl_attachToAttachment selected sel do
		(
			if cbxParticles.selection > 0 do (	
				ww_scene_lods.particlesystems[cbxParticles.selection].attachmentPoint = ddl_attachToAttachment.selected
				ww_scene_lods.setParticleSystems()
			)
		)
		on rdoParticleType changed stat do
		(
			if cbxParticles.selection > 0 do (
						
				
			if rdoParticleType.state == 1 then (
		       ww_scene_lods.particlesystems[cbxParticles.selection].type= "keyvalue"
		     ) else if rdoParticleType.state == 2 then (
		
		        ww_scene_lods.particlesystems[cbxParticles.selection].type= "once"
		     ) else if rdoParticleType.state == 3 then (
		       ww_scene_lods.particlesystems[cbxParticles.selection].type = "scripted"
		     ) else (
		        ww_scene_lods.particlesystems[cbxParticles.selection].type = "keyvalue"
		     ) 
				
				ww_scene_lods.particlesystems[cbxParticles.selection].sequence = ddlSeqList.selected
				ww_scene_lods.setParticleSystems()
			)
		
		setParticleButtons()
		
		)
		on btn24 pressed do
		(
		
		 try (
		   fileIn "$scripts/WallWorm.com/WallWormUtilities/particleDefaults.ms"
		
		) catch ()
		
		)
		on spnEnd changed val do
		(
		    if cbxParticles.selection > 0 do (	
		
		
		       if ddlSeqList.selection > 0 do (
		         for s in ww_scene_lods.sequences do (
		          if s.sequence == ddlSeqList.selected AND val > s.end do (
		           val = s.end
		           messagebox ("The value you entered was higher than the end of the chosen sequence. The max time was lowered to "+(s.end as string)+".")
		          )
		         )
		       )
			   if val < spnFrame.value do (
		         spnFrame.value = val - 1
		        )
		        if spnEnd.value != val do (
		          spnEnd.value = val
		         )
		
			   ww_scene_lods.particlesystems[cbxParticles.selection].pEnd = val
			   ww_scene_lods.setParticleSystems()
		    )
		
		)
	)
		
	rollout wwmt_sequences "Sequences, Activities and Weights" width:239 height:953
	(
		
		spinner spn_expStart "Start" pos:[20,198] width:69 height:16 enabled:false range:[0,999999,0] type:#integer
		spinner spn_expEnd "End" pos:[102,199] width:74 height:16 enabled:false range:[0,999999,0] type:#integer
		--edittext edt_expSequenceName "Sequence Name" pos:[10,222] width:203 height:18 enabled:false
		checkbox chk_expReverse "Reverse" pos:[13,343] width:68 height:15 enabled:false
		combobox cbx_sequences "Sequences" pos:[4,27] width:223 height:8 enabled:false selection:0
		button btn_addSeq "Add Sequence" pos:[4,163] width:82 height:21 enabled:false toolTip:""
		button btn_delSeq "Delete Sequence" pos:[93,163] width:90 height:21 enabled:false
		checkbox chk_loop "Loop" pos:[13,361] width:51 height:18 enabled:false
		HyperLink lnkSequenceHelp "Sequence Help" pos:[155,5] width:74 height:15 address:"http://dev.wallworm.com/document/60/sequences.html" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
		checkbox chk_idleSequence "Use Idle Sequence" pos:[4,4] width:117 height:16 enabled:false toolTip:"Make a default Idle Sequence at Frame 0"
		combobox cbxWeightLists "Weight Lists" pos:[21,611] width:199 height:6
		button btnAddWeightList "Add List" pos:[21,737] width:53 height:18
		button btn4 "Update Name" pos:[80,737] width:81 height:19
		button btnDeleteWeightList "Delete" pos:[168,737] width:53 height:18
		combobox cbxWeightlistBones "Bones In List" pos:[24,771] width:137 height:9
		spinner spnWeight "Bone Weight in this List" pos:[34,920] width:185 height:16 range:[0,1,1] type:#float scale:0.1
		button btnAddBone "Add" pos:[169,814] width:59 height:18
		button btnDeleteBone "Delete" pos:[169,837] width:60 height:23
		button btnFillList "Fill List" pos:[168,793] width:60 height:13
		combobox cbxSeqWeightlist "Sequence Weightlist" pos:[12,225] width:220 height:6 selection:0
		spinner spnFPS "FPS" pos:[124,346] width:104 height:16 range:[1,300,30] scale:0.1
		checkbox chkAutoPlay "Autoplay" pos:[13,382] width:80 height:16
		spinner spnActivityWeight "Activity Weight" pos:[91,563] width:131 height:16 range:[-1,1,1]
		checkbox chkSnap "Snap" pos:[13,402] width:66 height:16
		checkbox chkRealtime "Realtime" pos:[114,366] width:82 height:15
		checkbox chkAsAnimation "As $animation" pos:[114,384] width:96 height:14
		edittext edtAnimations "Anims" pos:[13,443] width:216 height:17
		checkbox chkHidden "Hidden" pos:[114,402] width:93 height:15
		checkbox chkMakeSMD "Make SMD" pos:[13,424] width:75 height:16
		spinner spnFadeIn "Fade In" pos:[114,484] width:114 height:16 range:[0,1000,0.2]
		spinner spnFadeOut "Fade Out" pos:[105,507] width:123 height:16 range:[0,1000,0.2]
		edittext edtNode "Node" pos:[114,420] width:116 height:17
		edittext edtActivity "Activity" pos:[31,535] width:192 height:22
		button btnGetActivity "Get" pos:[21,562] width:49 height:16 toolTip:"Select a common, default activity."
		edittext edtAddLayer "Add Layer" pos:[12,464] width:217 height:16
		button btnNoWeightList "None" pos:[158,223] width:72 height:18
		
		button btnCompileSequence "Compile" pos:[187,163] width:42 height:21 toolTip:"Compile the selected Sequence SMD."
		button btnTimeline "Timeline" pos:[185,199] width:45 height:18 tooltip:"Set the timeline to this range."
		on btnTimeline pressed do (

			
			if spn_expStart.value < spn_expEnd.value then (
				
				animationRange = interval spn_expStart.value spn_expEnd.value
				sliderTime = spn_expStart.value
			)

		)
		
		function setSequenceFromUI = (
			--!TODO !UNIMPORTANT... Update older WWMT code for sequence modification into this block.
			local theSequence
			if ww_scene_lods.sequences != undefined AND ww_scene_lods.sequences.count > 0 AND cbx_sequences.selection > 0 AND ww_scene_lods.sequences[cbx_sequences.selection] != undefined then (
				theSequence = ww_scene_lods.sequences[cbx_sequences.selection]
				ww_scene_lods.sequences[cbx_sequences.selection].weightlist = cbxSeqWeightlist.selected
				ww_scene_lods.sequences[cbx_sequences.selection].autoplay = chkAutoPlay.state
				ww_scene_lods.sequences[cbx_sequences.selection].realtime = chkRealtime.state
				ww_scene_lods.sequences[cbx_sequences.selection].asAnimation = chkAsAnimation.state
				ww_scene_lods.sequences[cbx_sequences.selection].snap = chkSnap.state
				ww_scene_lods.sequences[cbx_sequences.selection].hidden = chkHidden.state
				ww_scene_lods.sequences[cbx_sequences.selection].makeSMD = chkMakeSMD.state
				ww_scene_lods.sequences[cbx_sequences.selection].addLayer = edtAddLayer.text
				ww_scene_lods.sequences[cbx_sequences.selection].fadeOut = spnFadeOut.value
				ww_scene_lods.sequences[cbx_sequences.selection].animations = edtAnimations.text
				ww_scene_lods.sequences[cbx_sequences.selection].nd = edtNode.text
				ww_scene_lods.sequences[cbx_sequences.selection].activityWeight = spnActivityWeight.value
				ww_scene_lods.sequences[cbx_sequences.selection].fps = spnFPS.value
				ww_scene_lods.sequences[cbx_sequences.selection].fadeIn = spnFadeIn.value
				
				ww_scene_lods.sequences[cbx_sequences.selection].activity = edtActivity.text
				ww_scene_lods.sequences[cbx_sequences.selection].setSequence ww_scene_lods.target
				
				ww_scene_lods.setSeqListCust()
				
			)
			theSequence
		)
		
			
		
		
		function updateWeightList tex = (
				if tex != undefined AND tex!="undefined" AND tex != "" AND findItem cbxSeqWeightlist.items tex == 0 then (
					itemList = cbxSeqWeightlist.items
					
					append itemList tex
					
					cbxSeqWeightlist.items = itemList
					
					
					cbxSeqWeightlist.selection = itemList.count
				) else (
						cbxSeqWeightlist.selection = 0
				)
			
		)
		
		
		
-- 		on edt_expSequenceName entered text do
-- 		(
-- 			
-- 			if text != "" then (
-- 				    	ww_scene_lods.setExpSequenceName cbx_sequences.selected text
-- 			) else (
-- 				messagebox "You must give this model a Sequence Name. If this is a reference model, enter \"idle\"."
-- 				
-- 				)
-- 		)
		function setFormFromSequence seq = (
			--ddl_expType.
			
			--ddl_expType.selection = findItem ddl_expType.items  seq.type
			spn_expStart.value = seq.start
			spn_expEnd.value = seq.end
			chkSnap.state = seq.snap
			chkHidden.state = seq.hidden
			chkMakeSMD.state = seq.makeSMD
			
			
			 chkAutoPlay.state = seq.autoplay
			 spnActivityWeight.value = seq.activityWeight

			 chkRealtime.state  = seq.realtime
			 chkAsAnimation.state  = seq.asAnimation
			 edtAnimations.text  = seq.animations


			 spnFadeIn.value  = seq.fadeIn
			 spnFadeOut.value  = seq.fadeOut
			 edtNode.text  = seq.nd
			edtActivity.text  = seq.activity

			edtAddLayer.text  = seq.addLayer
		
			spnFPS.value = (seq.fps as float)
			
			if seq.weightlist != undefined AND seq.weightlist != "" then (
				updateWeightList seq.weightlist
				cbxSeqWeightlist.selection = findItem cbxSeqWeightlist.items seq.weightlist
			) else (
				cbxSeqWeightlist.selection = 0
				
			)
			
			if  seq.expReverse==1 then (
				chk_expReverse.checked = true
				
			) else (
				
				chk_expReverse.checked =false
			)
			
			if  seq.loop==1 then (
				chk_loop.checked = true
				
				) else (
				
				chk_loop.checked =false
				)
				
				
				
				
		)



			
			
	
			
		

		

				

				
		function addToWeightBoneList boneName = (
			local tempList = cbxWeightlistBones.items
			
					if cbxWeightLists.selection != 0 then (
						ww_scene_lods.weightlists[cbxWeightLists.selection].setWeightByBoneName boneName spnWeight.value

					
					if findItem tempList boneName == 0 then (
					
						
						append tempList boneName
						
						
						
					)
					
					ww_scene_lods.weightlists[cbxWeightLists.selection].writeWeightListToObject ww_scene_lods.target
					
					
					cbxWeightlistBones.selection = 0	
					
					cbxWeightlistBones.items = tempList
					
					)
		)	

		on spn_expStart changed val do
		(		
			ww_scene_lods.setExpStart cbx_sequences.selected val 	
		)
		on spn_expEnd changed val do
		(
			ww_scene_lods.setExpEnd cbx_sequences.selected val 	
		)
		on chk_expReverse changed state do
		(
		    	if state == true then (
		    	
					ww_scene_lods.setExpReverse  cbx_sequences.selected 1 
		    	
		    	) else (
		    	ww_scene_lods.setExpReverse cbx_sequences.selected 0 
		    	
		    	)
			)
		on cbx_sequences selected sel do
		(
					--set other values
			
		
			
			notf = true
			for s in ww_scene_lods.sequences while notf do (
				
				    if cbx_sequences.items[sel] == s.sequence do (
						setFormFromSequence s
						if s.start != undefined AND s.start != "" then (
							
		
							anR = animationRange
							
							newstart = undefined
							newend = undefined
							
							if anR.start > s.start then (
								newstart = s.start
							)
							
							if anR.end < s.end then (
								newend = s.end
							)
							if newstart == undefined then (
								newstart = animationRange.start
							)
							if newend == undefined then (
								newend = animationRange.end
							)
							
							animationRange = interval newstart newend
							
							
							sliderTime = s.start
						)
						notf = false
					)
					
			)
					
		)
		on btn_addSeq pressed do
		(
			
			t=cbx_sequences.text
			if ((t == "")OR (t == "idle")) then (
				if (t == "") then (
					message = "You must enter a unique name in the sequence field. Note that you cannot use \"idle\" since it is a special one that is always created."
					) else (
					message = "You cannot use \"idle\" since it is a special one that is always created."
		
					
					)
				    messagebox message
				
				) else (
					
					if ( (findItem  cbx_sequences.items t) == 0) then (
						append ww_scene_lods.sequencelist t
						cbx_sequences.items = ww_scene_lods.sequencelist
						
						
						
						
						
						seq = wwmt_sequence()
						seq.sequence = t
						seq.start=spn_expStart.value
						seq.end=spn_expEnd.value
						seq.fps=frameRate
						seq.type= "Sequence"
						
						
						
						
						if chk_loop.checked == false then (
						seq.loop=0
						) else (
							
							seq.loop=1
							)
						
						
						
						if chk_expReverse.checked == false then (
						seq.expReverse=0
						) else (
							
							seq.expReverse=1
							)
						
						ww_scene_lods.addToSequences seq
						--seq.setSequence ww_scene_lods.target
						
						ww_scene_lods.setSeqListCust()
						ind = findItem  cbx_sequences.items t
						cbx_sequences.selection = ind
						setFormFromSequence seq
						setSequenceFromUI()	
						wwToolsFloater.rollouts[6].ddlSeqList.items = cbx_sequences.items	
							
						) else (
						
		
						
						)
					
					
					)
			)
		on btn_delSeq pressed do
		(
			if cbx_sequences.selected == "idle" then (
				messagebox "You cannot delete the \"idle\" sequence."
				
				) else (
				
				ww_scene_lods.removeSequence cbx_sequences.selected
				cbx_sequences.items = ww_scene_lods.sequencelist
		
				ww_scene_lods.setSeqListCust
				
				wwToolsFloater.rollouts[6].ddlSeqList.items = cbx_sequences.items	
				
				)
			)
		on chk_loop changed state do
		(
		    	if state == true then (
		    	
					ww_scene_lods.setLoop  cbx_sequences.selected 1 
		    	
		    	) else (
		    	ww_scene_lods.setLoop cbx_sequences.selected 0 
		    	
		    	)
				ww_scene_lods.setSeqListCust()
			)
		on chk_idleSequence changed stat do
		(
					ww_scene_lods.setIdleSequence stat
		)
		on cbxWeightLists selected sel do
		(
					
			cbxWeightlistBones.items = ww_scene_lods.weightlists[cbxWeightLists.selection].bns
		)
		on btnAddWeightList pressed do
		(
			
					t=cbxWeightLists.text
					if (t == "") then (
		
						    messagebox "You must enter a unique name in the Leight Lists field."
						
						) else (
							
							if ( (findItem  cbxWeightLists.items t) == 0) then (
								
								
								cbxWeightlistBones.items = #()
								
								cbxWeightlistBones.selection = 0
								
								append ww_scene_lods.weightlistnames t
								cbxWeightLists.items = ww_scene_lods.weightlistnames
								
								
								
								
								
								seq = wwmt_weightlist()
								seq.name = t
								ww_scene_lods.addToWeightLists seq
								
								seq.writeWeightListToObject ww_scene_lods.target
								
								ww_scene_lods.setWeightListCust()
								ind = findItem  cbxWeightLists.items t
								cbxWeightLists.selection = ind
		
									
								) else (
								
				
								
								)
							
							
							)
				)
		on btnDeleteWeightList pressed do
		(
					if cbxWeightLists.selection != 0 AND ww_scene_lods.weightlists.count > 0 then (
						ww_scene_lods.removeWeightlist cbxWeightLists.selected
						cbxWeightLists.selection = 0
						
						cbxWeightLists.items = ww_scene_lods.weightlistnames
						
					)
				
				)
		on cbxWeightlistBones selected sel do
		(
					
					if ww_scene_lods.weightlists[cbxWeightLists.selection].weights[cbxWeightlistBones.selection] != undefined then (
						spnWeight.value = ww_scene_lods.weightlists[cbxWeightLists.selection].weights[cbxWeightlistBones.selection] as float
					)
				)
		on spnWeight changed val do
		(
		
					if cbxWeightLists.selection != 0 AND cbxWeightlistBones.selection != 0 then (
						ww_scene_lods.weightlists[cbxWeightLists.selection].setWeightByBoneName cbxWeightlistBones.text val
						ww_scene_lods.weightlists[cbxWeightLists.selection].writeWeightListToObject ww_scene_lods.target
					)
					
				)
		on btnAddBone pressed do
		(
					
				if cbxWeightlistBones.text != "" then (
					addToWeightBoneList cbxWeightlistBones.text
				)
		)
		on btnDeleteBone pressed do
		(
					if cbxWeightLists.selection != 0 AND cbxWeightlistBones.selection != 0 then (
						
						sel = cbxWeightlistBones.selection
						
						deleteItem ww_scene_lods.weightlists[cbxWeightLists.selection].bns sel
						deleteItem ww_scene_lods.weightlists[cbxWeightLists.selection].weights sel
						
						
						ww_scene_lods.weightlists[cbxWeightLists.selection].writeWeightListToObject ww_scene_lods.target
						cbxWeightlistBones.items = ww_scene_lods.weightlists[cbxWeightLists.selection].bns
						
					)
					
				)
		on btnFillList pressed do
		(
				
						ww_scene_lods.resetBonesArray()
						if ww_scene_lods.bonesarray.count > 0 do (
							for b in ww_scene_lods.bonesarray do (
								addToWeightBoneList b.name 
							)
							
							
						)
					
				)
		on cbxSeqWeightlist selected sel do
		(
					setSequenceFromUI()
					
		)
		on cbxSeqWeightlist entered tex do
		(
					
					updateWeightList tex
					setSequenceFromUI()
			
		
		)
		on spnFPS changed val do
		(
					setSequenceFromUI()
				)
		on chkAutoPlay changed stat do
		(
					setSequenceFromUI()
				)
		on spnActivityWeight changed val do
		(
					setSequenceFromUI()
		
				)
		on chkSnap changed stat do
		(
					setSequenceFromUI()
		
				)
		on chkRealtime changed stat do
		(
					setSequenceFromUI()
				)
		on chkAsAnimation changed stat do
		(
					
					setSequenceFromUI()
		
				)
		on edtAnimations entered tex do
		(
					setSequenceFromUI()
				)
		on chkHidden changed stat do
		(
					setSequenceFromUI()
				)
		on chkMakeSMD changed stat do
		(
					setSequenceFromUI()
		
				)
		on spnFadeIn changed val do
		(
					setSequenceFromUI()
		
				)
		on spnFadeOut changed val do
		(
					setSequenceFromUI()
					
		
				)
		on edtNode entered tex do
		(
					setSequenceFromUI()
		
				)
		on edtActivity changed tex do
		(
					
					setSequenceFromUI()
				)
		on btnGetActivity pressed do
		(
					
						fileIn "$scripts/WallWorm.com/WallWormUtilities/actionDefaults.ms"
		)
		on edtAddLayer entered tex do
		(
					setSequenceFromUI()
		
				)
		on btnNoWeightList pressed do
		(
					
					cbxSeqWeightlist.selection = 0
					setSequenceFromUI()
				)
		on btnCompileSequence pressed do
		(
						if ww_scene_lods.sequences != undefined AND ww_scene_lods.sequences.count > 0 AND cbx_sequences.selection > 0 AND ww_scene_lods.sequences[cbx_sequences.selection] != undefined then (
							ww_scene_lods.export_sequence ww_scene_lods.sequences[cbx_sequences.selection]
						)
				)
	)


	rollout wwmt_lodsrollout "Level of Detail Tools" width:250 height:215
	(
		
		
		
		spinner lodSpinner "LODs" pos:[21,7] width:120 height:16 enabled:false range:[1,10,0] type:#integer scale:1 toolTip:"Select the number of LODs that get generated with the LOD options below."
		button generateLODbtn "Generate LODs" pos:[146,6] width:93 height:18 enabled:false toolTip:"Click here to make an array of lower-res models based off of the model selected above."
		--subRollout lodslistrollout "lodslistrollout" pos:[13,29] width:224 height:130

		
		button createLODCam "Create LOD Camera" pos:[19,47] width:105 height:40
		button selectLODCam "Select LOD Cam" pos:[132,47] width:105 height:20
		GroupBox grp2 "LOD Camera Utilities" pos:[12,31] width:231 height:66
		button btnViewLOD "View to LOD Cam" pos:[132,73] width:105 height:14	
	
	
	
	
		checkbox chk_shadow "$shadowlod" pos:[11,104] width:80 height:17 enabled:false toolTip:"Use the lowest level of LOD to calculate the shadow. Ignored if there as no LOD Model."
		button btnDeleteAllLods "Delete All Current LODs" pos:[12,128] width:230 height:27 toolTip:"Delete all the current LODs and their helpers for this model."
				
		
		button btnHideLODs "Show Main Model" pos:[13,163] width:229 height:36 toolTip:"Hide all LODs and hulls for this model. Displays main mesh."
			
			
				
				
			
			
		on generateLODbtn pressed do
		(
				
			--print lodSpinner.value
			if ww_scene_lods.target == undefined  do (
				messageBox "You must first pick your model/mesh."
				
		        return messageBox
		
				)
				
				if(lodSpinner.value == undefined OR lodSpinner.value == 0) do(
					lodSpinner.value = 1
					)
					
			--if(lodSpinner.value==1 AND ww_scene_lods.lods.count==0)do(
				--lodSpinner.value = 2
				--lodSpinner.value = 1
				--messageBox "To Create 1 (and only 1) LOD, please increment the LOD spinner then revert it back to 1. This bug will be fixed soon."
				
		       -- return messageBox
				--)		
					
			ww_scene_lods.makeLodsArray lodSpinner.value ww_scene_lods
			wwmt_activateLODMenus ww_scene_lods.lods
				
				
			wwToolsFloater.rollouts[3].open = false
			wwToolsFloater.rollouts[4].open = true
				
			)
		on createLODCam pressed do
		(
						if ww_scene_lods.lodcount() == 0 then (
							 messagebox "The LOD Came only works if the model has LODs."
							) else (
								if ww_scene_lods.cam == undefined OR isDeleted ww_scene_lods.cam then (
									include "$scripts/WallWorm.com/common/config.ms"
									camTar = targetObject pos:ww_scene_lods.targets[1].pos
									camTar.parent = ww_scene_lods.targets[1]
									cam = targetCamera target:camTar
									cam.name = (ww_scene_lods.modelName + "_LOD_Camera" )
									cam.fov = wwmt_FOV
									cam.position = ww_scene_lods.lods[1].helperTape.position
									cam.parent = ww_scene_lods.targets[1]
									
									ww_scene_lods.cam = cam
									
									ww_scene_lods.target.cam = cam
									
									--setUserProp ww_scene_lods.target "wwmt_cam"  cam.name	
									
									ww_scene_lods.setCamChangeHandler()
								) else (
									ww_scene_lods.setCamChangeHandler()
								)
								select ww_scene_lods.cam
							)
					)
		on selectLODCam pressed do
		(
						
						if (ww_scene_lods.cam !=undefined AND NOT isDeleted ww_scene_lods.cam) do (
							select ww_scene_lods.cam
							)
						
						)
		on btnViewLOD pressed do
		(
		if ww_scene_lods.cam != undefined then (
		select ww_scene_lods.cam
		viewport.setType #view_camera
		) else (
		 messagebox "No LOD Cam. Create one first."
		)
		)
		on chk_shadow changed state do
		(
			    	if state == true then (
			    	
			    	ww_scene_lods.setShadowlod(true)
			    	
			    	) else (
			    	ww_scene_lods.setShadowlod(false)
			    	
			    	)
				)
		on btnDeleteAllLods pressed do
		(
					
					for l in ww_scene_lods.lods where l != undefined AND classOf l == ww_lod do (
						l.deleteLOD()
						
					)
					ww_scene_lods.lods = #()
					wwmt_activateLODMenus ww_scene_lods.lods
					
					
				)
		on btnHideLODs pressed  do
		(
		
		ww_scene_lods.showOnlyModel()
		)
	)
	

rollout wwtoolsAbout "About and Settings" width:250 height:171
(
	HyperLink ShawnLink "Shawn Olson" pos:[143,42] width:96 height:15 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://www.shawnolson.net"
	label lbl1 "Wall Worm Model Tools Version " pos:[9,3] width:232 height:19
	label lbl2 "Copyright (c) 2010-2014" pos:[11,43] width:131 height:19
	HyperLink cust2 "Documents and Reference" pos:[9,22] width:132 height:12 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/2/wall_worm_model_tools.html"
	bitmap wwmt_logo "" pos:[19,65] width:200 height:68 fileName:"$scripts\Wallworm.com\assets\ww_model_tools.png"
	HyperLink Credits "Credits" pos:[13,138] width:46 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/29/credits.html"
	HyperLink changelog "Changelog" pos:[66,138] width:65 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/33/wwmt_changelog.html"
	HyperLink donate "Donate" pos:[197,138] width:43 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"
	button configButton "Settings" pos:[153,16] width:80 height:20 toolTip:"Set various settings to control the way WWMT works, including setting important Source SDK paths, etc."
	HyperLink cust22 "Forums" pos:[139,138] width:51 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://www.wallworm.net"
	on configButton pressed do
	(
			
			macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
			
	)
)

include "$scripts/WallWorm.com/rollouts/wwmt_utilities.ms"
	
rollout wwmt_propData "Prop Data and Custom Gibs" width:250 height:590
(
	combobox ddl_base "Base" pos:[11,6] width:225 height:5 enabled:false items:#("", "Cardboard.Small", "Cardboard.Medium", "Cardboard.Large", "Cardboard.break", "Cardboard.Indestructable", "Cardboard.breakclient", "Cloth.Small", "Cloth.Medium", "Cloth.Large", "Cloth.Object", "Flesh.Tiny", "Flesh.Small", "Glass.Small", "Glass.Window", "Glass.picture", "Glass.CSWindow", "Glass.CSWindow2", "Glass.WindowStrong", "Item.Small", "Item.Medium", "Item.Large", "Door.Standard", "Metal.Small", "Metal.Medium", "Metal.Large", "Metal.break", "Metal.break2", "Metal.MediumClient", "Wooden.Tiny", "Wooden.Small", "Wooden.chair", "Wooden.MediumNobreak", "Wooden.Large", "Wooden.Huge", "Wooden.sticks", "Wooden.Barrel", "Wooden.Small2", "Wooden.Barrel2", "Metal.Large", "Plastic.Small", "Plastic.Medium", "Plastic.Large", "Plastic.break", "PlasticSmall.break", "Plastic.Small2", "Pottery.Small", "Pottery.Medium", "Pottery.Large", "Pottery.Huge", "Pottery.break", "Pottery.Plant", "Pottery.break2", "Pottery.PlantBreak", "Stone.Small", "Stone.Medium", "Stone.Large", "Stone.Huge", "Stone.Gigantic", "Wooden.Tiny", "Wooden.Small", "Wooden.Medium", "Wooden.Large", "Wooden.ExtraLarge", "Wooden.Huge")
	HyperLink hyperlinkgibs "Prop Data Help" pos:[160,6] width:73 height:15 address:"http://dev.wallworm.com/topic/28/prop_data_and_custom_gibs.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	spinner spn_health "Health" pos:[143,153] width:92 height:16 enabled:false range:[0,10000,0] type:#integer scale:1
	checkbox chk_allowstatic "Allow Static " pos:[12,155] width:115 height:15 enabled:false
	dropdownList ddl_physicsmode "Physics Mode" pos:[11,106] width:224 height:40 enabled:false items:#("Auto", "Solid, pushes the player away.", "Non-solid, but gets pushed away by the player.", "Non-solid, clientside simulated only.")
	checkbox chk_blockLOS "Block Line of Sight" pos:[12,176] width:118 height:15 enabled:false
	checkbox chk_AIWalkable "AI Walkable" pos:[132,172] width:103 height:14 enabled:false
	spinner spn_dmg_bullets "dmg.bullet" pos:[49,215] width:135 height:16 enabled:false range:[0,10000,1]
	spinner spn_dmg_club "dmg.club" pos:[49,241] width:135 height:16 enabled:false range:[0,100,1]
	spinner spn_dmg_explosive "dmg.explosive" pos:[50,266] width:134 height:16 enabled:false range:[0,10000,1]
	checkbox chk_ignite "Ignite" pos:[11,328] width:57 height:14 enabled:false
	checkbox chk_explosive_resist "Explosive Resist" pos:[11,345] width:98 height:14 enabled:false
	checkbox chk_flammable "Flammable" pos:[11,363] width:97 height:13 enabled:false
	GroupBox grp1 "Flammable Prop" pos:[4,307] width:110 height:79
	spinner spn_explosive_damage "Exp. Dmg" pos:[147,330] width:89 height:16 enabled:false range:[0,10000,0]
	spinner spn_explosive_radius "Exp. Radius" pos:[147,352] width:89 height:16 enabled:false range:[0,10000,0]
	GroupBox grp2 "Exploding Prop" pos:[116,307] width:126 height:79
	dropdownList ddl_breakable_model "Gibs Model Class" pos:[12,417] width:134 height:40 enabled:false items:#("", "WoodChunks", "GlassChunks", "ConcreteChunks", "MetalChunks", "CustomGibs")
	spinner spn_breakable_count "Count" pos:[18,472] width:114 height:16 enabled:false type:#integer scale:1
	spinner spn_breakable_skin "Skin #" pos:[148,472] width:85 height:16 enabled:false type:#integer scale:1
	dropdownList ddl_multiplayer_break "Multiplayer Break" pos:[10,505] width:227 height:40 enabled:false items:#("client", "server", "both")
	button btn_custGibs "Add Sel Gibs" pos:[158,408] width:76 height:17 enabled:false toolTip:"Click here to set all selected meshes as Gibs models for this model."
	GroupBox grp3 "Gibs" pos:[5,396] width:237 height:180
	GroupBox grp4 "Damage Modifiers" pos:[4,198] width:239 height:99
	spinner spn_fadetime "Fade Time" pos:[141,502] width:92 height:16 enabled:false range:[0,10000,0] type:#integer scale:1
	button btn_removeGibs "Rem Sel Gibs" pos:[158,432] width:75 height:17 enabled:false toolTip:"Click to remove all selected items from the gibs list for this model."
	button btn_compileGibs "Compile Gibs" pos:[11,552] width:100 height:15 enabled:false toolTip:"Click here to compile all gibs models."
	button btn_compileGibsVTFs "Compile Gibs VTFs" pos:[120,552] width:100 height:15 enabled:false toolTip:"Click here to compile all textures belonging to gibs."
	checkbox chk_motiondisabled "motiondisabled" pos:[132,188] width:109 height:19 tooltip:"To spawn non-moving gibs (in some mods)." enabled:false
	
	on chk_motiondisabled changed state do
	(
		ww_scene_lods.setmotiondisabled state
	)
	
	on ddl_base selected sel do
	(
	
		ww_scene_lods.setBase(ddl_base.items[sel])
	)
	on ddl_base changed txt do
	(
			ww_scene_lods.setBase(txt)
		)
	on spn_health changed val do
	(
		ww_scene_lods.setHealth val
	)
	on chk_allowstatic changed state do
	(
	    ww_scene_lods.setAllowstatic state
	)
	on ddl_physicsmode selected sel do
	(
	ww_scene_lods.setPhysicsmode(ddl_physicsmode.selection)
	
	)
	on chk_blockLOS changed state do
	(
		ww_scene_lods.setBlockLOS state
	)
	on chk_AIWalkable changed state do
	(
		ww_scene_lods.setAIWalkable state
	)
	on spn_dmg_bullets changed val do
	(
		ww_scene_lods.setDmg_bullets val
	)
	on spn_dmg_club changed val do
	(
		ww_scene_lods.setDmg_club val
	)
	on spn_dmg_explosive changed val do
	(
		ww_scene_lods.setDmg_explosive val
	)
	on chk_ignite changed state do
	(
		ww_scene_lods.setIgnite state
	)
	on chk_explosive_resist changed state do
	(
		ww_scene_lods.setExplosive_resist state
	)
	on chk_flammable changed state do
	(
		ww_scene_lods.setFlammable state
	)
	on spn_explosive_damage changed val do
	(
		ww_scene_lods.setExplosive_damage val
	)
	on spn_explosive_radius changed val do
	(
		ww_scene_lods.setExplosive_radius val
	)
	on ddl_breakable_model selected sel do
	(
	
	ww_scene_lods.setBreakable_model(ddl_breakable_model.items[sel])
	)
	on spn_breakable_count changed val do
	(
		ww_scene_lods.setBreakable_count val
	)
	on spn_breakable_skin changed val do
	(
		ww_scene_lods.setBreakable_skin val
	)
	on ddl_multiplayer_break selected sel do
	(
	
	ww_scene_lods.setMultiplayer_break(ddl_multiplayer_break.items[sel])
	)
	on btn_custGibs pressed do
	(
		if (ww_scene_lods.breakable_model == undefined OR ww_scene_lods.breakable_model != "CustomGibs") then (
				messagebox "Custom Gibs is can only be set if Gibs Model Class is set to \"CustomGibs\"."
			) else(
			
				if selection.count > 0 then (
					ww_scene_lods.addGibs selection
				
					if ww_scene_lods.breakable_count != undefined AND spn_breakable_count.value != ww_scene_lods.breakable_count then (
	
						spn_breakable_count.value = ww_scene_lods.breakable_count 
						
					)
					
					) else (
					messagebox "You must first select the items to add to the gibs list."
					
					)
			)
		
		
	
		
	)
	on spn_fadetime changed val do
	(
			ww_scene_lods.setFadetime val
	
	
	)
	on btn_removeGibs pressed do
	(
			
			ww_scene_lods.removeGibs selection
			
			
			)
	on btn_compileGibs pressed do
	(
			if ww_scene_lods.gibs.count > 0 then (
			ww_scene_lods.exportGibs()
			) else (
				messagebox "You haven't assigned any gibs to this model."
			)

	)
	on btn_compileGibsVTFs pressed do
	(
		   if ww_scene_lods.gibs.count > 0 then (
		   			if ww_scene_lods.canCompile "tex" then (
							include "$scripts\\WallWorm.com\\WallWormModelTools\\textureExport.ms"
						) else (
							messagebox "To compile textures, the following requirements must be met:\n\n*Set a \"Material Path\" in the Export Options rollout\n*Have valid materials (with Bitmaps in the diffuse slots) on model\n*\"Bin Dir\" AND \"Material Root Directory\" set in the Settings floater"
						)
					) else(
						messagebox "You haven't assigned any gibs to this model."
					)
		   )
)
--addRollout titleRoll wwToolsFloater 
addRollout Wall_Worm_Model_Tools wwToolsFloater
	
addRollout wwmt_cm wwToolsFloater	rolledUp:true
	
addRollout wwmt_lodsrollout wwToolsFloater rolledUp:true


	
	
	



try (
	addRollout wwmt_lodslistrollouta wwToolsFloater rolledUp:true
	) catch (
	execute lodstring
	addRollout wwmt_lodslistrollouta wwToolsFloater rolledUp:true
	)
	
	

addRollout wwmt_sequences wwToolsFloater rolledUp:true
addRollout wwmt_attachments wwToolsFloater rolledUp:true
addRollout wwmt_exportRollout wwToolsFloater rolledUp:true	
addRollout wwmt_utilities wwToolsFloater rolledUp:true	
addRollout wwmt_propData wwToolsFloater rolledUp:true	
addRollout wwtoolsAbout wwToolsFloater

wwToolsFloater.rollouts[10].lbl1.caption += (ww_wwmt_version as string)
wwToolsFloater.rollouts[3].lodSpinner.range=[1,wwmt_lodLimit,1]

	
	
	if wallworm_reset_wwmt == true AND ww_scene_lods != undefined then (
		wallworm_setWWMUI()

	)
wallworm_reset_wwmt = undefined