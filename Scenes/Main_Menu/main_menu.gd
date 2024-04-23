extends Node2D



func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	player_data.life = 4
	get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/town.tscn")
