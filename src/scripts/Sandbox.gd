extends Spatial

func _ready():
	$GUI/Toolbar.link_toolbar($Scene/Robot1)

func _process(_delta):
	get_input_keyboard()
	
func get_input_keyboard():
	if Input.is_action_pressed("exit"):
		get_tree().change_scene("res://src/guis/MainMenu.tscn")
