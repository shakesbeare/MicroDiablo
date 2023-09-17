extends Node

const Isometry = preload("res://Isometry.gd")
const Floor = preload("res://Floor.gd")

# Called when the node enters the scene tree for the first time.
func _ready():

	var floor = Floor.new()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://selector.png")
	self.add_child(sprite)
	
	var child = get_children()[0]
	child.scale = Vector2(floor.SCALE, floor.SCALE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var isometry = Isometry.new()
	var highlighted_tile = isometry.get_grid_coord(screen_to_world_point())
	var child = get_children()[0]
	child.position = isometry.get_world_coord(highlighted_tile)

func screen_to_world_point():
	var camera = get_tree().get_root().get_node("Node2D/Camera2D")
	var viewport = camera.get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos.y += 30
	
	var x_offset = mouse_pos.x - viewport.x / 2
	var y_offset = mouse_pos.y - viewport.y / 2
	
	return Vector2(camera.position.x + x_offset, camera.position.y + y_offset)
