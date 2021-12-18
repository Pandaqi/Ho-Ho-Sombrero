extends Spatial

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")
onready var eggs = get_node("/root/Main/Eggs")
onready var powerups = get_node("/root/Main/Powerups")

onready var timer = $Timer

const SHOOT_FORCE : float = 40.0
const FORCE_BOUNDS : Dictionary = { 'min': 22.0, 'max': 60.0 }

const DELAY_PLANNED_SHOT = { 'min': 1.5, 'max': 4.0 }

export var fixed_type : String = "regular"
export var planned_type : String = ""

# all in RADIANS
const ROTATE_SPEED : float = 0.25
export var barrel_starting_rotation : float = 0.0
export var barrel_rotation_bounds : float = 0.0
var barrel_rotate_dir : float = 0.0

const SWIVEL_SPEED : float = 0.25
var swivel_starting_rotation : float = 0.0
export var swivel_bounds : float = 0.0
var swivel_dir : float = 0.0

onready var barrel = $Barrel
onready var barrel_tip = $Barrel/BarrelTip

onready var swivel_timer = $SwivelTimer
const SWIVEL_TIME_BOUNDS = { 'min': 0.3, 'max': 0.8 }

func _ready():
	swivel_starting_rotation = rotation.y
	barrel.rotation.z = barrel_starting_rotation
	
	_on_SwivelTimer_timeout()

func _on_SwivelTimer_timeout():
	barrel_rotate_dir = sign(randf()*2-1)
	swivel_dir = sign(randf()*2-1)
	
	swivel_timer.wait_time = rand_range(SWIVEL_TIME_BOUNDS.min, SWIVEL_TIME_BOUNDS.max)
	swivel_timer.start()

func _physics_process(dt):
	barrel.rotation.z = clamp(barrel.rotation.z + barrel_rotate_dir*ROTATE_SPEED*dt, barrel_starting_rotation - barrel_rotation_bounds, barrel_starting_rotation + barrel_rotation_bounds)
	
	rotation.y = clamp(rotation.y + swivel_dir*dt*SWIVEL_SPEED, swivel_starting_rotation - swivel_bounds, swivel_starting_rotation + swivel_bounds)

func _on_Timer_timeout():
	shoot_egg(planned_type)
	planned_type = ''

func plan_shoot_egg(type : String):
	planned_type = type
	
	timer.wait_time = rand_range(DELAY_PLANNED_SHOT.min, DELAY_PLANNED_SHOT.max)
	timer.start()

func has_egg_planned():
	return (planned_type != '')

# TO DO: wait until shooting animation is finished
func is_busy():
	return (timer.time_left > 0)

func shoot_egg(type : String = ""):
	var e = egg_scene.instance()
	
	var shoot_speed = SHOOT_FORCE*powerups.get_egg_speed_modifier()
	var rand_modifier = 0.6+randf()*0.6
	shoot_speed = clamp(shoot_speed * rand_modifier, FORCE_BOUNDS.min, FORCE_BOUNDS.max)
	
	# NOTE: I modeled the cannon mesh the wrong way -.-
	# That's why we use +X, instead of the default -Z
	var shoot_vec = barrel.global_transform.basis.x*shoot_speed
	var shoot_pos = barrel_tip.global_transform.origin
	e.transform.origin = shoot_pos
	e.transform = e.transform.looking_at(shoot_pos + shoot_vec, Vector3.UP)
	e.apply_central_impulse(shoot_vec)
	
	main_node.add_child(e)
	
	if type == "": type = fixed_type
	e.visuals.set_type(type)
	
	eggs.on_egg_created(e)
