extends MarginContainer

onready var cardEnums = preload("res://assets/cards/cardEnums.gd")
var cardName = "left"
onready var cardInfo = cardEnums.DATA[cardEnums.get(cardName)]
onready var cardImagePath = str("res://assets/cards/graphics/",cardName,".bmp")

func _ready():
	print(cardInfo)
	var cardSize = rect_size
	$Back.scale *= cardSize / $Back.texture.get_size()
	$Card.texture = load(cardImagePath)
	$Card.scale *= cardSize / $Card.texture.get_size()
	$Border.scale *= cardSize / $Border.texture.get_size()
