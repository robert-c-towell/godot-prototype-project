extends MarginContainer

var cardName = "backward"

onready var cardEnums = preload("res://assets/cards/cardEnums.gd")
onready var cardInfo = cardEnums.DATA[cardEnums.get(cardName)]
onready var cardImagePath = str("res://assets/cards/graphics/",cardInfo.image)

onready var originalScaleX = rect_scale.x
var startingPosition = 0
var targetPosition = 0
var startingRotation = 0
var targetRotation = 0
var t = 0
const DRAWTIME = 0.5
const REORGANIZETIME = 0.3

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
	var r = stepify(rand_range(0,0.95),0.01) * 1000
	$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer2/Speed.text = str(r)
	
	$Back.visible = true
	$Front.visible = false
	$VBoxContainer.visible = false

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
			pass
		DrawingCard:
			if t <= 1:
				rect_position = startingPosition.linear_interpolate(targetPosition, t)
				rect_rotation = startingRotation * (1-t) + targetRotation*t
				rect_scale.x = originalScaleX * abs(2*t - 1)
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
			if t <= 1:
				rect_position = startingPosition.linear_interpolate(targetPosition, t)
				rect_rotation = startingRotation * (1-t) + targetRotation*t
				t += delta / float(REORGANIZETIME)
			else:
				rect_position = targetPosition
				rect_rotation = targetRotation
				state = InHand
				t = 0
