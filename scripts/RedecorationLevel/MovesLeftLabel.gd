extends Label

var current_player = null

func _process(delta):
	if current_player != null:
		if current_player.movement_left != 1:
			text = "%d moves left!" % current_player.movement_left
		else:
			text = "%d move left!" % current_player.movement_left
	else:
		text = ""
