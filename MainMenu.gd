extends Control

func _on_level_select(level_name: String) -> void:
	var level: Node = GameLogic.load_level(level_name)
	get_tree().root.add_child(level)
	get_tree().root.remove_child(self)
	self.queue_free()
