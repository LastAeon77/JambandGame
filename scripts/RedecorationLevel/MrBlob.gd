extends Node2D
class_name MrBlob

@onready var sprite :AnimatedSprite2D = $AnimatedSprite2D
@export var tilemap_position : Vector2i = Vector2i(0,0)
var facing_direction : GameBoard.Direction = GameBoard.Direction.SW
var final_position : Vector2i
var start_position = Vector2i(21,-15)
var staging_area = Vector2i(17,-13)
var moving = false
var move_timer 
@export var move_time : float = 0.2


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
			sprite.play("NW")
		GameBoard.Direction.NE:
			sprite.play("NE")
		GameBoard.Direction.SW:
			sprite.play("SW")
		GameBoard.Direction.SE:
			sprite.play("SE")

