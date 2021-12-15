extends Node

const JUMP_FORCE : float = 20.0

var body

func _on_Input_button_press():
	pass

func _on_Input_button_release():
	body.apply_central_impulse(Vector3.UP * JUMP_FORCE)
