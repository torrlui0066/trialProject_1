extends Area2D

var inArea

func _on_body_entered(body):
	inArea = true
	print(inArea)
	if body.name == "player":
		get_node("alchemistShop/anim").play("TransIn")

func _on_body_exited(body):
	inArea = false
	get_node("alchemistShop/anim").play("TransOut")
	print(inArea)
