extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
var velocity = 3.3
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset -= Vector2(velocity,0)
	if scroll_base_offset.x < -1735:
		SignalBus.emit_signal("_moon_gem_stage_clear")
		velocity = 0



#func _on_area_2d_area_entered(area):
	#var curr_area :Area2D = area
	#if area.is_in_group("passengerShip"):
		#SignalBus.emit_signal("_moon_gem_stage_clear")
		#velocity = 0
		#scroll_base_offset = Vector2(0,0)
#
