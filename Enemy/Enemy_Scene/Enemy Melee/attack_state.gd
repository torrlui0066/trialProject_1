extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var speed : int

var player : CharacterBody2D
var max_speed

func on_process(delta : float):
	pass
	
	
func on_physics_process(delta : float):
	var direction : int
	
	if character_body_2d.global_position > player.global_position:
		animation_player.flip_h = false
		direction = -1
	elif character_body_2d.global_position < player.global_position:
		animation_player.flip_h = true
		direction = 1
		
	animation_player.play("attack")
	
	character_body_2d.velocity.x += direction * speed * delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_speed, max_speed)
	character_body_2d.move_and_slide()
	
	
func enter():
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	max_speed = speed + 20
	
	
func exit():
	pass
