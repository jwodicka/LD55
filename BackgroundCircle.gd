extends Node2D

@export
var color : Color:
	get:
		return _color
	set (value):
		_color = value
		queue_redraw()
var _color : Color

@export
var radius : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
