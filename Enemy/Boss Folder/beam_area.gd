extends Node2D

var travelled_distance = 0
@onready var anim = $AnimationPlayer

func beam():
	anim.play("Beam_attack")
	'''
	const SPEED = 1000
	const RANGE = 600
	
	var direction = Vector2.from_angle(delta)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()
	'''
