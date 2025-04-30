extends Path2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PathFollow2D/Blob.play("moving")
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.EASY):
		$Timer.wait_time = 0.16
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.MEDIUM):
		$Timer.wait_time = 0.12
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.HARD):
		$Timer.wait_time = 0.09

var check1 = false;
var check2 = false;
var check3 = false;
var check4 = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PathFollow2D.progress_ratio >= 0.99:
		%AudioStreamPlayer2D.stop()
		SignalBus.emit_signal("_flower_defeat")
		
	if $PathFollow2D.progress_ratio >= 0.2289 and not check1:
		$PathFollow2D/Blob.scale.y = $PathFollow2D/Blob.scale.y * -1
		check1 = true
		
	if $PathFollow2D.progress_ratio >= 0.3795 and not check2:
		$PathFollow2D/Blob.scale.y = $PathFollow2D/Blob.scale.y * -1
		check2 = true
	if $PathFollow2D.progress_ratio >= 0.5576 and not check3:
		$PathFollow2D/Blob.scale.y = $PathFollow2D/Blob.scale.y * -1
		check3 = true
	if $PathFollow2D.progress_ratio >= 0.8468 and not check4:
		$PathFollow2D/Blob.scale.y = $PathFollow2D/Blob.scale.y * -1
		check4 = true
	
	$TextureRect.modulate = Color.from_hsv(0,0,1 - $PathFollow2D.progress_ratio)
	


func _on_timer_timeout():
	if $PathFollow2D.progress_ratio < .991:
		$PathFollow2D.progress_ratio+=0.001
