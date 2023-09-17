class_name GridItem

var isometry = Isometry.new()

var position : Vector2
var height : float
var sprite : Sprite2D

func _init(sprite: Sprite2D, grid_coord: Vector2, grid_height: float):
    self.position = grid_coord
    self.height = grid_height
    self.sprite = sprite

func world_coordinate():
    return isometry.get_world_coord(self.position)
