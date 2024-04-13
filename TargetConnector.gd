extends Line2D

@export
var end_a : DropTarget
@export
var end_b : DropTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If this doesn't have a line set, make it at runtime.
	if points.size() == 0:
		add_point(end_a.position)
		add_point(end_b.position)
	end_a.add_neighbor(end_b)
	end_b.add_neighbor(end_a)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
