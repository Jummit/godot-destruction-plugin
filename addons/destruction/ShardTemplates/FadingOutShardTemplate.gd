extends RigidBody3D


var fade_delay = 4

func _ready():
	var material : StandardMaterial3D = $MeshInstance.mesh.surface_get_material(0)
	if not material:
		return
	material = material.duplicate()
	$MeshInstance.material_override = material
	material.flags_transparent = true
	
	var tween = create_tween()
	tween.tween_property(material, "albedo_color", Color(1, 1, 1, 0), 2).from(Color.WHITE).set_delay(fade_delay).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await (tween.finished) #Await the tween to finish making the shards disapear then queues free the base rock along with the shards.
    get_parent().queue_free()
