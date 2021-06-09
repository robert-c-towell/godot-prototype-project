extends Spatial

func _process(_delta):
	get_input_keyboard()
	
func get_input_keyboard():
	if Input.is_action_pressed("exit"):
		get_tree().quit()
