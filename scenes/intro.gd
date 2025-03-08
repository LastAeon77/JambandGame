extends Control

var file = "res://Texts/IntroStoryDialouge.json"
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
	var json_as_text = FileAccess.get_file_as_string(file)
	json_dict_data = JSON.parse_string(json_as_text)
	$Path2D/PathFollow2D.progress_ratio = 0
	$Path2D/PathFollow2D/Timer.autostart = true
	$Path2D/PathFollow2D/MR_BLOB.play("Walking")
	$MR_NEIGHBOR.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if($Path2D/PathFollow2D.progress_ratio >=1):
		if(story_start == false):
			next_story()
			story_start = true
		if (Input.is_action_just_pressed("button_1_player_1") or Input.is_action_just_pressed("button_1_player_2") or Input.is_action_just_pressed("start_player_1")):
			next_story()
		


func _on_timer_timeout():
	$Path2D/PathFollow2D.progress_ratio = min(1,$Path2D/PathFollow2D.progress_ratio + 0.05)



func next_story():
	count = count + 1
	if count>=len(json_dict_data):
		get_tree().change_scene_to_file("res://scenes/intro_2_reflection.tscn")
	else:
		var curr = json_dict_data[count]
		var text = curr["text"]
		var talker = curr["talker"]
		if(talker == "neighbor"):
			$MR_NEIGHBOR.play("Talking")
			$Path2D/PathFollow2D/MR_BLOB.play("default")
		else:
			$MR_NEIGHBOR.play("default")
			$Path2D/PathFollow2D/MR_BLOB.play("Talking")
		$RichTextLabel.text = text_template.replace("<Text>",text).replace("<Talker>",talker)
		
