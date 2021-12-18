extends Node

const JUMP_FORCE : float = 40.0

var body

func _on_Input_button_press():
	pass

func _on_Input_button_release():
	var on_ground = body.rc.is_colliding()
	if not on_ground: return
	
	body.apply_central_impulse(Vector3.UP * JUMP_FORCE)
