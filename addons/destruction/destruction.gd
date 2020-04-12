extends Node

onready var DestructionUtils := preload("res://addons/destruction/DestructionUtils.gd")
export var shard_template : PackedScene = preload("res://addons/destruction/ShardTemplates/DefaultShardTemplate.tscn")
export var shard_scene : PackedScene
export var shard_container : NodePath

onready var to_add_shards_to := get_parent().get_parent()

func _ready():
	if shard_container:
		to_add_shards_to = get_node(shard_container)


func destroy() -> void:
	var shards := DestructionUtils.create_shards(shard_scene.instance(), shard_template)
	to_add_shards_to.add_child(shards)
	shards.global_transform.origin = get_parent().global_transform.origin
	get_parent().queue_free()
