extends Node

const ROT_SPEED : float = 2.0
const MOVE_SPEED : float = 960.0
const SPEED_BOUNDS = { 'min': 550.0, 'max': 1800.0 }

var speed_modifier : float = 1.0
var slip_factor : float = 0.0

const STUN_TIME : float = 0.75
onready var stun_timer = $StunTimer
var stunned : bool = false

onready var body = get_parent()
var input_vec : Vector2 = Vector2.ZERO
var fps_dt = (1.0/60.0)

var extra_speed : float = 0.0
var extra_force : Vector3 = Vector3.ZERO
var last_known_input : Vector2

var MOVE_AUDIO_VOLUME : float = -4.5
var audio_player = null

const SLIP_DAMPING : float = 0.00001

func _ready():
	create_move_audio()

func create_move_audio():
	var key = "walking"
	audio_player = GAudio.play_dynamic_sound(body, key, MOVE_AUDIO_VOLUME, "FX", false)
	audio_player.get_parent().remove_child(audio_player)
	add_child(audio_player)
	audio_player.stop()

func _on_Input_move_vec(vec, dt):
	input_vec = vec

func _integrate_forces(state):
	if stunned: return
	if not audio_player: return
	
	var temp_slip_factor = slip_factor
	if GDict.cfg.whole_level_is_ice: temp_slip_factor = 0.7
	
	var cur_vel = state.get_linear_velocity()
	var cur_vel_without_y = Vector3(cur_vel.x, 0, cur_vel.z)
	
	if input_vec.length() > 0.03: 
		var vec_3d = Vector3(input_vec.x, 0, input_vec.y)
		var cur_vec_3d = -state.transform.basis.z
		var cur_vec_2d = Vector2(cur_vec_3d.x, cur_vec_3d.z)
		
		var rot_dir = cur_vec_2d.cross(input_vec)
		var angle = abs(cur_vec_2d.angle_to(input_vec))/PI
		
		# if exactly anti-parallel, just pick one default direction
		# (rot_dir will be 0, same as when parallel)
		if cur_vec_2d.dot(input_vec) <= (-0.99):
			rot_dir = 1

		var rotate_speed = 70 * sqrt(angle)
		rotate_speed *= 1.0 - temp_slip_factor
		
		state.set_angular_velocity(-Vector3.UP*rotate_speed*rot_dir)
	
	var cur_speed = cur_vel_without_y.length()
	var wanted_speed = get_final_speed()*fps_dt
	var wanted_vel = -state.transform.basis.z
	
	var vel_norm = cur_vel_without_y.normalized()
	var wanted_norm = wanted_vel.normalized()
	
	if vel_norm.length() == 1 and wanted_norm.length() == 1:
		wanted_vel = vel_norm.slerp(wanted_norm, 1.0 - temp_slip_factor)
	
	if input_vec.length() <= 0.03:
		if temp_slip_factor > 0.03:
			wanted_speed = cur_speed * (1.0 - SLIP_DAMPING*fps_dt)
		elif extra_speed > 0.03:
			pass
		else:
			wanted_speed = 0.0
			stop_moving()
	
	wanted_vel *= wanted_speed
	
	if input_vec.length() <= 0.03:
		state.set_angular_velocity(Vector3.ZERO)

	if wanted_vel.length() >= 0.03 and not audio_player.is_playing():
		audio_player.play()
	
	wanted_vel = Vector3(wanted_vel.x, cur_vel.y, wanted_vel.z)
	state.set_linear_velocity(wanted_vel)
	
	if input_vec.length() >= 0.03: last_known_input = input_vec

func stop_moving():
	if audio_player.is_playing(): audio_player.stop()

func get_final_speed():
	return clamp(MOVE_SPEED*speed_modifier, SPEED_BOUNDS.min, SPEED_BOUNDS.max) + extra_speed

func set_extra_speed(val : float):
	extra_speed = val

func stun_temporarily():
	stunned = true
	stun_timer.wait_time = STUN_TIME
	stun_timer.start()

func _on_StunTimer_timeout():
	stunned = false

func _on_Input_button_press():
	pass # Replace with function body.

func _on_Input_button_release():
	pass # Replace with function body.



