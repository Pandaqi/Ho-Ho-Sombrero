extends RigidBody

onready var mover = $Mover
onready var powerups = $Powerups
onready var rc = $RayCast
onready var input = $Input
onready var status = $Status
onready var sombrero = get_node("../Sombrero")

var wrapper = null
var wrapper_scene = preload("res://scenes/general_modules/wrapper.tscn")

func _ready():
	if GDict.cfg.level_wrapping:
		wrapper = wrapper_scene.instance()
		add_child(wrapper)

func _integrate_forces(state):
	mover._integrate_forces(state)
	
	if wrapper:
		wrapper._integrate_forces(state)
	
	if sombrero.joints.settling_joint:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
	
