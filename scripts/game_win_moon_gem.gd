extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	SignalBus.connect("_game_lost",game_lost)
	SignalBus.connect("_moon_gem_stage_clear",game_win)
	SignalBus.connect("_moon_gem_stage_restart",restart)


func _process(_delta):
	if Input.is_action_just_pressed("submit"):
		if ($WinScreen.visible==true):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func game_win():
	$WinScreen.visible = true


func game_lost():
	pass

func restart():
	$WinScreen.visible = false

