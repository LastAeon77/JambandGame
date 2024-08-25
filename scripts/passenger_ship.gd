extends CharacterBody2D


@export var speed: int = 300.0
@export var acceleration = 2.0

var follow_tolerance: int = 15
var magnetic_ship: CharacterBody2D


func _ready():
	magnetic_ship = get_tree().get_first_node_in_group("Magnetic")


func _process(delta):
	var direction: Vector2
	
	var y_diff = magnetic_ship.global_position.y - global_position.y
	if abs(y_diff) > follow_tolerance:
		direction.y = y_diff
	else:
		direction.y = 0
	direction = direction.normalized()
	
	velocity = lerp(velocity, direction * speed, delta * acceleration)
	#for non-slippery movement
	#velocity = direction * speed 

	move_and_slide()
