class_name SummoningCircle
extends Control

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
var target_connectors : Array[Vector2i] = []

@export
var initial_placements : Dictionary = {}

@export
var offset_angle : float = 0

@export
var flavor_text : String = ""

var solved : bool = false

var _base_direction: Vector2:
	get:
		return Vector2.UP.rotated(deg_to_rad(offset_angle))

func _ready() -> void:
	var center_offset := Vector2(0.5, 0.5)
	if !flavor_text.is_empty():
		center_offset = Vector2(0.75, 0.5)
		$FlavorContainer.visible = true
		$FlavorContainer/PanelContainer/FlavorLabel.text = flavor_text
	else:
		$FlavorContainer.visible = false
	
	var center := get_viewport_rect().size * center_offset
	var radius := get_viewport_rect().size.y / 3
	
	$BackgroundCircle.position = center
	$BackgroundCircle.radius = radius
	
	var glyph_position := Vector2(100, 100)
	for symbol in glyphs:
		var glyph: DraggableGlyph = DRAGGABLE_GLYPH.instantiate()
		glyph.symbol = symbol
		glyph.position = Vector2(glyph_position)
		$Glyphs.add_child(glyph)
		glyph_position.x += 100
	for i in range(targets):
		var target: DropTarget = DROP_TARGET.instantiate()
		target.name = "DropTarget%d" % i
		var offset: Vector2 = (_base_direction * radius).rotated((TAU / targets) * i)
		target.position = center + offset
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
	for c in target_connectors:
		var connector: TargetConnector = TARGET_CONNECTOR.instantiate()
		connector.end_a = _targets[c.x]
		connector.end_b = _targets[c.y]
		# Does this connector connect adjacent points?
		if abs(c.x - c.y) == 1 || abs(c.x - c.y) == targets -1:
			var offset_a := connector.end_a.position - center
			var offset_b := connector.end_b.position - center

			var angle: float
			if (offset_a + offset_b).is_zero_approx():
				angle = PI
			else:
				angle = offset_a.angle_to(offset_b)

			var angle_step := angle/CURVE_STEPS
			for step in range(0, CURVE_STEPS + 1):
				var theta := angle_step * step
				var offset := offset_a.rotated(theta) + center
				connector.add_point(offset)
		$Connectors.add_child(connector);

func _process(_delta: float) -> void:
	if !solved && _targets.all(
		func(target: DropTarget) -> bool:
			return target.glyph_held && target.is_valid() == GameLogic.State.CORRECT
	):
		solved = true
		for target: DropTarget in _targets:
			target.current_glyph.is_locked = true
		$BackgroundCircle.color = Color.DARK_MAGENTA
		queue_redraw()

func _on_button_pressed() -> void:
	GameShell.return_to_menu()
