extends Area

const ATTRACT_STRENGTH : float = 90.0

onready var parent = get_parent()
var valid_bodies = []

func _physics_process(dt):
	valid_bodies = get_valid_bodies()
	for body in valid_bodies:
		var vec_to_me = (global_transform.origin - body.global_transform.origin).normalized()
		body.apply_central_impulse(vec_to_me * ATTRACT_STRENGTH*dt)

func get_valid_bodies():
	var arr = []
	
	for body in get_overlapping_bodies():
		if not body.is_in_group("Eggs"): continue
		if body.bouncer.get_num_unique_players_touched() <= 0: continue
		if body.status.delivered: continue
		
		arr.append(body)
	
	return arr
