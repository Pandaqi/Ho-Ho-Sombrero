extends Area

const ATTRACT_STRENGTH : float = 90.0

onready var parent = get_parent()

var valid_bodies =[]

func _physics_process(dt):
	valid_bodies = get_valid_bodies()
	for body in valid_bodies:
		var vec_to_me = (global_transform.origin - body.global_transform.origin).normalized()
		body.apply_central_impulse(vec_to_me * ATTRACT_STRENGTH*dt)

func get_valid_bodies():
	var arr = []
	for body in get_overlapping_bodies():
		if not body.is_in_group("Eggs"): continue
		
		var vec_to_them = (body.global_transform.origin - parent.global_transform.origin).normalized()
		
		# not in position for opening
		if vec_to_them.dot(parent.global_transform.basis.y) < 0: continue
		
		# very much not _moving_ towards opening
#		if body.linear_velocity.dot(parent.global_transform.basis.y) > 0.5: continue
		
		if body.status.delivered: continue
		
		arr.append(body)
		
		# new one? reset some properties to prevent them from falling down before they reach us
		if not body in valid_bodies:
			body.linear_velocity.y *= 0.2
			body.gravity_scale = 0.0
	
	return arr

func _on_AttractArea_body_exited(body):
	if body.gravity_scale <= 0.03: body.gravity_scale = 2.0
