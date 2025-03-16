extends Label
@export var player : int = 1
var player_node : Node
func _ready():
	if player == 1:
		player_node = %RedecorationPlayer1
	else:
		player_node = %RedecorationPlayer2

func _process(delta):
	var temp
	if player == 1:
		temp = "Player 1 inventory:\n"
	else:
		temp = "Player 2 inventory:\n"
	if player_node.held_object == null:
		temp = temp + "Empty"
	else:
		temp = temp + player_node.held_object.name
	text = temp
	
