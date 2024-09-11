class_name PathNode

var height: float
var grid_size: Vector2

var position: Vector2
var g_score: float
var h_score: float
var f_score: float

var came_from: PathNode

func _init(position: Vector2, grid_size: Vector2) -> void:
    self.position = position
    self.g_score = 1.79769e308
    self.f_score = 1.79769e308
    self.came_from = null
    self.grid_size = grid_size

func from_xy(x: float, y: float) -> PathNode:
    return PathNode.new(Vector2(x, y), grid_size)

func calculate_f_score() -> float:
    f_score = g_score + h_score
    return f_score

func get_neighbors() -> Array[PathNode]:
    var neighbor_list = Array()
    if position.x - 1 >= 0:
        neighbor_list.add(from_xy(position.x - 1, position.y))

        if position.y - 1 >= 0:
            neighbor_list.add(from_xy(position.x - 1, position.y - 1))
        if position.y + 1 < grid_size.y:
            neighbor_list.add(from_xy(position.x - 1, position.y + 1))

    if position.x + 1 < grid_size.x:
        neighbor_list.add(from_xy(position.x + 1, position.y))

        if position.y - 1 >= 0:
            neighbor_list.add(from_xy(position.x + 1, position.y - 1))
        if position.y + 1 < grid_size.y:
            neighbor_list.add(from_xy(position.x + 1, position.y + 1))

    if position.y - 1 >= 0:
        neighbor_list.add(from_xy(position.x, position.y - 1))
    if position.y + 1 < grid_size.y:
        neighbor_list.add(from_xy(position.x, position.y + 1))

    return neighbor_list

func _to_string() -> String:
    return str(position.x) + ", " + str(position.y)
