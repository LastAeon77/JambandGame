extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	SignalBus.connect("_flower_victory",game_win)
	SignalBus.connect("_game_lost",game_lost)
	SignalBus.connect("_flower_defeat",flower_defeat)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("right_player_1") or Input.is_action_just_pressed(("right_player_2")):
		if($TryAgain.visible == false && $MainMenu.visible == true):
			print("hi")
			$TryAgain.visible = false
			$MainMenu.visible = true
	if Input.is_action_just_pressed("left_player_1") or Input.is_action_just_pressed(("left_player_2")):
		if($MainMenu.visible == false && $TryAgain.visible == true):
			print("hi2")
			$TryAgain.visible = true
			$MainMenu.visible = false
	
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
	$TryAgain.visible = true

func restart():
	$WinScreen.visible = false
