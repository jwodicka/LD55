class_name DropTarget
extends Area2D

@export
var color : Color:
	get:
		return _color
	set(value):
		if value != _color:
			_color = value
			$Sprite2D.material.set_shader_parameter("shade_color", _color)
	
var _color := Color.WHITE

var current_glyph : DraggableGlyph = null
var glyph_held : bool:
	get:
		return _glyph_held
	set(value):
		if _glyph_held != value:
			if value == true:
				$AudioStreamPlayer.play()
			_glyph_held = value
var _glyph_held : bool

func check_if_glyph_held() -> void:
	if current_glyph == null:
		glyph_held = false
	elif current_glyph.is_dragging:
		glyph_held = false
	else:
		glyph_held = true
	
var neighbors : Dictionary = {}

func add_neighbor(neighbor : DropTarget, connector : TargetConnector) -> void:
	if !neighbors.has(neighbor):
		neighbors[neighbor] = connector
		
func _queue_redraw_neighborhood() -> void:
	queue_redraw()
	for neighbor: DropTarget in neighbors.keys():
		neighbor.queue_redraw()
	
func _get_state_color() -> Color:
	match is_valid():
		GameLogic.State.INCOMPLETE:
			return Color.GRAY
		GameLogic.State.ERROR:
			return Color.FUCHSIA
		GameLogic.State.CORRECT:
			return Color.AQUAMARINE
		_:
			return Color.LAWN_GREEN

func is_valid() -> GameLogic.State:
	return GameLogic.is_target_valid(self)

func _process(_delta: float) -> void:
	check_if_glyph_held()
	if glyph_held:
		current_glyph.position = position
	color = _get_state_color()

func _on_area_entered(area: Area2D) -> void:
	if current_glyph == null:
		current_glyph = area
		_queue_redraw_neighborhood()

func _on_area_exited(area: Area2D) -> void:
	if current_glyph == area:
		current_glyph = null;
		_queue_redraw_neighborhood()
