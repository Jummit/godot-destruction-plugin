# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

extends RigidBody3D

## Shard created by [Destruction].

## See [member Destruction.shrink_delay].
var shrink_delay: float
## See [method Destruction.destroy].
var explosion_power: float
## See [member Destruction.fade_delay].
var fade_delay: float
var material: Material
var shape: Shape3D
var mesh: Mesh

@onready var mesh_instance: MeshInstance3D = $MeshInstance
@onready var collision_shape: CollisionShape3D = $CollisionShape

func _ready():
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	collision_shape.shape = shape
	if shrink_delay < 0 and fade_delay < 0:
		await get_tree().create_timer(2).timeout
	else:
		# Both of these are required to skip the first loop due to this bug:
		# https://github.com/godotengine/godot/issues/75934
		await get_tree().physics_frame
		await get_tree().physics_frame
		apply_impulse(_random_direction() * explosion_power, -position.normalized())
		var tween = create_tween()
		if shrink_delay > 0:
			tween.tween_property(mesh_instance, "scale", Vector3.ZERO, 2)\
				.set_delay(shrink_delay)
		await tween.finished
	queue_free()


static func _random_direction() -> Vector3:
	return (Vector3(randf(), randf(), randf()) - Vector3.ONE / 2.0).normalized() * 2.0
