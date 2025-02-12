extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$Pause_Continue.visible = true

