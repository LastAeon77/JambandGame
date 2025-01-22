@tool
extends Node2D
class_name GameBoard
enum Direction {NW,NE, SW, SE}
@onready var tilemap = $TileMap
@onready var player1 = $RedecorationPlayer1
@onready var player2 = $RedecorationPlayer2
@export var dimensions : Vector2i = Vector2i(9,11)
@onready var blob_timer : Timer = $Timer
const PICKUP_HOLD_TIME = 0.25
var pickup_button_hold_start = null
var turn : int = -1
var selected_tile = null
var path = []
var green_highlight_cells = []
var path_directions = []
var in_pickup_mode = false
var obstacle_positions :Dictionary = {}
var staging_area_position = Vector2i(16,-13)
var house_top_left = Vector2i(3,-11)
var item_in_staging_area = null
var should_flip_object = false
const MOVEMENT_PER_TURN = 100
var moves_left = MOVEMENT_PER_TURN
@export var align_to_tilemap : bool = false
@onready var plant_scene = load("res://scenes/RedecorationLevel/furniture/spider_plant.tscn")

var direction_to_animation_name = {
	Direction.NW:"move_nw",
	Direction.NE: "move_ne",
	Direction.SW: "move_sw",
	Direction.SE: "move_se",
}

var direction_to_cell_neighbor = {
	Direction.NW: TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE,
	Direction.NE: TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE,
	Direction.SW: TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,
	Direction.SE: TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,
}
func _ready():
	item_in_staging_area = plant_scene.instantiate()
	item_in_staging_area.tilemap_position = staging_area_position
	add_child(item_in_staging_area)
	update_obstacles()

