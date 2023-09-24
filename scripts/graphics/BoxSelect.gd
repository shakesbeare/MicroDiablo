class_name BoxSelect
extends Node2D

var start_pos: Vector2
var end_pos: Vector2

func _init(start_pos_: Vector2):
    self.start_pos = start_pos_
    self.end_pos = start_pos_

func _process(_delta):
    queue_redraw()

func _draw():
    draw_rect(Rect2(start_pos, end_pos - start_pos), Color.GREEN, false, 10.0)

func update_end_pos(end_pos_: Vector2):
    self.end_pos = end_pos_

func update_start_pos(start_pos_: Vector2):
    self.start_pos = start_pos_

