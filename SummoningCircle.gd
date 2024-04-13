class_name SummoningCircle
extends Node2D

const DRAGGABLE_GLYPH = preload("res://draggable_glyph.tscn")
const DROP_TARGET = preload("res://drop_target.tscn")
const TARGET_CONNECTOR = preload("res://target_connector.tscn")

const CURVE_STEPS = 20

@export
var glyphs : Array[GameLogic.Symbol]

@export
var targets : int

var _targets : Array[DropTarget] = []

@export
var target_connectors : Array[Vector2i]

@export
var offset_angle : float = 0

var _base_direction: Vector2:
	get:
		return Vector2.UP.rotated(deg_to_rad(offset_angle))
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var position := Vector2(100, 100)
	
	var center := get_viewport_rect().size / 2
	var radius := get_viewport_rect().size.y / 3
	
	$BackgroundCircle.position = center
	$BackgroundCircle.radius = radius
	
	for symbol in glyphs:
		var glyph = DRAGGABLE_GLYPH.instantiate()
		glyph.symbol = symbol
		glyph.position = Vector2(position)
		$Glyphs.add_child(glyph)
		position.x += 100
	for i in range(targets):
		var target = DROP_TARGET.instantiate()
		target.name = "DropTarget%d" % i
		var offset = (_base_direction * radius).rotated((TAU / targets) * i)
		target.position = center + offset
		$Targets.add_child(target)
		_targets.append(target)
	for c in target_connectors:
		var connector = TARGET_CONNECTOR.instantiate()
		connector.end_a = _targets[c.x]
		connector.end_b = _targets[c.y]
		# Does this connector connect adjacent points?
		if abs(c.x - c.y) == 1 || abs(c.x - c.y) == targets -1:
			print("Adjacent points")
			var offset_a = connector.end_a.position - center
			var offset_b = connector.end_b.position - center
			var angle = offset_a.angle_to(offset_b)
			var angle_step = angle/CURVE_STEPS
			for step in range(0, CURVE_STEPS + 1):
				var theta = angle_step * step
				var offset = offset_a.rotated(theta) + center
				connector.add_point(offset)
		$Connectors.add_child(connector);
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
