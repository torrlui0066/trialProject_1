extends Node
class_name Walker



const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var steps_since_loot = 0
var rooms = []

func _init(starting_position_param, new_borders):
	assert(new_borders.has_point(starting_position_param))
	position = starting_position_param
	step_history.append(position)
	borders = new_borders	


func walk(steps):
	create_startroom(position)
	for i in steps:  # Renamed 'step' to 'i' to avoid shadowing the 'step' method.
		#increase randf higher for more chance of rooms and steps since inscreases length of passive  tunnels
		if  randf() <= 0.22 or steps_since_turn >= 8:
			change_direction()
		
		if step():  # Now it's clear that 'step()' refers to the method.
			step_history.append(position)
		else:
			change_direction()
			return step_history


func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	create_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	##IMPLAMENT REPETITION SAFTEY TO AVOID SMALL MAP
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func room_slot(position, size):
		return {position = position, size = size}

func create_room(position):
	#increase random room size higher # means less individual rooms more merged rooms
	var size = Vector2(randi() % 5 + 1, randi() % 3 + 2)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(room_slot(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x,y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func create_startroom(position):
	var size = Vector2(20,8)
	var top_left_corner = (position - size/2).ceil()
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x,y)
			if borders.has_point(new_step):
				step_history.append(new_step)
