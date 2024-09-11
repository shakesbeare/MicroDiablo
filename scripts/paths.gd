class_name Paths
extends Node

var Pathfinding = preload("res://scripts/cs/Pathfinding.cs")
static var pathfinding
static var a_star
static var seen = []
static var grid_items = GridItems.init()

func _init():
	pathfinding = Pathfinding.new()
	pathfinding.Setup(Graphics.GROUND_SIZE)

	a_star = AStar2D.new()
	add_grid_item(-1, 0)

func add_grid_item(parent: int, i: int):
	if i in seen:
		return

	seen.append(i)
	a_star.add_point(i, grid_items.positions[i])

	if parent == -1:
		return

	if grid_items.is_cube_at_grid_pos_passable(grid_items.positions[i]) and grid_items.is_cube_at_grid_pos_passable(grid_items.positions[parent]):
		a_star.connect_points(parent, i)
	
	for cube in grid_items.get_cube_neighbors(i):
		add_grid_item(i, cube)

	print(len(seen))
