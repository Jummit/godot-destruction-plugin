extends RigidBody

func _ready():
	var material : SpatialMaterial = $MeshInstance.mesh.surface_get_material(0)
	if not material:
		return
	material = material.duplicate()
	$MeshInstance.material_override = material
	material.flags_transparent = true
	
	$Tween.interpolate_property(material, "albedo_color", Color.white, Color(1, 1, 1, 0), 2, Tween.TRANS_EXPO, Tween.EASE_OUT, 4)
	$Tween.start()
