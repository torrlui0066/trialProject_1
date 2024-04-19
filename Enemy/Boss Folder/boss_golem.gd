extends CharacterBody2D

var health = 1000
var speed = 0
var direction = 0
var attack_cooldown = 2.0

var player = null
var can_shoot = true
var can_attack = true
var player_chase = false
var can_take_damage = true
var player_inattack_zone = false

var projectile_scene1 = preload("res://Enemy/Boss Folder/mana_beam.tscn") # Path to your first projectile scene
var projectile_scene2 = preload("res://Enemy/Boss Folder/golem_proj.tscn") # Path to your second projectile scene

@onready var Beam_marker : Marker2D = $Beam_marker
@onready var knife_marker : Marker2D = $knife_marker

func _physics_process(delta):
	if player_inattack_zone and can_take_damage:
		take_damage()
			
	if player_inattack_zone and player_chase:
		if $shoot_cooldown.is_stopped():
			$shoot_cooldown.start()
	else:
		
		if not $shoot_cooldown.is_stopped():
			$shoot_cooldown.stop()
	
	if player_chase:
		position += (player.position - position) / speed

		$AnimatedSprite2D.play("idle")

		if player.position.x - position.x < 0:
			$AnimatedSprite2D.flip_h = false
			direction = -1
		else:
			$AnimatedSprite2D.flip_h = true
			direction = 1
	else:
		$AnimatedSprite2D.play("idle")
		
func take_damage():
	player_data.life -= 1
	$take_damage_cooldown.start()
	can_take_damage = false
	print("Boss health =", health)
	if health <= 0:
		$AnimatedSprite2D.play("death")
		self.queue_free()

func _on_boss_detection_body_entered(body):
	if body.name == "player":
		player = body
		player_chase = true
		player_inattack_zone = true
		print("Player entered detection area")
	

func _on_boss_detection_body_exited(body):
	if body.name == "player":
		player = null
		player_chase = false
		player_inattack_zone = false
		print("Player exited detection area")

func _ready():
	player = get_node("/root/MainScene/Player") # Adjust the path to the player node in your scene

func _process(delta):
	if can_attack:
		var rand_attack = randi() % 3
		match rand_attack:
			0:
				rangedAttack1()
			1:
				rangedAttack2()
			2:
				meleeAttack()
		can_attack = false
		$Timer.start(attack_cooldown)

func meleeAttack():
	if player.global_position.distance_to(global_position) < 100: # Melee range
		player.takeDamage(10) # Adjust the damage value as needed
		$AnimatedSprite2D.play("melee")
	#else:
		# Move towards the player for melee attack

func rangedAttack1():
	if player_inattack_zone and can_shoot:
		if direction == -1:
			var projectile = projectile_scene1.instance()
			get_parent().add_child(projectile)
			projectile.global_position = $Beam_marker.global_position
			projectile.scale.x = -1
			projectile.set("direction", direction)
			$AnimatedSprite2D.play("ranged")
			await $AnimatedSprite2D.animation_finished
		elif direction == 1:
			var projectile = projectile_scene1.instance()
			get_parent().add_child(projectile)
			projectile.global_position = $Beam_marker.global_position
			projectile.scale.x = 1
			projectile.set("direction", direction)
			$AnimatedSprite2D.play("ranged")
			await $AnimatedSprite2D.animation_finished

func rangedAttack2():
	if player_inattack_zone and can_shoot:
		if direction == -1:
			var projectile = projectile_scene2.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $knife_marker.global_position
			projectile.scale.x = -1
			projectile.set("direction", direction)
			$AnimatedSprite2D.play("ranged_2")
			await $AnimatedSprite2D.animation_finished
		elif direction == 1:
			var projectile = projectile_scene2.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $knife_marker.global_position
			projectile.scale.x = 1
			projectile.set("direction", direction)
			$AnimatedSprite2D.play("ranged_2")
			await $AnimatedSprite2D.animation_finished


func _on_timer_timeout():
	can_attack = true
	shoot_projectile()
