extends Control

func _ready():
	#link_toolbar()
	pass
	
func link_toolbar():
	var playerCharacter = get_node("root/Main/Scene/Robot1")
	var toolbar = find_node("Toolbar").init(playerCharacter)
