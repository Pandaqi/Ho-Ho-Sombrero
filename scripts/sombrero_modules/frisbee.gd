extends Node

const MAX_DIST_TO_PLAYER : float = 15.0
const THROW_SPEED : float = 35.0
const SPIN_SPEED : float = 20.0

var active : bool = false
var phase : String = "idle"

var original_throw_dir : Vector3

onready var body = get_parent()
onready var player = get_node("../../Player")

func _ready():
	player.input.connect("button_release", self, "_on_Input_button_release")

func activate():
	active = true

func deactivate():
	active = false

func _on_Input_button_release():
	if not active: return
	enter_throw_phase()
	
func enter_throw_phase():
	yield(body.joints.destroy_joint(), "completed")
	original_throw_dir = -player.transform.basis.z
	phase = "throw"

func enter_return_phase():
	phase = "return"

func finish_return_phase():
	phase = "idle"
	body.joints.plan_joint("regular")

func _physics_process(dt):
	if not active: return
	if phase == "idle": 
		body.set_linear_velocity(Vector3.ZERO)
		return
	
	body.set_angular_velocity(Vector3.UP * SPIN_SPEED)
	if phase == "throw":
		body.set_linear_velocity(original_throw_dir * THROW_SPEED)
	
	elif phase == "return":
		var vec_back = (player.transform.origin - body.transform.origin).normalized()
		body.set_linear_velocity(vec_back * THROW_SPEED)
	
	var dist_to_player = (body.transform.origin - player.transform.origin).length()
	if dist_to_player >= MAX_DIST_TO_PLAYER:
		enter_return_phase()
	
	if phase == "return" and dist_to_player <= 0.5:
		finish_return_phase()
