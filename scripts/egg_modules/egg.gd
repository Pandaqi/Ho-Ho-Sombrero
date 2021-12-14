extends RigidBody

onready var bouncer = $Bouncer
onready var breaker = $Breaker
onready var visuals = $Visuals
onready var status = $Status

func _integrate_forces(state):
	breaker._integrate_forces(state)
	bouncer._integrate_forces(state)
