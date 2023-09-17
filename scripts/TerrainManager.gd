class_name TerrainManager
extends Node

@onready var isometry = Isometry.new()
@onready var cube_parent = Node2D.new()

@export var GROUND_SIZE = Vector2(64, 64)
@export var SCALE = 2

const SPRITE_DIMENSIONS = Vector2(32, 32)

var cubes : Array[GridItem]

func _ready():
    
    var sprite = Sprite2D.new()
    sprite.texture = load("res://assets/selector.png")
    sprite.name = "CursorHighlight"
    sprite.scale = Vector2(SCALE, SCALE)

    self.add_child(cube_parent)
    create_tiles()

    # note that the *bottom* of the node tree is the sprite that's drawn last and therefore the topmost object
    self.add_child(sprite, true)

func _process(_delta):

    render_tiles()
    highlight_under_cursor()
    demo_animation()

func create_tiles():
    # create a bunch of cubes to form the terrain out of
    # store them in self.cubes for use later
    var cube_texture = load("res://assets/grass_cube_corner.png")
    
    for i in range(GROUND_SIZE.x):
        for j in range(GROUND_SIZE.y):
            var sprite = Sprite2D.new()
            sprite.texture = cube_texture
            sprite.name = "GroundCube" + str(i)
            sprite.scale = Vector2(SCALE, SCALE)
            cube_parent.add_child(sprite)

            cubes.append(GridItem.new(
                sprite,
                Vector2(i, j),
                i
            ))
    

func render_tiles():
    # update each cube's position to it's stored position internally
    # note: to animate cubes, update their internal stored position
    for item in cubes:
        var expected_position = isometry.get_world_coord(item.position)
        var y_offset = item.height * SPRITE_DIMENSIONS.y
        
        var actual_position = Vector2(expected_position.x, expected_position.y + y_offset)

        item.sprite.position = actual_position

func highlight_under_cursor():
    # update cursor highlight position
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    var highlighted_tile = isometry.get_grid_coord(isometry.screen_to_world_point(camera))
    var child = get_children()[-1] # for some reason, finding it by name didn't work? find_child("CursorHighlight")
    child.position = isometry.get_world_coord(highlighted_tile)

func demo_animation():
    for i in cubes.size():
        cubes[i].height = sin(Time.get_unix_time_from_system() * i / 100)

