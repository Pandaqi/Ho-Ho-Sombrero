extends RigidBody

onready var mover = $Mover
onready var powerups = $Powerups
onready var rc = $RayCast
onready var input = $Input
onready var status = $Status
onready var sombrero = get_node("../Sombrero")

var wrapper = null
var wrapper_scene = preload("res://scenes/general_modules/wrapper.tscn")

var original_gravity_scale : float

func _ready():
	original_gravity_scale = gravity_scale
	
	if GDict.cfg.level_wrapping:
		wrapper = wrapper_scene.instance()
		add_child(wrapper)
	
	if not GDict.cfg.player_lights:
		$OmniLight.queue_free()

func change_gravity_scale(mult : float):
	gravity_scale = original_gravity_scale * mult

func _integrate_forces(state):
	mover._integrate_forces(state)
	
	if wrapper:
		wrapper._integrate_forces(state)
	
	if sombrero.joints.settling_joint:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
	
