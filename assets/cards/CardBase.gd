extends MarginContainer

var cardName = "backward"

onready var CardStates = preload("res://assets/cards/CardStates.gd")
onready var CardEnums = preload("res://assets/cards/cardEnums.gd")
onready var CardInfo = CardEnums.DATA[CardEnums.get(cardName)]
onready var CardImagePath = str("res://assets/cards/graphics/",CardInfo.image)

onready var originalScale = Vector2(0.75,0.75)
var startingPosition = 0
var targetPosition = 0
var defaultPosition = Vector2()
var startingRotation = 0
var targetRotation = 0
var startingScale = Vector2()
var zoomSize = 2

var cardSize = Vector2(125,175)
var cardNumber

var setup = true
var reorganizeNeighbors = true
var moveCard = false
var isCardSelected = false

var t = 0
const DRAWTIME = 0.5
const REORGANIZETIME = 0.3
const FOCUSTIME = 0.2

var state
var previousState

var selectedOption = 1

func _ready():
	setup()
	
func setup():
	randomize()
	var r = stepify(rand_range(0.15,0.95),0.01) * 1000
	$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer2/Speed.text = str(r)
	
	$Node2d/Back.visible = true
	$Node2d/Front.visible = false
	$Node2d/VBoxContainer.visible = false

	rect_scale = originalScale
	
	if CardInfo.image:
		$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.texture = load(CardImagePath)
		$Node2d/VBoxContainer/MainTextSpacer/MainImage.texture = load(CardImagePath)
		
		$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/Symbol.visible = false
		$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.visible = true
		$Node2d/VBoxContainer/MainTextSpacer/MainImage.visible = true
		$Node2d/VBoxContainer/MainTextSpacer/Description.visible = false
		
		if CardInfo.description:
			$Node2d/VBoxContainer/MainTextSpacer/ShortDescription.text = CardInfo.description
			$Node2d/VBoxContainer/MainTextSpacer/ShortDescription.visible = true
		else:
			$Node2d/VBoxContainer/MainTextSpacer/ShortDescription.visible = false
	else:
		$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/Symbol.visible = true
		$Node2d/VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.visible = false
		$Node2d/VBoxContainer/MainTextSpacer/MainImage.visible = false
		$Node2d/VBoxContainer/MainTextSpacer/ShortDescription.visible = false
		$Node2d/VBoxContainer/MainTextSpacer/Description.visible = true
		
		if CardInfo.description:
			$Node2d/VBoxContainer/MainTextSpacer/Description.text = CardInfo.description
			$Node2d/VBoxContainer/MainTextSpacer/Description.visible = true
		else:
			$Node2d/VBoxContainer/MainTextSpacer/Description.visible = false

func _input(event):
	match state:
		CardStates.InMouse, CardStates.InMovementQueue, CardStates.InActionQueue:
			if event.is_action_pressed("leftclick"):
				if !isCardSelected:
					isCardSelected = true
					previousState = state
					state = CardStates.InMouse
					setup = true

func _on_TextureButton_mouse_entered():
	match state:
		CardStates.ReorganizeHand:
			setup = true
			get_parent().focus(self)
			state = CardStates.InFocus

func _on_TextureButton_mouse_exited():
	match state:
		CardStates.InFocus:
			setup = true
			targetPosition = defaultPosition
			state = CardStates.ExitFocus

func _on_Focus_pressed():
	if state != CardStates.DrawingCard:
		get_parent().get_parent().cardClicked(self)


#func _physics_process(delta):
#	match state:
#		CardStates.InHand:
#			pass
#		CardStates.InMovementQueue:
#			pass
#		CardStates.InActionQueue:
#			pass
#		CardStates.InMouse:
#			if setup:
#				physicsSetup()
#			if t <= 1:
#				rect_position = startingPosition.linear_interpolate(get_global_mouse_position() - cardSize, t)
#				rect_rotation = startingRotation * (1-t)
#				rect_scale.x = originalScale.x * abs(2*t - 1)
#				t += delta / 0.1
#			else:
#				rect_position = get_global_mouse_position() - cardSize
#				rect_rotation = 0
#		CardStates.InFocus:
#			if setup:
#				physicsSetup()
#			if t <= 1:
#				rect_position = startingPosition.linear_interpolate(targetPosition, t)
#				rect_rotation = startingRotation * (1-t)
#				rect_scale = startingScale * (1-t) + zoomSize*originalScale*t
#				t += delta / float(FOCUSTIME)
#				if reorganizeNeighbors:
#					reorganizeNeighbors = false
#					var isThisCardFound = false
#					for card in get_parent().get_children():
#						if card.get_instance_id() == self.get_instance_id():
#							isThisCardFound = true
#						else:
#							card.targetPosition = card.defaultPosition
#							if isThisCardFound:
#								card.targetPosition.x += card.rect_size.x/2
#							else:
#								card.targetPosition.x -= card.rect_size.x/2
#							moveNeighbor(card)
#			else:
#				rect_position = targetPosition
#				rect_rotation = 0
#				rect_scale = zoomSize*originalScale
#		CardStates.DrawingCard:
#			if t <= 1:
#				rect_position = startingPosition.linear_interpolate(targetPosition, t)
#				rect_rotation = startingRotation * (1-t) + targetRotation*t
#				rect_scale.x = originalScale.x * abs(2*t - 1)
#				if $Node2d/Back.visible:
#					if t >= 0.5:
#						$Node2d/Back.visible = false
#						$Node2d/Front.visible = true
#						$Node2d/VBoxContainer.visible = true
#				t += delta / float(DRAWTIME)
#			else:
#				rect_position = targetPosition
#				rect_rotation = targetRotation
#				state = CardStates.InHand
#				t = 0
#		CardStates.ReorganizeHand:
#			if setup:
#				physicsSetup()
#			if t <= 1:
#				if moveCard:
#					moveCard = false
#				rect_position = startingPosition.linear_interpolate(targetPosition, t)
#				rect_rotation = startingRotation * (1-t) + targetRotation*t
#				rect_scale = startingScale * (1-t) + originalScale*t
#				t += delta / float(REORGANIZETIME)
#				if !reorganizeNeighbors:
#					reorganizeNeighbors = true
#					for card in get_parent().get_children():
#						if card.get_instance_id() != self.get_instance_id():
#							resetNeighbor(card)
#			else:
#				rect_position = targetPosition
#				rect_rotation = targetRotation
#				rect_scale = originalScale
#				state = CardStates.InHand
#
#func moveNeighbor(card: Node):
#	card.setup = true
#	moveCard = true
#	card.state = CardStates.ReorganizeHand
#
#func resetNeighbor(card: Node):
#	if !card.moveCard && card.state != CardStates.InFocus:
#		card.targetPosition = card.defaultPosition
#		card.setup = true
#		card.state = CardStates.ReorganizeHand
#
#func physicsSetup():
#	startingPosition = rect_position
#	startingRotation = rect_rotation
#	startingScale = rect_scale
#	t = 0
#	setup = false
