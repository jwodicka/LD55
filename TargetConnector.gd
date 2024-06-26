class_name TargetConnector
extends Line2D

@export
var end_a : DropTarget
@export
var end_b : DropTarget

@export
var state : GameLogic.State:
	get:
		return _state
	set(value):
		if value != state:
			_state = value
			default_color = _get_state_color()
			material = _get_state_material()
			queue_redraw()
			recalculate_audio()
var _state : GameLogic.State

@export
var theme : Theme = preload("res://summoner_theme.tres")

@export_category("Materials")
@export
var error_material : Material = null

@export
var correct_material : Material = null

@export
var incomplete_material : Material = null

func recalculate_audio() -> void:
	$CorrectAudioPlayer.stop()
	$ErrorAudioPlayer.stop()
	match state:
		GameLogic.State.ERROR:
			$ErrorAudioPlayer.play()
		GameLogic.State.CORRECT:
			$CorrectAudioPlayer.play()
	

func is_valid() -> GameLogic.State:
	return GameLogic.is_connector_valid(self)

func _get_state_color() -> Color:
	match state:
		GameLogic.State.INCOMPLETE:
			return theme.get_color("incomplete_connection", "")
		GameLogic.State.ERROR:
			return theme.get_color("error_connection", "")
		GameLogic.State.CORRECT:
			return theme.get_color("correct_connection", "")
		_:
			return Color.LAWN_GREEN

func _get_state_material() -> Material:
	match state:
		GameLogic.State.INCOMPLETE:
			return incomplete_material
		GameLogic.State.ERROR:
			return error_material
		GameLogic.State.CORRECT:
			return correct_material
		_:
			return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If this doesn't have a line set, make it at runtime.
	if points.size() == 0:
		add_point(end_a.position)
		add_point(end_b.position)
	end_a.add_neighbor(end_b, self)
	end_b.add_neighbor(end_a, self)
	default_color = _get_state_color()
	material = _get_state_material()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state = is_valid()
