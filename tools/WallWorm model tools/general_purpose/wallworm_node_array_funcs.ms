
/*

Functions to quickly add nodes to properties of other objects. Like Blobmesh, etc.

*/

function wallworm_get_list_node_properties obj = (
	names = for n in (getPropNames obj) WHERE  (classof (getProperty obj (n as string)) ) == ArrayParameter collect (n as string)
)




function wallworm_add_objs_to_obj objs obj = (

	
)


function wallworm_choose_arrayprop_from_list obj = (
	wallworm_get_list_node_properties obj
	
	--global wallworm_add_targets = rollout
	
)