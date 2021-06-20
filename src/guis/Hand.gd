extends Control

const CardBase = preload("res://assets/cards/CardBase.tscn")
const CardStates = preload("res://assets/cards/CardStates.gd")
const CardTypes = preload("res://assets/cards/cardEnums.gd")

onready var cardArcCenter = get_viewport().size * Vector2(0.5, 1.275)
onready var horizontalRadius = get_viewport().size.x*0.45
onready var verticalRadius = get_viewport().size.y*0.325
var cardSpread = 0.175
var arcAngleVector = Vector2()

const DRAWTIME = 0.5
const REORGANIZETIME = 0.4
const FOCUSTIME = 0.25

var cardInFocusNumber = -1
var cardDiscarded = false

func addCard(card: Node):
	self.add_child(card)
	card.cardNumber = self.get_child_count()
	card.startingRotation = 0
	
	var angle = PI/2 + cardSpread * (float(self.get_child_count()+1)/2 - card.cardNumber)
	arcAngleVector = Vector2(horizontalRadius * cos(angle), -verticalRadius * sin(angle))
	card.targetRotation = (90 - rad2deg(angle)) / 4
	card.targetPosition = cardArcCenter + arcAngleVector - card.rect_size/2
	card.defaultPosition = card.targetPosition
	
	card.state = CardStates.DrawingCard

func removeCard(card: Node):
	card.targetRotation = 0
	card.state = CardStates.DiscardingCard

func _physics_process(delta):
	reorganizeCards(delta)

func reorganizeCards(delta):
	var Cards = self.get_children()
	
	var renumberCards = false
	if cardDiscarded:
		cardDiscarded = false
		renumberCards = true
	
	var count = 1
	for card in Cards:
		if renumberCards:
			card.cardNumber = count
			count += 1
		match card.state:
			CardStates.DrawingCard:
				if card.t <= 1:
					card.rect_position = card.startingPosition.linear_interpolate(card.targetPosition, card.t)
					card.rect_rotation = card.startingRotation * (1-card.t) + card.targetRotation*card.t
					card.rect_scale.x = card.originalScale.x * abs(2*card.t - 1)
					if card.get_child(0).get_node("Back").visible:
						if card.t >= 0.5:
							card.get_child(0).get_node("Back").visible = false
							card.get_child(0).get_node("Front").visible = true
							card.get_child(0).get_node("VBoxContainer").visible = true
					card.t += delta / float(DRAWTIME)
				else:
					card.rect_position = card.targetPosition
					card.rect_rotation = card.targetRotation
					card.rect_scale = card.originalScale
					card.t = 0
					card.state = CardStates.ReorganizeHand

			CardStates.DiscardingCard:
				if card.t <= 1:
					card.rect_position = card.startingPosition.linear_interpolate(card.targetPosition, card.t)
					card.rect_rotation = card.startingRotation * (1-card.t) + card.targetRotation*card.t
					card.rect_scale = card.startingScale * (1-card.t) + card.originalScale*card.t
					card.t += delta
				else:
					card.rect_position = card.targetPosition
					card.rect_rotation = card.targetRotation
					card.rect_scale = card.originalScale
					get_parent().get_node("DiscardSpacer/Control/Discard").add_child(card)
					self.remove_child(card)
					cardDiscarded = true
					cardInFocusNumber = -1

			CardStates.InFocus:
				cardInFocusNumber = card.cardNumber
				if card.setup:
					physicsSetup(card)
				if card.t >= 0.5:
					card.get_child(0).z_index = 999
				if card.t <= 1:
					card.rect_position = card.startingPosition.linear_interpolate(card.targetPosition, card.t)
					card.rect_rotation = card.startingRotation * (1-card.t)
					card.rect_scale = card.startingScale * (1-card.t) + card.zoomSize*card.originalScale*card.t
					card.t += delta / float(FOCUSTIME)
				else:
					card.rect_position = card.targetPosition
					card.rect_rotation = 0
					card.rect_scale = card.zoomSize*card.originalScale
			CardStates.ExitFocus:
				cardInFocusNumber = -1
				card.state = CardStates.ReorganizeHand

			CardStates.ReorganizeHand:
				card.get_child(0).z_index = 0
				if card.setup:
					physicsSetup(card)
				if card.t <= 1:
					if card.moveCard:
						card.moveCard = false
					var angle = PI/2 + cardSpread * (float(self.get_child_count()+1)/2 - card.cardNumber)
					arcAngleVector = Vector2(horizontalRadius * cos(angle), -verticalRadius * sin(angle))
					card.targetRotation = (90 - rad2deg(angle)) / 4
					if cardInFocusNumber >= 0:
						card.targetPosition = cardArcCenter + arcAngleVector - card.rect_size/2
						if card.cardNumber < cardInFocusNumber:
							card.targetPosition.x -= card.cardSize.x / (cardInFocusNumber - card.cardNumber + 0.75)
						else:
							card.targetPosition.x += card.cardSize.x / (card.cardNumber - cardInFocusNumber + 0.75)
					else:
						card.targetPosition = cardArcCenter + arcAngleVector - card.rect_size/2
					card.defaultPosition = card.targetPosition
						
					card.rect_position = card.startingPosition.linear_interpolate(card.targetPosition, card.t)
					card.rect_rotation = card.startingRotation * (1-card.t) + card.targetRotation*card.t
					card.rect_scale = card.startingScale * (1-card.t) + card.originalScale*card.t
					card.t += delta / float(REORGANIZETIME)
				else:
					card.rect_position = card.targetPosition
					card.rect_rotation = card.targetRotation
					card.rect_scale = card.originalScale
					
					card.startingPosition = card.rect_position
					card.startingRotation = card.rect_rotation
					card.startingScale = card.rect_scale
					
					card.t = 0

func focus(card: Node):
	var angle = PI/2 + cardSpread * (float(self.get_child_count()+1)/2 - card.cardNumber)
	arcAngleVector = Vector2(horizontalRadius * cos(angle), -verticalRadius * sin(angle))
	card.targetPosition = cardArcCenter + arcAngleVector - card.rect_size/2
	card.targetPosition.y = get_viewport().size.y - ((card.cardSize.y/1.2)*card.zoomSize + (card.cardSize.y/1.2))

func physicsSetup(card: Node):
	card.startingPosition = card.rect_position
	card.startingRotation = card.rect_rotation
	card.startingScale = card.rect_scale
	card.t = 0
	card.setup = false
