extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

var isAttacking: bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if isAttacking == false:
			if velocity.y == 0:
				anim.play("Run")
		elif isAttacking == true:
				anim.play("Attack")
				isAttacking = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#if isAttacking == false:
		if velocity.y == 0:
			if isAttacking == false:
				anim.play("Idle")
			elif isAttacking == true:
				anim.play("Attack")
				await anim.animation_finished
				isAttacking = false
			#isAttacking = false
	if velocity.y > 0:
		anim.play("Fall")
		
	#isAttacking = false
	move_and_slide()
	
		
func _on_sword_swing_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()
