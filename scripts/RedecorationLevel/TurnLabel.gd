extends Label

func set_turn(turn):
	if turn % 3 == 0:
		text = "Mr. Blob's turn!"
	elif turn % 3 == 1: 
		text = "Player 1's turn!"
	else:
		text = "Player 2's turn!"

