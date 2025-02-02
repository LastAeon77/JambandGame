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

func _ready():
	if !flipped:
		dimensions = normal_dimensions
	else:
		dimensions = flipped_dimensions
	if has_node("Flipped"):
		flipped_animation = $Flipped
		flipped_animation.play()
	animation.play()

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
		on_ground = false
		remove_from_group("obstacles")
		visible = false
		SignalBus._obstacle_changed.emit()
		return self
	return null

func place(placement_data = null):
	if placement_data != null and placement_data.is_in_group("bookshelf"):
		placement_data.place_books(self)
	else:
		on_ground=true
		add_to_group("obstacles")
		SignalBus._obstacle_changed.emit()
		visible = true
	return true

