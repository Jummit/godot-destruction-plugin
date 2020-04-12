tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Destruction", "Node", load("res://addons/destruction/destruction.gd"), load("res://addons/destruction/destruction_icon.svg"))


func _exit_tree():
	remove_custom_type("Destruction")

