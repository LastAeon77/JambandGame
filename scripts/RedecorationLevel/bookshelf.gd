extends Node2D
@export var moveable = true
@export var tilemap_position : Vector2i
var dimensions : Vector2i = Vector2i(1,1)
@export var normal_dimensions : Vector2i = Vector2i(1,1)
@export var flipped_dimensions : Vector2i = Vector2i(1,1)
var on_ground = true
@onready var animation : AnimatedSprite2D = $Normal
var flipped = false
var flipped_animation
var books_on_shelf = null
func _ready():
	if !flipped:
		dimensions = normal_dimensions
	else:
		dimensions = flipped_dimensions
	if has_node("Flipped"):
		flipped_animation = $Flipped
		flipped_animation.play()
	animation.play()
	SignalBus._obstacle_changed.emit()
func flip():
	if flipped_animation!= null:
		if !flipped:
			flipped = true
			if flipped_animation != null:
				flipped_animation.visible = true
				animation.visible = false
			dimensions = flipped_dimensions
		else:
			flipped = false
			if flipped_animation != null:
				flipped_animation.visible = false
				animation.visible = true
			dimensions = normal_dimensions
func pick_up():
	if moveable and on_ground:
		if books_on_shelf == null:
			on_ground = false
			remove_from_group("obstacles")
			visible = false
			SignalBus._obstacle_changed.emit()
			SignalBus._bookshelf_state_changed.emit(true)
			return self
		else:
			flipped_animation.play("default")
			animation.play("default")
			SignalBus._bookshelf_state_changed.emit(true)
			return books_on_shelf.pickup()
		
	return null

func place(placement_data = null):
	on_ground=true
	add_to_group("obstacles")
	visible = true
	SignalBus._obstacle_changed.emit()

func place_books(books):
	books_on_shelf = books
	flipped_animation.play("full")
	animation.play("full")

