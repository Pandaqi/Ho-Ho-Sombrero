extends Spatial

onready var body = get_parent()
onready var ground_indicator = $GroundIndicator
onready var ground_sprite = $GroundIndicator/Sprite3D
onready var line_mesh = $MeshInstance

onready var map = get_node("/root/Main/Map")

const MIN_DIST_OFF_GROUND : float = 0.5
const MAX_DIST_OFF_GROUND : float = 20.0

var epsilon : float = 0.003
var ground_pos : Vector3

func _ready():
	remove_child(ground_indicator)
	map.add_child(ground_indicator)
	
	remove_child(line_mesh)
	map.add_child(line_mesh)
	
	line_mesh.mesh = line_mesh.mesh.duplicate(true)
	line_mesh.material_override = line_mesh.material_override.duplicate(true)
	
	body.connect("on_death", self, "on_death")

func _physics_process(dt):
	shoot_raycast()
	position_line()

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
	ground_pos = new_pos
	
	var normal = result.normal
	var target_look_pos = new_pos + normal
	
	# NOTE: if the target vector aligns exactly with our up vector, it will crash and do nothing
	# So, in that case, just use a fixed identity transform
	if (normal - Vector3.UP).length() <= 0.01: 
		new_transform.basis = Basis(Vector3.RIGHT, Vector3.BACK, Vector3.UP)
	
	else:
		new_transform = new_transform.looking_at(target_look_pos, Vector3.UP)

	ground_indicator.transform = new_transform
	ground_indicator.set_visible(true)

func position_line():
	if not ground_pos: return
	
	var dist_to_ground = (body.transform.origin - ground_pos).length()
	var avg_pos = 0.5*(body.global_transform.origin + ground_pos)
	
	line_mesh.global_transform.origin = avg_pos
	line_mesh.mesh.height = dist_to_ground
	line_mesh.material_override.set_shader_param("height", dist_to_ground)

func on_death():
	ground_indicator.queue_free()
