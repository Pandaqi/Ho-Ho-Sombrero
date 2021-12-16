extends RigidBody

onready var mover = $Mover
onready var powerups = $Powerups
onready var rc = $RayCast
onready var wrapper = $Wrapper
onready var input = $Input
onready var status = $Status
onready var sombrero = get_node("../Sombrero")

func _integrate_forces(state):
	mover._integrate_forces(state)
	wrapper._integrate_forces(state)
	
	if sombrero.joints.settling_joint:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
	
