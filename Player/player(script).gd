extends CharacterBody2D

var input
var direction : Vector2 = Vector2.ZERO

# variables for movement
@export var speed = 100.0
@export var atk_mov_spd = 50
@export var dash_distance = 4000

# variables for jumping
@export var gravity = 10
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 700
@export var midjump_multiplier = 1.7

# wall jump
@onready var wall = $wall_ray

# everything related to state machine
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, MAGIC, DEAD, DASH}

# variables for life/ hp
var health = 100.0
var is_dead: bool = false

# variable for attacking
var attack_count = 0
var max_attacks = 2
var isAttacking: bool = false

# variable for magic attacks
# @export var fireball_range = 5
# var TimeInSeconds = 0
# @export var fireball_speed = 1
const MAGIC_FIREBALL = preload("res://Player/MagicScenes/fireball.tscn")

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var muzzle : Marker2D = $fbStart

var muzzle_position

func _ready():
	$sword/sword_collider.disabled = true
	muzzle_position = muzzle.position
	#$fireball/fireball_collider.disabled = true
	#$fireball/fireball_sprite.visible = false
	
	
func _physics_process(delta):
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.MAGIC:
			print("magic shooting")
			fire(delta)
		player_states.DASH:
			dashing()
	
func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# actual movement code
	if input != 0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100, speed)
			sprite.scale.x = 1
			wall.scale.x = 1
			$sword.position.x = 29
			$fbStart.position.x = 29
			# $fireball.position.x = 29
			# $fireball.scale.x = 1
			sprite.position.x = 8
			anim.play("Run")
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100, -speed)
			sprite.scale.x = -1
			wall.scale.x = -1
			$sword.position.x = -20
			$fbStart.position.x = -20
			# $fireball.position.x = -20
			# $fireball.scale.x = -1
			sprite.position.x = -1
			anim.play("Run")

	if input == 0:
		velocity.x = 0
		anim.play("Idle")
	
	
	# Jump Code
	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if velocity.y < 0:
			anim.play("Jump")
		if velocity.y > 0:
			anim.play("Fall")
			
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump_force * midjump_multiplier
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	# allows the second jump to be multiplied to change heights from first jump
	else:
		gravity_force()
	
	# wall jump
	if wall_collider() && Input.is_action_just_pressed("ui_accept"):
		if velocity.x > 0:
			velocity = Vector2(-3000, -450)
		elif velocity.x < 0:
			velocity = Vector2(3000, -450)
	
	if Input.is_action_just_pressed("attack"):
		current_state = player_states.SWORD
	
	if Input.is_action_just_pressed("use_ability"):
		current_state = player_states.MAGIC
	
	if Input.is_action_just_pressed("dash"):
		current_state = player_states.DASH
	
	gravity_force()
	move_and_slide()

func gravity_force():
	if !wall_collider():
		velocity.y += gravity
	elif wall_collider():
		velocity.y += 0.1
	
func sword(delta):
	anim.play("Attack")
	input_movment(delta)

func fire(delta):
	# const MAGIC_FIREBALL = preload("res://Player/MagicScenes/fireball.tscn")
	var direction = player_direction()
	
	if Input.is_action_pressed("use_ability"):
		var new_fireball = MAGIC_FIREBALL.instantiate() as Node2D
		if input < 0:
			new_fireball.scale.x = -1
			new_fireball.global_position = muzzle.global_position
			get_parent().add_child(new_fireball)
		elif input > 0:
			new_fireball.scale.x = 1
			new_fireball.global_position = muzzle.global_position
			get_parent().add_child(new_fireball)
		elif input == 0:
			new_fireball.scale.x = sprite.scale.x
			new_fireball.global_position = muzzle.global_position
			get_parent().add_child(new_fireball)
	# hard codes state to move state after fireball is used
	current_state = player_states.MOVE

func dashing():
	if velocity.x > 0:
		velocity.x += dash_distance
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
	elif velocity.x < 0:
		velocity.x -= dash_distance
		await get_tree().create_timer(0.1).timeout
		current_state = player_states.MOVE
	else:
		if sprite.scale.x == 1:
			velocity.x += dash_distance
			await get_tree().create_timer(0.1).timeout
			current_state = player_states.MOVE
		if sprite.scale.x == -1:
			velocity.x -= dash_distance
			await get_tree().create_timer(0.1).timeout
			current_state = player_states.MOVE
			
	move_and_slide()

func player_direction():
	var direction = Input.get_axis("ui_left", "ui_right")
	
	return direction
			
func input_movment(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0:
		if input > 0:
			velocity.x += atk_mov_spd * delta
			velocity.x = clamp(atk_mov_spd, 50, atk_mov_spd)
			velocity.y = clamp(0,0,0)
			sprite.scale.x = 1
		if input < 0:
			velocity.x -= atk_mov_spd * delta
			velocity.x = clamp(-atk_mov_spd, 50, -atk_mov_spd)
			velocity.y = clamp(0,0,0)
			sprite.scale.x = -1
			
	if input == 0:
		velocity.x = 0
	
	gravity_force()
	move_and_slide()

func wall_collider():
	return wall.is_colliding()
	
func reset_states():
	current_state = player_states.MOVE

"""
func _on_hurtbox_body_entered(body : Node2D):
	if body.is_ingroup("Enemy"):
		print("Enemy Entered")
"""
