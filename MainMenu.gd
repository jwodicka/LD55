class_name MainMenu
extends Control

func _ready() -> void:
	var level_buttons: Node = find_child("LevelButtons")
	for level_name: String in Levels.levels.keys():
		var level_button: Button = Button.new()
		level_button.text = level_name
		level_button.pressed.connect(func () -> void: _on_level_select(level_name))
		level_buttons.add_child(level_button)
	GameShell.set_sfx(find_child("SFXCheckBox").button_pressed)
	GameShell.set_music(find_child("MusicCheckBox").button_pressed)


func _on_level_select(level_name: String) -> void:
	GameShell.enter_level(level_name)


func _on_music_check_box_toggled(toggled_on: bool) -> void:
	GameShell.set_music(toggled_on)


func _on_sfx_check_box_toggled(toggled_on: bool) -> void:
	GameShell.set_sfx(toggled_on)


func _on_button_pressed():
	$Credits.show()
