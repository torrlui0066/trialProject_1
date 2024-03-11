extends CharacterBody2D

var input
var direction : Vector2 = Vector2.ZERO

# variables for movement
@export var speed = 100.0
@export var atk_mov_spd = 50

# variables for jumping
@export var gravity = 10
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 700
@export var midjump_multiplier = 1.7

# everything related to state machine
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, MAGIC, DEAD}

# variables for life/ hp
var health = 100.0
var is_dead: bool = false

# variable for attacking
var attack_count = 0
var max_attacks = 2
var isAttacking: bool = false

# variable for magic attacks
@export var fireball_range = 5
var TimeInSeconds = 0
@export var fireball_speed = 1


@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer

func _ready():
	$sword/sword_collider.disabled = true
	$fireball/fireball_collider.disabled = true
	$fireball/fireball_sprite.visible = false
	
	
func _physics_process(delta):
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.MAGIC:
			fireball(delta)
	
func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# actual movement code
	if input != 0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100, speed)
			sprite.scale.x = 1
			$sword.position.x = 29
			$fireball.position.x = 29
			$fireball.scale.x = 1
			sprite.position.x = 8
			anim.play("Run")
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 100, -speed)
			sprite.scale.x = -1
			$sword.position.x = -20
			$fireball.position.x = -20
			$fireball.scale.x = -1
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
			
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
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
	
	if Input.is_action_just_pressed("attack"):
		current_state = player_states.SWORD
	
	if Input.is_action_just_pressed("use_ability"):
		current_state = player_states.MAGIC
		
	gravity_force()
	move_and_slide()

func gravity_force():
	velocity.y += gravity
	
func sword(delta):
	anim.play("Attack")
	input_movment(delta)

func fireball(delta):
	anim.play("Fireball")
	magic_input_movment(delta)
	fireball_physics(delta)
	
func fireball_physics(delta):
	if $fireball.scale.x == 1:
		$fireball/fireball_sprite.visible = true
		if attack_count != 1:
			$fireball.position.x += fireball_speed * delta
			await anim.animation_finished
			attack_count += 1
		$fireball.position.x = 29
		$fireball/fireball_sprite.visible = false
	if $fireball.scale.x == -1:
		$fireball/fireball_sprite.visible = true
		if attack_count != 1:
			$fireball.position.x += -fireball_speed * delta
			await anim.animation_finished
			attack_count += 1
		$fireball.position.x = -20
		$fireball/fireball_sprite.visible = false
			
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

func magic_input_movment(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input != 0:
		if input > 0:
			velocity.x += atk_mov_spd * delta
			velocity.x = clamp(speed, 100, speed)
			velocity.y = clamp(0, 0, 0)
			sprite.scale.x = 1
		if input < 0:
			velocity.x -= atk_mov_spd * delta
			velocity.x = clamp(-speed, 100, -speed)
			velocity.y = clamp(0, 0, 0)
			sprite.scale.x = -1
			
	if input == 0:
		velocity.x = 0
	
	gravity_force()
	move_and_slide()
	
func reset_states():
	current_state = player_states.MOVE
