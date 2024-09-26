extends PathFollow2D


var speed = 0.1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	progress_ratio = min(progress_ratio + delta * speed,1)
	print(progress_ratio)
	if progress_ratio >=1:
		print("win")
		SignalBus.emit_signal("_moon_gem_stage_clear")
	
