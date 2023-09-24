class_name Player
extends Node

var player_entity: PlayerEntity
var pointed_cube: int

func _ready():
    self.player_entity = PlayerEntity.new()
    self.add_child(self.player_entity)
    self.player_entity.add_child(self.player_entity.sprite)

func _process(delta):
    self.player_entity.move(delta)


class PlayerEntity:
    extends Node2D

    var sprite: Sprite2D


    var grid_position: Vector2
    var grid_height: float

    var move_targets: Array[Vector2]
    var target_heights: Array[float]
    var time_since_last_move: float = 0
    var movement_speed: int = 5


    func _init():
        self.grid_position = Vector2.ZERO
        self.grid_height = Graphics.grid_items.heights[0]

        var expected_position = Isometry.get_world_coord(self.grid_position)
        var y_offset = self.grid_height * Graphics.SPRITE_DIMENSIONS.y
        self.position = expected_position - Vector2(0, y_offset)

        var sprite = Sprite2D.new()
        sprite.texture = Graphics.debug_textures["cube"]
        sprite.name = "Player"
        sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE)
        self.sprite = sprite

    func move(delta):
        if self.time_since_last_move >= 1.0 / self.movement_speed:
            if self.move_targets.size() > 0:
                self.grid_position = self.move_targets.pop_back()
                if self.target_heights.size() > 0:
                    self.grid_height = self.target_heights.pop_back()
                self.update_position()
                self.time_since_last_move = 0
        else:
            self.time_since_last_move += delta

    func update_position():
        var expected_position = Isometry.get_world_coord(self.grid_position)
        var y_offset = self.grid_height * Graphics.SPRITE_DIMENSIONS.y
        self.position = expected_position - Vector2(0, y_offset)

func _on_controls_mouse_point_index(i: int):
    self.pointed_cube = i


func _on_controls_move_attack(button_down: bool):
    if button_down:
        var grid_coord = Graphics.grid_items.positions[self.pointed_cube]
        var points = Paths.pathfinding.FindPath(self.player_entity.grid_position, grid_coord)

        self.player_entity.move_targets.clear()
        for item in points:
            var cube_index = Graphics.grid_items.grid_position_map[item]
            self.player_entity.move_targets.push_front(item)
            self.player_entity.target_heights.push_front(Graphics.grid_items.heights[cube_index] + 1)

