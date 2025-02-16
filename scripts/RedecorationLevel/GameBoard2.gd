@tool
extends TileMap
class_name Gameboard2

@export var align : bool = false

enum Direction {NW,NE, SW, SE}
enum Highlight_Color {RED, GREEN, BLUE}

func get_color_source_id(color : Highlight_Color):
	match color:
		Highlight_Color.RED:
			return 10
		Highlight_Color.GREEN:
			return 11
		Highlight_Color.BLUE:
			return 12

func _ready():
	if !Engine.is_editor_hint():
		SignalBus._update_highlight.connect(set_highlight)
		update_tilemap_positions()
		align_children_to_tilemap()
		$RedecorationPlayer1.start_turn()
	
func update_tilemap_positions():
	var tilemap_bound_objects = get_tree().get_nodes_in_group("tilemap_bound")
	for node in tilemap_bound_objects:
		if "tilemap_position" in node:
			node.tilemap_position = local_to_map(node.position)

func align_children_to_tilemap():
	var children = get_children()
	children = children.filter(func child(x): 
			return x.is_in_group("tilemap_bound")
	)
	for child in children:
		if "tilemap_position" in child:
			child.position = map_to_local(child.tilemap_position)

func set_highlight(positions, color):
	clear_layer(1)
	for pos in positions:
		set_cell(1,pos,get_color_source_id(color),Vector2i.ZERO)
func clear_highlight():
	clear_layer(1)
	
func get_turn_order():
	pass

func _process(_delta):
	if !Engine.is_editor_hint():
		align_children_to_tilemap()
	elif align:
		align = false
		update_tilemap_positions()		
		align_children_to_tilemap()

