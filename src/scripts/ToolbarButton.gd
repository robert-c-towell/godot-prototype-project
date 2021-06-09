extends Button

func _ready():
	connect("pressed", self, "buttonPressed")

func buttonPressed():
	print(self.name)
	
	var playerCharacter = get_parent().get_parent().get_parent().playerCharacter
	
	if self.name == "Left":
		playerCharacter.x -= 100
	if self.name == "Right":
		playerCharacter.x += 100
	if self.name == "Forward":
		playerCharacter.z -= 100
	if self.name == "Backward":
		playerCharacter.z += 100
