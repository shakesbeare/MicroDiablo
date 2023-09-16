const Floor = preload("res://Floor.gd")


# Grid Coordinate: Coordinate on the isometric gridspace
# World Coordinate: Coordinate for rendering objects in Godot space
# Screen Coordinate: Coordinate relative to the viewport itself

func get_screen_coord(grid_coord: Vector2):
	var floor = Floor.new()
	var i_hat = Vector2(0.5 * floor.SPRITE_DIMENSIONS.x, 0.25 * floor.SPRITE_DIMENSIONS.y) * floor.SCALE
	var j_hat = Vector2(-0.5 * floor.SPRITE_DIMENSIONS.x, 0.25 * floor.SPRITE_DIMENSIONS.y) * floor.SCALE
	
	var new_x = grid_coord.x * i_hat.x + grid_coord.y * j_hat.x
	var new_y = grid_coord.x * i_hat.y + grid_coord.y * j_hat.y
	
	return Vector2(new_x, new_y)

func get_grid_coord(world_coord: Vector2):
	pass
	
func get_world_coord(screen_coord: Vector2):
	pass
