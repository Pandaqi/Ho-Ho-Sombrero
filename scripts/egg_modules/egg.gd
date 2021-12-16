extends RigidBody

onready var bouncer = $Bouncer
onready var breaker = $Breaker
onready var visuals = $Visuals
onready var status = $Status
onready var wrapper = $Wrapper
onready var offscreen = $Offscreen

var auto_deliver
var auto_deliver_module = preload("res://scenes/egg_modules/auto_deliver.tscn")

const VEL_BOUNDS = { 'min': 0.0, 'max': 10.0 }

signal on_death()

func _ready():
	if GDict.cfg.auto_deliver_eggs:
		auto_deliver = auto_deliver_module.instance()
		add_child(auto_deliver)

func _integrate_forces(state):
	breaker._integrate_forces(state)
	bouncer._integrate_forces(state)
	wrapper._integrate_forces(state)
	
	cap_velocity(state)

func cap_velocity(state):
	var vel = state.linear_velocity
	var vel_without_y = Vector3(vel.x, 0, vel.z)
	var magnitude = clamp(vel_without_y.length(), VEL_BOUNDS.min, VEL_BOUNDS.max)
	
	var new_vel = vel_without_y.normalized() * magnitude
	new_vel.y = vel.y
	state.set_linear_velocity(new_vel)
