extends CharacterBody2D

var input

@export var speed = 100.0
@export var gravity = 10

# variable for jumping
var jump_count = 0
@export var max_jump = 2
@export var jump_force = 700
@export var midjump_multiplier = 1.7

# variable for attacking
var attack_count = 0
var max_attacks = 1
var isAttacking: bool = false


@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer

func _ready():
	pass
	
	
func _process(delta):
	movement(delta)
	
	
func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	attack_count = 0
	
	# attacking part of code
	attacking()
	
	# attacking part of movement
	if isAttacking == false:
	# actual movement code
		if input != 0:
			if input > 0:
				velocity.x += speed * delta
				velocity.x = clamp(speed, 100, speed)
				sprite.scale.x = 1
				sprite.position.x = 8
				anim.play("Run")
			if input < 0:
				velocity.x -= speed * delta
				velocity.x = clamp(-speed, 100, -speed)
				sprite.position.x = 0
				sprite.scale.x = -1
				anim.play("Run")
	
		if input == 0:
			velocity.x = 0
			anim.play("Idle")
		
		
	# Jump Code
	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if isAttacking == false:
			if velocity.y < 0:
				anim.play("Jump")
			if velocity.y > 0:
				anim.play("Fall")
		elif isAttacking == true:
			attacking()
			
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
	
	
	gravity_force()
	move_and_slide()

func gravity_force():
	velocity.y += gravity
	
func attacking():
	if Input.is_action_just_pressed("attack") && attack_count < max_attacks:
		isAttacking = true
		if isAttacking == true:
			attack_count += 1
			if sprite.scale.x == 1 && input > 0:
				velocity.x = 10
			elif sprite.scale.x == -1 && input < 0:
				velocity.x = -10
			elif input == 0:
				velocity.x = 0
			anim.play("Attack")
		await anim.animation_finished
		isAttacking = false
