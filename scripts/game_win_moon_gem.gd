extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	SignalBus.connect("_game_lost",game_lost)
	SignalBus.connect("_moon_gem_stage_clear",game_win)
	SignalBus.connect("_moon_gem_stage_restart",restart)
	SignalBus._controller_unplugged.connect(_on_controller_unplugged)
	if SignalBus.get_moon_first():
		get_tree().paused = true
		$Pause_Continue.visible = true
		SignalBus.set_moon_first(false)


func _process(_delta):
	if Input.is_action_just_pressed("start_player_1") or Input.is_action_just_pressed("start_player_2"):
		get_tree().paused = true
		$Pause_Continue.visible = true
	if Input.is_action_just_pressed("submit"):
		if ($WinScreen.visible==true):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			
	if Input.is_action_just_pressed("right_player_1") or Input.is_action_just_pressed(("right_player_2")):
		if($TryAgain.visible == false && $MainMenu.visible == true):
			$TryAgain.visible = true
			$MainMenu.visible = false
		if($Pause_Continue.visible == false && $Pause_MainMenu.visible == true):
			$Pause_Continue.visible = true
			$Pause_MainMenu.visible = false
	if Input.is_action_just_pressed("left_player_1") or Input.is_action_just_pressed(("left_player_2")):
		if($MainMenu.visible == false && $TryAgain.visible == true):
			$TryAgain.visible = false
			$MainMenu.visible = true
		if($Pause_MainMenu.visible == false && $Pause_Continue.visible == true):
			$Pause_Continue.visible = false
			$Pause_MainMenu.visible = true
			
	if Input.is_action_just_pressed("submit"):
		if($TryAgain.visible==true):
			get_tree().paused = false
			get_tree().reload_current_scene()
		elif($MainMenu.visible==true):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif($Pause_Continue.visible == true):
			$Pause_MainMenu.visible = false
			$Pause_Continue.visible = false
			get_tree().paused = false
		elif($Pause_MainMenu.visible == true):
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func game_win():
	get_tree().paused = true
	$WinScreen.visible = true


func game_lost():
	get_tree().paused = true
	$TryAgain.visible = true

func restart():
	$WinScreen.visible = false
	
func _on_controller_unplugged():
	get_tree().paused = true
	$Pause_Continue.visible = true


