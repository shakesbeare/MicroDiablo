const Floor = preload("res://Floor.gd")


# Grid Coordinate: Coordinate on the isometric gridspace
# World Coordinate: Coordinate for rendering objects in Godot space
# Screen Coordinate: Coordinate relative to the viewport itself

func get_world_coord(grid_coord: Vector2):
	var floor = Floor.new()
	var i_hat = Vector2(0.5 * floor.SPRITE_DIMENSIONS.x, 0.25 * floor.SPRITE_DIMENSIONS.y) * floor.SCALE
	var j_hat = Vector2(-0.5 * floor.SPRITE_DIMENSIONS.x, 0.25 * floor.SPRITE_DIMENSIONS.y) * floor.SCALE
	
	var new_x = grid_coord.x * i_hat.x + grid_coord.y * j_hat.x
	var new_y = grid_coord.x * i_hat.y + grid_coord.y * j_hat.y
	
	return Vector2(new_x, new_y)

func get_grid_coord(world_coord: Vector2):
	var floor = Floor.new()
	var i_hat = Vector2(1, 0.5) * floor.SCALE
	var j_hat = Vector2(-1, 0.5) * floor.SCALE
	
	var a = i_hat.x * 0.5 * floor.SPRITE_DIMENSIONS.x
	var b = j_hat.x * 0.5 * floor.SPRITE_DIMENSIONS.x
	var c = i_hat.y * 0.5 * floor.SPRITE_DIMENSIONS.y
	var d = j_hat.y * 0.5 * floor.SPRITE_DIMENSIONS.y
	
	var determinant = 1 / (a * d - b * c)
	
	var new_a = d * determinant
	var new_b = -b * determinant
	var new_c = -c * determinant
	var new_d = a * determinant
	
	var inverse = Vector4(new_a, new_b, new_c, new_d)
	
	return Vector2(
		int(world_coord.x * inverse.x + world_coord.y * inverse.y),
		int(world_coord.x * inverse.z + world_coord.y * inverse.w)
	)
