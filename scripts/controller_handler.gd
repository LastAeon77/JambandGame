extends Node
var player_one_controller = -1
var player_two_controller = -1
func _ready():
	var joypad_ids = Input.get_connected_joypads()
	
	if(len(joypad_ids) >= 1):
		player_one_controller = joypad_ids[0]
	if(len(joypad_ids) >= 2):
		player_two_controller = joypad_ids[1]
	print("Player 1 controller:", player_one_controller)
	print("Player 2 controller:", player_two_controller)
	
	
	
func _input(event):
	
	if event.device == player_one_controller and player_one_controller != -1:
		if event is InputEventJoypadMotion:
			var strength = abs(event.axis_value)
			if event.is_action_pressed("controller_up"):
				Input.action_press("up_player_1",strength)
			if event.is_action_released("controller_up"):
				Input.action_release("up_player_1")
				
			if event.is_action_pressed("controller_down"):
				Input.action_press("down_player_1",strength)
			if event.is_action_released("controller_down"):
				Input.action_release("down_player_1")
				
			if event.is_action_pressed("controller_left"):
				Input.action_press("left_player_1",strength)
			if event.is_action_released("controller_left"):
				Input.action_release("left_player_1")
				
			if event.is_action_pressed("controller_right"):
				Input.action_press("right_player_1",strength)
			if event.is_action_released("controller_right"):
				Input.action_release("right_player_1")
	if event.device == player_two_controller and player_two_controller != -1:
		if event is InputEventJoypadMotion:
			var strength = abs(event.axis_value)
			if event.is_action_pressed("controller_up"):
				Input.action_press("up_player_2",strength)
			if event.is_action_released("controller_up"):
				Input.action_release("up_player_2")
				
			if event.is_action_pressed("controller_down"):
				Input.action_press("down_player_2",strength)
			if event.is_action_released("controller_down"):
				Input.action_release("down_player_2")
				
			if event.is_action_pressed("controller_left"):
				Input.action_press("left_player_2",strength)
			if event.is_action_released("controller_left"):
				Input.action_release("left_player_2")
				
			if event.is_action_pressed("controller_right"):
				Input.action_press("right_player_2",strength)
			if event.is_action_released("controller_right"):
				Input.action_release("right_player_2")
				
		if event.is_action_pressed("controller_accelerate"):
			print("accel")
			Input.action_press("accelerate")
		if event.is_action_released("controller_accelerate"):
			Input.action_release("accelerate")
			
		if event.is_action_pressed("controller_decelerate"):
			Input.action_press("decelerrate")
		if event.is_action_released("controller_decelerate"):
			Input.action_release("decelerrate")
