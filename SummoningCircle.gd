class_name SummoningCircle
extends Node2D

const DRAGGABLE_GLYPH = preload("res://draggable_glyph.tscn")
const DROP_TARGET = preload("res://drop_target.tscn")
const TARGET_CONNECTOR = preload("res://target_connector.tscn")

@export
var glyphs : Array[GameLogic.Symbol]

@export
var targets : int

var _targets : Array[DropTarget] = []

@export
var target_connectors : Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var position := Vector2(100, 100)
	
	var center := get_viewport_rect().size / 2
	print("center", center)
	var radius := get_viewport_rect().size.y / 4
	
	for symbol in glyphs:
		var glyph = DRAGGABLE_GLYPH.instantiate()
		glyph.symbol = symbol
		glyph.position = Vector2(position)
		$Glyphs.add_child(glyph)
		position.x += 100
	for i in range(targets):
		var target = DROP_TARGET.instantiate()
		target.name = "DropTarget%d" % i
		var offset = (Vector2.UP * radius).rotated((TAU / targets) * i)
		target.position = center + offset
		$Targets.add_child(target)
		_targets.append(target)
	for c in target_connectors:
		var connector = TARGET_CONNECTOR.instantiate()
		connector.end_a = _targets[c.x]
		connector.end_b = _targets[c.y]
		$Connectors.add_child(connector);
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
