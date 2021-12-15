extends Node

const UP_INFLUENCE : float = 5.0
const BOUNCE_POWER : float = 3.0

var epsilon = 0.1
var active : bool = true

onready var powerups = get_node("/root/Main/Powerups")

func _integrate_forces(state):
	if not active: return
	
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		if obj.is_in_group("NormalBouncer"): continue
		
		print("OLD")
		print(normal)
		
		if normal.y < 0: normal.y += 1.0
		normal.y *= UP_INFLUENCE
		
		normal = normal.normalized()
		
		print("NEW")
		print(normal)
		
		var final_bounce_power = BOUNCE_POWER
		if obj.is_in_group("Players"):
			final_bounce_power *= obj.powerups.get_final_bounce_factor()
		final_bounce_power *= powerups.get_egg_speed_modifier()
		
		state.apply_central_impulse(normal * final_bounce_power)
		break

func set_delivered():
	active = false
