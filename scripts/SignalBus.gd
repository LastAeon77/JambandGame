extends Node

enum Difficulties { EASY, MEDIUM, HARD }
var curr_difficulty
var beat_moon
var beat_flower
var beat_redecorate

var moon_gem_first_time : bool = true

var flower_first_time : bool = true

var redecoration_first_time : bool = true

signal _game_lost()

signal _game_won()

signal _moon_gem_stage_clear()

signal _moon_gem_stage_restart()

signal _pause()

signal _moon_story_next()

signal _flower_victory()

signal _flower_defeat()

signal _redecoration_defeat()
signal _redecoration_victory()
signal _update_highlight(points : Array, color : GameBoard.Highlight_Color, clear : bool)
signal _turn_changed(turn_number:int)
signal _pickup(character, coord : Vector2i)
signal _place(character,item)
signal _end_turn
signal _transparency_altered(transparent : bool)
signal _bee_sting(pixie : Node2D)
signal _action_taken

# Called when the node enters the scene tree for the first time.
func _ready():
	ensure_save_file_exists()
	connect("_moon_gem_stage_clear",win_moon)
	connect("_flower_victory", win_flower)
	connect("_redecoration_victory", win_redecorate)
	curr_difficulty = Difficulties.MEDIUM
	load_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		emit_signal("_pause")
	if Input.is_action_just_pressed("restart"):
		emit_signal("_moon_gem_stage_restart")

func ensure_save_file_exists():
	var save_path = "user://save.json"
	if not FileAccess.file_exists(save_path):
		var default_save_data = {
		"beat_moon": false,
		"beat_flower": false,
		"beat_redecorate": false
		}
		var json = JSON.new()
		var save_file = FileAccess.open(save_path, FileAccess.WRITE)
		if save_file:
			save_file.store_string(json.stringify(default_save_data))  # Write default data as JSON
			save_file.close()
			print("save.json created at:", save_path)
		else:
			print("Failed to create save.json at:", save_path)
	else:
		print("save.json already exists at:", save_path)


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
	var json = JSON.new()
	var save_file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if save_file:
		var parsed_json: String = json.stringify(save())  # Convert Dictionary to JSON string
		save_file.store_line(parsed_json)
		print("Game saved successfully!")
	else:
		print("Failed to save the game.")
	save_file.close()
	
func load_game():
	var save_file = FileAccess.open("user://save.json", FileAccess.READ)
	var json_string = save_file.get_as_text()
	save_file.close()
	var json = JSON.new()
	var parse_result = json.parse_string(json_string)
	if not parse_result:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
	var node_data = parse_result
	if node_data.has("beat_moon"):
		beat_moon = node_data["beat_moon"]
	if node_data.has("beat_flower"):
		beat_flower = node_data["beat_flower"]
	if node_data.has("beat_redecorate"):
		beat_redecorate = node_data["beat_redecorate"]

func win_moon():
	beat_moon = true
	save_game()
	
func win_flower():
	beat_flower = true
	save_game()
	
func win_redecorate():
	beat_redecorate = true
	save_game()
	
func change_difficulty(diff):
	curr_difficulty = diff
	
func get_moon_first():
	return moon_gem_first_time

func set_moon_first(boolean:bool):
	moon_gem_first_time = boolean
		
func get_flower_first():
	return flower_first_time

func set_flower_first(boolean:bool):
	flower_first_time = boolean
		
func get_redecoration_first():
	return redecoration_first_time

func set_redecoration_first(boolean:bool):
	redecoration_first_time = boolean
		
