extends Node2D
class_name Furniture

@onready var animation : AnimatedSprite2D = $Normal
@onready var sound_effects_scene = preload("res://scenes/RedecorationLevel/furniture/furniture_sound_effects.tscn")

@export var friendly_name = ""
@export var moveable = true
@export var tilemap_position : Vector2i
@export var normal_dimensions : Vector2i = Vector2i(1,1)
@export var flipped_dimensions : Vector2i = Vector2i(1,1)
@export var desired_locations : Array[Vector2i] = []
@export var desired_location_flipped : Array[bool] = []

var dimensions : Vector2i = Vector2i(1,1)
var on_ground = true
var flipped = false
var flipped_animation = null
var pickup_sound
var place_sound
func _ready():
	var sound_effects = sound_effects_scene.instantiate()
	add_child(sound_effects)
	pickup_sound = sound_effects.get_child(0)
	place_sound = sound_effects.get_child(1)
	
	if !flipped:
		dimensions = normal_dimensions
	else:
		dimensions = flipped_dimensions
	if has_node("Flipped"):
		flipped_animation = $Flipped
		flipped_animation.play()
	animation.play()
	SignalBus._transparency_altered.connect(set_tranparent)
	get_parent().align_location(self)

func play_place_sound():
	place_sound.play()

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
	for x in range(pos.x, pos.x - dim.y, -1):
		for y in range(pos.y,pos.y - dim.x, -1):
			output.append(Vector2i(x,y))
	return output

func pick_up():
	if moveable and on_ground:
		on_ground = false
		remove_from_group("obstacles")
		visible = false
		pickup_sound.play()
		return self
	return null

func place(placement_data = null):
	if placement_data == null:
		get_parent().align_location(self)
		on_ground = true
		add_to_group("obstacles")
		visible = true
		place_sound.play()
		return true
	return false

func set_tranparent(transparent):
	if transparent:
		modulate.a = 0.85
	else:
		modulate.a = 1

func draw_placement_highlight():
	draw_desired_highlight()
	SignalBus._update_highlight.emit(get_tiles(),GameBoard.Highlight_Color.BLUE,false)

func draw_desired_highlight():
	SignalBus._update_highlight.emit([],GameBoard.Highlight_Color.GREEN,true)
	var desired_tiles = []
	for i in range(len(desired_locations)):
		desired_tiles.append_array(get_tiles(desired_locations[i],desired_location_flipped[i]))
	SignalBus._update_highlight.emit(desired_tiles,GameBoard.Highlight_Color.GREEN,false)
	
func is_in_correct_spot():
	if !on_ground:
		return false
	
	if len(desired_locations) == 0:
		return true
	var index = desired_locations.find(tilemap_position)
	if index != -1 and (desired_location_flipped[index] == flipped or flipped_animation == null):
		return true
	return false

func get_top_left():
	return tilemap_position + Vector2i(-1 * (dimensions.y - 1),-1*(dimensions.x - 1))

func _process(_delta):
	if !is_in_correct_spot():
		modulate = Color(1,0,0,modulate.a)
	else:
		modulate = Color(1,1,1,modulate.a)
