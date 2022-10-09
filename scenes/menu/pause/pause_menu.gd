extends ColorRect


func pause(do : bool) -> void:
	get_tree().paused = do
	visible = do
