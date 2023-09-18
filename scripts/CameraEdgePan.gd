extends Camera2D

@export var camera_x_bound: int = 1000
@export var camera_y_bound: int = 1000

const EDGE_PAN_SENSITIVITY = 50 * 100

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

    if self.position.x > camera_x_bound:
        self.position.x = camera_x_bound
    elif self.position.x < -camera_x_bound:
        self.position.x = -camera_x_bound

    if self.position.y > camera_y_bound:
        self.position.y = camera_y_bound
    elif self.position.y < -camera_y_bound:
        self.position.y = -camera_y_bound


