extends AnimatedSprite2D

var held_object = null
var movement_path
var move_timer : Timer
var pending_action = false

@export var max_movement = 5
@export var tilemap_position : Vector2i
@export var move_time : float = 0.1
@export var action_map : Resource

@onready var movement_left : int = 0
@onready var turn_in_progress : bool = false
@onready var initiatives = [100]
@onready var direction : Vector2i = Vector2i(0,-1)

func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time

func _process(delta):
	var select_pressed = action_map.get_select()
	if select_pressed:
		pause_game()
	elif turn_in_progress and !pending_action:
		var movement_vector = action_map.get_vector()
		var button1_pressed = action_map.get_button_1()
		var button2_pressed = action_map.get_button_2()
		var start_pressed = action_map.get_start()
		
		if start_pressed:
			end_turn()
		elif button1_pressed:
			if len(movement_path) != 0:
				move(movement_path)
			elif held_object != null:
				place_held_object()
		elif button2_pressed and held_object != null:
			flip_held_object()
		elif movement_vector != Vector2i.ZERO:
			var point = movement_vector
			if len(movement_path) > 0:
				point = point + movement_path.back()
			else:
				point = point + tilemap_position
			
			if len(movement_path) == 0 and direction != movement_vector:
				set_direction(movement_vector)
			elif len(movement_path) == 0:
				if movement_left > 0:
					movement_path.append(point)
					update_movement_highlight()
			else:
				var previous
				if len(movement_path) == 1:
					previous = tilemap_position
				else:
					previous = movement_path[-2]
				if previous == point:
					movement_path.pop_back()
					update_movement_highlight()
				elif !movement_path.has(point) and len(movement_path) < movement_left:
					movement_path.append(point)
				update_movement_highlight()
			
			
func query_obstacle(point):
	return false
func update_movement_highlight():
	SignalBus._update_highlight.emit(movement_path, Gameboard2.Highlight_Color.RED)

func place_held_object():
	pass
func flip_held_object():
	pass
func pause_game():
	pass
	
func move(path):
	movement_path = []
	movement_left = movement_left - len(path)
	update_movement_highlight()
	pending_action = true
	for point in path:
		print(tilemap_position)
		move_timer.start()
		set_direction(point - tilemap_position)
		await move_timer.timeout
		tilemap_position = point
	pending_action = false
	
func start_turn():
	movement_left = max_movement
	print(tilemap_position)
	movement_path = []
	print(movement_path)
	turn_in_progress = true
	
func end_turn():
	SignalBus._end_turn.emit()
	turn_in_progress = false

func set_direction(vector):
	direction = vector
	match direction:
		Vector2i(-1,0):
			play("move_nw")
		Vector2i(0,-1):
			play("move_ne")
		Vector2i(0,1):
			play("move_sw")
		Vector2i(1,0):
			play("move_se")
