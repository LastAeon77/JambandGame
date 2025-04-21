extends Label
@onready var gameboard = %GameBoard

func _process(delta):
	text = "%d" % gameboard.rounds_left
