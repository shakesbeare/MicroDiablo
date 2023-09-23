class_name GridItems

var isometry = Isometry.new()

var positions : Array[Vector2]
var heights : Array[float]
var sprites : Array[Sprite2D]
var groups : Array[String]
var update_queue : Array[int] # indices for cubes needing updates
var _size : int

enum CubeType {
    Grass,
    Dirt,
    Water,
    StairsUp,
    StairsDown,
    NaC,
}

enum CubePassability {
    Passable,
    Impassable,
}

func world_coordinate():
    return isometry.get_world_coord(self.position)

func _init(sprites: Array[Sprite2D], grid_coords: Array[Vector2], grid_heights: Array[float], groups: Array[String]):
    self.positions = grid_coords
    self.heights = heights
    self.sprites = sprites
    self.groups = groups
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

func update_cube(i: int, position: Vector2, height: float, texture: CompressedTexture2D = null):
    if texture != null:
        self.sprites[i].texture = texture
    self.positions[i] = position
    self.heights[i] = height
    self.update_queue.append(i)

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
    else:
        return CubeType.NaC

func get_cube_passability(i: int) -> CubePassability:
    if self.get_cube_type(i) == CubeType.Water or CubeType.NaC:
        return CubePassability.Impassable
    else:
        return CubePassability.Passable

func get_cube_neighbors(i: int) -> Array[int]:
    """Returns the 4 directly adjacent neighbors of the cube at index i"""
    return [
        i - 1,
        i + 1,
        i - GraphicsManager.GROUND_SIZE.x,
        i + GraphicsManager.GROUND_SIZE.x
    ]

func get_upper_neighbors(i: int) -> Array[int]:
    """Returns the 3 neighbors of the cube at index i that are above it"""
    return [
        i - 1,
        i - GraphicsManager.GROUND_SIZE.x ,
    ]
