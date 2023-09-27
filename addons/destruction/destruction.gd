@tool
@icon("destruction_icon.svg")
class_name Destruction
extends Node

## Handles destruction of the parent node.
##
## When [method destroy] is called, the parent node is freed and
## shards are added to the [member shard_container]. The [member shard]
## scene is used as a template for [RigidBody3D]s created from the meshes
## inside the [member fragmented] scene..

## A scene of the fragmented mesh containing multiple [MeshInstance3D]s.
@export var fragmented: PackedScene: set = set_fragmented
## The shard which is instanced for every part of the fragmented version.
@export var shard := preload("shard.tscn"): set = set_shard
## The node where created shards are added to.
@onready @export var shard_container := get_node("../../")

@export_group("Animation")
## How many seconds until the shards fade away. Set to -1 to disable fading.
@export var fade_delay := 2.0
## How many seconds until the shards shrink. Set to -1 to disable shrinking.
@export var shrink_delay := 2.0

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
	var shards = _create_shards(explosion_power)
	shard_container.add_child(shards)
	shards.global_transform.origin = get_parent().global_transform.origin
	get_parent().queue_free()


func set_shard(to: PackedScene) -> void:
	shard = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func set_fragmented(to: PackedScene) -> void:
	fragmented = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not fragmented:
		warnings.append("No fragmented version set")
	elif not shard:
		warnings.append("No shard template set")
	return warnings


func _create_shards(explosion_power : float):
	if not fragmented in cached_meshes:
		cached_meshes[fragmented] = fragmented.instantiate()
		for shard_mesh in cached_meshes[fragmented].get_children():
			cached_shapes[shard_mesh] = shard_mesh.mesh.create_convex_shape()
	var original_meshes = cached_meshes[fragmented]
	
	var shards := Node3D.new()
	shards.name = str(cached_meshes[fragmented].name) + "Shards"
	for original in original_meshes.get_children():
		if not original is MeshInstance3D:
			continue
		var new_shard: RigidBody3D = shard.instantiate()
		
		var mesh_instance: MeshInstance3D = new_shard.get_node("MeshInstance")
		mesh_instance.mesh = original.mesh
		
		var collision_shape : CollisionShape3D = new_shard.get_node("CollisionShape")
		collision_shape.shape = cached_shapes[original]
		
		new_shard.position = original.position
		new_shard.collision_layer = collision_layer
		new_shard.collision_mask = collision_mask
		new_shard.fade_delay = fade_delay
		new_shard.explosion_power = explosion_power
		new_shard.shrink_delay = shrink_delay
		
		shards.add_child(new_shard)
	return shards
