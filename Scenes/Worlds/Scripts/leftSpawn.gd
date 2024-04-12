extends Area2D

const meleeEnemy = preload("res://Enemy/Enemy_Scene/Slime_enemy/slime_enemy.tscn")

@onready var spawnPoint : Marker2D = $leftSpawnPoint

var spawnPoint_Position

func _ready():
	spawnPoint_Position = spawnPoint.position

func _on_body_entered(body):
	if body.name == "player":
		print("Now in spawn area")
		
		for loopCounter in 5:
			await get_tree().create_timer(3).timeout
			beginSpawn()
			
	
func beginSpawn():
	print("Now spawning")
	var slimeEnemy = meleeEnemy.instantiate()
	slimeEnemy.global_position = spawnPoint.global_position
	get_tree().get_root().add_child(slimeEnemy)
	print("Added Child")
