extends Area2D



func _on_area_entered(area):
	print("Entering Door")
	if area.name == "player_hitbox":
		get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/Test_Area.tscn")
