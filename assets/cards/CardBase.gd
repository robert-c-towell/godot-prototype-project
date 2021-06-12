extends MarginContainer

var cardName = "backward"

onready var cardEnums = preload("res://assets/cards/cardEnums.gd")
onready var cardInfo = cardEnums.DATA[cardEnums.get(cardName)]
onready var cardImagePath = str("res://assets/cards/graphics/",cardInfo.image)

func _ready():
	setupCard()
	
func setupCard():
	randomize()
	var r = stepify(rand_range(0,0.95),0.01) * 1000
	$VBoxContainer/TitleTextSpacer/HBoxContainer/MarginContainer2/Speed.text = str(r)

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
