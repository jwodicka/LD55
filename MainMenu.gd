class_name MainMenu
extends Control

func _on_level_select(level_name: String) -> void:
	GameShell.enter_level(level_name)
