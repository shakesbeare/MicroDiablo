class_name Isometry
extends Node2D


var terrain_manager = TerrainManager.new()

# Grid Coordinate: Coordinate on the isometric gridspace
# World Coordinate: Coordinate for rendering objects in Godot space
# Screen Coordinate: Coordinate relative to the viewport itself

func _init():
    pass

func screen_to_world_point(camera: Camera2D):
    var viewport = camera.get_viewport_rect().size
    var mouse_pos = camera.get_viewport().get_mouse_position()
    mouse_pos.y += 15
    
    var x_offset = mouse_pos.x - viewport.x / 2
    var y_offset = mouse_pos.y - viewport.y / 2
    
    return Vector2(camera.position.x + x_offset, camera.position.y + y_offset)

func get_world_coord(grid_coord: Vector2):
    # https://www.youtube.com/watch?v=04oQ2jOUjkU

    var i_hat = Vector2(0.5 * terrain_manager.SPRITE_DIMENSIONS.x, 0.25 * terrain_manager.SPRITE_DIMENSIONS.y) * terrain_manager.SCALE
    var j_hat = Vector2(-0.5 * terrain_manager.SPRITE_DIMENSIONS.x, 0.25 * terrain_manager.SPRITE_DIMENSIONS.y) * terrain_manager.SCALE
    
    var new_x = grid_coord.x * i_hat.x + grid_coord.y * j_hat.x
    var new_y = grid_coord.x * i_hat.y + grid_coord.y * j_hat.y
    
    return Vector2(new_x, new_y)

func get_grid_coord(world_coord: Vector2):
    # https://www.youtube.com/watch?v=04oQ2jOUjkU

    var i_hat = Vector2(1, 0.5) * terrain_manager.SCALE
    var j_hat = Vector2(-1, 0.5) * terrain_manager.SCALE
    
    var a = i_hat.x * 0.5 * terrain_manager.SPRITE_DIMENSIONS.x
    var b = j_hat.x * 0.5 * terrain_manager.SPRITE_DIMENSIONS.x
    var c = i_hat.y * 0.5 * terrain_manager.SPRITE_DIMENSIONS.y
    var d = j_hat.y * 0.5 * terrain_manager.SPRITE_DIMENSIONS.y
    
    var determinant = 1 / (a * d - b * c)
    
    var new_a = d * determinant
    var new_b = -b * determinant
    var new_c = -c * determinant
    var new_d = a * determinant
    
    var inverse = Vector4(new_a, new_b, new_c, new_d)
    
    var res =  Vector2(
        world_coord.x * inverse.x + world_coord.y * inverse.y,
        world_coord.x * inverse.z + world_coord.y * inverse.w
    )

    var int_res = Vector2(snapped(res.x, 1), snapped(res.y, 1))

    return int_res
