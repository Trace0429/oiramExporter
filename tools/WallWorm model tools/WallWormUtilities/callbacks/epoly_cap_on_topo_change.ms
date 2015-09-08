fn wallworm_cap_borders  nodes = (
	for nd in nodes WHERE classof nd == Editable_Poly  do (
		nd.capHoles #object
	)
)

wallworm_cap_borders selection