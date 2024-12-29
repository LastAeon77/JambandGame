extends CharacterBody2D


@export var speed = 300.0
@export var acceleration = 2.0

var health = 100

var follow_tolerance = 15
var magnetic_ship: CharacterBody2D


func _ready():
	magnetic_ship = get_tree().get_first_node_in_group("Magnetic")
	SignalBus.connect("_game_lost", ship_destroyed) 
	SignalBus.connect("_moon_gem_stage_restart",restart)
	$HealthBar.max_value = health
	$HealthBar.min_value = 0
	$HealthBar.value = $HealthBar.max_value


func _physics_process(delta):
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
		$ShipSprite.play("get_hit")
		SignalBus.emit_signal("_game_lost")
		SignalBus.emit_signal("_pause")
	
func ship_destroyed():
	print("You lost!")


func _on_area_2d_area_entered(area:Area2D):
	if area.is_in_group("asteroid"):
		damaged()
		
func restart():
	$ShipSprite.play("default")
	$HealthBar.value = $HealthBar.max_value
		

func _on_ship_sprite_animation_finished():
	if $ShipSprite.animation == "get_hit":
		SignalBus.emit_signal("_moon_gem_stage_restart")
