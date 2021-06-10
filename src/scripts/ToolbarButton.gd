extends Button

func _ready():
	connect("pressed", self, "buttonPressed")

func buttonPressed():
	print(self.name)
	
	var playerCharacter = get_parent().get_parent().get_parent().playerCharacter
	
	var velocity = Vector3()
	if self.name == "Forward":
		velocity -= playerCharacter.transform.basis.z
	if self.name == "Backward":
		velocity += playerCharacter.transform.basis.z
	if self.name == "Left":
		velocity -= playerCharacter.transform.basis.x
	if self.name == "Right":
		velocity += playerCharacter.transform.basis.x
	playerCharacter.translation += velocity * 2.1
