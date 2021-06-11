extends Spatial

export (float, 0, 1000) var movement_speed = 10
export (float, 0, 1000, 0.1) var rotation_speed = 20
export (int, 0, 90) var min_elevation_angle = 10
export (int, 0, 90) var max_elevation_angle = 75
export var min_elevation = 0
export var max_elevation = 100

export (int, 0, 1000) var min_zoom = 4
export (int, 0, 1000) var max_zoom = 45
export (float, 0, 1000, 0.1) var zoom_speed = 100
export (float, 0, 1, 0.1) var zoom_speed_damp = 0.5

export (bool) var allow_rotation = true
export (bool) var inverted_y = false

var original_mouse_position = Vector2()
var _last_mouse_position = Vector2()
var _is_rotating = false
onready var elevation = $Elevation
var _zoom_direction = 0
onready var camera = $Elevation/Camera

var isLocked = false

func _process(delta: float) -> void:
	if !isLocked:
		moveHorizontal(delta)
		moveVertical()
		rotateCamera(delta)
		zoom(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if !isLocked:
		if event.is_action_pressed("camera_rotate_lock"):
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			_last_mouse_position = get_viewport().get_mouse_position()
			original_mouse_position = get_viewport().get_mouse_position()
			_is_rotating = true
		if event.is_action_released("camera_rotate_lock"):
			_is_rotating = false
			get_viewport().warp_mouse(original_mouse_position)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.is_action_pressed("camera_zoom_in"):
			_zoom_direction = -1
		if event.is_action_pressed("camera_zoom_out"):
			_zoom_direction = 1
		
func _lockMovement():
	isLocked = true
	
func _unlockMovement():
	isLocked = false

func moveHorizontal(delta: float) -> void:
	var velocity = Vector3()
	if Input.is_action_pressed("camera_forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		velocity += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		velocity += transform.basis.x

	velocity = velocity.normalized()
	translation += velocity * delta * movement_speed * (camera.translation.z / 10)

func moveVertical():
	var velocity = Vector3()
	if Input.is_action_pressed("camera_down"):
		velocity += transform.basis.y
	if Input.is_action_pressed("camera_up"):
		velocity -= transform.basis.y

	velocity = velocity.normalized()
	translation += velocity * 2.1

func rotateCamera(delta: float) -> void:
	if not _is_rotating or not allow_rotation:
		return

	var displacement = getMouseDisplacement()
	rotateHorizontal(delta, displacement.x)
	rotateVertical(delta, displacement.y)
	
func getMouseDisplacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - _last_mouse_position
	_last_mouse_position = current_mouse_position
	return displacement

func rotateHorizontal(delta: float, val: float) -> void:
	rotation_degrees.y -= val * delta * rotation_speed

func rotateVertical(delta: float, val: float) -> void:
	var verticalRotation = elevation.rotation_degrees.x
	if inverted_y:
		verticalRotation += val * delta * rotation_speed
	else:
		verticalRotation -= val * delta * rotation_speed

	verticalRotation = clamp(verticalRotation, -max_elevation_angle, -min_elevation_angle)
	elevation.rotation_degrees.x = verticalRotation

func zoom(delta: float) -> void:
	var new_zoom = clamp(camera.translation.z + zoom_speed * delta * _zoom_direction, min_zoom, max_zoom)
	camera.translation.z = new_zoom
	_zoom_direction *= zoom_speed_damp
	if abs(_zoom_direction) <= 0.0001:
		_zoom_direction = 0
