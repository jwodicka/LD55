class_name MainMenu
extends Control

func _ready() -> void:
	var level_buttons: Node = find_child("LevelButtons")
	for level_name: String in Levels.levels.keys():
		var level_button: Button = Button.new()
		level_button.text = level_name
		level_button.pressed.connect(func () -> void: _on_level_select(level_name))
		level_buttons.add_child(level_button)


func _on_level_select(level_name: String) -> void:
	GameShell.enter_level(level_name)
