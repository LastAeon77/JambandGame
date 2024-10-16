extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 10
var carrying_flower = 0

func _physics_process(delta):
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.play("default")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			$AnimatedSprite2D.scale.x = -abs($AnimatedSprite2D.scale.x)
		elif direction == 1:
			$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func flower_num():
	return carrying_flower

func damaged():
	$HealthBar.value -=10
