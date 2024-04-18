extends Node2D

#preload Exit
const Player = preload("res://Player/player(scene).tscn")
const Coin = preload("res://Scenes/Interactables/scenes/coin.tscn")
const Exit = preload("res://Scenes/Worlds/Scenes/CaveExit.tscn")
const Slime = preload("res://Enemy/Enemy_Scene/Wolf_enemy (dup)/wolve_enemy.tscn")

var rect = Rect2(-64, -256, 300,600)
var borders = rect.abs()

@onready var tileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_level()
	

func generate_level():
	var walker = Walker.new(Vector2(7, 13), borders)
	var map = walker.walk(1000)

	#player spawn at start room
	
	#var player = Player.instance()
	#add_child(player)
	#player.position = map.front()*32
	
	for room in walker.rooms:
		var exit = Slime.instantiate()
		add_child(exit)
		exit.position = room.position *32
	
	walker.queue_free()
	var cells =[]
	for location in map:
		#location = [0,0]
		cells.append(location)
	
	tileMap.set_cells_terrain_connect(0, cells, 0, 0)

