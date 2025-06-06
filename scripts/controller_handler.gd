extends Node
var player_one_controller = -1
var player_two_controller = -1
func _ready():
	var joypad_ids = Input.get_connected_joypads()
	

	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
func _on_joy_connection_changed(id, connected):
	print(Input.get_connected_joypads())
	if len(Input.get_connected_joypads()) > 0:
		player_one_controller = Input.get_connected_joypads()[0]
	else:
		player_one_controller = -1
	if len(Input.get_connected_joypads()) > 1:
		player_two_controller = Input.get_connected_joypads()[1]
	else:
		player_two_controller = -1
		
func _input(event):
	if event.device == player_one_controller and player_one_controller != -1:
		var strength = 1.0
		if event is InputEventJoypadMotion:
			strength = abs(event.axis_value)
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
			
		if event.is_action_pressed("controller_button_1"):
			Input.action_press("button_2_player_1")
		if event.is_action_released("controller_button_1"):	
			Input.action_release("button_2_player_1")
		
		if event.is_action_pressed("controller_button_2"):
			Input.action_press("button_1_player_1")
		if event.is_action_released("controller_button_2"):
			Input.action_release("button_1_player_1")
			
		if event.is_action_pressed("controller_select"):
			Input.action_press("select_player_1")
		if event.is_action_released("controller_select"):
			Input.action_release("select_player_1")
		
		if event.is_action_pressed("controller_start"):
			Input.action_press("start_player_1")
		if event.is_action_released("controller_start"):
			Input.action_release("start_player_1")
	if event.device == player_two_controller and player_two_controller != -1:
		var strength = 1.0
		if event is InputEventJoypadMotion:
			strength = abs(event.axis_value)
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
				
		if event.is_action_pressed("controller_button_1"):
			Input.action_press("button_2_player_2")
		if event.is_action_released("controller_button_1"):
			Input.action_release("button_2_player_2")
			
		if event.is_action_pressed("controller_button_2"):
			Input.action_press("button_1_player_2")
		if event.is_action_released("controller_button_2"):
			Input.action_release("button_1_player_2")
		
		if event.is_action_pressed("controller_select"):
			Input.action_press("select_player_2")
		if event.is_action_released("controller_select"):
			Input.action_release("select_player_2")
			
		if event.is_action_pressed("controller_start"):
			Input.action_press("start_player_2")
			print("player 2 start")
		if event.is_action_released("controller_start"):
			Input.action_release("start_player_2")
