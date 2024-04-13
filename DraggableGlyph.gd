class_name DraggableGlyph
extends Area2D

enum Symbol {EARTH, AIR, FIRE, WATER, SALT}

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

@export
var symbol : Symbol

func _get_symbol_color() -> Color:
	match symbol:
		Symbol.EARTH:
			return Color.SADDLE_BROWN
		Symbol.AIR:
			return Color.DARK_TURQUOISE
		Symbol.FIRE:
			return Color.DARK_RED
		Symbol.WATER:
			return Color.AQUA
		Symbol.SALT:
			return Color.BEIGE
		_:
			return Color.LAWN_GREEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2.ZERO, 50, _get_symbol_color())
	
func begin_drag():
	is_dragging = true;
	drag_offset = get_global_mouse_position() - position
	
	
func end_drag():
	if is_dragging:
		is_dragging = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				begin_drag()
			else:
				end_drag()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dragging:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position = get_global_mouse_position() - drag_offset
	else:
		end_drag()
