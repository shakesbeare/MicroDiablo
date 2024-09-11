class_name Paths
extends Node

static var a_star
static var seen = []
static var grid_items;

func add_all_cubes():
	for i in range(grid_items.size()):
		if grid_items.decorative[i]:
			continue

		a_star.add_point(i, grid_items.positions[i])

		for j in grid_items.get_cube_neighbors(i):
			if j not in seen or grid_items.decorative[j]:
				continue

			if grid_items.is_cube_at_grid_pos_passable(grid_items.positions[i]) and grid_items.is_cube_at_grid_pos_passable(grid_items.positions[j]):
				a_star.connect_points(j, i)
		
		seen.append(i)


func _on_graphics_terrain_ready(callback: Callable) -> void:
	a_star = AStar2D.new()
	grid_items = GridItems.init()
	add_all_cubes()
	callback.call()
