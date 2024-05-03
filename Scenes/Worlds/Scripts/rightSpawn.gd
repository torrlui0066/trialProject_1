extends Area2D

const meleeEnemy = preload("res://Enemy/Enemy_Scene/Slime_enemy/slime_enemy.tscn")

@onready var right_spawnPoint : Marker2D = $rightSpawnPoint
@onready var right_SpawnCollider : CollisionShape2D = $rightDetection

var spawnPoint_Position

func _ready():
	spawnPoint_Position = right_spawnPoint.position

func _on_body_entered(body):
	if body.name == "player":
		print("Now in spawn area")
		while player_data.kills < 15:
			for loopCounter in 1:
				await get_tree().create_timer(3).timeout
				beginSpawn()
	
			right_SpawnCollider.disabled = true
		right_SpawnCollider.disabled = false

func beginSpawn():
	print("Now spawning")
	var slimeEnemy = meleeEnemy.instantiate()
	slimeEnemy.global_position = right_spawnPoint.global_position
	get_tree().get_root().add_child(slimeEnemy)
	print("Added Child")
