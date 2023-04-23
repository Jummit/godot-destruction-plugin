@tool
@icon("destruction_icon.svg")
class_name Destruction
extends Node

## Handles destruction of the parent node.
##
## When [method destroy] is called, the parent node gets removed
## and shards are added to the [member shard_container]. [member shard_scene] is
## instantiated to configure how the [member shard_scene] will be converted to
## [RigidBody]s.

## A scene of the fragmented mesh containing multiple [MeshInstance]s.
@export var fragmented : PackedScene: set = set_fragmented
## The shard which is instanced for every part of the fragmented version.
@export var shard := preload("shard.tscn"): set = set_shard
@onready @export var shard_container : Node = get_node("../../")
@export_group("Animation")
## How many seconds until the shards fade away. Set to -1 to disable fading.
@export var fade_delay := 2.0
## How many seconds until the shards shrink. Set to -1 to disable shrinking.
@export var shrink_delay := 2.0
@export_group("Collision")
@export_flags_3d_physics var collision_layers = 1
@export_flags_3d_physics var layer_masks = 1

signal _shards_created(shards)

## Remove the parent node and add shards to the shard container.
func destroy(explosion_power := 1.0) -> void:
	var thread := Thread.new()
	thread.start(_create_shards.bind(explosion_power))
	var shards = await _shards_created
	thread.wait_to_finish()
	shard_container.add_child(shards)
	shards.global_transform.origin = get_parent().global_transform.origin
	shards.top_level = true
	get_parent().queue_free()


func _create_shards(explosion_power : float):
	var shards := DestructionUtils.create_shards(fragmented, shard,
			collision_layers, layer_masks, explosion_power, fade_delay,
			shrink_delay)
	emit_signal.call_deferred("_shards_created", shards)


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
	return warnings
