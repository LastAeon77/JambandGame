extends Node2D

var asteroids_in_your_area = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("accelerate"):
		for key in asteroids_in_your_area:
			key.speed_up()
	if Input.is_action_just_pressed("decelerrate"):
		for key in asteroids_in_your_area:
			key.slow_down()
	pass


func _on_forcefield_area_entered(area:Area2D):
	if asteroids_in_your_area.has(area):
		pass
	else:
		asteroids_in_your_area[area] = null

func _on_forcefield_area_exited(area):
	if asteroids_in_your_area.has(area):
		asteroids_in_your_area.erase(area)

