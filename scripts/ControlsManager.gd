class_name Controls
extends Node

static var key_pan: Vector2 = Vector2.ZERO

func _input(event):
    if event is InputEventKey:
        handle_key_pan(event)

func handle_key_pan(event):
    var vec = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")

    key_pan = vec

static func get_key_pan_normalized() -> Vector2:
    return key_pan.normalized()
