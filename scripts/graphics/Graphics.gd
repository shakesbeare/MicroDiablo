class_name Graphics
extends Node


const SPRITE_DIMENSIONS = Vector2(32, 32)
static var GROUND_SIZE = Vector2(128, 128)
static var SCALE = 2

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

static var entity_textures = {
    "guydude": preload("res://assets/guydude.png")
}

static var stair_textures = {
    "up": preload("res://assets/stairs_up.png"),
    "down": preload("res://assets/stairs_down.png"),
}

static var ui_textures = {
    "selector": preload("res://assets/selector.png"),
    "selector_selected": preload("res://assets/selector_selected.png")
}

static var debug_textures = {
    "cube": preload("res://assets/cube.png"),
    "cube_red": preload("res://assets/cube_red.png"),
}

static var grid_items = GridItems.init()

static var cube_parent = Node2D.new()
var time_since_last_update: float = 0.0
var selector: Sprite2D

static var box: BoxSelect

func _ready():

    cube_parent.name = "CubeParent"
    cube_parent.y_sort_enabled = true
    self.add_child(cube_parent)
    create_cubes()

    box = BoxSelect.new(Vector2.ZERO)
    box.name = "BoxSelect"
    self.add_child(box)
    box.hide()

    # note that the *bottom* of the node tree is the sprite that's drawn last and therefore the topmost object
    var selector_sprite = Sprite2D.new()
    selector_sprite.texture = ui_textures["selector"]
    selector_sprite.name = "CursorHighlight"
    selector_sprite.scale = Vector2(SCALE, SCALE)
    self.add_child(selector_sprite, true)
    selector = get_children()[-1]

    box.z_index = 4096
    selector.z_index = 4096


func _on_player_ready():
    for entity in Entities.list:
        entity.spawn()


func _process(_delta):
    update_cubes()
    update_box()


func create_cubes():
    # create a bunch of grid_items to form the terrain out of
    # store them in self.grid_items for use later
    var terrain_map = TerrainMap.new()
    self.grid_items = terrain_map.generate()
    for i in self.grid_items.size():
        cube_parent.add_child(self.grid_items.sprites[i])

    grid_items.update_all()


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


func update_box():
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    box.update_end_pos(Isometry.screen_to_world_point(camera))
    var entities = Entities.get_entities_in_rect(box.start_pos, box.end_pos)


func _on_controls_manager_mouse_point_highlight_position(position: Vector2):
    selector.position = position


func _on_controls_move_attack(button_down: bool):
    if button_down:
        selector.texture = ui_textures["selector_selected"]
    else:
        selector.texture = ui_textures["selector"]


func _on_controls_select(button_down: bool):
    if button_down:
        selector.hide()
        var camera = get_tree().get_root().get_node("Node2D/Camera2D")
        box.update_start_pos(Isometry.screen_to_world_point(camera))
        box.show()
    else:
        selector.show()
        box.hide()
        box.update_start_pos(Vector2.ZERO)
        box.update_end_pos(Vector2.ZERO)

    




