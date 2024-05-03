extends CharacterBody2D

var speed = 200
var player_chase = false
var player = null

var health = 3
var player_inattack_zone = false
var can_take_damage = true
var can_shoot = true
var direction = 0

@onready var dark_start : Marker2D = $Marker2D


var projectile_scene = preload("res://Enemy/Enemy_Scene/Mini_golem_enemy/darkblast.tscn")  # Load the projectile scene


func _physics_process(delta):
	if player_inattack_zone and can_take_damage:
		#take_damage()
		'''if can_take_damage:
			player_data.life -= 20 
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Demon health =", health)
			if health <= 0:
				self.queue_free()'''
			
	if player_inattack_zone and player_chase:
		if $shoot_cooldown.is_stopped():
			$shoot_cooldown.start()
	else:
		if not $shoot_cooldown.is_stopped():
			$shoot_cooldown.stop()


	if player_chase:
		position += (player.position - position) / speed

		$AnimatedSprite2D.play("walk")

		if player.position.x - position.x < 0:
			$AnimatedSprite2D.flip_h = false
			direction = -1
		else:
			$AnimatedSprite2D.flip_h = true
			direction = 1
	else:
		$AnimatedSprite2D.play("idle")
'''
	if can_take_damage and player_inattack_zone:
		take_damage()
'''
func _on_detection_area_body_entered(body):
	if body.name == "player":
		player = body
		player_chase = true
		player_inattack_zone = true
		print("Player entered detection area")

func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null
		player_chase = false
		player_inattack_zone = false
		print("Player exited detection area")

func take_damage():
	player_data.life -= 1
	$take_damage_cooldown.start()
	can_take_damage = false
	print("Demon health =", health)
	if health <= 0:
		self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_demon_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_demon_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func shoot_projectile():
	if player_inattack_zone and can_shoot:
		if direction == -1:
			print("Is shooting")
			var projectile = projectile_scene.instantiate() as Node2D  # Instance the projectile
			get_parent().add_child(projectile)  # Add the projectile as a child of the enemy's parent node
			projectile.global_position = $Marker2D.global_position  # Set the initial position of the projectile
			projectile.scale.x = -1
			projectile.set("direction", direction)  # Set the direction of the projectile
			$AnimatedSprite2D.play("shoot")  # Play the shoot animation
			await $AnimatedSprite2D.animation_finished
		elif direction == 1:
			print("Is shooting")
			var projectile = projectile_scene.instantiate() as Node2D  # Instance the projectile
			get_parent().add_child(projectile)  # Add the projectile as a child of the enemy's parent node
			projectile.global_position = $Marker2D.global_position  # Set the initial position of the projectile
			projectile.scale.x = 1
			projectile.set("direction", direction)  # Set the direction of the projectile
			$AnimatedSprite2D.play("shoot")  # Play the shoot animation
			await $AnimatedSprite2D.animation_finished

func _on_timer_timeout():
	print("Is running")
	can_shoot = true
	shoot_projectile()


func _on_demon_hitbox_area_entered(area):
	if area.name == "sword" || area.name == "fireball_area":
		print("Enemy has been attacked")
		health -= 1
	
	if health == 0:
		queue_free()
