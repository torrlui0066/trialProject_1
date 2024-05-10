extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

var health = 2
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walking")
		
		if(player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = true
			$Attack_area.position.x = -16
		else:
			$AnimatedSprite2D.flip_h = false
			$Attack_area.position.x = 16
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_skeleton_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
	


func _on_skeleton_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health -20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_skeleton_hitbox_area_entered(area):
	if area.name == "sword" || area.name == "fireball_area":
		print("Enemy has been attacked")
		health -= 1
	
	if health == 0:
		$AnimatedSprite2D.play("death")
		queue_free()

func _on_attack_detection_body_entered(body):
	if body.name == "player":
		print("ASDF")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished