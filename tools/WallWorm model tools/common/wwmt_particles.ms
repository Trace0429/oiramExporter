
Struct wwmt_particles (
	
	systemname="",
	type="keyvalue",
	attachTo="start_at_origin",
	attachmentPoint=undefined,
	sequence=undefined,
	pframe=undefined,
	pEnd=undefined,
	
	
	function setParticleProperties = (
		return #(systemname,type,attachTo,attachmentPoint,sequence,pframe,pEnd)
	),
	
	function getParticleProperties ar = (
		
			systemname=ar[1]
			type=ar[2]
			attachTo=ar[3]
			attachmentPoint=ar[4]
			sequence=ar[5]
			pframe=ar[6]
			pEnd = ar[7]
		)
	
	
	)