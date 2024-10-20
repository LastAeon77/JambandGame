extends AnimatableBody2D


var SPEED = 4.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.

func on_ready():
	position.x +=100


func _physics_process(delta):
	position.x += SPEED

func _on_area_2d_body_entered(body):
	if body.is_in_group("FLowerBorder"):
		SPEED = -SPEED
