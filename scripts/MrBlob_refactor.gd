extends Node2D

var held_object
var staging_area_position
var move_timer
var turn_in_progress : bool = false

@export var tilemap_position: Vector2i
@export var initiatives = [100]
@export var move_time : float = 0.12

@onready var sprite :AnimatedSprite2D = $AnimatedSprite2D
@onready var furniture_queue = [
		preload("res://scenes/RedecorationLevel/furniture/couch.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/glass_table.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/lamp.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/spider_plant.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/stereo.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/table_seat.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/table_seat.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/world_globe.tscn"),
		preload("res://scenes/RedecorationLevel/furniture/bookshelf.tscn"),
]

var books = preload("res://scenes/RedecorationLevel/furniture/books.tscn")

func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	furniture_queue.shuffle()
	furniture_queue.append(books)

func _process(delta):
	if tilemap_position == Vector2i(-4,-13):
		z_index = 4
	else:
		z_index = 200
	
	





func move(path,directions):
	for i in range(len(path) - 1):
		var point = path[i+1]
		var dir = directions[i]
		set_direction(dir)
		move_timer.start()
		await move_timer.timeout
		tilemap_position = point

func set_direction(direction : GameBoard.Direction):
	match direction:
		GameBoard.Direction.NW:
			sprite.play("NW")
		GameBoard.Direction.NE:
			sprite.play("NE")
		GameBoard.Direction.SW:
			sprite.play("SW")
		GameBoard.Direction.SE:
			sprite.play("SE")
