extends Area2D

func _on_area_entered(area):
	print("Exiting Building 1")
	if area.name == "player_hitbox":
		if Input.is_action_pressed("interact"):
			get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/town.tscn")
