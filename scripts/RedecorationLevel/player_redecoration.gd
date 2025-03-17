extends AnimatedSprite2D

var held_object:
	set(value):
		_held = value
		update_held_object_position()
		update_highlight()
	get:
		return _held
var _held = null
var movement_path = []
var move_timer : Timer
var pending_action = false
const hard_max_movement = 6
const med_max_movement = 9
const easy_max_movement = 11

var max_movement = 10
@export var tilemap_position : Vector2i
@export var move_time : float = 0.1
@export var action_map : Resource

@onready var movement_left : int = 0
@onready var turn_in_progress : bool = false
@export var initiatives = [50]
@onready var direction : Vector2i = Vector2i(-1,0)

func _ready():
	move_timer = $Timer
	move_timer.wait_time = move_time
	match SignalBus.curr_difficulty:
		SignalBus.Difficulties.HARD:
			max_movement = hard_max_movement
		SignalBus.Difficulties.MEDIUM:
			max_movement = med_max_movement
		SignalBus.Difficulties.EASY:
			max_movement = easy_max_movement
	
func _process(delta):
	var start_pressed = action_map.get_start()
	if turn_in_progress and !pending_action:
		var movement_vector = action_map.get_vector()
		var button1_pressed = action_map.get_button_1()
		var button2_pressed = action_map.get_button_2()
		var select_pressed = action_map.get_select()
		
		
		if movement_vector != Vector2i.ZERO or button1_pressed or button2_pressed or select_pressed:
			SignalBus._action_taken.emit()
		
		if select_pressed:
			end_turn()
		elif button1_pressed:
			if len(movement_path) != 0:
				move(movement_path)
			elif held_object != null:
				place_held_object()
			else:
				SignalBus._pickup.emit(self, direction + tilemap_position)
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
				if movement_left > 0 and !get_parent().is_obstacle(point):
					movement_path.append(point)
			else:
				var previous
				if len(movement_path) == 1: 
					previous = tilemap_position
				else:
					previous = movement_path[-2]
				if previous == point:
					movement_path.pop_back()
				elif !movement_path.has(point) and len(movement_path) < movement_left:
					if !get_parent().is_obstacle(point):
						movement_path.append(point)
			
			update_held_object_position()
			update_highlight()
			
func query_obstacle(point):
	return false

func update_held_object_position():
	if _held != null:
		var add
		if direction == Vector2i(1,0) or direction == Vector2i(0,1):
			var swizzled = Vector2i(_held.dimensions.y,_held.dimensions.x)
			add = direction * swizzled
		else:
			add = direction
		_held.tilemap_position = tilemap_position + add

func update_highlight(draw_held = true):
	if pending_action:
		return
	if len(movement_path) != 0:
		SignalBus._update_highlight.emit(movement_path, GameBoard.Highlight_Color.RED, true)
		
	elif held_object != null and draw_held:
		held_object.draw_placement_highlight()
		
	else:
		SignalBus._update_highlight.emit([],GameBoard.Highlight_Color.RED, true)

func place_held_object():
	SignalBus._place.emit(self,held_object)

func flip_held_object():
	held_object.flip()
	update_held_object_position()
	update_highlight()
	
func move(path):
	movement_path = []
	movement_left = movement_left - len(path)
	update_highlight(false)
	pending_action = true
	for point in path:
		move_timer.start()
		set_direction(point - tilemap_position)
		await move_timer.timeout
		tilemap_position = point
	pending_action = false
	update_held_object_position()
	update_highlight()
	
func start_turn():
	SignalBus._transparency_altered.emit(true)
	movement_left = max_movement
	movement_path = []
	turn_in_progress = true
	update_highlight()
	
func end_turn():
	update_highlight(false)
	SignalBus._transparency_altered.emit(false)
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
