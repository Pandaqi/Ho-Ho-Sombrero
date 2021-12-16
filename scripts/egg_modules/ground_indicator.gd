extends Spatial

onready var body = get_parent()
onready var ground_indicator = $GroundIndicator
onready var ground_sprite = $GroundIndicator/Sprite3D

onready var map = get_node("/root/Main/Map")

const MIN_DIST_OFF_GROUND : float = 0.5
const MAX_DIST_OFF_GROUND : float = 20.0

var epsilon : float = 0.003

func _ready():
	remove_child(ground_indicator)
	map.add_child(ground_indicator)
	
	body.connect("on_death", self, "on_death")

func _physics_process(dt):
	shoot_raycast()

func shoot_raycast():
	var space_state = get_world().direct_space_state
	
	var start = body.transform.origin
	var end = start + Vector3.DOWN * 1000.0
	var exclude = [body]
	
	ground_indicator.set_visible(false)
	
	var result = space_state.intersect_ray(start, end, exclude)
	if not result: return
	
	var dist_off_ground = (result.position - body.transform.origin).length()
	if dist_off_ground <= MIN_DIST_OFF_GROUND: return

	# NOTE: scaling drastically looks ugly and doesn't help
	var dist_ratio = 0.4 + clamp(1.0 - dist_off_ground/MAX_DIST_OFF_GROUND, 0, 1)*0.2
	ground_sprite.set_scale(Vector3.ONE * dist_ratio)

	# epsilon to prevent Z-fighting
	var new_pos = result.position + Vector3.UP*epsilon
	var new_transform = Transform.IDENTITY
	new_transform.origin = new_pos
	
	var normal = result.normal
	var target_look_pos = new_pos + normal
	if (normal - Vector3.UP).length() <= 0.01: 
		new_transform.basis = Basis(Vector3.RIGHT, Vector3.BACK, Vector3.UP)
	
	else:
		new_transform = new_transform.looking_at(target_look_pos, Vector3.UP)

	ground_indicator.transform = new_transform
	ground_indicator.set_visible(true)

func on_death():
	ground_indicator.queue_free()
