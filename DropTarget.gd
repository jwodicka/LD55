class_name DropTarget
extends Area2D

var current_glyph : DraggableGlyph = null
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
	if current_glyph == null:
		return GameLogic.State.INCOMPLETE
	match current_glyph.symbol:
		GameLogic.Symbol.SALT:
			if neighbors.keys().any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == GameLogic.Symbol.SALT
			):
				return GameLogic.State.ERROR
			else:
				return GameLogic.State.CORRECT
		GameLogic.Symbol.WATER:
			if neighbors.keys().any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == GameLogic.Symbol.FIRE
			):
				return GameLogic.State.ERROR
			else:
				return GameLogic.State.CORRECT
		GameLogic.Symbol.FIRE:
			if neighbors.keys().any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == GameLogic.Symbol.WATER
			):
				return GameLogic.State.ERROR
			else:
				return GameLogic.State.CORRECT
		_:
			return GameLogic.State.INCOMPLETE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	draw_circle(Vector2.ZERO, 60, _get_state_color())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_glyph != null && current_glyph.is_dragging == false:
		current_glyph.position = position

func _on_area_entered(area: Area2D) -> void:
	if current_glyph == null:
		current_glyph = area
		$AudioStreamPlayer.play()
		_queue_redraw_neighborhood()
		#print("Claimed ", area)

func _on_area_exited(area: Area2D) -> void:
	if current_glyph == area:
		current_glyph = null;
		_queue_redraw_neighborhood()
		#print("Released ", area)
