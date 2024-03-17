extends Node

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : Sprite2D
@export var animation_player : AnimationPlayer

const GRAVITY : int = 1000

func _physics_process(delta):
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.y += GRAVITY * delta


	character_body_2d.move_and_slide()
