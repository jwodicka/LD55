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
	var locked_targets : Array[int] = []
	
	var level_def: Dictionary = Levels.levels[level_name]
	if "glyphs" in level_def:
		glyphs.assign(level_def.glyphs)
	if "targets" in level_def:
		targets = level_def.targets
	if "target_connectors" in level_def:
		target_connectors.assign(level_def.target_connectors)
	if "offset_angle" in level_def:
		offset_angle = level_def.offset_angle
	if "flavor_text" in level_def:
		flavor_text = level_def.flavor_text
	if "initial_placements" in level_def:
		initial_placements = level_def.initial_placements
	if "locked_targets" in level_def:
		locked_targets.assign(level_def.locked_targets)

	var level: SummoningCircle = SUMMONING_CIRCLE_SCENE.instantiate() as SummoningCircle
	level.glyphs = glyphs
	level.targets = targets
	level.target_connectors = target_connectors
	level.offset_angle = offset_angle
	level.flavor_text = flavor_text
	level.initial_placements = initial_placements
	level.locked_targets = locked_targets
	return level

static func has_glyph(target: DropTarget) -> bool:
	return target.current_glyph != null

# Only call this on targets that are known to have a current_glyph!
static func get_glyph(target: DropTarget) -> Symbol:
	return target.current_glyph.symbol
	
static func count_symbols(symbols: Array) -> Dictionary:
	return symbols as Array[Symbol].reduce(
		func(acc: Dictionary, val: Symbol):
			if !acc.has(val):
				acc[val] = 0
			acc[val] += 1
			return acc,
		{}
	)

static func is_connector_valid(link: TargetConnector) -> State:
	var end_a: DropTarget = link.end_a
	var end_b: DropTarget = link.end_b

	if (end_a.current_glyph == null) || (end_b.current_glyph == null):
		return INCOMPLETE
	var glyph_a: Symbol = end_a.current_glyph.symbol
	var glyph_b: Symbol = end_b.current_glyph.symbol

	# Simple adjacencies
	if glyph_a == SALT && glyph_b == SALT:
		return ERROR
	if  (glyph_a == FIRE && glyph_b == WATER) || \
		(glyph_b == FIRE && glyph_a == WATER):
		return ERROR
	
	# Group adjacencies
	# If Earth is invalid, it's unhappy with all its
	# neighbors. (They all need to match)
	if glyph_a == EARTH && end_a.is_valid() == ERROR:
		return ERROR
	if glyph_b == EARTH && end_b.is_valid() == ERROR:
		return ERROR

	# If Air is invalid, it's unhappy with any matching
	# neighbors
	if glyph_a == AIR && end_a.is_valid() == ERROR:
		var adjacents = adjacent_glyphs(end_a)
		var a_counts = count_symbols(adjacents)
		if a_counts[glyph_b] > 1:
			return ERROR
	if glyph_b == AIR && end_b.is_valid() == ERROR:
		var adjacents = adjacent_glyphs(end_b)
		var b_counts = count_symbols(adjacents)
		if b_counts[glyph_a] > 1:
			return ERROR

	return CORRECT

static func adjacent_glyphs(target: DropTarget):
	return target.neighbors.keys().filter(GameLogic.has_glyph).map(GameLogic.get_glyph)

static func is_target_valid(target: DropTarget) -> State:
	var current_glyph := target.current_glyph
	var neighborhood := target.neighbors.keys()
	var adjacent_glyphs = neighborhood.filter(GameLogic.has_glyph).map(GameLogic.get_glyph)
	
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
