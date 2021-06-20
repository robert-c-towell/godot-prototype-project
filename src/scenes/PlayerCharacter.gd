extends KinematicBody

const TILESIZE = 2.1

var moveSpeed = 6
var rotateSpeed = 1
var targetPosition = Vector3()
var targetRotation = Vector3()
var isMoving = false
var isRotating = false

func _process(delta):
	if isMoving:
		moveR()
	if isRotating:
		rotateR()

func moveR():
	var velocity
	var distance = targetPosition.distance_to(transform.origin)
	if distance > 0.05:
		velocity = targetPosition - transform.origin
		velocity = velocity.normalized() * distance * moveSpeed
		move_and_slide(velocity)
		rotation_degrees.y = normalizeRotation(rotation_degrees.y)
	else:
		transform.origin = targetPosition
		rotation_degrees.y = normalizeRotation(rotation_degrees.y)
		isMoving = false

func rotateR():
#	var velocity = Vector3.FORWARD
#	velocity.x = abs(rotation_degrees.y - targetPosition.y)
#	if velocity.x > 0.1:
#		var newRotation = rotation_degrees.y + lerp_angle(rotation_degrees.y, atan2(-velocity.x, -velocity.z), rotateSpeed)
#		rotation_degrees.y = normalizeRotation(newRotation)
#	else:
	rotation_degrees.y = normalizeRotation(targetRotation.y)
	isRotating = false

func moveRobot(direction, distance):
	if !isMoving:
		targetPosition = transform.origin
		
	var realDistance = distance * TILESIZE
	match int(rotation_degrees.y):
		0:
			match direction:
				"forward":
					targetPosition.z -= realDistance
				"backward":
					targetPosition.z += realDistance
		90:
			match direction:
				"forward":
					targetPosition.x -= realDistance
				"backward":
					targetPosition.x += realDistance
		180, -180:
			match direction:
				"forward":
					targetPosition.z += realDistance
				"backward":
					targetPosition.z -= realDistance
		270, -270:
			match direction:
				"forward":
					targetPosition.x += realDistance
				"backward":
					targetPosition.x -= realDistance
	isMoving = true

func normalizeRotation(r):
	if r < 0:
		r += 360
	r = fmod(r, 360.0)
	return r

func rotateRobot(direction):
	if !isRotating:
		targetRotation = rotation_degrees
	match direction:
		"left":
			targetRotation.y += 90
#			rotation_degrees.y += 90
		"right":
			targetRotation.y -= 90
			rotation_degrees.y -= 90
		"u-turn":
			targetRotation.y += 180
#			rotation_degrees.y += 180
#	rotation_degrees.y = normalizeRotation(rotation_degrees.y)
	isRotating = true
