class_name GameShell
extends Node

const MAIN_MENU_SCENE = preload("res://main_menu.tscn")
static var _game_shell: GameShell

var main_menu: MainMenu

var current_level: SummoningCircle = null

static func enter_level(level_name: String, from_node: Node = null) -> void:
	_game_shell._enter_level(level_name, from_node)

func _enter_level(level_name: String, from_node: Node = null) -> void:
	if from_node == null:
		from_node = main_menu
	current_level = GameLogic.load_level(level_name)
	add_child(current_level)
	remove_child(from_node)

static func return_to_menu() -> void:
	_game_shell._return_to_menu()

func _return_to_menu() -> void:
	add_child(main_menu)
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
		current_level = null

func _ready() -> void:
	if _game_shell == null:
		_game_shell = self
	main_menu = MAIN_MENU_SCENE.instantiate()
	add_child(main_menu)
	$BGMPlayer.play()

