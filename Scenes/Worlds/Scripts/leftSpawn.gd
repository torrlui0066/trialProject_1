extends Area2D

const meleeEnemy = preload("res://Enemy/Enemy_Scene/Slime_enemy/slime_enemy.tscn")

@onready var left_spawnPoint : Marker2D = $leftSpawnPoint
@onready var left_SpawnCollider : CollisionShape2D = $leftDetection

var spawnPoint_Position

func _ready():
	spawnPoint_Position = left_spawnPoint.position

func _on_body_entered(body):
	if body.name == "player":
		print("Now in spawn area")
		
		for loopCounter in 5:
			await get_tree().create_timer(1).timeout
			beginSpawn()
		
		left_SpawnCollider.disabled = true
	
func beginSpawn():
	print("Now spawning")
	var slimeEnemy = meleeEnemy.instantiate()
	slimeEnemy.global_position = left_spawnPoint.global_position
	get_tree().get_root().add_child(slimeEnemy)
	print("Added Child")