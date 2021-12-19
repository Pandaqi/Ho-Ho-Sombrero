extends Node

const UP_INFLUENCE : float = 5.0 # how much more eggs bounce upward than realistically
const WALL_INFLUENCE : float = 4.0 # how much walls push you _extra _inward
const BOUNCE_POWER : float = 6.0

var epsilon = 0.1
var active : bool = true

onready var body = get_parent()
onready var powerups = get_node("/root/Main/Powerups")

func _integrate_forces(state):
	if not active: return
	
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		var original_normal = normal
		if obj.is_in_group("NormalBouncer"): continue

		if normal.y < 0: normal.y += 1.0
		normal.y *= UP_INFLUENCE
		
		# TO DO: Make sure it bounces back quite quickly from walls? How?
		if obj.is_in_group("Walls"):
			if abs(normal.x) > abs(normal.z):
				normal.x *= WALL_INFLUENCE
			else:
				normal.z *= WALL_INFLUENCE
		
		normal = normal.normalized()

		var final_bounce_power = BOUNCE_POWER
		if obj.is_in_group("Players"):
			final_bounce_power *= obj.powerups.get_final_bounce_factor()
		final_bounce_power *= powerups.get_egg_speed_modifier()
		
		state.apply_central_impulse(normal * final_bounce_power)
		body.visuals.on_bounce(original_normal)
		break

func set_delivered():
	active = false
