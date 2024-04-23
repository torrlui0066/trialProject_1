extends Area2D

@onready var hp = 3
@onready var atk_damage = 1
@onready var speed = 20

var player = null

func _on_slime_hitbox_area_entered(area):
	if area.name == "sword" || area.name == "fireball_area":
		hp -= 1
		# Play some animation here for attack stun on slime
		# Also move slime entity backwards
		print ("Hp is ", hp)
	if hp == 0:
		# Play some animation here for death of slime
		queue_free()

func _on_detection_area_body_entered(body):
	if body.name == "player":
		print("Player in detection area")
