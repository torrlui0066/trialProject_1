extends Node

func _on_add_max_hp_button_pressed():
	if player_data.coin >= 10:
		player_data.coin -= 10
		player_data.life += 1
		player_data.max_life += 1
		print("Data: ", player_data.coin, ", ", player_data.life, ", ", player_data.max_life)
