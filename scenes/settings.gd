extends Control
var difficulities = 3
var curr_highlight
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Easy.visible = false
	$Medium.visible = false
	$Hard.visible = false
	if SignalBus.curr_difficulty == SignalBus.Difficulties.EASY:
		$Easy.visible = true
		curr_highlight = 0
	if SignalBus.curr_difficulty == SignalBus.Difficulties.MEDIUM:
		$Medium.visible = true
		curr_highlight = 1
	if SignalBus.curr_difficulty == SignalBus.Difficulties.HARD:
		$Hard.visible = true
		curr_highlight = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_player_1") or Input.is_action_just_pressed("left_player_2"):
		if curr_highlight == -1:
			curr_highlight = 0
		else:
			curr_highlight = max(0,curr_highlight-1)
		highlight_image(curr_highlight)
	if Input.is_action_just_pressed("right_player_1") or Input.is_action_just_pressed("right_player_2"):
		if curr_highlight == -1:
			curr_highlight = 0
		else:
			curr_highlight = min(difficulities-1,curr_highlight+1)
		highlight_image(curr_highlight)
	
	if Input.is_action_just_pressed("button_1_player_1"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if Input.is_action_just_pressed("button_1_player_2"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func highlight_image(index):
	$Easy.visible = false
	$Medium.visible = false
	$Hard.visible = false
	if index == 0:
		SignalBus.change_difficulty(SignalBus.Difficulties.EASY)
		$Easy.visible = true
	if index == 1:
		SignalBus.change_difficulty(SignalBus.Difficulties.MEDIUM)
		$Medium.visible = true
	if index == 2:
		SignalBus.change_difficulty(SignalBus.Difficulties.HARD)
		$Hard.visible = true
