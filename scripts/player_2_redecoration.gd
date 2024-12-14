extends AnimatedSprite2D
class_name RedecorationPlayer

enum Direction {NW,NE, SW, SE}
@onready var tilemap : TileMap = $"../TileMap"
var tilemap_position
var moving = false
@export_range(1,2) var player : int = 1
	
func _ready():
	tilemap_position = tilemap.local_to_map(position)

#TODO turn based movement
func _process(delta):
	position = tilemap.map_to_local(
			tilemap_position
		)
	
	tilemap_position = tilemap.local_to_map(position)
	if(Input.is_action_just_pressed("up_player_1")):
		move(Direction.NW, 1)
	if(Input.is_action_just_pressed("down_player_1")):
		move(Direction.SE, 1)

#TODO check for obstacles at given tilemap coord
func is_obstacle(point : Vector2i) -> bool:
	print("FUNCTION: 'is_obstacle' IS UNFINISHED. SCRIPT: ",get_script())
	return false
	
func direction_to_cell_neighbor(direction:Direction) -> TileSet.CellNeighbor:
	match direction:
		Direction.NW:
			return TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE
		Direction.NE:
			return TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE
		Direction.SW:
			return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
		Direction.SE:
			return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE
		_:
			push_error("invalid direction. Returning Top left")
			return TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE

func direction_to_animation_name(direction:Direction) -> String:
	match direction:
		Direction.NW:
			return "move_nw"
		Direction.NE:
			return "move_ne"
		Direction.SW:
			return "move_sw"
		Direction.SE:
			return "move_se"
		_:
			push_error("invalid direction. Returning Top left")
			return "default"

#
func move(direction: Direction, num_tiles : int):
	if(moving):
		return
	moving = true
	
	var neighbor = direction_to_cell_neighbor(direction)
	var animation_name = direction_to_animation_name(direction)
	var animation_speed = sprite_frames.get_animation_speed(animation_name)
	var frame_count = sprite_frames.get_frame_count(animation_name)
	var duration = animation_speed * frame_count
	
	for i in range(num_tiles):
		var next_cell = tilemap.get_neighbor_cell(tilemap_position,neighbor)
		if(!is_obstacle(next_cell)):
			play(animation_name)
			await animation_finished
			tilemap_position = tilemap.to_global(next_cell)
		else:
			break
	moving = false
