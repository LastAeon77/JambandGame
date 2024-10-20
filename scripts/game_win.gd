extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	$WinScreen.visible = false
	$Pause.visible = false
	SignalBus.connect("_moon_gem_stage_clear",game_win)
	SignalBus.connect("_flower_victory",game_win)
	SignalBus.connect("_game_lost",game_lost)
	SignalBus.connect("_moon_gem_stage_restart",restart)


func game_win():
	$WinScreen.visible = true
	
func game_lost():
	pass
	
func restart():
	$WinScreen.visible = false
