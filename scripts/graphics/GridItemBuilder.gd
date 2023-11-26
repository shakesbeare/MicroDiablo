class_name GridItemBuilder

# var water_level: int = 1
# var num_scatter_tries: int = 200

var grid_items: GridItems
var rng: RandomNumberGenerator
var has_placed_water: bool = false
var noise: FastNoiseLite
var noise_image: Image

enum NeedsBorder {
	Left,
	Right,
}


func _init(map_seed: int = -1):
	self.noise = FastNoiseLite.new()
	self.noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)

	if map_seed == -1:
		self.noise.set_seed(int(Time.get_unix_time_from_system()))
	else:
		self.noise.set_seed(map_seed)

	grid_items = GridItems.new()
	rng = RandomNumberGenerator.new()


func build() -> GridItems:
	return grid_items


func default() -> GridItemBuilder:
	var max_height = 5
	(
		self
		. generate_noise_texture()
		. create_cubes(max_height)
		. place_scatter(
			1, 1, int(max_height / 2.0), Graphics.stair_textures["up"]
		)
		. place_scatter(
			1, 0, int(max_height / 2.0), Graphics.stair_textures["down"]
		)
		. place_scatter(200)
		. place_water(1)
		. add_cliffs()
	)

	return self


func generate_noise_texture() -> GridItemBuilder:
	self.noise_image = self.noise.get_image(
		Graphics.GROUND_SIZE.x, Graphics.GROUND_SIZE.y
	)
	return self


func create_cubes(max_height: int) -> GridItemBuilder:
	for i in self.noise_image.get_width():
		for j in self.noise_image.get_height():
			var color = self.noise_image.get_pixel(i, j)
			var sprite = self._get_sprite_from_color(color)
			var height_offset = self._get_height_from_color(max_height, color)
			sprite.name = "GroundCube" + " " + str(i) + " " + str(j)
			grid_items.add(sprite, Vector2(i, j), height_offset, "")

	return self


func place_water(water_level: int) -> GridItemBuilder:
	has_placed_water = true
	for i in grid_items.size():
		if grid_items.heights[i] <= water_level:
			grid_items.update_cube(
				i,
				grid_items.positions[i],
				water_level,
				Graphics.scatter_textures["water_cube_m"]
			)

	return self


## Throws AssertionError if water has already been placed [br]
## [param num_scatters]: the number of scatters to place [br]
## [param height_offset]: how much higher than the ground the scatter should be placed [br]
## [param min_height]: the minimum height of the cube to place the scatter on [br]
## [param texture]: the texture to use for the scatter, if null, texture is chosen based on the selected cube [br]
func place_scatter(
	num_scatters: int,
	height_offset: int = 0,
	min_height: int = 0,
	texture: Texture2D = null
) -> GridItemBuilder:
	assert(not has_placed_water, "Scatter should be placed before water")

	var protected_cube_types = [
		GridItems.CubeType.StairsUp,
		GridItems.CubeType.StairsDown,
		GridItems.CubeType.Water
	]
	var index = rng.randi_range(0, grid_items.size() - 1)
	var type = grid_items.get_cube_type(index)
	var scattered_indices: Array[int] = []

	for _i in range(num_scatters):
		# (1) find an appropiate cube to place the scatter on
		var visited_indices: Array[int] = []
		while true:
			if index in visited_indices or index in scattered_indices:
				index = rng.randi_range(0, grid_items.size() - 1)
				type = grid_items.get_cube_type(index)
				continue
			else:
				visited_indices.append(index)

			if type in protected_cube_types:
				index = rng.randi_range(0, grid_items.size() - 1)
				type = grid_items.get_cube_type(index)
				continue

			if grid_items.heights[index] >= min_height:
				break

			index = rng.randi_range(0, grid_items.size() - 1)
			type = grid_items.get_cube_type(index)

		# (2) choose texture or use texture param
		if texture == null:
			if type == GridItems.CubeType.Grass:
				texture = Graphics.scatter_textures["grass_cube_flower_m"]
			elif type == GridItems.CubeType.Dirt:
				texture = Graphics.scatter_textures["dirt_cube_corner_boulder"]

		# (3) place scatter
		grid_items.update_cube(
			index,
			grid_items.positions[index],
			grid_items.heights[index] + height_offset,
			texture
		)
		scattered_indices.append(index)

	return self


func add_cliffs() -> GridItemBuilder:
	# cliffs occur when the height goes down as the cube gets farther away from the camera
	for i in grid_items.size():
		# these cubes should not get borders
		if (
			grid_items.get_cube_type(i)
			in [
				GridItems.CubeType.Water,
				GridItems.CubeType.StairsUp,
				GridItems.CubeType.StairsDown
			]
		):
			continue

		var upper_neighbors = grid_items.get_upper_neighbors(i)
		var needs_border = []

		if grid_items.heights[upper_neighbors[0]] < grid_items.heights[i]:
			needs_border.append(NeedsBorder.Right)

		if grid_items.heights[upper_neighbors[1]] < grid_items.heights[i]:
			needs_border.append(NeedsBorder.Left)

		if needs_border == []:
			continue

		# create border sprites
		for nb in needs_border:
			var sprite = self._create_border_sprite(i, nb)
			grid_items.add(
				sprite, grid_items.positions[i], grid_items.heights[i], "Border"
			)

	return self


func _create_border_sprite(i: int, needs_border: NeedsBorder):
	var sprite = Sprite2D.new()
	match needs_border:
		NeedsBorder.Right:
			sprite.texture = Graphics.scatter_textures["cliff_border_r"]
		NeedsBorder.Left:
			sprite.texture = Graphics.scatter_textures["cliff_border_l"]

	sprite.name = "Border" + " " + str(needs_border) + " " + str(i)
	sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE)

	return sprite


func _get_sprite_from_color(color: Color):
	# treat the color as a percent of total sprites available

	var num_sprites = Graphics.cube_textures.size() - 1
	var sprite_index = int(num_sprites * color.r)
	var sprite_array = Graphics.cube_textures.values()
	var texture = sprite_array[sprite_index]

	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.name = "GroundCube"
	sprite.scale = Vector2(Graphics.SCALE, Graphics.SCALE)

	return sprite


func _get_height_from_color(max_height: int, color: Color):
	return int(max_height * color.r)
