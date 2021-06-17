extends Control

const deck = ["forward","backward","forward","left","left","right","right","forward"]

const CardBase = preload("res://assets/cards/CardBase.tscn")
const CardStates = preload("res://assets/cards/CardStates.gd")
const CardTypes = preload("res://assets/cards/cardEnums.gd")

var playerCharacter

onready var cardArcCenter = get_viewport().size * Vector2(0.5, 1.275)
onready var horizontalRadius = get_viewport().size.x*0.45
onready var verticalRadius = get_viewport().size.y*0.325
var angle = deg2rad(90)
var cardSpread = 0.15
var arcAngleVector = Vector2()

func _ready():
	pass

func drawCard():	
	var newCard = CardBase.instance()
	newCard.cardName = deck.pop_front()
	prepareCard(newCard,  $Hand.get_child_count(), CardStates.DrawingCard, $Spacer/Control/TextureButton.rect_global_position - Vector2(125/4,175/4), 0)
	
	var i = 0
	for card in $Hand.get_children():
		prepareCard(card, i, CardStates.ReorganizeHand, card.rect_position, card.rect_rotation)
		i += 1
	$Hand.add_child(newCard)
	
	return deck.size()

func prepareCard(card: Node, cardNumber, state, startingPosition, startingRotation):
	angle = PI/2 + cardSpread * (float($Hand.get_child_count())/2 - cardNumber)
	arcAngleVector = Vector2(horizontalRadius * cos(angle), -verticalRadius * sin(angle))
	card.startingPosition = startingPosition
	card.targetPosition = cardArcCenter + arcAngleVector - card.rect_size/2
	card.defaultPosition = card.targetPosition
	card.startingRotation = startingRotation
	card.targetRotation = (90 - rad2deg(angle)) / 4
	
	if !card.state:
		card.state = state
		card.startingPosition = startingPosition
	elif card.state == CardStates.InHand:
		card.state = CardStates.ReorganizeHand
		card.startingPosition = startingPosition
	elif card.state == CardStates.DrawingCard:
		card.startingPosition = card.targetPosition - ((card.targetPosition - card.rect_position)/(1-card.t))
		
func cardClicked(card: Node):
	match card.cardName:
		"forward", "backward":
			playerCharacter.moveRobot(card.cardName, 1)
		"left", "right":
			playerCharacter.rotateRobot(card.cardName)
