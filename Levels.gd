class_name Levels

const Symbol = GameLogic.Symbol
const EARTH = Symbol.EARTH
const AIR = Symbol.AIR
const FIRE = Symbol.FIRE
const WATER = Symbol.WATER
const SALT = Symbol.SALT

const levels: Dictionary = {
    "Lesson 1": {
        flavor_text = """It's time for your first summoning!
        
All you need to do is place the glyphs in the empty spaces within the summoning circle.

That's all there is to it!""",
        victory_text = """You did it!

If this had been a real summoning, you'd have just unleashed a horrifying
monster onto an unsuspecting world.

Go you!""",
        glyphs = [FIRE],
        targets = 2,
        target_connectors = [Vector2i(0, 1), Vector2i(1,0)],
        initial_placements = {0: FIRE},
        locked_targets = [0],
        offset_angle = -90,
        next_level = "Lesson 2"
    },
    "Lesson 2": {
        flavor_text = """It's not always that easy.

Some glyphs don't like having certain other glyphs as neighbors. They'll make the summoning circle UNSTABLE if you put them together.""",
        victory_text = """Another success!

According to our research, unstable links have less than a 3% chance of summoning an eldritch entity that will eat the world, so don't worry too much about the occasional error.""",
        glyphs = [FIRE, FIRE],
        targets = 2,
        target_connectors = [Vector2i(0, 1), Vector2i(1, 0)],
        initial_placements = {0: WATER},
        offset_angle = -90,
        next_level = "Lesson 3"
    },
    "Lesson 3": {
		flavor_text = """Not every glyph cares about exactly
which other glyphs it connects to.

Some glyphs just need their entire set of neighbors to satisfy some condition.""",
        victory_text = """You've got the hang of it!

This is a traditional circle for apprentices to learn. In a proper setting, you can use this circle to bind small pests, including stinging insects, seagulls, and many social media commenters!""",
        glyphs = [AIR, AIR, EARTH, EARTH, SALT, SALT],
        targets = 6,
        target_connectors = [
            Vector2i(0, 1),
            Vector2i(1, 2),
            Vector2i(2, 3),
            Vector2i(3, 4),
            Vector2i(4, 5),
            Vector2i(5, 0),
            Vector2i(2, 4)
        ],
        next_level = "Lesson 4"
    },
    "Lesson 4": {
        flavor_text = """To ensure proper casting, some summoning circles have one or more glyphs permanently placed.""",
        victory_text = """You're a natural!

This circle was discovered by Alfred Zinzer in 1729, and is widely studied for its ability to call up torrential storms. Mr. Zinzer was posthumously awarded the highest honors by the Summoners' Guild after a thorough search of the rubble from his lab.""",
        glyphs = [SALT, SALT, AIR, EARTH],
        targets = 5,
        target_connectors = [
            Vector2i(0, 2),
            Vector2i(1, 3),
            Vector2i(2, 4),
            Vector2i(3, 0),
            Vector2i(4, 1),
            Vector2i(2, 3)
        ],
        initial_placements = {3: WATER},
        locked_targets = [3],
        next_level = "Lesson 5"
    },
    "Lesson 5": {
        flavor_text = """Did you know?
        
There are more than 47 million incorrect configurations to summon an archdemon, and only one correct one!""",
        victory_text = """This circle, making use of all five basic elements, is capable of summoning most inert substances!

Unrelatedly, you should be aware that most summoned materials have a strong likelihood of being toxic, so it's a bad idea to try to summon drinks to save a few coins at the pub.""",
        glyphs = [EARTH, AIR, WATER, SALT, FIRE],
        targets = 6,
        target_connectors = [
            Vector2i(0, 2),
            Vector2i(2, 4),
            Vector2i(4, 0),
            Vector2i(1, 3),
            Vector2i(3, 5),
            Vector2i(5, 1),
            Vector2i(1, 2),
            Vector2i(2, 3),
            Vector2i(3, 4)
        ],
        offset_angle = 30,
        initial_placements = {4: FIRE},
        locked_targets = [4],
        next_level = "Lesson 6"
    },
    "Lesson 6": {
        flavor_text = """This circle is infamous for its use in the stage magic scandals of the 1890s. Notwithstanding that, it's still an excellent practice exercise.""",
        victory_text = """Remember, just because you CAN summon a demon that looks like a giant rabbit, doesn't mean you SHOULD.""",
        glyphs = [WATER, EARTH, SALT, SALT, SALT, AIR],
        targets = 7,
        target_connectors = [
            Vector2i(0, 2),
            Vector2i(0, 3),
            Vector2i(0, 4),
            Vector2i(0, 5),
            Vector2i(1, 2),
            Vector2i(1, 3),
            Vector2i(1, 6),
            Vector2i(2, 5),
            Vector2i(5, 6),
            Vector2i(4, 6),
            Vector2i(5, 0)
        ],
        initial_placements = {5: WATER},
        locked_targets = [5]
    }
}

		

		