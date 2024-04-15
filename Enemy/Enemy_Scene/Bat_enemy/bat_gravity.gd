extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2D : AnimatedSprite2D

const GRAVITY : int = 100
const FLYING_SPEED : int = 50
const MAX_FALL_SPEED : int = 200

func _physics_process(delta):
	# Check if character_body_2d is not null before accessing its properties
	if character_body_2d:
		# Apply gravity to the flying bat
		character_body_2d.velocity.y += GRAVITY * delta
		character_body_2d.velocity.y = min(character_body_2d.velocity.y, MAX_FALL_SPEED)
		character_body_2d.position.x += FLYING_SPEED * delta

		character_body_2d.move_and_slide()
