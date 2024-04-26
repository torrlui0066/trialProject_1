extends Node




func _on_heal_button_pressed():
	if player_data.coin >= 10:
		player_data.coin -= 10
		player_data.life += 1
		print("Data: ", player_data.coin, ", ", player_data.life)
