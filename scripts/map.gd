extends Spatial

onready var floor_shape = $Floor/CollisionShape

func get_dimensions():
	return Vector3(floor_shape.shape.extents.x, 0, floor_shape.shape.extents.z)

func get_floor_pos():
	return floor_shape.transform.origin
