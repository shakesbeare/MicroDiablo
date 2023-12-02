# Handles the player theirself as they interact with the world and their units

class_name Player
extends Node

var controlled_units: Array[ControllableEntity] = []
var selected_units: Array[ControllableEntity] = []
var pointed_cube: int
var is_queueing: bool = false
var terrain_ready: bool = false

var groups = [
    [],
    [],
    [],
    [],
    [],
    [],
]


## Only create players when GridItems is populated
func _on_graphics_terrain_ready(callback: Callable):
    self.ready()
    terrain_ready = true
    callback.call()


func ready():
    self.controlled_units.append_array(
        [ControllableEntity.new(), ControllableEntity.new()]
    )
    self.controlled_units[1].sprite.texture = (
        Graphics.debug_textures["cube_red"]
    )
    self.controlled_units[1].grid_position = Vector2(2, 5)
    self.controlled_units[1].grid_height = (
        Graphics.grid_items.heights[Graphics.grid_items.grid_position_map[
            self.controlled_units[1].grid_position
        ]]
        + 1
    )
    self.controlled_units[1].movement_speed = 3

    for entity in self.controlled_units:
        self.selected_units.append(entity)
        self.add_child(entity)

    self.groups[0].append(self.controlled_units[0])
    self.groups[1].append(self.controlled_units[1])


func _process(delta):
    if not terrain_ready:
        return

    for entity in self.controlled_units:
        if entity.grid_position == entity.current_move_target:
            if entity.queued_actions.size() > 0:
                var action = entity.queued_actions.pop_front()
                if action.type == Action.ActionType.Move:
                    entity.current_move_target = action.move_target

        entity.pathfind()
        entity.move(delta)


func add_controlled_unit(entity: ControllableEntity):
    self.controlled_units.append(entity)
    self.selected_units.append(entity)
    self.add_child(entity)
    entity.add_child(entity.sprite)


func _on_controls_selected_entities(entities: Array[Entities.Entity]):
    self.selected_units.clear()
    for entity in entities:
        if entity.has_tag("Controllable"):
            self.selected_units.append(entity)


func _on_controls_group_1(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[0]:
            self.selected_units.append(entity)


func _on_controls_group_2(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[1]:
            self.selected_units.append(entity)


func _on_controls_group_3(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[2]:
            self.selected_units.append(entity)


func _on_controls_group_4(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[3]:
            self.selected_units.append(entity)


func _on_controls_group_6(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[5]:
            self.selected_units.append(entity)


func _on_controls_group_5(button_down: bool):
    if button_down:
        self.selected_units.clear()
        for entity in self.groups[4]:
            self.selected_units.append(entity)


func _on_controls_mouse_point_index(i: int):
    self.pointed_cube = i


func _on_controls_move_attack(button_down: bool):
    if button_down and not self.is_queueing:
        for entity in self.selected_units:
            entity.queued_actions.clear()
            entity.current_move_target = Graphics.grid_items.positions[
                self.pointed_cube
            ]
    elif button_down and self.is_queueing:
        for entity in self.selected_units:
            var action = Action.new(
                Action.ActionType.Move,
                true,
                Graphics.grid_items.positions[self.pointed_cube]
            )
            entity.queued_actions.append(action)


func _on_controls_ability_1(button_down: bool):
    pass


func _on_controls_ability_2(button_down: bool):
    pass


func _on_controls_ability_3(button_down: bool):
    pass


func _on_controls_ability_4(button_down: bool):
    pass


func _on_controls_queue_mod(button_down: bool):
    self.is_queueing = button_down
