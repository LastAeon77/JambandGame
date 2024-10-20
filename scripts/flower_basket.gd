extends Area2D

var victory_amount = 2
var current_amount = 0
func _ready():
	current_amount = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("pixie"):
		fill_basket(body.flower_drop())
	print(current_amount)
		

func fill_basket(num:int):
	current_amount += num
	if current_amount > victory_amount:
		SignalBus.emit_signal("_flower_victory")

