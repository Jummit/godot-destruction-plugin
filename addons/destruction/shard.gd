extends RigidBody3D

## Shard created by [Destruction].

var shrink_delay : float
var explosion_power : float
var fade_delay : float

func _ready():
	if not shrink_delay and not fade_delay:
		await get_tree().create_timer(2).timeout
	else:
		# Both of these are required to skip the first loop due to this bug:
		# https://github.com/godotengine/godot/issues/75934
		await get_tree().physics_frame
		await get_tree().physics_frame

		var material : StandardMaterial3D = $MeshInstance.mesh.surface_get_material(0)
		if not material:
			return
		material = material.duplicate()
		$MeshInstance.material_override = material
		material.flags_transparent = true

		var tween = create_tween()
		
		if fade_delay > 0:
			tween.tween_property(material, "albedo_color", Color(1, 1, 1, 0), 2)\
				.set_delay(fade_delay)\
				.set_trans(Tween.TRANS_EXPO)\
				.set_ease(Tween.EASE_OUT)

		apply_impulse(random_direction() * explosion_power, -position.normalized())

		if shrink_delay > 0:
			tween.parallel().tween_property($MeshInstance, "scale", Vector3.ZERO, 2)\
				.set_delay(shrink_delay)
		await tween.finished
	queue_free()


static func random_direction() -> Vector3:
	return (Vector3(randf(), randf(), randf()) - Vector3.ONE / 2.0).normalized() * 2.0
