extends Button

func _ready():
	connect("pressed", self, "buttonPressed")

func buttonPressed():
	print(self.name)
