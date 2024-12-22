extends Sprite2D

@onready var tilemap : TileMap = $".."/TileMap

func _physics_process(delta):
	position = tilemap.map_to_local(round(tilemap.local_to_map(position)))
