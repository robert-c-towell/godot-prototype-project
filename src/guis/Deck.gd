extends TextureButton

var deckSize

func _pressed():
	deckSize = get_parent().get_parent().get_parent().drawCard()
	
	if deckSize <= 0:
		empty()

func empty():
	self.mouse_filter = MOUSE_FILTER_IGNORE
	self.disabled = true
