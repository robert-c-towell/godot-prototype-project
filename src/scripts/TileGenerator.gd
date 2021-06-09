extends Spatial

const TILE = preload("res://src/scenes/Tile.tscn")
const TILE_WIDTH = 2.1

func _enter_tree():
	create_map()
	
func create_map():
	var content = load_file()
	var rows = content.split("\n")
	for x in rows.size():
		var cols = rows[x].split(",")
		for z in cols.size():
			var newTile = TILE.instance().init(cols[z])
			newTile.transform.origin = Vector3(x * TILE_WIDTH,0,-(z * TILE_WIDTH))
			self.add_child(newTile)

func load_file():
	var file = File.new()
	file.open("res://assets/maps/test_map_1.csv", File.READ)
	var content = file.get_as_text()
	file.close()
	return content
