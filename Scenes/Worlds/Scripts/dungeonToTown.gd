extends Area2D



func _on_body_entered(body):
	if player_data.boss == 1:
		get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/inside_building_1.tscn")
