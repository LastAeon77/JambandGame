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
	
func flip():
	if flipped_animation!= null:
		if !flipped:
			flipped = true
			dimensions = flipped_dimensions
		else:
			dimensions = normal_dimensions

func pick_up():
	if moveable and on_ground:
		on_ground = false
		remove_from_group("obstacles")
		visible = false
		return true
	return false

func set_down(position:Vector2i, flipped):
	if !on_ground:
		tilemap_position = position
		add_to_group("obstacles")
		visible = true
