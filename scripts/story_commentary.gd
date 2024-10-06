extends Control

var file = "res://Texts/SpaceStageDialouge.json"
var json_dict_data = null
var count = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	var json_as_text = FileAccess.get_file_as_string(file)
	json_dict_data = JSON.parse_string(json_as_text)
	SignalBus.connect("_moon_story_next",next_story)
	SignalBus.connect("_moon_gem_stage_restart",restart)
	$Casual.visible = false
	$Concerned.visible = false
	$Scared.visible = false
	next_story()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func restart():
	count = -1
	$Casual.visible = false
	$Concerned.visible = false
	$Scared.visible = false
	$RichTextLabel.visible = false
	next_story()

func next_story():
	count = count + 1
	if count>=len(json_dict_data):
		$Casual.visible = false
		$Concerned.visible = false
		$Scared.visible = false
		$RichTextLabel.visible = false
	else:
		var curr = json_dict_data[count]
		var text = curr["text"]
		var sprite = curr["sprite"]
		$Casual.visible = false
		$Concerned.visible = false
		$Scared.visible = false
		get_node(sprite).visible = true
		$RichTextLabel.visible = true
		$RichTextLabel.text = text
	
	
	
