extends Node

var beat_moon
var beat_flower
var beat_redecorate

signal _game_lost()

signal _game_won()

signal _moon_gem_stage_clear()

signal _moon_gem_stage_restart()

signal _pause()

signal _moon_story_next()

signal _flower_victory()

signal _flower_defeat()

signal _bee_sting(pixie : Node2D)
# Called when the node enters the scene tree for the first time.
func _ready():
	print("loading game")
	load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		emit_signal("_pause")
	if Input.is_action_just_pressed("restart"):
		emit_signal("_moon_gem_stage_restart")


func get_camera_top():
	var camera = get_tree().get_first_node_in_group("camera") as Camera2D
	var screen_size = get_viewport().get_visible_rect().size
	var zoom : Vector2 = camera.zoom
	var top_right = camera.position + (screen_size * Vector2(1/zoom.x,1/zoom.y)) / 2
	var bottom_right = camera.position + (screen_size * Vector2(1/zoom.x,1/zoom.y)) / 2
	return top_right.y


func save():
	var save_dict = {
		"beat_moon" : beat_moon,
		"beat_flower": beat_flower,
		"beat_redecorate": beat_redecorate
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("res://Save/save.json", FileAccess.WRITE)
	save_file.store_line(save())
	
func load_game():
	var save_file = FileAccess.open("res://Save/save.json", FileAccess.READ)
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
	var node_data = json.data
	beat_moon = node_data["beat_moon"]
	beat_flower = node_data["beat_flower"]
	beat_redecorate = node_data["beat_redecorate"]
