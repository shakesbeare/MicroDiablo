class_name Player
extends Node

var player_entity: PlayerEntity
var pointed_cube: int

func _ready():
    self.player_entity = PlayerEntity.new()
    self.add_child(self.player_entity)
    self.player_entity.add_child(self.player_entity.sprite)

func _process(_delta):
    self.player_entity.update()


class PlayerEntity:
    extends Node2D

    var sprite: Sprite2D
    var new_pos: Vector2
    var needs_update: bool

    func _init():
        self.position = Vector2.ZERO
        self.new_pos = Vector2.ZERO
        self.needs_update = false

        var sprite = Sprite2D.new()
        sprite.texture = Graphics.debug_textures["cube"]
        sprite.name = "Player"
        sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE)
        self.sprite = sprite

    func update():
        if self.needs_update:
            self.position = new_pos
            self.new_pos = Vector2.ZERO
            self.needs_update = false



func _on_controls_mouse_point_index(i: int):
    self.pointed_cube = i


func _on_controls_move_attack(button_down: bool):
    if button_down:
        var grid_coord = Graphics.grid_items.positions[self.pointed_cube]
        var y_offset = (Graphics.grid_items.heights[self.pointed_cube] + 1) * Graphics.SPRITE_DIMENSIONS.y
        var new_pos = Isometry.get_world_coord(grid_coord)
        new_pos.y -= y_offset
        self.player_entity.new_pos = new_pos
        self.player_entity.needs_update = true
