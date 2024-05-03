extends Node2D


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if player_data.kills >= 15:
		$hordeBounds/rightBound.disabled = true



func _on_horde_exit_area_entered(area):
	print("Leaving horde mode")
	if area.name == "player_hitbox":
		get_tree().change_scene_to_file("res://Scenes/Worlds/Scenes/boss_room.tscn")
