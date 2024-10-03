extends CharacterBody2D

var asteroids_in_your_area = {}
@export var max_speed = 500.0
@export var half_life = 0.3
var decay = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	decay = log(2)/half_life
	floor_stop_on_slope =false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
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
	
	var direction = Input.get_vector("left_player_2","right_player_2","up_player_2","down_player_2")
	velocity = max_speed*direction+(velocity - max_speed*direction)*exp(-delta*decay)
	
	move_and_slide()

func _on_forcefield_area_entered(area:Area2D):
	if(area.is_in_group("asteroid")):
		if asteroids_in_your_area.has(area):
			pass
		else:
			asteroids_in_your_area[area] = null

func _on_forcefield_area_exited(area):
	if asteroids_in_your_area.has(area):
		asteroids_in_your_area.erase(area)
