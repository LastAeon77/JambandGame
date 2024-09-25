extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("_moon_gem_stage_clear",game_win)


func game_win():
	print("win!!!!")
	visible = true
