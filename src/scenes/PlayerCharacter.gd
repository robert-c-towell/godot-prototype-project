extends KinematicBody

const TILESIZE = 2.1

var moveSpeed = 6
var rotateSpeed = 100
var targetPosition = Vector3()
var targetRotation = Vector3()
var isMoving = false
var isRotating = false

var rotateT = 0

func _process(delta):
	if isMoving:
		moveR()
	if isRotating:
		rotateR(delta)

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

func rotateR(delta):
	var currentRotation = Vector3.ZERO
	currentRotation.x = rotation_degrees.y
	var diff = currentRotation.direction_to(targetRotation)
	if rad2deg(diff.x) > 5:
		var newRotation = lerp_angle(deg2rad(rotation_degrees.y), deg2rad(targetRotation.x), rotateT * rotateSpeed)
		rotation_degrees.y = normalizeRotation(newRotation)
		rotateT += delta
	else:
		rotation_degrees.y = normalizeRotation(targetRotation.x)
		isRotating = false
		rotateT = 0

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
		targetRotation = Vector3.ZERO
		targetRotation.x = rotation_degrees.y
	match direction:
		"left":
			targetRotation.x += 90
#			rotation_degrees.y += 90
		"right":
			targetRotation.x -= 90
#			rotation_degrees.x -= 90
		"u-turn":
			targetRotation.x += 180
#			rotation_degrees.x += 180
#	rotation_degrees.y = normalizeRotation(rotation_degrees.y)
	targetRotation.x = normalizeRotation(targetRotation.x)
	isRotating = true
