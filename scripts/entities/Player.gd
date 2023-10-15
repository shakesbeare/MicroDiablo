class_name Player
extends Node

var controlled_units: Array[PlayerEntity] = []
var selected_units: Array[PlayerEntity] = []
var pointed_cube: int


func _ready():
    self.controlled_units.append_array([PlayerEntity.new(), PlayerEntity.new()])
    self.controlled_units[1].sprite.texture = Graphics.debug_textures["cube_red"]
    self.controlled_units[1].grid_position = Vector2(1, 1);
    self.controlled_units[1].grid_height = Graphics.grid_items.heights[Graphics.grid_items.grid_position_map[self.controlled_units[1].grid_position]] + 1
    self.controlled_units[1].movement_speed = 3

    for entity in self.controlled_units:
        self.selected_units.append(entity)
        self.add_child(entity)


func _process(delta):
    for entity in self.controlled_units:
        entity.pathfind()
        entity.move(delta)

func add_controlled_unit(entity: PlayerEntity):
    self.controlled_units.append(entity)
    self.selected_units.append(entity)
    self.add_child(entity)
    entity.add_child(entity.sprite)

class PlayerEntity:
    extends Entities.Entity

    var player_scene = preload("res://player.tscn") # scenes are equivalent to prefabs in unity

    var move_targets: Array[Vector2]
    var target_heights: Array[float]
    var current_move_target : Vector2
    var time_since_last_move: float = 0
    var movement_speed: int = 5


    func _init():
        self.tags.append_array(["Player", "Controllable"])

        self.grid_position = Vector2.ZERO
        self.grid_height = Graphics.grid_items.heights[0] + 1

        var expected_position = Isometry.get_world_coord(self.grid_position)
        var y_offset = self.grid_height * Graphics.SPRITE_DIMENSIONS.y
        self.position = expected_position - Vector2(0, y_offset)

        self.id = Entities.get_next_id()

        var instance = player_scene.instantiate()
        self.sprite = player_scene.instantiate()
        self.sprite.name = "Player" + str(self.id)
        self.sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE);

        Entities.add(self)
        self.update_position()


    func move(delta):
        if self.time_since_last_move >= 1.0 / self.movement_speed:
            if self.move_targets.size() > 0:
                var old_position = self.grid_position
                self.grid_position = self.move_targets.pop_back()

                for entity in Entities.list:
                    if entity == self:
                        continue
                    if self.grid_position == entity.grid_position:
                        self.grid_position = old_position
                        break

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
        self.move_sprite()
        self.sprite.z_index = self.grid_height

    func pathfind():
        var points = Paths.pathfinding.FindPath(self.grid_position, self.current_move_target)

        self.move_targets.clear()
        self.target_heights.clear()
        for item in points:
            var cube_index = Graphics.grid_items.grid_position_map[item]
            self.move_targets.push_front(item)
            self.target_heights.push_front(Graphics.grid_items.heights[cube_index] + 1)


func _on_controls_mouse_point_index(i: int):
    self.pointed_cube = i


func _on_controls_move_attack(button_down: bool):
    if button_down:
        for entity in self.selected_units:
            entity.current_move_target = Graphics.grid_items.positions[self.pointed_cube]




func _on_controls_ability_1(button_down: bool):
    pass


func _on_controls_ability_2(button_down: bool):
    pass


func _on_controls_ability_3(button_down: bool):
    pass


func _on_controls_ability_4(button_down: bool):
    pass

