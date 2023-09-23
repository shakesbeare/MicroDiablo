class_name Controls
extends Node

signal mouse_point_index(int)
signal mouse_point_highlight_position(Vector2)
signal move_attack(bool)

static var key_pan: Vector2 = Vector2.ZERO
var paused: bool = false

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(_delta):
    mouse_point()

func _input(event):
    if event is InputEventKey:
        if event.is_action_pressed("pause"):
            self.paused = !paused
            if self.paused:
                Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
            
        handle_key_pan()

    if event.is_action("move_attack"):
        move_attack.emit(event.is_action_pressed("move_attack"))
        
func mouse_point():
    # update cursor highlight position
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    var highlighted_tile = Isometry.get_grid_coord(Isometry.screen_to_world_point(camera))
    
    highlighted_tile.y = clamp(highlighted_tile.y, -4, 126)
    highlighted_tile.x = clamp(highlighted_tile.x, -4, 126)

    var expected_position = Isometry.get_world_coord(highlighted_tile)
    var pointed_index = 0

    if expected_position not in Graphics.grid_items.position_map.keys():
        expected_position.y -= Graphics.SPRITE_DIMENSIONS.y

    if expected_position in Graphics.grid_items.position_map.keys():
        pointed_index = Graphics.grid_items.position_map[expected_position]

    mouse_point_index.emit(pointed_index)
    mouse_point_highlight_position.emit(expected_position)

func handle_key_pan():
    var vec = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")

    key_pan = vec

static func get_key_pan_normalized() -> Vector2:
    return key_pan.normalized()
