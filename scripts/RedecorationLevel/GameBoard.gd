@tool
extends TileMap
class_name GameBoard

@export var align : bool = false

enum Direction {NW,NE, SW, SE}
enum Highlight_Color {RED, GREEN, BLUE} 
@onready var mr_blob = $MrBlob 
@onready var player1 = $RedecorationPlayer1 
@onready var player2 = $RedecorationPlayer2
@onready var turn_label = $"%TurnLabel"

var turn_order
var turn_index = 0
var border
var all_furniture_in_house = false

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
	var comparison = func (a,b):
		var apos = a.tilemap_position
		var bpos = b.tilemap_position
		var a_top_left = a.get_top_left() if a.has_method("get_top_left") else a.tilemap_position
		var b_top_left =  b.get_top_left() if b.has_method("get_top_left") else b.tilemap_position
		
		if a.name == "Couch" and b == player1 or b.name=="Couch" and a == player1:
			pass
		
		if a_top_left.y > bpos.y:
			return true
		if b_top_left.y > apos.y:
			return false
		
		if apos.x <= bpos.x and apos.y <= bpos.y :
			return false
		if bpos.x <= apos.x and bpos.y <= apos.y :
			return true
		
		return false
	
	for i in range(1,len(children)):
		var child = children[i]
		var j = i - 1
		while j >= 0 and comparison.call(child, children[j]):
			children[j+1] = children[j]
			j -= 1
		children[j + 1] = child
		
	for i in range(len(children)):
		var child = children[i]
		child.z_index = 98 - i

func try_pick_up(character, coord : Vector2i):
	var children = get_items()
	for child in children:
		if child.has_method("get_tiles") and child.is_in_group("obstacles"):
			var tiles = child.get_tiles()
			for tile in tiles:
				if tile == coord:
					character.held_object = child.pick_up()
					return

func align_location(item):
	item.position = map_to_local(item.tilemap_position)

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
	var in_correct_spots = mr_blob.all_items_in_house()
	for item in items:
		var occupied_tiles = item.get_tiles()
		in_correct_spots = in_correct_spots and item.is_in_correct_spot()
		if any_intersection(occupied_tiles,placement_tiles):
			if item_to_be_placed.place(item):
				character.held_object = null
			return
	if item_to_be_placed.place():
		character.held_object = null
	in_correct_spots = in_correct_spots and item_to_be_placed.is_in_correct_spot()
	
	if in_correct_spots:
		SignalBus._redecoration_victory.emit()
		
func update_tilemap_positions():
	var children = get_tilemap_bound_children()
	for node in children:
		if "tilemap_position" in node:
			node.tilemap_position = local_to_map(node.position)

func align_children_to_tilemap():
	var children = get_children()
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
	SignalBus._highlight_changed.emit(false)
	
func get_turn_order():
	var initiatives = []
	var turn_order = []
	for i in mr_blob.initiatives:
		initiatives.append(i)
		turn_order.append(mr_blob)
		
	for i in player1.initiatives:
		initiatives.append(i)
		turn_order.append(player1)
		
	for i in player2.initiatives:
		initiatives.append(i)
		turn_order.append(player2)
	
	for i in range(len(initiatives)):
		var initiative = initiatives[i]
		var character = turn_order[i]
		var j = i - 1
		while j >= 0 and initiatives[j] < initiatives[i]:
			initiatives[j+1] = initiatives[j]
			turn_order[j+1] = turn_order[j]
			j -= 1
		initiatives[j + 1] = initiative
		turn_order[j + 1] = character
	return turn_order

func _ready():
	if !Engine.is_editor_hint():
		SignalBus._update_highlight.connect(draw_highlight)
		SignalBus._end_turn.connect(start_next_turn)
		update_tilemap_positions()
		align_children_to_tilemap()
		SignalBus._pickup.connect(try_pick_up)
		SignalBus._place.connect(try_place)
		border = get_border_tiles()
		start_next_turn()
		
func _process(_delta):
	if !Engine.is_editor_hint():
		align_children_to_tilemap()
		sort_children()
	elif align:
		align = false
		update_tilemap_positions()		
		align_children_to_tilemap()
		
func start_next_turn():
	if turn_order == null:
		turn_order = get_turn_order()
		turn_order.push_front(mr_blob)
		turn_index = 0
	elif turn_index >= len(turn_order) - 1:
		turn_index = 0
		turn_order = get_turn_order()
	else:
		turn_index += 1
	turn_order[turn_index].start_turn()
	update_turn_label(turn_order[turn_index])

func update_turn_label(character):
	match character:
		mr_blob:
			turn_label.set_turn(0)
		player1:
				turn_label.set_turn(1)
		player2:
				turn_label.set_turn(2)
