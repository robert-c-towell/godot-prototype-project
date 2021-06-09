extends Spatial

const RANDOM = "R"
const AIR = "AIR"

const TILE_GREEN = preload("res://src/scenes/TileGreen.tscn")
const GREEN = "GREEN"

const TILE_BLUE = preload("res://src/scenes/TileBlue.tscn")
const BLUE = "BLUE"

const TYPES = [AIR,GREEN,BLUE]

func init(type):
	if type == RANDOM:
		return self.init(TYPES[randi() % len(TYPES)])
	if type == GREEN:
		var tileType = TILE_GREEN.instance()
		$Tile.add_child(tileType)
		return self
	if type == BLUE:
		var tileType = TILE_BLUE.instance()
		$Tile.add_child(tileType)
		return self
	return self
