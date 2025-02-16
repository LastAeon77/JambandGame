extends Resource

@export var up_action : String = "up_player_1"
@export var down_action : String = "down_player_1"
@export var left_action : String = "left_player_1"
@export var right_action : String = "right_player_1"

@export var button_1_action : String = "button_1_player_1"
@export var button_2_action : String = "button_2_player_1"

@export var select_action : String = "select_player_1"
@export var start_action : String = "start_player_1"

func get_vector() -> Vector2i:
	if Input.is_action_just_pressed(up_action):
		return Vector2i(0,-1)
	if Input.is_action_just_pressed(down_action):
		return Vector2i(0,1)
	if Input.is_action_just_pressed(left_action):
		return Vector2i(-1,0)
	if Input.is_action_just_pressed(right_action):
		return Vector2i(1,0)
	return Vector2i(0,0)
	
func get_button_1() -> bool:
	return Input.is_action_just_pressed(button_1_action)
func get_button_2() -> bool:
	return Input.is_action_just_pressed(button_2_action)
func get_select() -> bool:
	return Input.is_action_just_pressed(select_action)
func get_start() -> bool:
	return Input.is_action_just_pressed(start_action)
