extends Node

const GROUND_SIZE = Vector2(128, 128)
const SPRITE_DIMENSIONS = Vector2(32, 32)
const SCALE = 2

func _ready():
	place_tiles()

func _process(delta):
	pass

func get_screen_coord(world_coord: Vector2, sprite_dimensions: Vector2, scale: int):
	var i_hat = Vector2(0.5 * sprite_dimensions.x, 0.25 * sprite_dimensions.y) * scale
	var j_hat = Vector2(-0.5 * sprite_dimensions.x, 0.25 * sprite_dimensions.y) * scale
	
	var new_x = world_coord.x * i_hat.x + world_coord.y * j_hat.x
	var new_y = world_coord.x * i_hat.y + world_coord.y * j_hat.y
	
	return Vector2(new_x, new_y)
	
	
func place_tiles():
	var texture = load("res://cube.png")
	var dimensions = Vector2(32, 32)
	
	for i in range(GROUND_SIZE.x * GROUND_SIZE.y):
		var sprite = Sprite2D.new()
		sprite.texture = texture
		self.add_child(sprite)
	
	recenter_tiles()

func recenter_tiles():
	var children = self.get_children()
	var index = 0
	
	var grid_y_offset = SPRITE_DIMENSIONS.y * SCALE / 2 * GROUND_SIZE.x / 2
	
	for i in range(GROUND_SIZE.x):
		for j in range(GROUND_SIZE.y):
			var child = children[index]
			child.position = Vector2(get_screen_coord(Vector2(i, j), SPRITE_DIMENSIONS, SCALE))
			child.position.y -= grid_y_offset
			child.scale = Vector2(SCALE, SCALE)
			index += 1
	
