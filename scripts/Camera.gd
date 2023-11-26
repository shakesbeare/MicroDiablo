extends Camera2D

@export var camera_x_bound: int = 1000
@export var camera_y_bound: int = 1000


func _process(delta):
	edge_pan(delta)
	key_pan(delta)


func edge_pan(delta):
	var viewport_rect_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()

	if mouse_pos.x >= viewport_rect_size.x - 1:
		self.position.x += Settings.get_edge_pan_speed() * delta
	elif mouse_pos.x <= 0:
		self.position.x -= Settings.get_edge_pan_speed() * delta

	if mouse_pos.y >= viewport_rect_size.y - 1:
		self.position.y += Settings.get_edge_pan_speed() * delta
	elif mouse_pos.y <= 0:
		self.position.y -= Settings.get_edge_pan_speed() * delta

	if self.position.x > camera_x_bound:
		self.position.x = camera_x_bound
	elif self.position.x < -camera_x_bound:
		self.position.x = -camera_x_bound

	if self.position.y > camera_y_bound:
		self.position.y = camera_y_bound
	elif self.position.y < -camera_y_bound:
		self.position.y = -camera_y_bound


func key_pan(delta):
	self.position.x += (
		Controls.get_key_pan_normalized().x
		* Settings.get_key_pan_speed()
		* delta
	)
	self.position.y += (
		Controls.get_key_pan_normalized().y
		* Settings.get_key_pan_speed()
		* delta
	)
