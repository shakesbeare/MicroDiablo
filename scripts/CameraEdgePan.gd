extends Camera2D

const EDGE_PAN_SENSITIVITY = 30 * 100

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var viewport_rect_size = get_viewport_rect().size
    var mouse_pos = get_viewport().get_mouse_position()
    
    if mouse_pos.x >= viewport_rect_size.x - 1:
        self.position.x += EDGE_PAN_SENSITIVITY * delta
    elif mouse_pos.x <= 0:
        self.position.x -= EDGE_PAN_SENSITIVITY * delta
    
    if mouse_pos.y >= viewport_rect_size.y - 1:
        self.position.y += EDGE_PAN_SENSITIVITY * delta
    elif mouse_pos.y <= 0:
        self.position.y -= EDGE_PAN_SENSITIVITY * delta