func _process(delta):
	if Engine.is_editor_hint():
		update_tilemap_positions()
		if align_to_tilemap:
			align_objects_to_tilemap()
			align_to_tilemap = false
	
	if !Engine.is_editor_hint():
		align_objects_to_tilemap()
		if turn < 0:
			start_next_turn()
		
		var movement_direction = null
		var should_move = false
		var should_end_turn = false
		var should_pick_up_or_place = false
		var should_toggle_pick_up_mode =false
		
		var player = get_current_player()
		if turn % 3 == 1:
			if Input.is_action_just_pressed("up_player_1"):
				movement_direction = Direction.NE
			elif Input.is_action_just_pressed("down_player_1"):
				movement_direction = Direction.SW
			elif Input.is_action_just_pressed("left_player_1"):
				movement_direction = Direction.NW
			elif Input.is_action_just_pressed("right_player_1"):
				movement_direction = Direction.SE
			
			if Input.is_action_just_pressed("button_1_player_1"):
				if !in_pickup_mode:
					should_move = true
				else:
					should_pick_up_or_place = true
			
			if Input.is_action_just_pressed("button_2_player_1"):
				
				if in_pickup_mode:
					pickup_button_hold_start = Time.get_ticks_msec()
				else:
					should_toggle_pick_up_mode = true
				
			if pickup_button_hold_start != null and Time.get_ticks_msec() - pickup_button_hold_start > int(PICKUP_HOLD_TIME * 1000):
				if in_pickup_mode:
					should_toggle_pick_up_mode = true
					pickup_button_hold_start = null
				else:
					should_flip_object = false
			elif Input.is_action_just_released("button_2_player_1"):
				if in_pickup_mode and pickup_button_hold_start != null:
					should_flip_object = true
				pickup_button_hold_start = null
				
			if Input.is_action_just_pressed("select_player_1"):
				should_end_turn = true
		elif turn % 3 == 2:
			if Input.is_action_just_pressed("up_player_2"):
				movement_direction = Direction.NE
			elif Input.is_action_just_pressed("down_player_2"):
				movement_direction = Direction.SW
			elif Input.is_action_just_pressed("left_player_2"):
				movement_direction = Direction.NW
			elif Input.is_action_just_pressed("right_player_2"):
				movement_direction = Direction.SE
			
			if Input.is_action_just_pressed("button_1_player_2"):
				if !in_pickup_mode:
					should_move = true
				else:
					should_pick_up_or_place = true
					
			if Input.is_action_just_pressed("button_2_player_2"):
				if in_pickup_mode:
					pickup_button_hold_start = Time.get_ticks_msec()
				else:
					should_toggle_pick_up_mode = true
			
			if pickup_button_hold_start != null and Time.get_ticks_msec() - pickup_button_hold_start > int(PICKUP_HOLD_TIME * 1000):
				if in_pickup_mode:
					should_toggle_pick_up_mode = true
					pickup_button_hold_start = null
			elif Input.is_action_just_released("button_2_player_2"):
				if in_pickup_mode and pickup_button_hold_start != null:
					should_flip_object = true
				pickup_button_hold_start = null
			if Input.is_action_just_pressed("select_player_2"):
				should_end_turn = true
		else:
			#MR.blob's turn
			if blob_timer.is_stopped():
				#TODO temporary code to get the placement feature
				item_in_staging_area
				var position
				should_end_turn = true
		
		if !in_pickup_mode && movement_direction != null:
			var cell_neighbor = direction_to_cell_neighbor[movement_direction]
			var candidate_position = tilemap.get_neighbor_cell(selected_tile,cell_neighbor)
			if !is_obstacle(candidate_position):
				if path.size() > 1 and candidate_position in path:
					if path[path.size()-2] == candidate_position:
						tilemap.set_cell(0,path[path.size()-1] ,0,Vector2i.ZERO)
						path.pop_back()
						path_directions.pop_back()
						selected_tile = candidate_position
				elif moves_left > path.size()-1:
					selected_tile = candidate_position
					path_directions.append(movement_direction)
					path.append(candidate_position)
					tilemap.set_cell(0,selected_tile,1,Vector2i.ZERO)
		elif movement_direction != null:
			get_current_player().set_direction(movement_direction)
			update_green_highlight(player)
		if should_toggle_pick_up_mode:
			if !in_pickup_mode:
				var player_position = player.final_position
				clear_path(player_position)
				in_pickup_mode = true
				update_green_highlight(player)
			else:
				in_pickup_mode = false
				clear_green_highlight()
		if should_flip_object and player!= null and player.held_object != null:
			should_flip_object = false
			player.held_object.flip()
			update_green_highlight(player)
		
		if should_pick_up_or_place:
			var direction = player.facing_direction
			var cell_neighbor_dir = direction_to_cell_neighbor[direction]
			var neighbor_cell = tilemap.get_neighbor_cell(player.final_position,cell_neighbor_dir)
			if(player.held_object != null):
				var potential_collisions = get_obstacle_tiles(player.held_object)
				var can_place = true
				for coord in potential_collisions:
					if is_obstacle(coord):
						can_place = false
						break
				if can_place:
					var success = player.held_object.place()
					if success:
						player.held_object = null
						update_green_highlight(player)
			if neighbor_cell in obstacle_positions:
				var obstacle = obstacle_positions[neighbor_cell]
				if obstacle.has_method("pick_up"):
					var success = obstacle.pick_up()
					if success:
						player.held_object = obstacle
						update_green_highlight(player)
			update_obstacles()
		
		if should_move:
			get_current_player().move(path,path_directions)
			moves_left -= path.size() - 1
			clear_path(player.final_position)
		
		if should_end_turn:
			if player != null:
				clear_path(path[0])
			start_next_turn()


func clear_green_highlight():
	for cell_coord in green_highlight_cells:
		#if tilemap.get_cell_source_id(0,cell_coord) == 2:
		tilemap.set_cell(0,cell_coord, 0, Vector2i.ZERO)
	green_highlight_cells.clear()

func update_green_highlight(player : RedecorationPlayer):
	clear_green_highlight()
	if player.held_object != null and in_pickup_mode:
		var object = player.held_object
		var direction = player.facing_direction
		var cell_neighbor = direction_to_cell_neighbor[direction]
		var point = tilemap.get_neighbor_cell(player.final_position, cell_neighbor)
		if direction == Direction.SW:
			for i in range(object.dimensions.x-1):
				point = tilemap.get_neighbor_cell(point, cell_neighbor)
		elif direction == Direction.SE:
			for i in range(object.dimensions.y-1):
				point = tilemap.get_neighbor_cell(point, cell_neighbor)
		object.tilemap_position = point
		green_highlight_cells.append_array(get_obstacle_tiles(object))
		var to_remove = []
		for cell_coord in green_highlight_cells:
			if tilemap.get_cell_source_id(0,cell_coord) != 0 and tilemap.get_cell_source_id(0,cell_coord) != 2:
				to_remove.append(cell_coord)
		for cell_coord in to_remove:
			green_highlight_cells.erase(cell_coord)
		for cell_coord in green_highlight_cells:
			tilemap.set_cell(0,cell_coord, 2, Vector2i.ZERO)
