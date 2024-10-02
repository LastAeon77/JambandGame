extends PathFollow2D


var speed = 0.008
var resume = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	SignalBus.connect("_moon_gem_stage_restart",restart)
	SignalBus.connect("_pause",pause_function)

func _physics_process(delta):
	if resume:
		progress_ratio = min(progress_ratio + delta * speed,1)
	if progress_ratio >=1:
		SignalBus.emit_signal("_moon_gem_stage_clear")
		

	
func restart():
	progress_ratio = 0
	
func pause_function():
	resume = !resume
	
