extends CharacterBody2D


@export var speed: int = 300.0
@export var acceleration = 2.0

var health = 20

var follow_tolerance: int = 15
var magnetic_ship: CharacterBody2D


func _ready():
	magnetic_ship = get_tree().get_first_node_in_group("Magnetic")
	SignalBus.connect("_game_lost", ship_destroyed) 
	$HealthBar.max_value = health
	$HealthBar.min_value = 0
	$HealthBar.value = $HealthBar.max_value


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
	
func damaged():
	$HealthBar.value -= 10
	if $HealthBar.value<=0:
		SignalBus.emit_signal("_game_lost")
	
func ship_destroyed():
	print("You lost!")


func _on_area_2d_area_entered(area:Area2D):
	if area.is_in_group("asteroid"):
		damaged()
