extends PathFollow2D


var speed = 0.008
var resume = true
var triggers = [0.1,0.12,0.15]
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	SignalBus.connect("_moon_gem_stage_restart",restart)
	SignalBus.emit_signal("_moon_gem_stage_restart")

func _physics_process(delta):
	if triggers:
		if progress_ratio > triggers[0]:
			triggers.pop_front()
			SignalBus.emit_signal("_moon_story_next")
		
	if resume:
		progress_ratio = min(progress_ratio + delta * speed,1)
		$WorldBoundries/ProgressBar.value = progress_ratio*100
	if progress_ratio >=1:
		SignalBus.emit_signal("_moon_gem_stage_clear")
		
func restart():
	progress_ratio = 0
	
	
