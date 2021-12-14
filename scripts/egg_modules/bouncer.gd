extends Node

const UP_INFLUENCE : float = 2.0
const BOUNCE_POWER : float = 2.0

var epsilon = 0.1

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		
		if normal.y >= 0:
			normal.y = (normal.y + epsilon)*UP_INFLUENCE
		
		normal = normal.normalized()
		
		state.apply_central_impulse(normal * BOUNCE_POWER)
		break
