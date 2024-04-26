extends Area2D

func _on_area_entered(area):
	print("Entering Door")
	if area.name == "player_hitbox":
		if Input.is_action_pressed("interact"):
			get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/inside_building_1.tscn")
