/*

Fix Negative Scale on Painted Objects painted with the Object Paint tool in Graphite
By Shawn Olson
http://www.shawnolson.net

Developer of Wall Worm
http://dev.wallworm.com

The problem is that all Objects painted with the Object Paint Tool have a scale of [-1,-1,-1] by default.
This means that they are not actually representative of the original object.
The scale spinners do not let you go below 0... so trying to invesre the default 100 scale to -100 also does
not work.

That is why I made this script. You can fix the objects up to a point. They will not look exactly as painted,
but they will at least now look as if they would have looked had the scale not preset to [-1,-1,-1].


*/
(

rollout positive_paint_scale "Fix Object Paint Scale Version 0.1" width:295 height:155
(
	
	button btn1 "Get Objects Scales other than 1" pos:[12,16] width:270 height:52 toolTip:"Select all objects with scales that are not at [1,1,1]. If there is a selection of objects, it will select from the current selection. Otherwise, from entire scene."
	button btn2 "Set Selection Scale to 1" pos:[13,72] width:137 height:44 toolTip:"Set all objects in the current selection that don't have a scale of [1,1,1] to a scale of [1,1,1]. Then all objects are flipped 180 degrees on their local X axis."
	HyperLink shawn "Shawn Olson" pos:[79,126] width:63 height:15 address:"http://www.shawnolson.net"
	label lbl3 "Written by" pos:[16,126] width:61 height:16
	button btn3 "Rescale and Rotate" pos:[157,73] width:125 height:41
	
	function wallworm_select_negative_scale_objects = (
		
		if selection.count > 0 then (
			sel = selection 
		) else (
			 sel = objects 
		)
		
		 objs = for obj in sel WHERE obj.scale != [1,1,1]  collect obj
		if objs != undefined AND objs.count > 0 then (
				select objs
		)
		return objs
	)

	function wallworm_objects_positive sel:selection rot:false= (

		if sel != undefined AND sel.count > 0 then (
			
			for obj in sel where obj.scale != [1,1,1] do (
				obj.scale = [1,1,1]
				if rot == true then (
					in coordsys local (
						obj.rotation.x += 180
						obj.rotation.z += 180
					)
				)
			)
		)
	)

	
	on btn1 pressed do
	(	
		wallworm_select_negative_scale_objects()
	)
	on btn2 pressed  do 
	(
		undo label:"Scale 1" on (
			wallworm_objects_positive()
		)
	)
	on btn3 pressed  do  
	(
		undo label:"Scale 1 and Rotate" on (
			wallworm_objects_positive rot:true
		)
	
	)
)

createDialog positive_paint_scale   

)