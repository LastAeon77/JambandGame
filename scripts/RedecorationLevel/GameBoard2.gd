@tool
extends TileMap
class_name Gameboard2

@export var align : bool = false

enum Direction {NW,NE, SW, SE}
enum Highlight_Color {RED, GREEN, BLUE}
@onready var mr_blob = $MrBlob 
@onready var player1 = $RedecorationPlayer1 
@onready var player2 = $RedecorationPlayer2

var turn_order
var turn_index = 0

var border
func get_color_source_id(color : Highlight_Color):
	match color:
		Highlight_Color.RED:
			return 10
		Highlight_Color.GREEN:
			return 11
		Highlight_Color.BLUE:
			return 12
	
func get_border_tiles():
	var border = []
	border.append_array(get_used_cells(2))
	border.append_array(get_used_cells(4))
	border.append_array(get_used_cells(7))
	for i in range(len(border)):
		border[i] = border[i] + Vector2i(1,1)
	border.append(Vector2i(-4,-13))
	return border
	
func get_tilemap_bound_children():
	var children = get_children()
	children = children.filter(func (child): 
			return child.is_in_group("tilemap_bound")
	)
	return children

func get_items():
	var children = get_children()
	children = children.filter(func (child): 
			return child.is_in_group("obstacles")
	)
	return children

func is_obstacle(point : Vector2i) -> bool:
	if border.has(point):
		return true
	if point == player1.tilemap_position or point == player2.tilemap_position:
		return true
	var items = get_items()
	for item in items:
		if item.get_tiles().has(point):
			return true
	return false

func sort_children():
	var children = get_tilemap_bound_children()
	children.erase(mr_blob)
	for i in range(1,len(children)):
		var child = children[i]
		var j = i - 1
		while j >= 0 and children[j].tilemap_position.y < child.tilemap_position.y:
			children[j+1] = children[j]
			j -= 1
		children[j + 1] = child
	
	for i in range(1,len(children)):
		var child = children[i]
		var j = i - 1
		while j >= 0 and children[j].tilemap_position.x < child.tilemap_position.x:
			children[j+1] = children[j]
			j -= 1
		children[j + 1] = child
		
	for i in range(len(children)):
		var child = children[i]
		child.z_index = 98 - i

func try_pickup(character, coord : Vector2i):
	var children = get_items()
	var item_positions = {}
	for child in children:
		if child.has_method("get_tiles") and child.is_in_group("obstacles"):
			var tiles = child.get_tiles()
			for tile in tiles:
				if tile == coord:
					character.held_object = child.pick_up()
					return
func any_intersection(a : Array ,b : Array) -> bool:
	for item in b:
		if a.has(item):
			return true
	return false

func try_place(character, item_to_be_placed : Furniture):
	var placement_tiles = item_to_be_placed.get_tiles()
	
	if placement_tiles.has(player1.tilemap_position) or placement_tiles.has(player2.tilemap_position):
		return
	
	if any_intersection(border,placement_tiles):
		return
	
	var items = get_items()
	for item in items:
		var occupied_tiles = item.get_tiles()
		if any_intersection(occupied_tiles,placement_tiles):
			if item_to_be_placed.place(item):
				character.held_item = null
			return
	if item_to_be_placed.place():
		character.held_object = null

func update_tilemap_positions():
	var children = get_tilemap_bound_children()
	for node in children:
		if "tilemap_position" in node:
			node.tilemap_position = local_to_map(node.position)

func align_children_to_tilemap():
	var children = get_tilemap_bound_children()
	for child in children:
		if "tilemap_position" in child:
			child.position = map_to_local(child.tilemap_position)

func draw_highlight(positions, color, clear):
	if clear:
		clear_layer(1)
	for pos in positions:
		set_cell(1,pos,get_color_source_id(color),Vector2i.ZERO)

func clear_highlight():
	clear_layer(1)
	
func get_turn_order():
	pass

func _ready():
	if !Engine.is_editor_hint():
		SignalBus._update_highlight.connect(draw_highlight)
		update_tilemap_positions()
		align_children_to_tilemap()
		$RedecorationPlayer1.start_turn()
		SignalBus._pickup.connect(try_pickup)
		SignalBus._place.connect(try_place)
		border = get_border_tiles()
		
func _process(_delta):
	if !Engine.is_editor_hint():
		align_children_to_tilemap()
		sort_children()
	elif align:
		align = false
		update_tilemap_positions()		
		align_children_to_tilemap()

