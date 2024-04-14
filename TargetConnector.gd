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
			queue_redraw()
			recalculate_audio()
var _state : GameLogic.State

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
			return Color.GRAY
		GameLogic.State.ERROR:
			return Color.FUCHSIA
		GameLogic.State.CORRECT:
			return Color.AQUAMARINE
		_:
			return Color.LAWN_GREEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If this doesn't have a line set, make it at runtime.
	if points.size() == 0:
		add_point(end_a.position)
		add_point(end_b.position)
	end_a.add_neighbor(end_b, self)
	end_b.add_neighbor(end_a, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state = is_valid()
