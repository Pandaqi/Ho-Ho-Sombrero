extends Node

const ROT_SPEED : float = 2.0
const MOVE_SPEED : float = 700.0
const SPEED_BOUNDS = { 'min': 400.0, 'max': 1500.0 }

var speed_modifier : float = 1.0
var slip_factor : float = 0.0

onready var body = get_parent()
var input_vec
var fps_dt = (1.0/60.0)

var extra_speed : float = 0.0
var extra_force : Vector3 = Vector3.ZERO

func _on_Input_move_vec(vec, dt):
	input_vec = vec

func _integrate_forces(state):
	var cur_vel = state.get_linear_velocity()
	
	if input_vec.length() > 0.03: 
		var a = Quat(state.transform.basis)
		
		var vec_3d = Vector3(input_vec.x, 0, input_vec.y)
		var target_pos = state.transform.origin + vec_3d
		var new_transform = state.transform.looking_at(target_pos, Vector3.UP)
		
		var b = Quat(new_transform.basis)
		var c = a.slerp(b, 1.0 - (1.0/ROT_SPEED))
		state.transform.basis = Basis(c)
	
	var wanted_vel = -state.transform.basis.z*fps_dt*get_final_speed()
	wanted_vel = cur_vel.linear_interpolate(wanted_vel, 1.0 - slip_factor)
	
	if input_vec.length() <= 0.03 and slip_factor <= 0.03: 
		wanted_vel = Vector3.ZERO
	
	wanted_vel = Vector3(wanted_vel.x, cur_vel.y, wanted_vel.z)
	state.set_linear_velocity(wanted_vel)

func get_final_speed():
	return clamp(MOVE_SPEED*speed_modifier, SPEED_BOUNDS.min, SPEED_BOUNDS.max) + extra_speed

func set_extra_speed(val : float):
	extra_speed = val

func _on_Input_button_press():
	pass # Replace with function body.

func _on_Input_button_release():
	pass # Replace with function body.
