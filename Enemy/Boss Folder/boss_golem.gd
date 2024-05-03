extends CharacterBody2D

var health = 20
var speed = 0
var direction = 0

var current_state = boss_states.IDLE
enum boss_states {IDLE, SHOOT, SHOOT2, MELEE, DEATH}

var player = null
var can_shoot = true
var can_attack = true
var player_chase = false
var can_take_damage = true
var player_inattack_zone = false
var player_in_melee_atk_zone = false

var projectile_scene1 = preload("res://Enemy/Boss Folder/mana_beam.tscn") # Path to your first projectile scene
var projectile_scene2 = preload("res://Enemy/Boss Folder/golem_proj.tscn") # Path to your second projectile scene

@onready var anim = $AnimatedSprite2D
@onready var animPlay = $AnimationPlayer
@onready var Beam_marker : Marker2D = $beam_marker
@onready var knife_marker : Marker2D = $knife_marker
#@onready var timer : Timer = $attack_timer

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

'func randomAttack():
	var rand_attack = randi() % 3
	match rand_attack:
			0:
				current_state = boss_states.SHOOT
			1:
				current_state = boss_states.SHOOT2
			2:
				current_state = boss_states.MELEE
	#can_attack = false
	ranged_cooldown.wait_time = attack_cooldown  # Update the timer duration
	ranged_cooldown.start()  # Restart the timer with the new cooldown duration'

func checkDirection():
	if player_chase:
		if player.position.x - position.x < 0:
			anim.flip_h = false
			$melee_area.scale.x = 3.12
			direction = -1
		elif player.position.x - position.x > 0:
			anim.flip_h = true
			$melee_area.scale.x = -3.12
			direction = 1
			
func idle(delta):
	anim.play("idle")
	checkDirection()
	
	if player_inattack_zone and can_shoot and health >= 0 and player_in_melee_atk_zone != true:
		current_state = boss_states.SHOOT
	#if player_inattack_zone and can_shoot and health >= 0:
	#	current_state = boss_states.SHOOT2
	if player_inattack_zone and can_shoot and health >= 0 and player_in_melee_atk_zone == true:
		current_state = boss_states.MELEE
	if health <= 0:
		current_state = boss_states.DEATH

func shootTimer():
	can_shoot = false
	await get_tree().create_timer(3).timeout
	can_shoot = true

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
			shootTimer()
			#print("ranged attack shot")
		elif direction == 1:
			var projectile = projectile_scene1.instantiate() as Node2D
			get_parent().add_child(projectile)
			projectile.global_position = $beam_marker.global_position
			projectile.scale.x = 1
			projectile.set("direction", direction)
			anim.play("ranged")
			await anim.animation_finished
			shootTimer()
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
	if player and player.global_position and player_in_melee_atk_zone:
		if direction == 1:
			animPlay.play("meleeAttack")
		if direction == -1:
			animPlay.play("meleeAttack")
	else:
		current_state = boss_states.IDLE


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



func _on_melee_area_area_entered(area):
	player_in_melee_atk_zone = true


func _on_melee_area_area_exited(area):
	player_in_melee_atk_zone = false
