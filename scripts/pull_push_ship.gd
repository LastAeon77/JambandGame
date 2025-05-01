extends CharacterBody2D

var asteroids_in_your_area = {}
@export var max_speed = 600.0
@export var half_life = 0.2
var decay = 0
# Called when the node enters the scene tree for the first time.
var cooldown: bool = false
var past_delta = 10
func _ready():
	decay = log(2)/half_life
	floor_stop_on_slope =false
	$AnimatedSprite2D.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	
	if not cooldown:
		if Input.is_action_just_pressed("button_1_player_2"):
			$AttractSound.play()
			$AnimatedSprite2D.play("accel")
			for key in asteroids_in_your_area:
				if key.has_method("speed_up"):
					key.speed_up()
			cooldown = true
			past_delta = 1.40
		if Input.is_action_just_pressed("button_2_player_2"):
			$AnimatedSprite2D.play("deccel")
			$AttractSound.play()
			for key in asteroids_in_your_area:
				if key.has_method("slow_down"):
					key.slow_down()
			cooldown = true
			past_delta = 1.40

	else:
		pass
	if cooldown:
		past_delta-=delta
		if past_delta <0:
			cooldown = false
			$AnimatedSprite2D.play("default")
	
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
