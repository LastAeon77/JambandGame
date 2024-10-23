extends Path2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PathFollow2D/Blob.play("moving")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PathFollow2D.progress_ratio >=99:
		SignalBus.emit_signal("_flower_defeat")


func _on_timer_timeout():
	$PathFollow2D.progress_ratio+=0.001
