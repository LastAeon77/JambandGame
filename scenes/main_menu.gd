extends Control
var moon_scene = preload("res://scenes/space_level.tscn")
var flower_scene = preload("res://scenes/flower_level.tscn")

var settings_scene = preload("res://scenes/settings.tscn")
var checkbox_yes = preload("res://sprites/MainMenu/checkboxYes.PNG")

var buttons = []
var curr_highlight = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in $MainScene.get_children():
		if(x.get_child(0) is Button):
			buttons.append(x.get_child(0))
	if SignalBus.beat_moon:
		$MoonGemCheckbox.texture = checkbox_yes
	if SignalBus.beat_flower:
		$FlowerCheckbox.texture = checkbox_yes
	if SignalBus.beat_redecorate:
		$FlowerCheckbox.texture = checkbox_yes
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up_player_1") or Input.is_action_just_pressed("up_player_2"):
		if curr_highlight == -1:
			curr_highlight = 0
		else:
			curr_highlight = max(0,curr_highlight-1)
		highlight_button(curr_highlight)
	if Input.is_action_just_pressed("down_player_1") or Input.is_action_just_pressed("down_player_2"):
		if curr_highlight == -1:
			curr_highlight = 0
		else:
			curr_highlight = min(len(buttons)-1,curr_highlight+1)
		highlight_button(curr_highlight)
	if Input.is_action_just_pressed("submit"):
		press_hightlighted_button(curr_highlight)


func _on_intro_button_pressed():
	#Play Intro
	pass # Replace with function body.


func _on_moon_gem_button_pressed():
	get_tree().change_scene_to_packed(moon_scene)


func _on_flower_button_pressed():
	get_tree().change_scene_to_packed(flower_scene)


func _on_redecorate_button_pressed():
	pass


func _on_settings_button_pressed():
	get_tree().change_scene_to_packed(settings_scene)

func highlight_button(index):
	for button in buttons:
		button.toggle_mode = false

	var curr_button = buttons[index] as Button
	curr_button.toggle_mode = true
	curr_button.grab_focus()

func press_hightlighted_button(index):
	var button = buttons[index] as Button
	if buttons[index].toggle_mode:
		button.pressed.emit()
