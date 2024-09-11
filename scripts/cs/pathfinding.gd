class_name Pathfinding
extends Node

var grid_size: Vector2;
var grid_items: GridItems;

func _init() -> void:
    grid_items = GridItems.init()

func setup(grid_size: Vector2) -> void:
    self.grid_size = grid_size

func find_path(start: Vector2, end: Vector2):
    var target_passable: bool = grid_items.is_cube_at_grid_pos_passable(end)
    if not target_passable:
        return null
    
    var start_node: PathNode = PathNode.new(start, grid_size)
    start_node.h_score = h(start, end)
    start_node.g_score = 0
    start_node.calculate_f_score()
    start_node.came_from = null

    var open_set: PriorityQueue = PriorityQueue()
    var closed_set: HashS

