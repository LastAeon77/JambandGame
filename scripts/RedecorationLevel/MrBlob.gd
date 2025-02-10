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
@export var move_time : float = 0.12
var held_object
var current_step = 0
var is_my_turn = false
var movement_direction = null
var items_left_in_queue = true
var item_in_staging = true
func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	final_position = tilemap_position
	
func _process(delta):
	if !item_in_staging and current_step == 0 and !moving:
		SignalBus._blob_end_turn.emit()
		return
	if is_my_turn and !moving:
		if current_step == 0:
			z_index = 100
			var path = [tilemap_position] 
			var directions = []
			for i in range(4):
				path.append(path[i] + Vector2i(0,1))
				directions.append(GameBoard.Direction.SW)
			move(path,directions)
			
		elif current_step == 1:
			set_direction(GameBoard.Direction.NW, true)
		elif current_step == 2:
			wait(3)
		elif current_step == 3:
			SignalBus._blob_pickup.emit()
			z_index = 3
			current_step += 1
		elif current_step == 4:
			var path = [tilemap_position] 
			var directions = []
			for i in range(7):
				path.append(path[i] + Vector2i(0,1))
				directions.append(GameBoard.Direction.SW)
			move(path,directions)
		elif current_step == 5:
			var path = [tilemap_position] 
			var directions = []
			for i in range(2):
				path.append(path[i] + Vector2i(0,1))
				directions.append(GameBoard.Direction.SW)
			move(path,directions)
		elif current_step == 6:
			set_direction(GameBoard.Direction.NW,true)
		elif current_step == 7:
			wait(3)
		elif current_step == 8:
			SignalBus._blob_place.emit()
			current_step += 1
		elif current_step == 9:
			var path = [tilemap_position] 
			var directions = []
			for i in range(13):
				path.append(path[i] + Vector2i(0,-1))
				directions.append(GameBoard.Direction.NE)
			move(path,directions)
		elif current_step == 10:
			wait(3)
		elif current_step == 11:
			set_direction(GameBoard.Direction.SW)
			var path = [tilemap_position] 
			var directions = []
			for i in range(4):
				path.append(path[i] + Vector2i(0,1))
				directions.append(GameBoard.Direction.SW)
			if items_left_in_queue:
				move(path,directions)
			else:
				current_step += 1
				
		elif current_step == 12:
			if items_left_in_queue:
				set_direction(GameBoard.Direction.NW)
				wait(3)
			else:
				current_step += 1
		elif current_step == 13:
			if items_left_in_queue:
				SignalBus._blob_stage.emit()
			current_step += 1
		elif current_step == 14:
			# if items_left_in_queue:
				# SignalBus._blob_stage.emit()
			current_step += 1
		elif current_step == 15:
			var path = [tilemap_position] 
			var directions = []
			for i in range(4):
				path.append(path[i] - Vector2i(0,1))
				directions.append(GameBoard.Direction.NE)
			if items_left_in_queue:
				move(path,directions)
			else:
				current_step += 1
		elif current_step == 16:
			if items_left_in_queue:
				set_direction(GameBoard.Direction.SW, true)
			else:
				current_step += 1
		elif current_step == 17:
			SignalBus._blob_end_turn.emit()
			current_step = 0
			is_my_turn = false
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
	current_step += 1

func wait(numTicks = 1):
	moving = true
	for i in range(numTicks):
		move_timer.start()
		await move_timer.timeout
	moving = false
	current_step += 1

func set_direction(direction : GameBoard.Direction, increment = false):
	if increment:
		moving = true
		move_timer.start()
		await move_timer.timeout
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
	if increment:
		current_step += 1
		moving = false
