extends Spatial

onready var floor_shape = $Floor/CollisionShape

func get_dimensions():
	return Vector3(floor_shape.shape.extents.x, 0, floor_shape.shape.extents.z)
