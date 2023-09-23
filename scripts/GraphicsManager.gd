class_name Graphics
extends Node

static var GROUND_SIZE = Vector2(128, 128)
static var SCALE = 2

static var grid_items = GridItems.new([], [], [], [])

@onready var cube_parent = Node2D.new()

static var cube_textures = {
    "dirt_cube_corner": preload("res://assets/dirt_cube_corner.png"),
    "grass_cube_corner": preload("res://assets/grass_cube_corner.png"),
    "full_grass_cube_corner": preload("res://assets/full_grass_cube_corner.png"),
}

static var scatter_textures = {
    "dirt_cube_corner_boulder": preload("res://assets/dirt_cube_corner_boulder.png"),
    "grass_cube_corner_leaf": preload("res://assets/grass_cube_corner_leaf.png"),
    "grass_cube_flower_m": preload("res://assets/grass_cube_flower_m.png"),
    "water_cube_m": preload("res://assets/water_cube_m.png"),
    "cliff_border_r": preload("res://assets/cliff_border_r.png"),
    "cliff_border_l": preload("res://assets/cliff_border_l.png"),
}

static var stair_textures = {
    "up": preload("res://assets/stairs_up.png"),
    "down": preload("res://assets/stairs_down.png"),
}

var time_since_last_update: float = 0.0

const SPRITE_DIMENSIONS = Vector2(32, 32)

func _ready():
    var sprite = Sprite2D.new()
    sprite.texture = load("res://assets/selector.png")
    sprite.name = "CursorHighlight"
    sprite.scale = Vector2(SCALE, SCALE)

    self.add_child(cube_parent)
    create_cubes()

    # note that the *bottom* of the node tree is the sprite that's drawn last and therefore the topmost object
    self.add_child(sprite, true)


func _process(_delta):
    update_cubes()


func create_cubes():
    # create a bunch of grid_items to form the terrain out of
    # store them in self.grid_items for use later
    var terrain_map = TerrainMap.new()
    self.grid_items = terrain_map.generate()
    for i in grid_items.size():
        self.add_child(grid_items.sprites[i])
    
    update_cubes()


func update_cubes():
    # update each cube's position to it's stored position internally
    # note: to animate grid_items, update their internal stored position
    var i = grid_items.update_queue.pop_back()
    while i != null:
        var expected_position = Isometry.get_world_coord(grid_items.positions[i])
        var y_offset = grid_items.heights[i] * SPRITE_DIMENSIONS.y
        var actual_position = Vector2(expected_position.x, expected_position.y - y_offset)
        grid_items.sprites[i].position = actual_position

        i = grid_items.update_queue.pop_back()


# subscribed to ControlsManager/mouse_point_highlight_position
func _on_controls_manager_mouse_point_highlight_position(position: Vector2):
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    var child = get_children()[-1] # for some reason, finding it by name didn't work? find_child("CursorHighlight")
    child.position = position


