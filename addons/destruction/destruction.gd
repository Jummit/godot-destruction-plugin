@icon("destruction_icon.svg")
@tool
extends Node
class_name Destruction

## Handles destruction of the parent node.
##
## When [method destroy] is called, the parent node gets removed
## and shards are added to the `shard_container`. [member shard_scene] is
## instantiated to configure how the [member shard_scene] will be converted to
## [RigidBody]s.

## A scene of the fragmented mesh containing multiple [MeshInstance]s.
@export var fragmented : PackedScene: set = set_fragmented
## The shard which is instanced for every part of the fragmented version.
@export var shard := preload("shard.tscn"): set = set_shard
@onready @export var shard_container : Node = get_node("../../"):
	set = set_shard_container
@export_group("Animation")
## How long until the shards fade away. Set to -1 to disable fading.
@export var fade_delay := 2
## How long until the shards shrink. Set to -1 to disable shrinking.
@export var shrink_delay := 2
@export_group("Collision")
@export_flags_2d_physics var collision_layers = 1
@export_flags_2d_physics var layer_masks = 1

const DestructionUtils = preload("destruction_utils.gd")

## Remove the parent node and add shards to the shard container.
func destroy(explosion_power := 1.0) -> void:
	## TODO: Cache fragmented scene for use in other Destruction instances.
	## Remove the queue_free in the destruction utils afterwards.
	var shards := DestructionUtils.create_shards(fragmented.instantiate(),
			shard, collision_layers, layer_masks, explosion_power,
			fade_delay, shrink_delay)
	shard_container.add_child(shards)
	shards.global_transform.origin = get_parent().global_transform.origin
	shards.top_level = true
	get_parent().queue_free()


func set_shard_container(to : Node) -> void:
	shard_container = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func set_shard(to : PackedScene) -> void:
	shard = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func set_fragmented(to : PackedScene) -> void:
	fragmented = to
	if is_inside_tree():
		get_tree().node_configuration_warning_changed.emit(self)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not fragmented:
		warnings.append("No fragmented version set")
	elif not shard:
		warnings.append("No shard template set")
	elif shard_container is PhysicsBody3D or _has_parent_of_type(shard_container,
			PhysicsBody3D):
		warnings.append("The shard container is a PhysicsBody or has a PhysicsBody as a parent. This will make the shards added to it behave in unexpected ways.")
	return warnings


static func _has_parent_of_type(node : Node, type) -> bool:
	if not node.get_parent():
		return false
	if typeof(node.get_parent()) == type:
		return true
	return _has_parent_of_type(node.get_parent(), type)
