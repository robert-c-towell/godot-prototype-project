extends Spatial

const TILESIZE = 2.1

func moveRobot(direction, distance):
	var velocity = Vector3()
	if direction == "forward":
		velocity -= transform.basis.z
	if direction == "backward":
		velocity += transform.basis.z
	translation += velocity * TILESIZE * distance

func rotateRobot(direction):
	if direction == "left":
		rotation_degrees.y += 90
	if direction == "right":
		rotation_degrees.y -= 90
