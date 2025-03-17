extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	SignalBus.connect("_redecoration_defeat",game_lost)
	SignalBus.connect("_redecoration_victory",game_win)
	SignalBus._controller_unplugged.connect(_on_controller_unplugged)
	if SignalBus.get_redecoration_first():
		$Pause_Continue.visible = true
		SignalBus.set_redecoration_first(false)
		get_tree().paused = true

func _process(_delta):
	if Input.is_action_just_pressed("start_player_1") or Input.is_action_just_pressed("start_player_2"):
		get_tree().paused = true
		$Pause_Continue.visible = true
	
	elif Input.is_action_just_pressed("right_player_1") or Input.is_action_just_pressed(("right_player_2")):
		if($TryAgain.visible == false && $MainMenu.visible == true):
			$TryAgain.visible = true
			$MainMenu.visible = false
		elif($Pause_Continue.visible == false && $Pause_MainMenu.visible == true):
			$Pause_Continue.visible = true
			$Pause_MainMenu.visible = false
	elif Input.is_action_just_pressed("left_player_1") or Input.is_action_just_pressed(("left_player_2")):
		if($MainMenu.visible == false && $TryAgain.visible == true):
			$TryAgain.visible = false
			$MainMenu.visible = true
		elif($Pause_MainMenu.visible == false && $Pause_Continue.visible == true):
			$Pause_Continue.visible = false
			$Pause_MainMenu.visible = true
			
	elif Input.is_action_just_pressed("submit"):
		if($TryAgain.visible==true):
			get_tree().paused = false
			get_tree().reload_current_scene()
		elif($MainMenu.visible==true):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif($WinScreen.visible==true):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif($Pause_Continue.visible == true):
			$Pause_MainMenu.visible = false
			$Pause_Continue.visible = false
			get_tree().paused = false
		elif($Pause_MainMenu.visible == true):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func game_win():
	$WinScreen.visible = true

func game_lost():
	get_tree().paused = true
	$TryAgain.visible=true

func restart():
	$WinScreen.visible = false
	
func _on_controller_unplugged():
	get_tree().paused = true
	$Pause_Continue.visible = true
