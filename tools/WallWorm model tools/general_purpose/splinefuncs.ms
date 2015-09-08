
/*
This function will return a new spline useful for converting a shape so that each of the visible cornerns from interpolation become a knot.
*/
function wallworm_interpolated_spline_points spline method:1 del:false= (
	
	local out
	case method of (
		
		default:(
			out =  Line pos:spline.pos
			out.steps = 0
			
		)
	)
	
	
	if classof spline == line or classof spline == classof spline ==splineshape then (
		sps = numsplines spline
	) else (
		sps = 1
		
	)
	
	for s = 1 to sps do (
		
		if classof spline == line or classof spline == classof spline ==splineshape then (
			nk = numKnots spline s
		) else (
			nk = numKnots spline
			
		)
		
		addNewSpline out	
		
		local steps = spline.steps * nk
	

		in coordsys world addKnot out s  #corner #line (pathInterp spline s 0.0)
		--Point pos:(pathInterp spline s 0.0)
		
		local percent = 1.0/steps
		local newPercent = percent
		for i = 1 to (steps as integer) do (
			--append ptsArray (newPercent)
			in coordsys world addKnot out s  #corner #line (pathInterp spline s newPercent)
			--Point pos:(pathInterp spline s newPercent)
			
			newPercent += percent
		)
	
	)
	
	updateShape out
	out
)


--select (wallworm_interpolated_spline_points $)