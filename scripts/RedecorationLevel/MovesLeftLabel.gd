extends Label

var current_player = null

func _process(delta):
	if current_player != null:
		text = "%d" % current_player.movement_left
	else:
		text = ""
