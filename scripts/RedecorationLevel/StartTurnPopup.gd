extends PanelContainer
@onready var label = $StartTurnPopupLabel
func _ready():
	SignalBus._action_taken.connect(_on_action_taken)
	
func set_turn(turn):
	if turn % 3 == 1:
		visible = true
		label.text = "Player 1's turn!"
	elif turn % 3 == 2: 
		visible = true
		label.text = "Player 2's turn!"
	else:
		visible = false

func _on_action_taken():
	visible = false
