class_name TerrainMap

var noise: FastNoiseLite
var texture_image: Image
var height_image: Image
var max_height: int = 5
var water_level: int = 1
var num_scatter_tries: int = 200

var shadow_ratio: float = 0.75

func _init(seed: int = -1):
    self.noise = FastNoiseLite.new()
    self.noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
    
    if seed == -1:
        self.noise.set_seed(Time.get_unix_time_from_system())
    else:
        self.noise.set_seed(seed)

func generate() -> GridItems:
    self.texture_image = self.noise.get_image(GraphicsManager.GROUND_SIZE.x, GraphicsManager.GROUND_SIZE.y)
    self.height_image = self.noise.get_image(GraphicsManager.GROUND_SIZE.x, GraphicsManager.GROUND_SIZE.y)
    var grid_items = GridItems.new([], [], [], [])

    for i in self.texture_image.get_width():
        for j in self.texture_image.get_height():
            var color = self.texture_image.get_pixel(i, j)
            var sprite = self.get_sprite_from_color(color)
            var height = self.get_height_from_color(color)
            grid_items.add(sprite, Vector2(i, j), height, "")

    var rng = RandomNumberGenerator.new()

    # find stair up position
    var stair_index = find_index_for_stair(grid_items)
    grid_items.sprites[stair_index].texture = GraphicsManager.stair_textures["up"]
    grid_items.heights[stair_index] += 1

    # find stair down position
    stair_index = find_index_for_stair(grid_items)
    grid_items.sprites[stair_index].texture = GraphicsManager.stair_textures["down"]

    # place water
    for i in grid_items.size():
        if grid_items.heights[i] <= self.water_level:
            grid_items.heights[i] = self.water_level
            grid_items.sprites[i].texture = GraphicsManager.scatter_textures["water_cube_m"]

    for i in range(self.num_scatter_tries):
        var scatter_index = rng.randi_range(0, grid_items.size() - 1)
        var type = grid_items.get_cube_type(scatter_index)
        # do not override stairs
        if type == GridItems.CubeType.StairsUp or type == GridItems.CubeType.StairsDown:
            continue
        elif type == GridItems.CubeType.Grass:
            grid_items.sprites[scatter_index].texture = GraphicsManager.scatter_textures["grass_cube_flower_m"]
        elif type == GridItems.CubeType.Dirt:
            grid_items.sprites[scatter_index].texture = GraphicsManager.scatter_textures["dirt_cube_corner_boulder"]

    # add shadows
    for i in grid_items.size():
        if grid_items.get_cube_type(i) in [GridItems.CubeType.Water, GridItems.CubeType.StairsUp, GridItems.CubeType.StairsDown]:
            continue
        var upper_neighbors = grid_items.get_upper_neighbors(i)
        if grid_items.heights[upper_neighbors[0]] < grid_items.heights[i]:
            # left upper neighbor is lower, draw left border

            var sprite = Sprite2D.new()
            sprite.texture = GraphicsManager.scatter_textures["cliff_border_r"]
            sprite.name = "Border"
            sprite.scale = Vector2(GraphicsManager.SCALE, GraphicsManager.SCALE)

            grid_items.add(sprite, grid_items.positions[i], grid_items.heights[i], "Border")
        if grid_items.heights[upper_neighbors[1]] < grid_items.heights[i]:
            # right upper neighbor is lower, draw right border

            var sprite = Sprite2D.new()
            sprite.texture = GraphicsManager.scatter_textures["cliff_border_l"]
            sprite.name = "Border"
            sprite.scale = Vector2(GraphicsManager.SCALE, GraphicsManager.SCALE)

            grid_items.add(sprite, grid_items.positions[i], grid_items.heights[i], "Border")

    return grid_items

func get_sprite_from_color(color: Color):
    # treat the color as a percent of total sprites available
    
    var num_sprites = GraphicsManager.cube_textures.size() - 1
    var sprite_index = int(num_sprites * color.r)
    var sprite_array = GraphicsManager.cube_textures.values()
    var texture = sprite_array[sprite_index]

    var sprite = Sprite2D.new()
    sprite.texture = texture
    sprite.name = "GroundCube"
    sprite.scale = Vector2(GraphicsManager.SCALE, GraphicsManager.SCALE)

    return sprite

func get_height_from_color(color: Color):
    return int(self.max_height * color.r)

func find_index_for_stair(grid_items: GridItems) -> int:
    """Returns the index of a random cube at or above the given height. Will never return the index of a stair cube."""
    var rng = RandomNumberGenerator.new()
    var index = rng.randi_range(0, grid_items.size() - 1)
    var height = self.max_height / 2
    while true:
        if grid_items.heights[index] >= height and grid_items.get_cube_type(index) != GridItems.CubeType.StairsUp and grid_items.get_cube_type(index) != GridItems.CubeType.StairsDown:
            break
        index = rng.randi_range(0, grid_items.size() - 1)
    return index

