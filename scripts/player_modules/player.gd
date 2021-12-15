extends RigidBody

onready var mover = $Mover
onready var powerups = $Powerups
onready var rc = $RayCast
onready var wrapper = $Wrapper

func _integrate_forces(state):
	mover._integrate_forces(state)
	wrapper._integrate_forces(state)
	
