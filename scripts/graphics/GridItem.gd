class_name GridItems

static var instance: GridItems

var positions : Array[Vector2]
var heights : Array[float]
var sprites : Array[Sprite2D]
var groups : Array[String]
var update_queue : Array[int] # indices for cubes needing updates
var _size : int

var world_position_map = {}
var grid_position_map = {}

enum CubeType {
    Grass,
    Dirt,
    Water,
    StairsUp,
    StairsDown,
    Border,
    NaC,
}

enum CubePassability {
    Passable,
    Impassable,
}

func world_coordinate():
    return Isometry.get_world_coord(self.position)

static func init() -> GridItems:
    if instance:
        return instance
    else:
        instance = GridItems.new()
        return instance

func _init():
    self.positions = []
    self.heights = []
    self.sprites = []
    self.groups = []
    self._size = 0

func size():
    return self._size

func queue_size():
    return self.update_queue.size()

func add(sprite: Sprite2D, grid_coord: Vector2, grid_height: float, group: String):
    self._size += 1

    self.sprites.append(sprite)
    self.positions.append(grid_coord)
    self.heights.append(grid_height)
    self.groups.append(group)

    self.update_queue.append(self._size - 1)

    var drawn_position = Isometry.get_world_coord(grid_coord)
    drawn_position.y -= grid_height * Graphics.SPRITE_DIMENSIONS.y

    self.world_position_map[drawn_position] = self._size - 1
    self.grid_position_map[grid_coord] = self._size - 1

func update_cube(i: int, position: Vector2, height: float, texture: CompressedTexture2D = null):
    # clean up old map entry
    var drawn_position_old = Isometry.get_world_coord(self.positions[i])
    drawn_position_old.y -= self.heights[i] * Graphics.SPRITE_DIMENSIONS.y
    self.world_position_map.erase(drawn_position_old)
    self.grid_position_map.erase(self.positions[i])

    if texture != null:
        self.sprites[i].texture = texture
    self.positions[i] = position
    self.heights[i] = height
    self.update_queue.append(i)

    # create new map entry
    var drawn_position = Isometry.get_world_coord(self.positions[i])
    drawn_position.y -= self.heights[i] * Graphics.SPRITE_DIMENSIONS.y
    self.world_position_map[drawn_position] = i
    self.grid_position_map[self.positions[i]] = i


func get_cube_type(i: int) -> CubeType:
    if self.sprites[i].texture.load_path.contains("grass"):
        return CubeType.Grass
    elif self.sprites[i].texture.load_path.contains("dirt"):
        return CubeType.Dirt
    elif self.sprites[i].texture.load_path.contains("water"):
        return CubeType.Water
    elif self.sprites[i].texture.load_path.contains("stairs_up"):
        return CubeType.StairsUp
    elif self.sprites[i].texture.load_path.contains("stairs_down"):
        return CubeType.StairsDown
    elif self.sprites[i].texture.load_path.contains("border"):
        return CubeType.Border
    else:
        return CubeType.NaC

func get_cube_passability(i: int) -> CubePassability:
    if self.get_cube_type(i) == CubeType.Water or self.get_cube_type(i) == CubeType.NaC:
        return CubePassability.Impassable
    else:
        return CubePassability.Passable

func get_cube_position_from_world_position(world_coord: Vector2) -> Vector2:
    return self.positions[self.world_position_map[world_coord]]

func is_cube_at_grid_pos_passable(grid_coord: Vector2) -> bool:
    var i = self.grid_position_map[grid_coord]
    return self.get_cube_passability(i) == CubePassability.Passable

func get_cube_neighbors(i: int) -> Array[int]:
    """Returns the 4 directly adjacent neighbors of the cube at index i"""
    return [
        i - 1,
        i + 1,
        i - Graphics.GROUND_SIZE.x,
        i + Graphics.GROUND_SIZE.x
    ]

func get_upper_neighbors(i: int) -> Array[int]:
    """Returns the 3 neighbors of the cube at index i that are above it"""
    return [
        i - 1,
        i - Graphics.GROUND_SIZE.x ,
    ]
