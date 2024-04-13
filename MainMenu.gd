extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const LEVELS: Dictionary = {}

func _on_level_select(level_name: String) -> void:
	var level = GameLogic.load_level(level_name)
	get_tree().root.add_child(level)
	get_tree().root.remove_child(self)
	self.queue_free()
