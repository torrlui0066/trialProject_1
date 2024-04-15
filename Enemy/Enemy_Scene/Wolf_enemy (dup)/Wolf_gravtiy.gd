extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2D : AnimatedSprite2D
var is_attacking = false

const GRAVITY : int = 100
const ATTACK_DURATION = 0.5
var attack_timer = 0

func _physics_process(delta):
	if character_body_2d && !is_attacking:
		if !character_body_2d.is_on_floor():
			character_body_2d.velocity.y += GRAVITY * delta
		else:
			character_body_2d.velocity.y = 0  # Reset vertical velocity when on the floor

		if is_attacking:
			attack_timer += delta
			if attack_timer >= ATTACK_DURATION:
				is_attacking = false
				attack_timer = 0
				animated_sprite_2D.play("idle")  # Switch back to idle animation

		character_body_2d.move_and_slide()

func attack_player():
	if character_body_2d and !is_attacking:
		is_attacking = true
		animated_sprite_2D.play("attack")  # Play the attack animation
