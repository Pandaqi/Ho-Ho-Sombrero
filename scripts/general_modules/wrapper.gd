extends Node

onready var map = get_node("/root/Main/Map")

func _integrate_forces(state):
	pass
	
	# TO DO: check if we exceed map.get_dimensions()
	# If so, wrap around to the other side
	# But only if this is enabled in config
