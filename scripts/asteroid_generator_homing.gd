extends Node2D

var asteroid_block = load("res://scenes/asteroid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("_pause",pause)
	SignalBus.connect("_moon_gem_stage_restart", restart)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_asteroid"):
		create_asteroid()


func create_asteroid():
	if get_tree().get_first_node_in_group("passengerShip"):
		var ship = get_tree().get_first_node_in_group("passengerShip")
		var direction = global_position.direction_to(get_tree().get_first_node_in_group("passengerShip").global_position)
		var temp = asteroid_block.instantiate()
		temp.set_initial_vector(direction)
		temp.set_speed(400)
		add_child(temp)
		temp.global_position = global_position
	


func _on_timer_timeout():
	create_asteroid()
	if ($Timer.is_stopped()):
		$Timer.start()
		
func pause():
	if $Timer.is_stopped():
		$Timer.start()
	else:
		$Timer.stop()
		
func restart():
	if $Timer.is_stopped():
		$Timer.start()
	else:
		$Timer.stop()
	

