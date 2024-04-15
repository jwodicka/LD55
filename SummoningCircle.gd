class_name SummoningCircle
extends Control

const DRAGGABLE_GLYPH = preload("res://draggable_glyph.tscn")
const DROP_TARGET = preload("res://drop_target.tscn")
const TARGET_CONNECTOR = preload("res://target_connector.tscn")

const CURVE_STEPS = 20

signal puzzle_solved

@export
var radius : float = 200

@export
var glyphs : Array[GameLogic.Symbol]

@export
var targets : int

var _targets : Array[DropTarget] = []

@export
var target_connectors : Array[Vector2i] = []

@export
var initial_placements : Dictionary = {}

@export
var locked_targets : Array[int] = []

@export
var offset_angle : float = 0

var solved : bool = false

var center: Vector2:
	get:
		return get_rect().size / 2.0

var _base_direction: Vector2:
	get:
		return Vector2.UP.rotated(deg_to_rad(offset_angle))

func _ready() -> void:
	$BackgroundCircle.position = center
	$BackgroundCircle.radius = radius
	
	glyphs.shuffle()
	for i in range(glyphs.size()):
		var symbol := glyphs[i]
		var glyph: DraggableGlyph = DRAGGABLE_GLYPH.instantiate()
		glyph.symbol = symbol
		var offset: Vector2 = (Vector2.UP * (radius + 110)).rotated((TAU / glyphs.size()) * i)
		glyph.position = offset
		$Glyphs.add_child(glyph)
	for i in range(targets):
		var target: DropTarget = DROP_TARGET.instantiate()
		target.name = "DropTarget%d" % i
		var offset: Vector2 = (_base_direction * radius).rotated((TAU / targets) * i)
		target.position = offset
		$Targets.add_child(target)
		_targets.append(target)
		if initial_placements.has(i):
			var glyph: DraggableGlyph = DRAGGABLE_GLYPH.instantiate()
			glyph.symbol = initial_placements[i]
			glyph.position = Vector2(target.position)
			target.current_glyph = glyph
			# We bypass the setter to avoid the audio cue
			target._glyph_held = true
			$Glyphs.add_child(glyph)
			if locked_targets.has(i):
				glyph.is_locked = true;
	for c in target_connectors:
		var connector: TargetConnector = TARGET_CONNECTOR.instantiate()
		connector.end_a = _targets[c.x]
		connector.end_b = _targets[c.y]
		# Does this connector connect adjacent points?
		if abs(c.x - c.y) == 1 || abs(c.x - c.y) == targets -1:
			var offset_a := connector.end_a.position
			var offset_b := connector.end_b.position

			var angle: float
			if (offset_a + offset_b).is_zero_approx():
				print("direct pair") # BUG: This isn't happening
				angle = PI
			else:
				angle = offset_a.angle_to(offset_b)

			var angle_step := angle/CURVE_STEPS
			for step in range(0, CURVE_STEPS + 1):
				var theta := angle_step * step
				var offset := offset_a.rotated(theta)
				connector.add_point(offset)
		$Connectors.add_child(connector);

func _process(_delta: float) -> void:
	if !solved && _targets.all(
		func(target: DropTarget) -> bool:
			return target.glyph_held && target.is_valid() == GameLogic.State.CORRECT
	):
		solved = true
		on_victory()

func on_victory() -> void:
	for target: DropTarget in _targets:
		target.current_glyph.is_locked = true
	$BackgroundCircle.color = Color.BLACK
	$BackgroundCircle/GPUParticles2D.emitting = true
	puzzle_solved.emit()
	queue_redraw()


func _on_resized() -> void:
	print("on_resized")
	print("rect", get_rect())
	print("c", center)
	$Glyphs.transform = get_transform().translated(center)
	$Targets.transform = get_transform().translated(center)
	$Connectors.transform = get_transform().translated(center)
	$BackgroundCircle.position = center
	queue_redraw()
