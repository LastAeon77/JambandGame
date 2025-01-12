@tool
extends Node2D
class_name GameBoard
enum Direction {NW,NE, SW, SE}
@onready var tilemap = $TileMap
@onready var player1 = $RedecorationPlayer1
@onready var player2 = $RedecorationPlayer2
@export var dimensions : Vector2i = Vector2i(9,11)
@onready var blob_timer : Timer = $Timer
var turn : int = -1
var selected_tile = null
var path = []
var path_directions = []
var in_pickup_mode = false
var obstacles :Array[Vector2i] = []
const MOVEMENT_PER_TURN = 5
var moves_left = MOVEMENT_PER_TURN
@export var align_to_tilemap : bool = false

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

func update_obstacles():
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		var position = obstacle.tilemap_position
		if "dimensions" in obstacle:
			for i in obstacle.dimensions.x:
				obstacles.append(position)
				for j in obstacle.dimensions.y-1:
					if i%2 == 0:
						var neighbor_dir = direction_to_cell_neighbor[Direction.SW]
						position = tilemap.get_neighbor_cell(position,neighbor_dir)
					else:
						var neighbor_dir = direction_to_cell_neighbor[Direction.SE]
						position = tilemap.get_neighbor_cell(position,neighbor_dir)
					obstacles.append(position)
				var neighbor_dir = direction_to_cell_neighbor[Direction.NE]
				position = tilemap.get_neighbor_cell(position,neighbor_dir)
		else:
			obstacles.append(position)

func _ready():
	update_obstacles()
	
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
	if  cell_type != 0 and cell_type != 1:
		return true
	
	if get_other_player().tilemap_position == tilemap_position:
		return true
		
	if tilemap_position in obstacles:
		return true
	return false

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
				should_move = true
			
			if Input.is_action_just_pressed("button_2_player_1"):
				if !in_pickup_mode:
					var player_position = path[0]
					clear_path(player_position)
					in_pickup_mode= true
				else:
					in_pickup_mode= false
					
			if Input.is_action_just_pressed("end_turn"):
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
				
			if Input.is_action_just_pressed("button_2_player_2"):
				if !in_pickup_mode:
					var player_position = path[0]
					clear_path(player_position)
					in_pickup_mode= true
				else:
					in_pickup_mode= false
			
			if Input.is_action_just_pressed("end_turn"):
				should_end_turn = true
		else:
			#MR.blob's turn
			if blob_timer.is_stopped():
				start_next_turn()
			pass
			
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
		
		if should_move:
			get_current_player().move(path,path_directions)
			moves_left -= path.size() - 1
			var final_position = path[path.size()-1]
			clear_path(final_position)
		if should_end_turn:
			clear_path(path[0])
			start_next_turn()

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
