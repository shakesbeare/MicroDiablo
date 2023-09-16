extends Node

const Isometry = preload("res://Isometry.gd")

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	highlight_square()

func highlight_square():
	var isometry = Isometry.new()
	
	var mouse_pos = get_viewport().get_mouse_position()
