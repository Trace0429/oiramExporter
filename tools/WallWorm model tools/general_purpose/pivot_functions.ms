
/*

Function for moving the pivots to common places in an array of objects

Example usage: wallworm_move_pivots selection alignment:#topCenter
*/
function wallworm_move_pivots objsArray alignment:#bottomCenter = (
	for obj in objsArray do (
		minVal = obj.min
		maxVal = obj.max
		newPos = (minval + maxVal) / 2
		
		case alignment of (
				
			#topCenter:(
				obj.pivot = [newPos.x,newPos.y, maxVal.z]
			)
			default: obj.pivot = [newPos.x,newPos.y, minVal.z]
			
		)
	)
)

