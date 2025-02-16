extends Label

@onready var tilemap : TileMap = $"../../../GameBoard"
func _process(delta):
	if !tilemap == null:
		var mouse_position = tilemap.get_local_mouse_position()
		text = str(tilemap.local_to_map(mouse_position))
