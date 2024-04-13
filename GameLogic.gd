class_name GameLogic

const SUMMONING_CIRCLE_SCENE = preload("res://summoning_circle.tscn")

enum Symbol {EARTH, AIR, FIRE, WATER, SALT}
enum State {INCOMPLETE, ERROR, CORRECT}

static func load_level(level_name: String) -> SummoningCircle:
	
	var glyphs : Array[Symbol] = []
	var targets : int = 1
	var target_connectors : Array[Vector2i] = []
	var offset_angle : float = 0
	var flavor_text : String = ""
	match level_name:
		"Level 1":
			glyphs = [Symbol.FIRE]
			flavor_text = """It's time for your first summoning!
			
			All you need to do is place the glyph in the
			empty space within the summoning circle."""
		"Level 2":
			glyphs = [Symbol.FIRE, Symbol.WATER, Symbol.FIRE]
			targets = 2
			target_connectors = [Vector2i(0, 1)]
			offset_angle = -90
	var level: SummoningCircle = SUMMONING_CIRCLE_SCENE.instantiate() as SummoningCircle
	level.glyphs = glyphs
	level.targets = targets
	level.target_connectors = target_connectors
	level.offset_angle = offset_angle
	level.flavor_text = flavor_text
	return level
		
