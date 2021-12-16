extends RigidBody

onready var player = get_node("../Player")
onready var joints = $Joints
onready var frisbee = $Frisbee
onready var visuals = $Visuals

func _ready():
	joints.plan_joint("regular")

func _integrate_forces(state):
	joints._integrate_forces(state)
