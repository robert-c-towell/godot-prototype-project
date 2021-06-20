extends Control

const CardBase = preload("res://assets/cards/CardBase.tscn")
const CardStates = preload("res://assets/cards/CardStates.gd")
const CardTypes = preload("res://assets/cards/cardEnums.gd")
onready var Hand = $Hand

var deck = ["forward","backward","forward","left","left","right","right","forward"]
var discardPile = []




var playerCharacter

func _ready():
	var initialWait = 1
	yield(get_tree().create_timer(initialWait), "timeout")
	for n in 5:
		drawCard()
		var drawWait = 0.25
		yield(get_tree().create_timer(drawWait), "timeout")

func cardClicked(card: Node):
	match card.cardName:
		"forward", "backward":
			playerCharacter.moveRobot(card.cardName, card.selectedOption)
		"left", "right":
			playerCharacter.rotateRobot(card.cardName)
	discardCard(card)

func showDiscardPile():
	return 0
	pass

func drawCard():
	if (deck.size() > 0):
		var newCard = CardBase.instance()
		newCard.cardName = deck.pop_front()
		newCard.startingPosition = $DeckSpacer/Control/TextureButton.rect_global_position - (newCard.cardSize / 4)
		$Hand.addCard(newCard)
	else:
		$DeckSpacer/Control/TextureButton.empty()
	return deck.size()

func discardCard(card: Node):
	card.targetPosition = $DiscardSpacer/Control/TextureButton.rect_global_position - (card.cardSize / 4)
	$Hand.removeCard(card)
	
	discardPile.push_front(card.cardName)
	return discardPile.size()
