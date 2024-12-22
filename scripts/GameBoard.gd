@tool
extends Node2D
class_name GameBoard
enum Direction {NW,NE, SW, SE}
@onready var tilemap = $TileMap
@onready var player1 = $RedecorationPlayer1
@onready var player2 = $RedecorationPlayer2
var turn : int = -1
var selected_tile = null
var path = []
#TODO: move this to player script and export it
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

func get_current_player() -> RedecorationPlayer:
	return player1 if turn % 2 == 0 else player2
	
func get_other_player() -> RedecorationPlayer:
	return player2 if turn % 2 == 0 else player1
	
func start_next_turn():
	turn += 1
	moves_left = MOVEMENT_PER_TURN
	selected_tile = get_current_player().tilemap_position
	path.append(selected_tile)

func is_obstacle(tilemap_position : Vector2i) -> bool:
	if tilemap.get_cell_source_id(0,tilemap_position) == -1:
		return true
	var wall_position = tilemap.get_neighbor_cell(tilemap_position,TileSet.CELL_NEIGHBOR_TOP_CORNER)
	if tilemap.get_cell_source_id(1, wall_position) != -1:
		return true
	
	if get_other_player().tilemap_position == tilemap_position:
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
		
		#handle input
		var movement_direction = null
		var should_move = false
		if turn % 2 == 0:
			if Input.is_action_just_pressed("up_player_1"):
				movement_direction = Direction.NE
			elif Input.is_action_just_pressed("down_player_1"):
				movement_direction = Direction.SW
			elif Input.is_action_just_pressed("left_player_1"):
				movement_direction = Direction.NW
			elif Input.is_action_just_pressed("right_player_1"):
				movement_direction = Direction.SE
			
			if Input.is_action_just_pressed("accept_player_1"):
				should_move = true
				print("hello")
		else:
			if Input.is_action_just_pressed("up_player_2"):
				movement_direction = Direction.NE
			elif Input.is_action_just_pressed("down_player_2"):
				movement_direction = Direction.SW
			elif Input.is_action_just_pressed("left_player_2"):
				movement_direction = Direction.NW
			elif Input.is_action_just_pressed("right_player_2"):
				movement_direction = Direction.SW
			
			if Input.is_action_just_pressed("accept_player_2"):
				should_move = true
		if movement_direction != null:
			var cell_neighbor = direction_to_cell_neighbor[movement_direction]
			var candidate_position = tilemap.get_neighbor_cell(selected_tile,cell_neighbor)
			if !is_obstacle(candidate_position):
				if path.size() > 1 and candidate_position in path:
					if path[path.size()-2] == candidate_position:
						tilemap.set_cell(0,path[path.size()-1] ,0,Vector2i.ZERO)
						path.pop_back()
						selected_tile = candidate_position
				elif moves_left > path.size()-1:
					selected_tile = candidate_position
					path.append(candidate_position)
					tilemap.set_cell(0,selected_tile,1,Vector2i.ZERO)
		
		if should_move:
			get_current_player().move(path)
			for point in path:
				tilemap.set_cell(0,point,0,Vector2i.ZERO)
			moves_left -= path.size() - 1
			path = []
			path.append(get_current_player().tilemap_position)
			
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
