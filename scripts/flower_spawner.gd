extends Area2D

var pink_flower = preload("res://scenes/pink_flower.tscn")
var white_flower = preload("res://scenes/white_flower.tscn")
var has_flower: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.EASY):
		$Timer.wait_time = 10
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.MEDIUM):
		$Timer.wait_time = 15
	if(SignalBus.curr_difficulty == SignalBus.Difficulties.HARD):
		$Timer.wait_time = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

