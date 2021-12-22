extends Spatial

var body
var active : bool = false

export var keep_on_ground : bool = false

onready var area = $Area
onready var col_shape = $Area/CollisionShape

onready var feedback = get_node("/root/Main/Feedback")

const SPHERE_SIZE : float = 14.0

func _ready():
	col_shape.shape = SphereShape.new()
	col_shape.shape.radius = 0.0

func _on_Input_button_press():
	active = true
	col_shape.shape.radius = SPHERE_SIZE
	area.set_translation(Vector3.ONE*randf())
	
	var data = body.powerups.data
	if data.has("fb_use"):
		feedback.create_for(body, data.fb_use)

func _on_Input_button_release():
	active = false
	col_shape.shape.radius = 0.0
	area.set_translation(Vector3.ONE*randf())

func _physics_process(dt):
	if not keep_on_ground: return
	
	var space_state = get_world().direct_space_state
	var start = body.global_transform.origin
	var end = start + Vector3.DOWN * 1000.0
	var exclude = [body]
	var col_layer = 8

	var result = space_state.intersect_ray(start, end, exclude, col_layer)
	if not result: return
	
	area.global_transform.origin = result.position
