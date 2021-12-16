extends Spatial

onready var floor_shape = $Floor/CollisionShape

var starting_positions = []
const START_POS_OFFSET : Vector3 = Vector3.UP*2

func activate():
	for child in $StartingPositions.get_children():
		starting_positions.append(child.transform.origin + START_POS_OFFSET)

func get_start_pos(num : int):
	return starting_positions[num]

func get_dimensions():
	return Vector3(floor_shape.shape.extents.x, 0, floor_shape.shape.extents.z)

func get_floor_pos():
	return floor_shape.transform.origin
