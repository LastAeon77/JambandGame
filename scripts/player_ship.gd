extends CharacterBody2D


@export var speed: int = 500.0
@export var acceleration = 3.0

func _ready():
	$ShipSpriteAnimated.play("default")
	floor_stop_on_slope =false


func _process(delta):
	var direction: Vector2
	
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	
	velocity = lerp(velocity, direction * speed, delta * acceleration)
	#for non-slippery movement
	#velocity = direction * speed 

	move_and_slide()
