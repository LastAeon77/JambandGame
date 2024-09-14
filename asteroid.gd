extends Area2D

var movement_vector := Vector2(-1,0)
var speed: int = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	#rotation = randf_range(0,2*PI)
	rotation = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += movement_vector.rotated(rotation) * speed * delta
	# TODO: Check if asteroid is too high or low and queue free it.
	
func on_ready(rotate):
	rotation = rotate

func speed_up():
	speed *=1.5
	
func slow_down():
	speed*=0.5

func _on_area_entered(area):
	#queue_free()
	pass
