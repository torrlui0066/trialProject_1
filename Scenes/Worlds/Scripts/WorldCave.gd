extends Node2D


var rect = Rect2(-64, -256, 300,600)
var borders = rect.abs()

@onready var tileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_level()
	

func generate_level():
	var walker = Walker.new(Vector2(7, 13), borders)
	var map = walker.walk(1000)
	walker.queue_free()
	
	var cells =[]
	for location in map:
		#location = [0,0]
		cells.append(location)
	
	tileMap.set_cells_terrain_connect(0, cells, 0, 0)

