extends Control

var file = "res://Texts/IntroStoryDialouge2.json"
var json_dict_data = null
var count = 0
var story_start = false
var text_template = """
<Talker>

<Text>

PRESS Controller Button "A" or Keyboard "Enter" for next dialogue.
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var json_as_text = FileAccess.get_file_as_string(file)
	json_dict_data = JSON.parse_string(json_as_text)
	$MR_BLOB.play("default")
	$AudioStreamPlayer.play()
	next_story()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if (Input.is_action_just_pressed("button_1_player_1") or Input.is_action_just_pressed("button_1_player_2") or Input.is_action_just_pressed("start_player_1")):
			next_story()
		


func _on_timer_timeout():
	$Path2D/PathFollow2D.progress_ratio = min(1,$Path2D/PathFollow2D.progress_ratio + 0.05)



func next_story():
	count = count + 1
	if count>=len(json_dict_data):
		get_tree().change_scene_to_file("res://scenes/intro_3_fairy.tscn")
	else:
		var curr = json_dict_data[count]
		var text = curr["text"]
		var talker = curr["talker"]
		if(talker == "Blob Default"):
			$MR_BLOB.play("default")
		if(talker == "Blob Serious"):
			$MR_BLOB.play("serious")
		if(talker == "Blob Think"):
			$MR_BLOB.play("look_around")
		$RichTextLabel.text = text_template.replace("<Text>",text).replace("<Talker>","Mr. Blob")
