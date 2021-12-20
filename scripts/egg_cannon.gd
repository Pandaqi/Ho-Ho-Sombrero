extends Spatial

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


