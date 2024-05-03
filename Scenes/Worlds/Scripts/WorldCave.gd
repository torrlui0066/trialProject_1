extends Node2D

#preload Exit
const Crate = preload("res://Scenes/Interactables/scenes/crate.tscn")
const Coin = preload("res://Scenes/Interactables/scenes/coin.tscn")
const Exit = preload("res://Scenes/Worlds/Scenes/CaveExit.tscn")
const Bat = preload("res://Enemy/Enemy_Scene/Skeleton_enemy/Skeleton_enemy.tscn")

var rect = Rect2(-64, -256, 300,600)
var borders = rect.abs()

@onready var tileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_level()
	

func generate_level():
	var walker = Walker.new(Vector2(7, 13), borders)
	var map = walker.walk(1000)
	
		# Get unique room positions
	var unique_room_positions = walker.get_unique_room_positions()
	
	# Spawn coins at unique room positions
	for pos in unique_room_positions:
		if pos == unique_room_positions[-1]:
			var exit_instance = Exit.instantiate()
			exit_instance.position = pos * 32 
			add_child(exit_instance)
		else:
			var random_chance = randf()
			if random_chance < 0.15:
				var crate = Coin.instantiate()
				crate.position = pos * 32 # Adjust position as necessary
				add_child(crate)
			elif random_chance < 0.23: # 8% chance after 15%
				var bat = Bat.instantiate()
				bat.position = pos * 32 # Adjust position as necessary
				add_child(bat)
			else:
				var coin = Coin.instantiate()
				coin.position = pos * 32 # Adjust position as necessary
				add_child(coin)
	
	"for room in walker.rooms:
		var coin = Coin.instantiate()
		add_child(coin)
		coin.position = room.position *32"
	
	walker.queue_free()
	
	
	var cells =[]
	for location in map:
		#location = [0,0]
		cells.append(location)
	
	tileMap.set_cells_terrain_connect(0, cells, 0, 0)

