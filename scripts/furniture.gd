extends Node2D
@export var moveable = true
@export var tilemap_position : Vector2i
@export var dimensions : Vector2i = Vector2i(1,1)
@export var flipped_dimensions : Vector2i = Vector2i(1,1)
var on_ground = true

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
