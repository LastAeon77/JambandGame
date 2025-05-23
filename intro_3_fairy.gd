extends Control

var file = "res://Texts/IntroStoryDialouge3.json"
var json_dict_data = null
var count = 0
var story_start = false
var fairy_flying_in = false
var transitioning = false
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
	$MR_BLOB_THROW_COIN.play("default")
	$MR_BLOB_THROW_COIN.visible = false
	$Fountain.play("default")
	$NeonSign.visible = false
	$WaterFountainMP3.play()
	next_story()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if (Input.is_action_just_pressed("button_1_player_1") or Input.is_action_just_pressed("button_1_player_2") or Input.is_action_just_pressed("start_player_1")):
			next_story()
		


func _on_timer_timeout():
	$Path2DFairy1/PathFollow2D.progress_ratio = min(1,$Path2DFairy1/PathFollow2D.progress_ratio + 0.05)
	$Path2DFairy2/PathFollow2D.progress_ratio = min(1,$Path2DFairy2/PathFollow2D.progress_ratio + 0.02)
	if ($Path2DFairy1/PathFollow2D.progress_ratio ==1 ):
		fairy_flying_in = false
	


func next_story():
	if(fairy_flying_in == false and transitioning == false):
		count = count + 1
		if count>=len(json_dict_data):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		else:
			var curr = json_dict_data[count]
			var text = curr["text"]
			var talker = curr["talker"]
			var curr_id = curr["id"]
			if(talker == "Mr. Blob"):
				$MR_BLOB.visible = true
			if(curr_id == 3.5):
				$MR_BLOB.visible = false
				$MR_BLOB_THROW_COIN.visible = true;
				$MR_BLOB_THROW_COIN.play("default")
				await get_tree().create_timer(1.8).timeout
				$Coin_Splash.play()
			if(curr_id == 3.6):
				$MR_BLOB.visible = true
				$MR_BLOB_THROW_COIN.visible = false;
			if(curr_id == 3.8):
				$MR_BLOB.visible = false
				$MR_BLOB_THROW_COIN.visible = true;
				$MR_BLOB_THROW_COIN.play("default")
				await get_tree().create_timer(1.8).timeout
				$Coin_Splash.play()
			if(curr_id == 4):
				$MR_BLOB.visible = true
				$MR_BLOB_THROW_COIN.visible = false;
				$MR_BLOB.stop()
				$Path2DFairy1/PathFollow2D/Fairy1.play("default")
				$Path2DFairy2/PathFollow2D/Fairy2.play("default")
				$Timer.start()
				fairy_flying_in = true
				$AudioStreamPlayer2D.play()
			if(curr_id == 8):
				$AnimationPlayer.play("RESET")
				transitioning = true
				
			$RichTextLabel.text = text_template.replace("<Text>",text).replace("<Talker>",talker)


func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "RESET"):
		$FountainBefore.visible = false
		$NeonSign.visible = true
		$FountainAfter.visible = true
		$NeonSign.play("default")
		$AnimationPlayer.play("DISSOLVE")
	if(anim_name == "DISSOLVE"):
		$MR_BLOB.play("default")
		transitioning = false
