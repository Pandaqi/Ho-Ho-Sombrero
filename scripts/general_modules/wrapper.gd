extends Node

onready var map = get_node("/root/Main/Map")

func _integrate_forces(state):
	if not GDict.cfg.level_wrapping: return
	
	var dims = map.get_dimensions()
	var pos = state.transform.origin
	
	if pos.x < -dims.x or pos.x > dims.x:
		pos.x *= -1
	
	if pos.z < -dims.z or pos.z > dims.z:
		pos.z *= -1
	
	state.transform.origin = pos
