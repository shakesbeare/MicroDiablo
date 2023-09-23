class_name Settings
extends Node

static var PAN_SENSITIVITY_MULT: int = 1000

static var ENABLE_EDGE_PAN: bool = true
static var EDGE_PAN_SENSITIVITY: float = 10
static var KEY_PAN_SENSITIVITIY: float = 5


static func get_edge_pan_speed() -> float:
    return EDGE_PAN_SENSITIVITY * PAN_SENSITIVITY_MULT

static func get_key_pan_speed() -> float:
    return KEY_PAN_SENSITIVITIY * PAN_SENSITIVITY_MULT
