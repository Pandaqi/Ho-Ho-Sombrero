extends Area

const EXPLODE_FORCE : float = 10.0

func _ready():
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	var epsilon = 0.01
	set_translation(get_translation() + Vector3.ONE*epsilon)
	yield(get_tree(), "physics_frame")
	
	blow_away_surroundings()

func blow_away_surroundings():
	for body in get_overlapping_bodies():
		if body.is_in_group("Sombreros"): continue
		if body.is_in_group("Players"):
			body.mover.stun_temporarily()

		var vec_away = (body.global_transform.origin - self.global_transform.origin).normalized()
		body.add_central_impulse(vec_away * EXPLODE_FORCE)

	self.queue_free()
