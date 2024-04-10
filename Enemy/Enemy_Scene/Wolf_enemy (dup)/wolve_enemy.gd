extends CharacterBody2D

var speed = 80
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true

const GRAVITY = 100
const MAX_Y_SPEED = 200

func _physics_process(delta):
	deal_with_damage()

	if player_chase and player:
		var target_position = player.position
		var direction = (target_position - position).normalized()

		# Adjust Y position to stay grounded
		var ground_position = Vector2(target_position.x, position.y)
		if position.y < ground_position.y:
			position.y = ground_position.y
		else:
			position.y = min(position.y, ground_position.y + MAX_Y_SPEED * delta)

		# Move horizontally towards the player
		position += direction * speed * delta

		# Apply gravity to prevent flying behavior
		if position.y < ground_position.y:
			position.y = ground_position.y
		else:
			position.y = min(position.y, ground_position.y + MAX_Y_SPEED * delta)

		$AnimatedSprite2D.play("run")

		if direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("idle")

func _on_wolve_detection_body_entered(body):
	player = body
	player_chase = true
	print("player entered detection area")

func _on_wolve_detection_body_exited(body):
	player = null
	player_chase = false

func _on_wolf_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_wolf_hitbox_body_exited(body):
	if body == player:
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("wolf health = ", health)
			if health <= 0:
				$AnimatedSprite2D.play("death")
				self.queue_free()

func _on_wolf_take_damage_cooldown_timeout():
	can_take_damage = true
