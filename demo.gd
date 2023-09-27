# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

extends Node3D

## Demo of the Destruction plugin.
##
## Shows a [RigidBody3D] cube which can be destroyed by clicking a button.

@onready var _destruction: Destruction = $DestructibleCube/Destruction
@onready var _destroy_button: Button = $DestroyButton

var _destructible_cube_scene := preload("res://cube/destructible_cube.tscn")

func _on_destroy_button_pressed() -> void:
	_destruction.destroy(5)
	_destroy_button.disabled = true
	await get_tree().create_timer(1).timeout
	var new := _destructible_cube_scene.instantiate()
	add_child(new)
	_destruction = new.get_node("Destruction")
	_destroy_button.disabled = false
