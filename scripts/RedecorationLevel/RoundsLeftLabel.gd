extends Label
@onready var gameboard = %GameBoard

func _process(delta):
	if gameboard.rounds_left == 1:
		text = "%d round left!" % gameboard.rounds_left
	else:
		text = "%d rounds left!" % gameboard.rounds_left
