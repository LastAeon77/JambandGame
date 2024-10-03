extends Area2D

var movement_vector := Vector2(-1,0)
var speed: int = 220
var prev_speed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	#rotation = randf_range(0,2*PI)
	rotation = 0
	SignalBus.connect("_pause",pause)
	SignalBus.connect("_moon_gem_stage_restart", restart)
	SignalBus.connect("_moon_gem_stage_clear",restart)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += movement_vector.rotated(rotation) * speed * delta
	if global_position.x < -1000:
		queue_free()

	
func set_initial_vector(new_vector):
	movement_vector = new_vector
	

func set_speed(new_speed):
	speed = new_speed

func on_ready(rotate):
	rotation = rotate

func speed_up():
	speed *=1.5
	speed = max(100,speed)
	
func slow_down():
	speed*=0.5
	speed = max(1,speed)

func pause():
	if prev_speed ==0:
		prev_speed = speed
		speed = 0
	else:
		speed = prev_speed
		prev_speed = 0

func restart():
	queue_free()
