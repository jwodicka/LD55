class_name DropTarget
extends Area2D

var current_glyph : DraggableGlyph = null
var neighbors : Array[DropTarget] = []

func add_neighbor(neighbor : DropTarget) -> void:
	if !neighbors.has(neighbor):
		neighbors.append(neighbor)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	draw_circle(Vector2.ZERO, 50, Color.BEIGE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_glyph != null && current_glyph.is_dragging == false:
		current_glyph.position = position

func _on_area_entered(area: Area2D) -> void:
	if current_glyph == null:
		current_glyph = area
		print("Claimed ", area)

func _on_area_exited(area: Area2D) -> void:
	if current_glyph == area:
		current_glyph = null;
		print("Released ", area)
