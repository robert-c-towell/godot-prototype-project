extends Spatial

var showInGameMenu = false

func _ready():
	$GUI/Toolbar.link_toolbar($Scene/Robot1)
	$GUI/CardManager.playerCharacter = $Scene/PlayerCharacter

func _process(_delta):
	get_input_keyboard()
	
func get_input_keyboard():
	if Input.is_action_just_released("exit"):
		showInGameMenu = !showInGameMenu
		if showInGameMenu:
			$GUI/InGameMenu.visible = true
			$CameraController._lockMovement()
		else:
			$GUI/InGameMenu.visible = false
			$CameraController._unlockMovement()
