# Represents an entity that is controllable by either the player or an AI force
class_name ControllableEntity
extends Entities.Entity

static var grid_items;

var player_scene = preload("res://scenes/player.tscn")  # scenes are equivalent to prefabs in unity

var move_targets: Array[Vector2]
var target_heights: Array[float]
var current_move_target: Vector2
var time_since_last_move: float = 0
var movement_speed: int = 5
var queued_actions: Array[Action]


func _init():
	grid_items = GridItems.init()
	self.tags.append_array(["Controllable"])

	self.grid_position = Vector2.ZERO
	self.grid_height = Graphics.grid_items.heights[0] + 1

	var expected_position = Isometry.get_world_coord(self.grid_position)
	var y_offset = self.grid_height * Graphics.SPRITE_DIMENSIONS.y
	self.position = expected_position - Vector2(0, y_offset)

	self.id = Entities.get_next_id()

	self.sprite = player_scene.instantiate()
	self.sprite.name = "ControllableEntity" + str(self.id)
	self.sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE)

	Entities.add(self)
	self.update_position()


func move(delta):
	if self.time_since_last_move >= 1.0 / self.movement_speed:
		if self.move_targets.size() > 0:
			var old_position = self.grid_position
			self.grid_position = self.move_targets.pop_back()

			# This checks for collision with other entities
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
	self.sprite.z_index = int(self.grid_height)


func pathfind():
	var start_id = grid_items.grid_position_map[self.grid_position]
	var target_id = grid_items.grid_position_map[self.current_move_target]
	var path = Paths.a_star.get_point_path(start_id, target_id)
	var points = path.slice(1) # a_star includes the starting position as the initial point

	self.move_targets.clear()
	self.target_heights.clear()
	for item in points:
		var cube_index = Graphics.grid_items.grid_position_map[item]
		self.move_targets.push_front(item)
		self.target_heights.push_front(
			Graphics.grid_items.heights[cube_index] + 1
		)
