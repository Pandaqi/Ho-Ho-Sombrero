extends RigidBody

onready var bouncer = $Bouncer
onready var breaker = $Breaker
onready var visuals = $Visuals
onready var status = $Status
onready var wrapper = $Wrapper

const VEL_BOUNDS = { 'min': 0.0, 'max': 25.0 }

func _integrate_forces(state):
	breaker._integrate_forces(state)
	bouncer._integrate_forces(state)
	wrapper._integrate_forces(state)
	
	cap_velocity(state)

func cap_velocity(state):
	print(state.linear_velocity.length())
	
	var magnitude = clamp(state.linear_velocity.length(), VEL_BOUNDS.min, VEL_BOUNDS.max)
	state.set_linear_velocity(state.linear_velocity.normalized() * magnitude)
