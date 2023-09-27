# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

@tool
@icon("destruction_icon.svg")
class_name Destruction
extends Node

## Handles destruction of the parent node.
##
## When [method destroy] is called, the parent node is freed and shards
## are added to the [member shard_container].

## A scene of the fragmented mesh containing multiple [MeshInstance3D]s.
@export var fragmented: PackedScene: set = set_fragmented
## The node where created shards are added to.
@onready @export var shard_container := get_node("../../")

@export_group("Animation")
## How many seconds until the shards fade away. Set to -1 to disable fading.
@export var fade_delay := 2.0
## How many seconds until the shards shrink. Set to -1 to disable shrinking.
@export var shrink_delay := 2.0
## How long the animation lasts before the shard is removed.
@export var animation_length := 2.0

@export_group("Collision")
## The [member RigidBody3D.collision_layer] set on the created shards.
@export_flags_3d_physics var collision_layer = 1
## The [member RigidBody3D.collision_mask] set on the created shards.
@export_flags_3d_physics var collision_mask = 1

## Cached shard meshes (instantiated from [member fragmented]).
static var cached_meshes := {}
## Cached collision shapes.
static var cached_shapes := {}

## Remove the parent node and add shards to the shard container.
func destroy(explosion_power := 1.0) -> void:
	if not fragmented in cached_meshes:
		cached_meshes[fragmented] = fragmented.instantiate()
		for shard_mesh in cached_meshes[fragmented].get_children():
			cached_shapes[shard_mesh] = shard_mesh.mesh.create_convex_shape()
	var original_meshes = cached_meshes[fragmented]
	for original in original_meshes.get_children():
		if original is MeshInstance3D:
			_add_shard(original, explosion_power)
	get_parent().queue_free()


func _add_shard(original: MeshInstance3D, explosion_power: float) -> void:
	var body := RigidBody3D.new()
	var mesh := MeshInstance3D.new()
	var shape := CollisionShape3D.new()
	body.add_child(mesh)
	body.add_child(shape)
	shard_container.add_child(body, true)
	body.global_position = get_parent().global_transform.origin + original.position
	body.collision_layer = collision_layer
	body.collision_mask = collision_mask
	shape.shape = cached_shapes[original]
	mesh.mesh = original.mesh
	if fade_delay >= 0:
		var material = original.mesh.surface_get_material(0)
		if material is StandardMaterial3D:
			material = material.duplicate()
			material.flags_transparent = true
			get_tree().create_tween().tween_property(material, "albedo_color",
					Color(1, 1, 1, 0), animation_length)\
				.set_delay(fade_delay)\
				.set_trans(Tween.TRANS_EXPO)\
				.set_ease(Tween.EASE_OUT)
			mesh.material_override = material
		else:
			push_warning("Shard doesn't use a StandardMaterial3D, can't add transparency.")
	body.apply_impulse(_random_direction() * explosion_power,
			-original.position.normalized())
	if shrink_delay < 0 and fade_delay < 0:
		get_tree().create_timer(animation_length)\
				.timeout.connect(func(): body.queue_free())
	elif shrink_delay >= 0:
		var tween := get_tree().create_tween()
		tween.tween_property(mesh, "scale", Vector3.ZERO, animation_length)\
				.set_delay(shrink_delay)
		tween.finished.connect(func(): body.queue_free())


func set_fragmented(to: PackedScene) -> void:
	fragmented = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func _get_configuration_warnings() -> PackedStringArray:
	return ["No fragmented version set"] if not fragmented else []


static func _random_direction() -> Vector3:
	return (Vector3(randf(), randf(), randf()) - Vector3.ONE / 2.0).normalized() * 2.0
