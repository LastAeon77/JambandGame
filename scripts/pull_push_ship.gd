extends CharacterBody2D

var asteroids_in_your_area = {}
var speed: int = 500.0
var acceleration = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("accelerate"):
		$AnimatedSprite2D.play("accel")
		for key in asteroids_in_your_area:
			if key.has_method("speed_up"):
				key.speed_up()
	if Input.is_action_just_pressed("decelerrate"):
		$AnimatedSprite2D.play("deccel")
		for key in asteroids_in_your_area:
			if key.has_method("slow_down"):
				key.slow_down()
	
	if Input.is_action_pressed("down_player_2"):
		position.y+=10
	if Input.is_action_pressed("up_player_2"):
		position.y-=10		
	if Input.is_action_pressed("right_player_2"):
		position.x+=10
	if Input.is_action_pressed("left_player_2"):
		position.x-=10

func _on_forcefield_area_entered(area:Area2D):
	if(area.is_in_group("asteroid")):
		if asteroids_in_your_area.has(area):
			pass
		else:
			asteroids_in_your_area[area] = null

func _on_forcefield_area_exited(area):
	if asteroids_in_your_area.has(area):
		asteroids_in_your_area.erase(area)

