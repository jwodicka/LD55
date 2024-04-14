class_name GameLevel
extends Control

const Symbol = GameLogic.Symbol
const SUMMONING_CIRCLE_SCENE = preload("res://summoning_circle.tscn")

@export
var level_name : String = ""

@export
var next_level : String = ""

@export
var flavor_text : String = ""

@export
var victory_text : String = ""

@onready
var circle: SummoningCircle = SUMMONING_CIRCLE_SCENE.instantiate()

func load_level() -> void:
	var glyphs : Array[Symbol] = []
	var targets : int = 1
	var target_connectors : Array[Vector2i] = []
	var offset_angle : float = 0
	var initial_placements : Dictionary = {} # Maps target number to glyph symbol
	var locked_targets : Array[int] = []
	
	var level_def: Dictionary = Levels.levels[level_name]
	if "next_level" in level_def:
		next_level = level_def.next_level
	if "glyphs" in level_def:
		glyphs.assign(level_def.glyphs)
	if "targets" in level_def:
		targets = level_def.targets
	if "target_connectors" in level_def:
		target_connectors.assign(level_def.target_connectors)
	if "offset_angle" in level_def:
		offset_angle = level_def.offset_angle
	if "flavor_text" in level_def:
		flavor_text = level_def.flavor_text
	if "victory_text" in level_def:
		victory_text = level_def.victory_text
	if "initial_placements" in level_def:
		initial_placements = level_def.initial_placements
	if "locked_targets" in level_def:
		locked_targets.assign(level_def.locked_targets)

	circle.glyphs = glyphs
	circle.targets = targets
	circle.target_connectors = target_connectors
	circle.offset_angle = offset_angle
	circle.initial_placements = initial_placements
	circle.locked_targets = locked_targets
	
	circle.puzzle_solved.connect(_on_victory)

	$BoxContainer.add_child(circle)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var flavor_container = $BoxContainer/VBoxContainer/FlavorContainer
	var flavor_label = $BoxContainer/VBoxContainer/FlavorContainer/PanelContainer/FlavorLabel
	if !level_name.is_empty():
		load_level()
	if !flavor_text.is_empty():
		flavor_container.visible = true
		flavor_label.text = flavor_text
	else:
		flavor_container.visible = false

func _on_victory() -> void:
	var end_flavor_text := victory_text
	if end_flavor_text.is_empty():
		end_flavor_text = "Another successful summoning!"
	(find_child("EndFlavorLabel") as Label).text = end_flavor_text
	(find_child("VictoryPanel") as Container).custom_minimum_size.x = get_viewport_rect().size.x * 0.33

	if next_level.is_empty():
		find_child("NextButton").hide()

	$VictoryOverlay.show()

func _on_button_pressed() -> void:
	GameShell.return_to_menu()

func _on_next_button_pressed() -> void:
	GameShell.enter_level(next_level, self)
