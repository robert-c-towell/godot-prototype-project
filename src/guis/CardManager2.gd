extends Control

const CardBase = preload("res://assets/cards/CardBase.tscn")
const CardStates = preload("res://assets/cards/CardStates.gd")
const CardTypes = preload("res://assets/cards/cardEnums.gd")
onready var Hand = $Hand

var deck = ["forward","backward","forward","left","left","right","right","forward"]
var discard = []




var playerCharacter

func cardClicked(card: Node):
	match card.cardName:
		"forward", "backward":
			playerCharacter.moveRobot(card.cardName, card.selectedOption)
		"left", "right":
			playerCharacter.rotateRobot(card.cardName)

func drawCard():
	if (deck.size() > 0):
		var newCard = CardBase.instance()
		newCard.cardName = deck.pop_front()
		newCard.startingPosition = $Spacer/Control/TextureButton.rect_global_position - (newCard.cardSize / 4)
		$Hand.addCard(newCard)
	return deck.size()

func discardCard(card: Node):
	pass
