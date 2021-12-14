extends RigidBody

onready var bouncer = $Bouncer

func _integrate_forces(state):
	bouncer._integrate_forces(state)
