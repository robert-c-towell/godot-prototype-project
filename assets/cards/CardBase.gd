extends MarginContainer

var cardName = "backward"

onready var cardEnums = preload("res://assets/cards/cardEnums.gd")
onready var cardInfo = cardEnums.DATA[cardEnums.get(cardName)]
onready var cardImagePath = str("res://assets/cards/graphics/",cardInfo.image)

onready var originalScale = Vector2(0.75,0.75)
var startingPosition = 0
var targetPosition = 0
var defaultPosition = Vector2()
var startingRotation = 0
var targetRotation = 0
var startingScale = Vector2()
var zoomSize = 2

var cardSize = Vector2(125,175)

var setup = true
var reorganizeNeighbors = true
var moveCard = false

var t = 0
const DRAWTIME = 0.5
const REORGANIZETIME = 0.3
const FOCUSTIME = 0.2

enum {
	InHand
	InMovementQueue
	InActionQueue
	InMouse
	FocusInHand
	DrawingCard
	ReorganizeHand
}
var state = InHand

func _ready():
	setupCard()
	
func setupCard():
	randomize()
	var r = stepify(rand_range(0.15,0.95),0.01) * 1000
	$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer2/Speed.text = str(r)
	
	$Back.visible = true
	$Front.visible = false
	$VBoxContainer.visible = false
	
	rect_scale = originalScale

	if cardInfo.image:
		$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.texture = load(cardImagePath)
		$VBoxContainer/MainTextSpacer/MainImage.texture = load(cardImagePath)
		
		$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/Symbol.visible = false
		$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.visible = true
		$VBoxContainer/MainTextSpacer/MainImage.visible = true
		$VBoxContainer/MainTextSpacer/Description.visible = false
		
		if cardInfo.description:
			$VBoxContainer/MainTextSpacer/ShortDescription.text = cardInfo.description
			$VBoxContainer/MainTextSpacer/ShortDescription.visible = true
		else:
			$VBoxContainer/MainTextSpacer/ShortDescription.visible = false
	else:
		$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/Symbol.visible = true
		$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer/TitleImage.visible = false
		$VBoxContainer/MainTextSpacer/MainImage.visible = false
		$VBoxContainer/MainTextSpacer/ShortDescription.visible = false
		$VBoxContainer/MainTextSpacer/Description.visible = true
		
		if cardInfo.description:
			$VBoxContainer/MainTextSpacer/Description.text = cardInfo.description
			$VBoxContainer/MainTextSpacer/Description.visible = true
		else:
			$VBoxContainer/MainTextSpacer/Description.visible = false

func _physics_process(delta):
	match state:
		InHand:
			pass
		InMovementQueue:
			pass
		InActionQueue:
			pass
		InMouse:
			pass
		FocusInHand:
			if setup:
				physicsSetup()
			if t <= 1:
				rect_position = startingPosition.linear_interpolate(targetPosition, t)
				rect_rotation = startingRotation * (1-t)
				rect_scale = startingScale * (1-t) + zoomSize*originalScale*t
				t += delta / float(FOCUSTIME)
				if reorganizeNeighbors:
					reorganizeNeighbors = false
					var isThisCardFound = false
					for card in get_parent().get_children():
						if card.get_instance_id() == self.get_instance_id():
							isThisCardFound = true
						else:
							card.targetPosition = card.defaultPosition
							if isThisCardFound:
								card.targetPosition.x += card.rect_size.x/2
							else:
								card.targetPosition.x -= card.rect_size.x/2
							moveNeighbor(card)
			else:
				rect_position = targetPosition
				rect_rotation = 0
				rect_scale = zoomSize*originalScale
		DrawingCard:
			if t <= 1:
				rect_position = startingPosition.linear_interpolate(targetPosition, t)
				rect_rotation = startingRotation * (1-t) + targetRotation*t
				rect_scale.x = originalScale.x * abs(2*t - 1)
				if $Back.visible:
					if t >= 0.5:
						$Back.visible = false
						$Front.visible = true
						$VBoxContainer.visible = true
				t += delta / float(DRAWTIME)
			else:
				rect_position = targetPosition
				rect_rotation = targetRotation
				state = InHand
				t = 0
		ReorganizeHand:
			if setup:
				physicsSetup()
			if t <= 1:
				if moveCard:
					moveCard = false
				rect_position = startingPosition.linear_interpolate(targetPosition, t)
				rect_rotation = startingRotation * (1-t) + targetRotation*t
				rect_scale = startingScale * (1-t) + originalScale*t
				t += delta / float(REORGANIZETIME)
				if !reorganizeNeighbors:
					reorganizeNeighbors = true
					for card in get_parent().get_children():
						if card.get_instance_id() != self.get_instance_id():
							resetNeighbor(card)
			else:
				rect_position = targetPosition
				rect_rotation = targetRotation
				rect_scale = originalScale
				state = InHand

func moveNeighbor(card: Node):
	card.setup = true
	moveCard = true
	card.state = ReorganizeHand

func resetNeighbor(card: Node):
	if !card.moveCard && card.state != FocusInHand:
		card.targetPosition = card.defaultPosition
		card.setup = true
		card.state = ReorganizeHand

func physicsSetup():
	startingPosition = rect_position
	startingRotation = rect_rotation
	startingScale = rect_scale
	t = 0
	setup = false

func _on_TextureButton_mouse_entered():
	match state:
		InHand, ReorganizeHand:
			setup = true
			targetPosition = defaultPosition
			targetPosition.y = get_viewport().size.y - ((cardSize.y/1.2)*zoomSize + (cardSize.y/1.2))
			state = FocusInHand

func _on_TextureButton_mouse_exited():
	match state:
		FocusInHand:
			setup = true
			targetPosition = defaultPosition
			state = ReorganizeHand
