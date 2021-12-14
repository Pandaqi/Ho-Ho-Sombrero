extends RigidBody

onready var mover = $Mover

func _integrate_forces(state):
	mover._integrate_forces(state)
