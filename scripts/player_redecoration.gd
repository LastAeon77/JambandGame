extends AnimatedSprite2D
class_name RedecorationPlayer

@export var tilemap_position : Vector2i
var final_position : Vector2i
@export var move_time : float = 0.1
var facing_direction : GameBoard.Direction = GameBoard.Direction.SW
var move_timer : Timer
func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	
func move(path):
	for point in path:
		move_timer.start()
		await move_timer.timeout
		tilemap_position = point
