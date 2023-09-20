class_name GraphicsManager
extends Node

@export var GROUND_SIZE = Vector2(128, 128)
@export var SCALE = 2

@onready var isometry = Isometry.new()
@onready var cube_parent = Node2D.new()
@onready var grid_items = GridItems.new([], [], [], [])
@onready var textures = {
    "cube": load("res://assets/cube.png"),
    "dirt_cube_corner": load("res://assets/dirt_cube_corner.png"),
    "dirt_cube_corner_boulder": load("res://assets/dirt_cube_corner_boulder.png"),
    "full_grass_cube_corner": load("res://assets/full_grass_cube_corner.png"),
    "grass_cube_corner": load("res://assets/grass_cube_corner.png"),
    "grass_cube_corner_leaf": load("res://assets/grass_cube_corner_leaf.png"),
    "grass_cube_corner_texture_one": load("res://assets/grass_cube_corner_texture_one.png"),
    "grass_cube_corner_texture_two": load("res://assets/grass_cube_corner_texture_two.png"),
    "grass_cube_corner_texture_three": load("res://assets/grass_cube_corner_texture_three.png"),
    "water_cube_corner": load("res://assets/water_cube_corner.png")
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


func _process(delta):
    update_cubes()
    highlight_under_cursor()
    demo_animation()


func create_cubes():
    # create a bunch of grid_items to form the terrain out of
    # store them in self.grid_items for use later
    var count = 0
    
    for i in range(GROUND_SIZE.x):
        for j in range(GROUND_SIZE.y):
            var sprite = Sprite2D.new()
            sprite.texture = textures["grass_cube_corner"]
            sprite.name = "GroundCube" + str(count)
            sprite.scale = Vector2(SCALE, SCALE)
            cube_parent.add_child(sprite)

            var height = 0
            var group: String = "down"

            if i < 32:
                group = "up"
                if j < 32:
                    group = "upup"
                    height += 1
                height += 1
            elif i > 96 and j > 96:
                group = "down"
                height -= 1
            elif i < 96 and i > 64 and j < 96 and j > 64:
                group = "water"
                height -= 2

            grid_items.add(sprite, Vector2(i, j), height, group)

            count += 1
    
    update_cubes()


func update_cubes():
    # update each cube's position to it's stored position internally
    # note: to animate grid_items, update their internal stored position
    var i = grid_items.update_queue.pop_back()
    while i != null:
        var expected_position = isometry.get_world_coord(grid_items.positions[i])
        var y_offset = grid_items.heights[i] * SPRITE_DIMENSIONS.y
        var actual_position = Vector2(expected_position.x, expected_position.y - y_offset)
        grid_items.sprites[i].position = actual_position

        grid_items.sprites[i].texture = dirt_on_edges(i)

        i = grid_items.update_queue.pop_back()


func highlight_under_cursor():
    # update cursor highlight position
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    var highlighted_tile = isometry.get_grid_coord(isometry.screen_to_world_point(camera))
    var child = get_children()[-1] # for some reason, finding it by name didn't work? find_child("CursorHighlight")
    child.position = isometry.get_world_coord(highlighted_tile)


func demo_animation():
    for i in grid_items.size():
        if grid_items.groups[i] == "upup":
            var new_height = sin(Time.get_unix_time_from_system() * i / 500)
            grid_items.update_cube(i, grid_items.positions[i], new_height)

func dirt_on_edges(i: int):
    var current_pos = grid_items.positions[i]
    if grid_items.heights[i] > 0:
        if current_pos.x >= GROUND_SIZE.x - 1 or current_pos.y >= GROUND_SIZE.y - 1: 
            var rng = RandomNumberGenerator.new()
            var num = rng.randi_range(0, 3)
            var grasses = [textures["grass_cube_corner"], textures["grass_cube_corner_texture_one"], textures["grass_cube_corner_texture_two"], textures["grass_cube_corner_texture_three"]]
            return grasses[num]
        else:
            return textures["full_grass_cube_corner"]
    elif grid_items.heights[i] == -1:
        var rng = RandomNumberGenerator.new()
        var num = rng.randi_range(0, 1)
        var dirts = [textures["dirt_cube_corner"], textures["dirt_cube_corner_boulder"]]
        return dirts[num]
    elif grid_items.heights[i] < -1:
        return textures["water_cube_corner"]
    else:
        var rng = RandomNumberGenerator.new()
        var num = rng.randi_range(0, 3)
        var grasses = [textures["grass_cube_corner"], textures["grass_cube_corner_texture_one"], textures["grass_cube_corner_texture_two"], textures["grass_cube_corner_texture_three"]]
        return grasses[num]

