extends CharacterBody2D

var health = 20
var speed = 0
var direction = 0
var attack_cooldown = 2.0

var current_state = boss_states.IDLE
enum boss_states {IDLE, SHOOT, SHOOT2, MELEE, DEATH}

var player = null
var can_shoot = true
var can_attack = true
var player_chase = false
var can_take_damage = true
var player_inattack_zone = false

var projectile_scene1 = preload("res://Enemy/Boss Folder/mana_beam.tscn") # Path to your first projectile scene
var projectile_scene2 = preload("res://Enemy/Boss Folder/golem_proj.tscn") # Path to your second projectile scene

@onready var anim = $AnimatedSprite2D
@onready var Beam_marker : Marker2D = $beam_marker
@onready var knife_marker : Marker2D = $knife_marker
@onready var ranged_cooldown : Timer = $attack_timer

func _physics_process(delta):
	match current_state:
		boss_states.IDLE:
			idle(delta)
		boss_states.SHOOT:
			shoot(delta)
		boss_states.SHOOT2:
			shoot2(delta)
		boss_states.MELEE:
			melee(delta)
		boss_states.DEATH:
			death(delta)

func _on_detection_area_body_entered(body):
	if body.name == "player":
		player = body
		player_chase = true
		player_inattack_zone = true
		print("Player in detection range")

func _on_detection_area_body_exited(body):
	if body.name == "player":
		player = null
		player_chase = false
		player_inattack_zone = false
		print("Player left detection range")

func randomAttack():
	pass

func checkDirection():
	if player_chase:
		if player.position.x - position.x < 0:
			anim.flip_h = false
			direction = -1
		elif player.position.x - position.x > 0:
			anim.flip_h = true
			direction = 1
			
func idle(delta):
	anim.play("idle")
	checkDirection()
	
	if player_inattack_zone and can_shoot and health >= 0:
		current_state = boss_states.SHOOT
	#if player_inattack_zone and can_shoot and health >= 0:
	#	current_state = boss_states.SHOOT2
	if health <= 0:
		current_state = boss_states.DEATH

func shoot(delta):
	checkDirection()
	if player_inattack_zone and can_shoot:
		if direction == -1:
			var projectile = projectile_scene1.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $beam_marker.global_position
			projectile.scale.x = -1
			projectile.set("direction", direction)
			anim.play("ranged")
			await anim.animation_finished
			print("ranged attack shot")
		elif direction == 1:
			var projectile = projectile_scene1.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $beam_marker.global_position
			projectile.scale.x = 1
			projectile.set("direction", direction)
			anim.play("ranged")
			await anim.animation_finished
		current_state = boss_states.IDLE

func shoot2(delta):
	checkDirection()
	if player_inattack_zone and can_shoot:
		if direction == -1:
			var projectile = projectile_scene2.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $knife_marker.global_position
			projectile.scale.x = -1
			projectile.set("direction", direction)
			anim.play("ranged_2")
			await anim.animation_finished
		elif direction == 1:
			var projectile = projectile_scene2.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $knife_marker.global_position
			projectile.scale.x = 1
			projectile.set("direction", direction)
			anim.play("ranged_2")
			await anim.animation_finished
	current_state = boss_states.IDLE

func melee(delta):
	checkDirection()
	if player and player.global_position:
		if player.global_position.distance_to(global_position) < 100: # Melee range
			player.takeDamage(1) # Adjust the damage value as needed
			anim.play("melee")
			await anim.animation_finished

func death(delta):
	checkDirection()
	anim.play("death")
	await anim.animation_finished
	print("Enemy has been destroyed")
	queue_free()

func _on_golem_hitbox_area_area_entered(area):
	if area.name == "sword":
		print("Enemy has taken melee damage, health is: ", health)
		health -= player_data.sword_damage
	if area.name == "fireball_area":
		print("Enemyhas taken fireball damage, health is: ", health)
		health -= player_data.fireball_damage
