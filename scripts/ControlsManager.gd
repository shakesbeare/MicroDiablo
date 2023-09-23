class_name Controls
extends Node

static var key_pan: Vector2 = Vector2.ZERO
var paused: bool = false

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _input(event):
    if event is InputEventKey:
        if event.is_action_pressed("pause"):
            self.paused = !paused
            if self.paused:
                Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
            
        handle_key_pan(event)
        
func handle_key_pan(event):
    var vec = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")

    key_pan = vec

static func get_key_pan_normalized() -> Vector2:
    return key_pan.normalized()
