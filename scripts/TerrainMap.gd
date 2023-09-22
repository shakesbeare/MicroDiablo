class_name TerrainMap

var noise: FastNoiseLite
var image: Image

func _init():
    self.noise = FastNoiseLite.new()
    self.noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)

func generate() -> GridItems:
    self.image = self.noise.get_image(GraphicsManager.GROUND_SIZE.x, GraphicsManager.GROUND_SIZE.y)
    var grid_items = GridItems.new([], [], [], [])

    for i in self.image.get_width():
        for j in self.image.get_height():
            var color = self.image.get_pixel(i, j)
            var sprite = self.get_sprite_from_color(color)
            var height = int(color.r * 2)
            grid_items.add(sprite, Vector2(i, j), height, "")

    return grid_items

func get_sprite_from_color(color: Color):
    # treat the color as a percent of total sprites available
    
    var num_sprites = GraphicsManager.textures.size()
    var sprite_index = int(num_sprites * color.r) - 1
    var sprite_array = GraphicsManager.textures.values()
    var texture = sprite_array[sprite_index]

    var sprite = Sprite2D.new()
    sprite.texture = texture
    sprite.name = "GroundCube"
    sprite.scale = Vector2(GraphicsManager.SCALE, GraphicsManager.SCALE)

    return sprite

