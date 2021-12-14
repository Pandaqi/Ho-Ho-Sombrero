extends Node

const UP_INFLUENCE : float = 3.0
const BOUNCE_POWER : float = 3.0

var epsilon = 0.1
var active : bool = true

func _integrate_forces(state):
	if not active: return
	
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		if obj.is_in_group("NormalBouncer"): continue
		
		if normal.y >= 0:
			normal.y = (normal.y + epsilon)*UP_INFLUENCE
		
		normal = normal.normalized()
		
		state.apply_central_impulse(normal * BOUNCE_POWER)
		break

func set_delivered():
	active = false