func get_obstacle_tiles(obstacle):
	var output = []
	var position = obstacle.tilemap_position
	for i in range(obstacle.dimensions.x):
		output.append(position)
		for j in range(obstacle.dimensions.y-1):
			if i%2 == 0:
				var neighbor_dir = direction_to_cell_neighbor[Direction.NW]
				position = tilemap.get_neighbor_cell(position,neighbor_dir)
			else:
				var neighbor_dir = direction_to_cell_neighbor[Direction.SE]
				position = tilemap.get_neighbor_cell(position,neighbor_dir)
			output.append(position)
		var neighbor_dir = direction_to_cell_neighbor[Direction.NE]
		position = tilemap.get_neighbor_cell(position,neighbor_dir)
	return output

func update_obstacles():
	obstacle_positions.clear()
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		var position = obstacle.tilemap_position
		for i in range(obstacle.dimensions.x):
			for j in range(obstacle.dimensions.y-1):
				obstacle_positions[position] = obstacle
				if i%2 == 0:
					var neighbor_dir = direction_to_cell_neighbor[Direction.NW]
					position = tilemap.get_neighbor_cell(position,neighbor_dir)
				else:
					var neighbor_dir = direction_to_cell_neighbor[Direction.SE]
					position = tilemap.get_neighbor_cell(position,neighbor_dir)
			obstacle_positions[position] = obstacle
			
			var neighbor_dir = direction_to_cell_neighbor[Direction.NE]
			position = tilemap.get_neighbor_cell(position,neighbor_dir)

func get_current_player() -> RedecorationPlayer:
	if turn % 3 == 1:
		return player1
	elif turn % 3 == 2: 
		return player2
	return null
	
func get_other_player() -> RedecorationPlayer:
	if turn % 3 == 1:
		return player2
	elif turn % 3 == 2: 
		return player1
	return null
	
func start_next_turn():
	turn += 1
	moves_left = MOVEMENT_PER_TURN
	in_pickup_mode = false
	clear_green_highlight()
	if turn % 3 != 0:
		selected_tile = get_current_player().tilemap_position
		path.clear()
		path.append(selected_tile)
	SignalBus.emit_signal("_turn_changed",turn)
	if turn % 3 == 0:
		blob_timer.start()
		
func is_obstacle(tilemap_position : Vector2i) -> bool:
	if tilemap.get_cell_source_id(0,tilemap_position) == -1:
		return true
	var wall_position = tilemap.get_neighbor_cell(tilemap_position,TileSet.CELL_NEIGHBOR_TOP_CORNER)
	if tilemap.get_cell_source_id(1, wall_position) != -1:
		return true
		
	var cell_type = tilemap.get_cell_source_id(0, tilemap_position)
	if  cell_type != 0 and cell_type != 1 and cell_type != 2:
		return true
	
	if get_other_player().tilemap_position == tilemap_position:
		return true
		
	if tilemap_position in obstacle_positions:
		return true
	return false

func clear_path(player_position):
	for point in path:
		tilemap.set_cell(0,point,0,Vector2i.ZERO)
		path = []
		path_directions = []
		path.append(player_position)
		selected_tile = player_position

func update_tilemap_positions():
	var tilemap_bound_objects = get_tree().get_nodes_in_group("tilemap_bound")
	for node in tilemap_bound_objects:
		if "tilemap_position" in node:
			node.tilemap_position = tilemap.local_to_map(node.position)

func align_objects_to_tilemap():
	var tilemap_bound_objects = get_tree().get_nodes_in_group("tilemap_bound")
	for node in tilemap_bound_objects:
		if "tilemap_position" in node:
			node.position = tilemap.map_to_local(node.tilemap_position)
