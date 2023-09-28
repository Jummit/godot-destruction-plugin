# SPDX-FileCopyrightText: 2023 Jummit
#
# SPDX-License-Identifier: MIT

extends Node3D

## Demo of the Destruction plugin.
##
## Shows multiple [RigidBody3D] cubes which can be destroyed by
## clicking on them.

var _destructible_cube_scene := preload("res://cube/destructible_cube.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("destroy"):
		var camera := get_viewport().get_camera_3d()
		var parameters := PhysicsRayQueryParameters3D.create(
				camera.global_position,
				camera.project_position(get_viewport().get_mouse_position(), 30))
		parameters.collision_mask = 1
		var result := get_world_3d().direct_space_state.intersect_ray(parameters)
		if not result or not result.collider.has_node("Destruction"):
			return
		_destroy_and_respawn(result.collider)
	elif event.is_action_pressed("destroy_all"):
		for child in get_children():
			if child.has_node("Destruction"):
				_destroy_and_respawn(child)


func _destroy_and_respawn(cube):
	cube.get_node("Destruction").destroy(7)
	var new := _destructible_cube_scene.instantiate()
	new.position = cube.position
	await get_tree().create_timer(1).timeout
	add_child(new)
