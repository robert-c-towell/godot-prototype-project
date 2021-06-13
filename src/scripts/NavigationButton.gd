extends Button

export var navigationPath = ""

func _ready():
	connect("pressed", self, "onButtonPressed")
	
func onButtonPressed():
	if navigationPath != "":
		get_tree().change_scene(navigationPath)
	else:
		get_tree().quit()
