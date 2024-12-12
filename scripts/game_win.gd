extends Control

var self_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
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


func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("right_player_1") or Input.is_action_just_pressed(("right_player_2")):
		print($TryAgain.visible)
		print($MainMenu.visible)
		if($TryAgain.visible == false && $MainMenu.visible == true):
			print("hi")
			$TryAgain.visible = true
			$MainMenu.visible = false
	if Input.is_action_just_pressed("left_player_1") or Input.is_action_just_pressed(("left_player_2")):
		print($TryAgain.visible)
		print($MainMenu.visible)
		if($MainMenu.visible == false && $TryAgain.visible == true):
			print("hi2")
			$TryAgain.visible = false
			$MainMenu.visible = true
	
	if Input.is_action_just_pressed("submit"):
		if($TryAgain.visible==true):
			get_tree().reload_current_scene()
		elif($MainMenu.visible==true):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif($WinScreen.visible==true):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
func game_win():
	print("you win the flower!")
	$WinScreen.visible = true
	print($WinScreen.visible)


func game_lost():
	pass

func flower_defeat():
	if(!self_visible):
		$TryAgain.visible = true
		self_visible = true

func restart():
	$WinScreen.visible = false
