extends CharacterBody2D


@export var max_speed: int = 500.0
@export var half_life = 0.3
var decay = 0

func _ready():
	$ShipSpriteAnimated.play("default")
	floor_stop_on_slope =false
	decay = log(2)/half_life

func _physics_process(delta):
	
	var direction = Input.get_vector("left_player_1","right_player_1","up_player_1","down_player_1")
	direction.x = 0
	velocity = max_speed*direction+(velocity - max_speed*direction)*exp(-delta*decay)
	
	
	#for non-slippery movement
	#velocity = direction * speed 

	move_and_slide()
