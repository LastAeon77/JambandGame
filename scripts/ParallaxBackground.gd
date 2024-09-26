extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
var velocity = 3.3
var moon_gem_clear = false
var up_vector = Vector2(0,-1)
var down_vector = Vector2(0,1)
var curr_vector = up_vector

func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset -= Vector2(velocity,0)
	scroll_base_offset +=curr_vector
	if scroll_base_offset.y >100:
		curr_vector = up_vector
	if scroll_base_offset.y < -100:
		curr_vector = down_vector
	
	if scroll_base_offset.x < -1735 and not moon_gem_clear:
		moon_gem_clear = true
		SignalBus.emit_signal("_moon_gem_stage_clear")
		velocity = 0



#func _on_area_2d_area_entered(area):
	#var curr_area :Area2D = area
	#if area.is_in_group("passengerShip"):
		#SignalBus.emit_signal("_moon_gem_stage_clear")
		#velocity = 0
		#scroll_base_offset = Vector2(0,0)
#
