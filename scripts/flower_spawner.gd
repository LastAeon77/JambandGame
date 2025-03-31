extends Area2D
@onready var timer = $Timer 
var pink_flower = preload("res://scenes/pink_flower.tscn")
var white_flower = preload("res://scenes/white_flower.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.EASY):
		timer.wait_time = 10.0
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.MEDIUM):
		timer.wait_time = 15.0
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.HARD):
		timer.wait_time = 20.0
	timer.wait_time += randf()/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var empty_area = get_overlapping_areas().is_empty()
	
	if get_overlapping_areas().is_empty() and timer.is_stopped():
		timer.start()

signal flower_spawned(flower : Node2D);

func _on_timer_timeout():
	if get_overlapping_areas().is_empty():
		var first_value = bool(randi() % 2)
		var flower_instance
		if first_value:
			flower_instance = pink_flower.instantiate()
			add_child(flower_instance)
			flower_instance.global_position = global_position
		else:
			flower_instance = white_flower.instantiate()
			add_child(flower_instance)
			flower_instance.global_position = global_position
		flower_spawned.emit(flower_instance)

