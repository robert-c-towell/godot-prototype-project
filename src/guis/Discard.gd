extends TextureButton

var discardPileSize = 0

func _pressed():
	discardPileSize = get_parent().get_parent().get_parent().showDiscardPile()
	
	if discardPileSize <= 0:
		self.mouse_filter = MOUSE_FILTER_IGNORE
		self.disabled = true
