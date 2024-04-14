class_name GameLogic

const SUMMONING_CIRCLE_SCENE = preload("res://summoning_circle.tscn")

enum Symbol {EARTH, AIR, FIRE, WATER, SALT}
const EARTH = Symbol.EARTH
const AIR = Symbol.AIR
const FIRE = Symbol.FIRE
const WATER = Symbol.WATER
const SALT = Symbol.SALT

enum State {INCOMPLETE, ERROR, CORRECT}
const INCOMPLETE = State.INCOMPLETE
const ERROR = State.ERROR
const CORRECT = State.CORRECT

static func load_level(level_name: String) -> SummoningCircle:
	var glyphs : Array[Symbol] = []
	var targets : int = 1
	var target_connectors : Array[Vector2i] = []
	var offset_angle : float = 0
	var flavor_text : String = ""
	var initial_placements : Dictionary = {} # Maps target number to glyph symbol
	match level_name:
		"Level 1":
			flavor_text = """It's time for your first summoning!
			
			All you need to do is place the glyphs in the
			empty spaces within the summoning circle.
			
			That's all there is to it!"""
			glyphs = [Symbol.FIRE]
			targets = 2
			target_connectors = [Vector2i(0, 1)]
			initial_placements = {0: Symbol.FIRE}
			offset_angle = -90
		"Level 2":
			flavor_text = """It's not always that easy.
			
			Some glyphs don't like having certain other 
			glyphs as neighbors. They'll make the summoning
			circle UNSTABLE if you put them together."""
			glyphs = [Symbol.FIRE, Symbol.FIRE]
			targets = 2
			target_connectors = [Vector2i(0, 1)]
			initial_placements = {0: Symbol.WATER}
			offset_angle = -90
	var level: SummoningCircle = SUMMONING_CIRCLE_SCENE.instantiate() as SummoningCircle
	level.glyphs = glyphs
	level.targets = targets
	level.target_connectors = target_connectors
	level.offset_angle = offset_angle
	level.flavor_text = flavor_text
	level.initial_placements = initial_placements
	return level

static func has_glyph(target: DropTarget) -> bool:
	return target.current_glyph != null

# Only call this on targets that are known to have a current_glyph!
static func get_glyph(target: DropTarget) -> Symbol:
	return target.current_glyph.symbol

static func is_target_valid(target: DropTarget) -> GameLogic.State:
	var current_glyph := target.current_glyph
	var neighborhood := target.neighbors.keys()
	#var adjacent_glyphs := target.neighbors.keys().filter(has_glyph) #.map(get_glyph)
	
	#print(adjacent_glyphs)
	
	if current_glyph == null:
		return INCOMPLETE
	match current_glyph.symbol:
		SALT:
			if neighborhood.any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == SALT
			):
				return ERROR
			else:
				return CORRECT
		WATER:
			if neighborhood.any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == FIRE
			):
				return ERROR
			else:
				return CORRECT
		FIRE:
			if neighborhood.any(
				func (target: DropTarget) -> bool:
					return target.current_glyph != null && target.current_glyph.symbol == WATER
			):
				return ERROR
			else:
				return CORRECT
		AIR:
			return INCOMPLETE
		_:
			return INCOMPLETE
