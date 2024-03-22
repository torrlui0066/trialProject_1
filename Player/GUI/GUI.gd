extends CanvasLayer

const heart_row_size = 8
const heart_offset = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in player_data.life:
		var new_heart = Sprite2D.new()
		new_heart.texture = $playerLife.texture
		new_heart.hframes = $playerLife.hframes
		$playerLife.add_child(new_heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$coinNumber.text = var_to_str(player_data.coin)
	display_heart()

func display_heart():
	for heart in $playerLife.get_children():
		var index = heart.get_index()
		var x = (index % heart_row_size) * heart_offset
		var y = (index / heart_row_size) * heart_offset
		heart.position = Vector2(x, y)
		
		var last_heart = floor(player_data.life)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (player_data.life - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
