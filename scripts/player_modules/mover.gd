extends Node

const ROT_SPEED : float = 2.0
const MOVE_SPEED : float = 300.0

onready var body = get_parent()
var input_vec
var fps_dt = (1.0/60.0)

func _on_Input_move_vec(vec, dt):
	input_vec = vec

func _integrate_forces(state):
	if input_vec.length() <= 0.03: 
		state.set_linear_velocity(Vector3.ZERO)
		return
	
	var a = Quat(state.transform.basis)
	
	var vec_3d = Vector3(input_vec.x, 0, input_vec.y)
	var target_pos = state.transform.origin + vec_3d
	var new_transform = state.transform.looking_at(target_pos, Vector3.UP)
	
	var b = Quat(new_transform.basis)
	var c = a.slerp(b, 1.0 - (1.0/ROT_SPEED))
	state.transform.basis = Basis(c)
	
	state.set_linear_velocity(state.transform.basis.z*fps_dt*MOVE_SPEED)

func _on_Input_button_press():
	pass # Replace with function body.

func _on_Input_button_release():
	pass # Replace with function body.
