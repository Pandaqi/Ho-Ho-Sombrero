extends Node

const JUMP_FORCE : float = 40.0

var body
onready var feedback = get_node("/root/Main/Feedback")

func _on_Input_button_press():
	pass

func _on_Input_button_release():
	var on_ground = body.rc.is_colliding()
	if not on_ground: return
	
	body.apply_central_impulse(Vector3.UP * JUMP_FORCE)
	
	var data = body.powerups.data
	if data.has("fb_use"):
		feedback.create_for(body, data.fb_use)
