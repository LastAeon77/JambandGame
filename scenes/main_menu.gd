extends Control
var moon_scene = preload("res://scenes/space_level.tscn")
var flower_scene = preload("res://scenes/flower_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	pass
