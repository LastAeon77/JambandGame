extends Node2D
class_name Furniture

@onready var animation : AnimatedSprite2D = $Normal
@export var moveable = true
@export var tilemap_position : Vector2i
@export var normal_dimensions : Vector2i = Vector2i(1,1)
@export var flipped_dimensions : Vector2i = Vector2i(1,1)

var dimensions : Vector2i = Vector2i(1,1)
var on_ground = true
var flipped = false
var flipped_animation

@export var desired_locations = []
@export var desired_location_flipped = []

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

func get_tiles( pos : Vector2i = tilemap_position, flip : bool = flipped) -> Array:
	var output = []
	var dim = normal_dimensions if !flip else flipped_dimensions
	for x in range(pos.x, pos.x - dimensions.y, -1):
		for y in range(pos.y,pos.y - dimensions.x, -1):
			output.append(Vector2i(x,y))
	return output

func pick_up():
	if moveable and on_ground:
		on_ground = false
		remove_from_group("obstacles")
		visible = false
		SignalBus._obstacle_changed.emit()
		return self
	return null

func place(placement_data = null):
	if placement_data == null:
		on_ground = true
		add_to_group("obstacles")
		visible = true
		SignalBus._obstacle_changed.emit()
		return true
	return false

func draw_placement_highlight():
	SignalBus._update_highlight.emit(get_tiles(),Gameboard2.Highlight_Color.GREEN,true)
	var desired_tiles = []
	for i in range(len(desired_locations)):
		desired_tiles.append_array(get_tiles(desired_locations[i],desired_location_flipped[i]))
	SignalBus._update_highlight.emit(desired_tiles,Gameboard2.Highlight_Color.BLUE,false)
	
	
