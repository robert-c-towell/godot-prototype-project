extends KinematicBody

const TILESIZE = 2.1

var t = 0
var moveDirection
var moveDistance = 0
var isMoving = false
var rotateDirection
var isRotating = false

var velocity = Vector3()
var targetPosition = Vector3()
var speed = 15

func moveRobot(direction, distance):
	targetPosition = transform.origin
	targetPosition.z -= distance * TILESIZE
	velocity = targetPosition - transform.origin
	isMoving = true
	moveDirection = direction
	moveDistance = distance
#	match moveDirection:
#		"forward":
#			velocity.z -= 1
#		"backward":
#			velocity += 1

func rotateRobot(direction):
	match direction:
		"left":
			rotation_degrees.y += 90
		"right":
			rotation_degrees.y -= 90
		"u-turn":
			rotation_degrees.y += 180

func _physics_process(delta):
	if isMoving:
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
