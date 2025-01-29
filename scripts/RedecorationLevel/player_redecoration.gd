extends AnimatedSprite2D
class_name RedecorationPlayer

var max_movement = 5
@export var tilemap_position : Vector2i
var final_position : Vector2i
var held_object
@export var move_time : float = 0.1
var facing_direction : GameBoard.Direction = GameBoard.Direction.NW
var move_timer : Timer
var moving = false
func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	final_position = tilemap_position
	
func move(path,directions):
	final_position = path[len(path)-1]
	moving = true
	for i in range(len(path) - 1):
		var point = path[i+1]
		var dir = directions[i]
		set_direction(dir)
		move_timer.start()
		await move_timer.timeout
		tilemap_position = point
	moving = false
	
func set_direction(direction : GameBoard.Direction):
	facing_direction = direction
	match direction:
		GameBoard.Direction.NW:
			play("move_nw")
		GameBoard.Direction.NE:
			play("move_ne")
		GameBoard.Direction.SW:
			play("move_sw")
		GameBoard.Direction.SE:
			play("move_se")
