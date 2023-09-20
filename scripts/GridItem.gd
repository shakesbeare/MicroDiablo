class_name GridItems

var isometry = Isometry.new()

var positions : Array[Vector2]
var heights : Array[float]
var sprites : Array[Sprite2D]
var groups : Array[String]
var update_queue : Array[int] # indices for cubes needing updates
var _size : int


func world_coordinate():
    return isometry.get_world_coord(self.position)

func _init(sprites: Array[Sprite2D], grid_coords: Array[Vector2], grid_heights: Array[float], groups: Array[String]):
    self.positions = grid_coords
    self.heights = heights
    self.sprites = sprites
    self.groups = groups
    self._size = 0

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

func size():
    return self._size

func queue_size():
    return self.update_queue.size()


