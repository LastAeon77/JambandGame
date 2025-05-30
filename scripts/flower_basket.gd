extends Area2D

var victory_amount = 12
var current_amount = 0
var padding = ""
func _ready():
	if current_amount < 10:
		padding = " "
	else:
		padding = ""
	$RichTextLabel.text = "%s%s/%s" % [padding,str(current_amount),str(victory_amount)]
	current_amount = 0
	$AnimatedSprite2D.play("0")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: CharacterBody2D):
	if body.is_in_group("pixie"):
		fill_basket(body.flower_drop())
	var padding = ""
	if current_amount < 10:
		padding = " "
	else:
		padding = ""
	$RichTextLabel.text = "%s%s/%s" % [padding,str(current_amount),str(victory_amount)]
		

func fill_basket(num:int):
	current_amount += num
	$AnimatedSprite2D.play(str(min(current_amount,12)))
	if current_amount >= victory_amount:
		%AudioStreamPlayer2D.stop()
		SignalBus.emit_signal("_flower_victory")


