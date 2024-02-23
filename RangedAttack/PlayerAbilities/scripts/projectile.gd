class_name Projectile
extends Node2D

@export var speed = 100.0

var direction = Vector2.ZERO
var source : Node
var launched = false
var lookingRight: bool = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	call_deferred("_validate_setup")
	
"""
	SOMETHING IN THE FUNC UNDER HERE NEEDS TO CHANGE IN 
	ORDER FOR THE PROJECTILE TO SHOOT WHERE THE PLAYER IS 
	ACTUALLY LOOKING, TOO TIRED RN FIGURE IT OUT TMRW
"""

func _physics_process(delta):
	if direction.x > 0:
		lookingRight = true
		if lookingRight == true:
			position.x += direction.x * speed * delta
	elif direction.x < 0:
		lookingRight = false
		sprite.scale.x = -1
		if lookingRight == false:
			position.x += direction.x * speed * delta
	elif direction.x == 0:
		position.x += sprite.scale.x * speed * delta 
		
func launch(p_source : Node, p_direction : Vector2):
	source = p_source
	direction = p_direction
	launched = true

# private function
func _validate_setup() -> bool:
	var no_problems = true
	
	if(launched == false):
		push_warning("Projectile created but launch not called")
		no_problems = false
	
	return no_problems
