extends CharacterBody2D
@export var flower_spawner : Node2D
@export var aggro_distance: float = 200.0
@export var unaggro_distance: float = 300.0
@export var aggro_cooldown: float = 2.0
@export var wander_distance : float = 100
@export var wander_min_distance : float = 50
@export var angry_speed = 200
@export var return_speed = 100
@export var wander_speed = 50

@onready var aggro_cooldown_timer: Timer = $CooldownTimer
@onready var navigation_agent :NavigationAgent2D = $NavigationAgent2D
@onready var spawn_point : Vector2
@onready var death_animation :AnimationPlayer = $AnimationPlayer

var pixies
var angry : bool = false
var navigation_is_ready : bool = false
var animation :AnimatedSprite2D
var target : Node2D
func _ready():
	pixies = get_tree().get_nodes_in_group("pixie")
	visible = false
	animation = $AnimatedSprite2D
	animation.play("default")
	aggro_cooldown_timer.wait_time = aggro_cooldown
	spawn_point = flower_spawner.global_position
	if(flower_spawner != null && flower_spawner.has_signal("flower_spawned")):
		flower_spawner.connect("flower_spawned", on_flower_spawned)
		print("signal connected")
	navigation_agent.target_position = spawn_point
func _physics_process(_delta):
	for pixie in pixies:
		if(global_position.distance_to(pixie.global_position) < aggro_distance && aggro_cooldown_timer.is_stopped()):
			begin_aggression(pixie)
	
	if(navigation_is_ready):
		var current_speed = wander_speed
		velocity = Vector2.ZERO
		if(angry && navigation_agent.distance_to_target() > unaggro_distance):
				end_aggression()
		if(angry):
			current_speed = angry_speed
			navigation_agent.target_position = target.position
		else:
			if(navigation_agent.is_target_reached() && global_position.distance_to(spawn_point) < wander_distance):
				while (true):
					var random_distance = randf() * wander_distance
					var random_angle = randf() * 2 * PI
					var offset = random_distance * Vector2(cos(random_angle), sin(random_angle))
					navigation_agent.target_position = spawn_point + offset
					if(navigation_agent.is_target_reachable() && global_position.distance_to(navigation_agent.target_position) > wander_min_distance):
						break
			elif(global_position.distance_to(spawn_point) >= wander_distance):
				navigation_agent.target_position = spawn_point
				current_speed = return_speed
		if(!navigation_agent.is_target_reached()):
			velocity = global_position.direction_to( navigation_agent.get_next_path_position()) * current_speed

	navigation_is_ready = true
	animation.flip_h = velocity.x < 0
	move_and_slide()



func on_flower_spawned(spawned_flower : Node2D):
	death_animation.stop()
	queue_visibility_on()
	spawned_flower.connect("tree_exited", on_flower_picked_up)
	print("flower spawned")
func begin_aggression(new_target: Node2D):
	
	animation.play("sting")
	target = new_target
	if(! angry):
		$CollisionShape2D.transform = $CollisionShape2D.transform.rotated(-PI/2)
		$Area2D.transform = $Area2D.transform.rotated(-PI/2)
	angry = true
	
func end_aggression():
	
	animation.play("default")
	if(angry):
		$CollisionShape2D.transform = $CollisionShape2D.transform.rotated(PI/2)
		$Area2D.transform = $Area2D.transform.rotated(PI/2)
	angry = false
func queue_visibility_on():
	if(death_animation.is_playing()):
		death_animation.connect("animation_finished", visibility_on)
	else:
		visible = true

func visibility_on():
	visible = true
	death_animation.disconnect("animation_finished", visibility_on)
func on_flower_picked_up():
	target = null
	death_animation.play("delete")
	end_aggression()
	await death_animation.animation_finished
	visible = false
	global_position = spawn_point


func _on_area_2d_body_entered(body:Node2D):
	if(body.is_in_group("pixie")):
		end_aggression()
		aggro_cooldown_timer.start()
