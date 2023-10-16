class_name Controls
extends Node

signal mouse_point_index(int)
signal mouse_point_highlight_position(Vector2)

signal select(bool)
signal selected_entities(entities: Array[Entities.Entity])

signal move_attack(bool)

signal ability_1(bool)
signal ability_2(bool)
signal ability_3(bool)
signal ability_4(bool)

static var key_pan: Vector2 = Vector2.ZERO
var paused: bool = false

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(_delta):
    mouse_point()

func _input(event):
    # Keyboard Inputs
    if event is InputEventKey:
        if event.is_action_pressed("pause"):
            self.paused = !paused
            if self.paused:
                Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

        elif event.is_action("pan_left") or event.is_action("pan_right") or event.is_action("pan_up") or event.is_action("pan_down"):    
            handle_key_pan()

        elif event.is_action("ability_1"):
            ability_1.emit(event.is_action_pressed("ability_1"))
        elif event.is_action("ability_2"):
            ability_2.emit(event.is_action_pressed("ability_2"))
        elif event.is_action("ability_3"):
            ability_3.emit(event.is_action_pressed("ability_3"))
        elif event.is_action("ability_4"):
            ability_4.emit(event.is_action_pressed("ability_4"))

    # Other Inputs
    if event.is_action("move_attack"):
        move_attack.emit(event.is_action_pressed("move_attack"))

    elif event.is_action("select"):
        
        if event.is_action_released("select"):
            var entities = Entities.get_entities_in_rect(Graphics.box.start_pos, Graphics.box.end_pos)
            selected_entities.emit(entities["in"])

        select.emit(event.is_action_pressed("select"))

func mouse_point():
    # update cursor highlight position
    var camera = get_tree().get_root().get_node("Node2D/Camera2D")
    var highlighted_tile = Isometry.get_grid_coord(Isometry.screen_to_world_point(camera))
    
    highlighted_tile.y = clamp(highlighted_tile.y, -4, 126)
    highlighted_tile.x = clamp(highlighted_tile.x, -4, 126)

    var expected_position = Isometry.get_world_coord(highlighted_tile)
    var pointed_index = 0

    if expected_position not in Graphics.grid_items.world_position_map.keys():
        expected_position.y -= Graphics.SPRITE_DIMENSIONS.y

    if expected_position in Graphics.grid_items.world_position_map.keys():
        pointed_index = Graphics.grid_items.world_position_map[expected_position]

    mouse_point_index.emit(pointed_index)
    mouse_point_highlight_position.emit(expected_position)

func handle_key_pan():
    var vec = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")

    key_pan = vec

static func get_key_pan_normalized() -> Vector2:
    return key_pan.normalized()
