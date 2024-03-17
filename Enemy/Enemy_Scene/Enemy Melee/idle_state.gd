extends NodeState

@export var character_body_2d : CharacterBody2D
@export var sprite_2d : Sprite2D
@export var animation_player : AnimationPlayer
@export var slow_down_speed : int = 50

func on_process(delta : float):
	pass
	
	
func on_physics_process(delta : float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)
	animation_player.play("idle")
	character_body_2d.move_and_slide()
	
	
func enter():
	pass
	
	
func exit():
	pass
