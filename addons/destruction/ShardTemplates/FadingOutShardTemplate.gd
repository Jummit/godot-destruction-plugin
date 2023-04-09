extends RigidBody3D

func _ready():
	var material : StandardMaterial3D = $MeshInstance.mesh.surface_get_material(0)
	if not material:
		return
	material = material.duplicate()
	$MeshInstance.material_override = material
	material.flags_transparent = true
	
	var tween = create_tween()
	tween.tween_property(material, "albedo_color", Color(1, 1, 1, 0), 2).from(Color.WHITE).set_delay(4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
