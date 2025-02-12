extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 10
var carrying_flower = 0
var max_capacity = 3
var pickup_playing : bool = false

@onready var stung_timer : Timer = $StungTimer 
func _ready():
	stung_timer.stop()
	
func _physics_process(delta):
	if stung_timer.is_stopped():
		if not is_on_floor():
			velocity.y += gravity * delta
		if not pickup_playing:
			if velocity.x != 0 or velocity.y != 0:
				if(carrying_flower <= 0):
					$AnimatedSprite2D.play("default")
				else:
					$AnimatedSprite2D.play("default_flower")
			# Handle jump.
		if Input.is_action_just_pressed("up_player_1") and is_on_floor():
			velocity.y = JUMP_VELOCITY/(carrying_flower/3+1)

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left_player_1", "right_player_1")
		if direction:
			#if direction == -1:
				#$AnimatedSprite2D.scale.x = -abs($AnimatedSprite2D.scale.x)
			#elif direction == 1:
				#$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)
			velocity.x = direction * (SPEED/(carrying_flower/3+1))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/(carrying_flower/3+1))
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO
		if not $AnimatedSprite2D.is_playing() || $AnimatedSprite2D.animation != "stung":
			$AnimatedSprite2D.play("stung")
		carrying_flower = 0
		
	move_and_slide()

func flower_drop():
	if carrying_flower <= 0:
		return carrying_flower
	else:
		var temp = carrying_flower
		carrying_flower = 0
		return temp

func damaged():
	$HealthBar.value -=10
	
func pick_flower():
	pickup_playing = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("flower_pickup")
	velocity.x = 0
	velocity.y = 0
	if carrying_flower >= max_capacity:
		pass
	else:
		carrying_flower+=1


func _on_area_2d_area_entered(area : Area2D):
	if area.is_in_group("flower"):
		pick_flower()
		area.queue_free()
	if area.is_in_group("bee"):
		stung_timer.start()
		pickup_playing = false

func _on_animated_sprite_2d_animation_finished():
	if not $AnimatedSprite2D.is_playing():
		pickup_playing = false
