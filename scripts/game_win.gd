extends Control

var self_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	SignalBus.connect("_flower_victory",game_win)
	SignalBus.connect("_game_lost",game_lost)
	SignalBus.connect("_flower_defeat",flower_defeat)
	SignalBus.connect("_moon_gem_stage_clear",game_win)
	SignalBus.connect("_moon_gem_stage_restart",restart)
	$WinScreen.visible = false
	$MainMenu.visible = false
	$MainMenu.visible = false
	$TryAgain.visible = false
	$Pause_Continue.visible = false
	$Pause_MainMenu.visible = false


func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
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
			get_tree().reload_current_scene()
		elif($MainMenu.visible==true):
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
			
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Pause_Continue.visible = true
		
func game_win():
	$WinScreen.visible = true


func game_lost():
	pass

func flower_defeat():
	if(!self_visible):
		$TryAgain.visible = true
		self_visible = true

func restart():
	$WinScreen.visible = false
	
	
