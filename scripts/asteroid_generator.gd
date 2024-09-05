extends Node2D

var asteroid_block = preload("res://scenes/asteroid.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_asteroid"):
		#var temp = asteroid_block
		#asteroid_block.instantiate()
		#asteroid_block.position = position
		var camera :Camera2D = get_tree().get_first_node_in_group("camera")
		var screen_size = get_viewport().get_visible_rect().size
		var zoom = camera.zoom
		var top_right = camera.position + (screen_size * zoom) / 2
		var bottom_right = camera.position + (screen_size * zoom) / 2

		print("Top-left: ", top_right)
		print("Bottom-right: ", bottom_right)
	pass

