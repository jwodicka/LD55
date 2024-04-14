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
	
static func count_symbols(symbols: Array[Symbol]) -> Dictionary:
	return symbols.reduce(
		func(acc: Dictionary, val: Symbol):
			if !acc.has(val):
				acc[val] = 0
			acc[val] += 1
			return acc,
		{}
	)

static func is_target_valid(target: DropTarget) -> GameLogic.State:
	var current_glyph := target.current_glyph
	var neighborhood := target.neighbors.keys()
	var adjacent_glyphs := neighborhood.filter(GameLogic.has_glyph).map(GameLogic.get_glyph)
	
	if current_glyph == null:
		return INCOMPLETE
	match current_glyph.symbol:
		SALT:
			if adjacent_glyphs.has(SALT):
				return ERROR
			else:
				return CORRECT
		WATER:
			if adjacent_glyphs.has(FIRE):
				return ERROR
			else:
				return CORRECT
		FIRE:
			if adjacent_glyphs.has(WATER):
				return ERROR
			else:
				return CORRECT
		AIR:
			if count_symbols(adjacent_glyphs).values().all(func (i: int): return i == 1):
				return CORRECT
			else:
				return ERROR
		EARTH:
			if count_symbols(adjacent_glyphs).keys().size() > 1:
				return ERROR
			else:
				return CORRECT
		_:
			return INCOMPLETE
