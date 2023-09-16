extends Node

const Isometry = preload("res://Isometry.gd")

const GROUND_SIZE = Vector2(64, 64)
const SPRITE_DIMENSIONS = Vector2(32, 32)
const SCALE = 2

func _ready():
	place_tiles()

func place_tiles():
	var texture = load("res://cube.png")
	var dimensions = Vector2(32, 32)
	
	for i in range(GROUND_SIZE.x * GROUND_SIZE.y):
		var sprite = Sprite2D.new()
		sprite.texture = texture
		self.add_child(sprite)
	
	recenter_tiles()

func recenter_tiles():
	var isometry = Isometry.new()
	var children = self.get_children()
	var index = 0
	
	var grid_y_offset = SPRITE_DIMENSIONS.y * SCALE / 2 * GROUND_SIZE.x / 2
	
	for i in range(GROUND_SIZE.x):
		for j in range(GROUND_SIZE.y):
			var child = children[index]
			child.position = Vector2(isometry.get_screen_coord(Vector2(i, j)))
			child.position.y -= grid_y_offset
			child.scale = Vector2(SCALE, SCALE)
			index += 1
	
