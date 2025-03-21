extends Node2D

var asteroid_block = load("res://scenes/asteroid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("_pause",pause)
	SignalBus.connect("_moon_gem_stage_restart", restart)
	if SignalBus.curr_difficulty == SignalBus.Difficulties.EASY:
		$Timer.wait_time = 1.0
	elif SignalBus.curr_difficulty == SignalBus.Difficulties.MEDIUM:
		$Timer.wait_time = 0.7
	elif SignalBus.curr_difficulty == SignalBus.Difficulties.HARD:
		$Timer.wait_time = 0.38
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_asteroid"):
		create_asteroid()


func create_asteroid():
	var camera :Camera2D = get_tree().get_first_node_in_group("camera")
	if not camera:
		pass
	var screen_size = get_viewport().get_visible_rect().size
	var zoom : Vector2 = camera.zoom
	var top_right = camera.position + (screen_size * Vector2(1/zoom.x,1/zoom.y)) / 2
	var bottom_right = camera.position + (screen_size * Vector2(1/zoom.x,1/zoom.y)) / 2
	bottom_right[1] = -bottom_right[1]
	var vector_to_top_right = top_right - position
	var vector_to_bottom_right = bottom_right - position
	vector_to_top_right = vector_to_top_right.normalized()
	vector_to_bottom_right = vector_to_bottom_right.normalized()
	var vector_backward = Vector2(-1,0)
	vector_backward = vector_backward.normalized()
	var starting_angle = acos(vector_backward.dot(vector_to_top_right))
	var dot_product = vector_to_top_right.dot(vector_to_bottom_right)
	var angle = acos(dot_product)
	angle = angle
	var temp = asteroid_block.instantiate()
	add_child(temp)
	temp.global_position = global_position
	temp.rotation = starting_angle - randf_range(0,angle)


func _on_timer_timeout():
	create_asteroid()
	if ($Timer.is_stopped()):
		$Timer.start()
		
func pause():
	if $Timer.is_stopped():
		$Timer.start()
		
func restart():
	if $Timer.is_stopped():
		$Timer.start()
	

