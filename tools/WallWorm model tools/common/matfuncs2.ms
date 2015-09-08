/*Generic functions to get maps from common materials.

For the moment WW collects only from Standard but in the future
it should properly export some other common materials.

*/

function wallworm_getMap_from_Material mat mapType = (
	
	
	
	case mapType of (
			"diffuseColor": (
				case (classOf mat) of (
					Standard: return mat.diffuseMap
					Arch___Design__mi: return mat.diff_color_map
					VRayMtl: return mat.texmap_diffuse
				)
			)
			"bumpMap": (
				case (classOf mat) of (
					Standard: return mat.bumpMap
					Arch___Design__mi: return mat.bump_map
					VRayMtl:return mat.texmap_bump
				)
			)
			
			"displacementMap": (
				case (classOf mat) of (
					Standard: return mat.displacementMap
					Arch___Design__mi: return mat.displacement_map
					VRayMtl:texmap_displacement
				)
			)
			
			
			
			
			"SelfIllumMap": (
				case (classOf mat) of (
					Standard: return mat.SelfIllumMap
					Arch___Design__mi: return mat.self_illum_map
					--VRayMtl:texmap_displacement
				)
			)
			
			
			"opacityMap": (
				case (classOf mat) of (
					Standard: return mat.opacityMap
					Arch___Design__mi: return mat.cutout_map
					VRayMtl:texmap_opacity
				)
			)
			
			specularLevelMap
			specularMap
			ReflectionMap
			RefractionMap
			
			
			
			
			
			
			
	)
	
	
	
	
	
	
	
	)