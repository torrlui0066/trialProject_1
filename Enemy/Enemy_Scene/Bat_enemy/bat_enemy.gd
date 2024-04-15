extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("idle")
		
		if(player.position.x - position.x) <0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")


func deal_with_damage():
	if player_inattack_zone and global.player_current_attack:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("bat health = ", health)
			if health <= 0:
				self.queue_free()


func _on_bat_detection_body_entered(body):
	player = body
	player_chase = true
	#if body.has_method("get_name") and body.get_name() == "Player":  # Check if the entering body is the player
		#player = body
		#player_chase = true
		#$AnimatedSprite2D.play("idle")  # Play 'idle' animation when player is detected


func _on_bat_detection_body_exited(body):
	if body == player:
		player = null
		player_chase = false


#func attack_player():
	#if player:
		#player.health -= ATTACK_DAMAGE


func _on_bat_damage_cool_timeout():
	can_take_damage = true
