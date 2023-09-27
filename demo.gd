# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

extends Node3D

@onready var destruction: Destruction = $DestructibleCube/Destruction
@onready var destroy_button: Button = $DestroyButton

var destructible_cube_scene := preload("res://cube/destructible_cube.tscn")

func _on_destroy_button_pressed() -> void:
	destruction.destroy(5)
	destroy_button.disabled = true
	await get_tree().create_timer(1).timeout
	var new := destructible_cube_scene.instantiate()
	add_child(new)
	destruction = new.get_node("Destruction")
	destroy_button.disabled = false
