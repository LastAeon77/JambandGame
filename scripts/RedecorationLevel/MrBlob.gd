extends Node2D

var held_object
var object_in_staging
var move_timer
var turn_in_progress : bool = false
var pending_action = false
var turn_actions : Array[Callable] = []
var furniture_row

const DOORWAY_LOCATION = Vector2i(-4,-13)
const STAGING_AREA_LOCATION = Vector2i(-4,-21)
const START_LOCATION = Vector2i(-4,-25)
const TOP_LEFT_LOCATION = Vector2i(-9,-12)

@export var tilemap_position: Vector2i
@export var initiatives = [100]
@export var move_time : float = 0.12

@onready var sprite :AnimatedSprite2D = $AnimatedSprite2D
@onready var furniture_queue = [
		preload("res://scenes/RedecorationLevel/furniture/couch.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/glass_table.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/lamp.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/spider_plant.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/spider_plant.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/stereo.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/table_seat.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/table_seat.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/world_globe.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/bookshelf.tscn"),
]
@onready var books = preload("res://scenes/RedecorationLevel/furniture/books.tscn")


func get_turn_actions() -> Array[Callable]:
	var actions : Array[Callable] = []
	
	if object_in_staging != null:
		actions.append(move_to_location.bind(STAGING_AREA_LOCATION))
		actions.append(set_direction.bind(Vector2i(-1,0)))
		actions.append(wait.bind(0.25))
		actions.append(pickup_object_in_staging)
		actions.append(move_to_location.bind(DOORWAY_LOCATION))
		actions.append(place_object_in_house)
		actions.append(move_to_location.bind(START_LOCATION))
		actions.append(set_direction.bind(Vector2i(0,1)))
	
	if len(furniture_queue) > 0:
		actions.append(move_to_location.bind(STAGING_AREA_LOCATION))
		actions.append(set_direction.bind(Vector2i(-1,0)))
		actions.append(wait.bind(0.25))
		actions.append(stage_next_object)
		actions.append(flash_staged_highlight)
		actions.append(move_to_location.bind(START_LOCATION))
		actions.append(set_direction.bind(Vector2i(0,1)))
		
	actions.append(end_turn)
	return actions

func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	furniture_queue.shuffle()
	furniture_queue.append(books)
	furniture_row = []
	for x in range(-9,-4):
		furniture_row.append(Vector2i(x,-12))

func wait(time):
	var already_pending = pending_action
	var timer = Timer.new()
	timer.wait_time = time
	add_child(timer)
	pending_action = true
	timer.start()
	await timer.timeout
	if !already_pending:
		pending_action = false

func _process(delta):
	if tilemap_position.y > -20:
		z_index = 4
	else:
		z_index = 200
	if turn_in_progress and !pending_action:
		turn_actions.pop_front().call()

func move_to_location(location):
	move(get_path_to_point(location))

func pickup_object_in_staging():
	SignalBus._pickup.emit(self,object_in_staging.tilemap_position)

func stage_next_object():
	var item = furniture_queue.pop_front().instantiate()
	item.tilemap_position = STAGING_AREA_LOCATION + Vector2i(-1,0)
	get_parent().add_child(item)
	object_in_staging = item

func flash_staged_highlight():
	pending_action = true
	SignalBus._transparency_altered.emit(true)
	object_in_staging.draw_desired_highlight()
	await wait(.3)
	clear_highlight()
	await wait(.3)
	object_in_staging.draw_desired_highlight()
	await wait(.3)
	clear_highlight()
	await wait(.3)
	SignalBus._transparency_altered.emit(false)
	pending_action = false
	
func place_object_in_house():
	pending_action = true
	object_in_staging = null
	if held_object != null:
		for point in furniture_row:
			var dimensions 
			dimensions = Vector2i(held_object.dimensions.y,held_object.dimensions.x)
			if (point - TOP_LEFT_LOCATION).x >= dimensions.x-1:
				held_object.tilemap_position = point + Vector2i(0,dimensions.y -1)
				SignalBus._place.emit(self,held_object)
			if held_object == null:
				pending_action = false
				return
			held_object.flip()
			dimensions = Vector2i(held_object.dimensions.y,held_object.dimensions.x)
			if (point - TOP_LEFT_LOCATION).x >= dimensions.x-1:
				held_object.tilemap_position = point + Vector2i(0,dimensions.y -1)
				SignalBus._place.emit(self,held_object)
			if held_object == null:
				pending_action = false
				return
			held_object.flip()
		SignalBus._redecoration_defeat.emit()
		pending_action = false

func get_path_to_point(point):
	var path = []
	var dir = -1 if tilemap_position.y > point.y else 1
	
	for y in range(tilemap_position.y, point.y, dir):
		path.append(Vector2i(tilemap_position.x,y + dir))
	return path

func start_turn():
	turn_in_progress = true
	pending_action = false
	turn_actions = get_turn_actions()
	
func end_turn():
	turn_in_progress = false
	SignalBus._end_turn.emit()

func move(path):
	pending_action = true
	for point in path:
		move_timer.start()
		set_direction(point - tilemap_position)
		await move_timer.timeout
		tilemap_position = point
	pending_action = false

func all_items_in_house():
	return len(furniture_queue) == 0 and object_in_staging == null

func set_direction(direction : Vector2i):
	match direction:
		Vector2i(-1,0):
			sprite.play("NW")
		Vector2i(0,-1):
			sprite.play("NE")
		Vector2i(0,1):
			sprite.play("SW")
		Vector2i(1,0):
			sprite.play("SE")

func clear_highlight():
	SignalBus._update_highlight.emit([],GameBoard.Highlight_Color.BLUE,true)
