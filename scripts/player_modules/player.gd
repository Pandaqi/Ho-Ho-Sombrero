extends RigidBody

onready var mover = $Mover
onready var powerups = $Powerups

func _integrate_forces(state):
	mover._integrate_forces(state)
