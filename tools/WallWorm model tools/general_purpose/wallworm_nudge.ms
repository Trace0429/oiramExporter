/*
Functions for nudging selections around the world.



*/

global wallworm_nudge_amount 
if wallworm_nudge_amount == undefined then (
	wallworm_nudge_amount = (getINISetting wallworm_userIni "Nudge" "nudgeAmount" ) as integer
)
if wallworm_nudge_amount == undefined OR wallworm_nudge_amount == 0 then (
	wallworm_nudge_amount = 8
)
			
global wallworm_super_nudge_mult
if wallworm_super_nudge_mult == undefined then (
	wallworm_super_nudge_mult = (getINISetting wallworm_userIni "Nudge" "superNudgeAmount") as integer
)
if wallworm_super_nudge_mult == undefined OR wallworm_super_nudge_mult == 0 then (
	wallworm_super_nudge_mult = 16
)

function wallworm_getCurCoordsys = (
	local csys = getRefCoordsys()
	
	case csys of
	(
	#hybrid: (
		--figure out if there is a way to use the #hybrid system itself (for example, the Top, Front, etc.) Until then return world
		return #world
	)
	#object: (
		if activegrid != undefined then (
			return activegrid.objecttransform
		) else (
			return #world
		)
	)
	default: return csys
	)
)

function wallworm_moveSelectedKnots norm = (
	in coordsys (wallworm_getCurCoordsys()) (
		for s = 1 to numSplines $ do (
			k = (getKnotSelection $ s)
			for i = 1 to k.count do (
				p = getKnotPoint $ s k[i]
				setKnotPoint $ s k[i] (p + norm)
				updateShape $
			)
		)
	)
)


/*
 norm should be a vector (point 3) for moving the selection. For example, if norm == [0,0,24] then the nudge will send the object 24 units in the Z axis.
*/
function wallworm_nudge norm = (
		
	
		if subobjectLevel == 0 or subobjectLevel == undefined then (
			local sel = selection as array
			for i = sel.count to 1 by -1 do if isGroupMember sel[i] and not isOpenGroupMember sel[i] do deleteItem sel i
			for i = sel.count to 1 by -1 do if isOpenGroupMember sel[i] do (
				if findItem sel sel[i].parent != 0 do deleteItem sel i
			)
			in coordsys (wallworm_getCurCoordsys()) (move sel norm)

		) else (
				
			case (superclassof $) of (
					
					GeometryClass:(		
						case (subObjectLevel) of
							(
							1: move $.selectedVerts norm
							2: move $.selectedEdges norm
							3: move $.selectedFaces norm
							4: move $.selectedFaces norm
							default:()
						)
					)
					Shape:(
						case (subObjectLevel) of
						(
							1: wallworm_moveSelectedKnots norm
							2: ()
							3: (
								local sp = getSplineSelection $
								for i = 1 to (numsplines $) do (setKnotSelection $ i #())
								for i = 1 to sp.count do
								(
									local nk = numknots $ sp[i]
									local knots = #()
									for j = 1 to nk do append knots j
									setKnotSelection $ sp[i] knots keep:false
								)
								wallworm_moveSelectedKnots norm
							)

						)
					)
					default:(
						--Figure out what to do with other common objects... if necessary
						
					)
			)
		)
	)