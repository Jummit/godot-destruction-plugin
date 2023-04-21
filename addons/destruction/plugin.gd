@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("DestructionUtils",
			"res://addons/destruction/destruction_utils.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("DestructionUtils")
