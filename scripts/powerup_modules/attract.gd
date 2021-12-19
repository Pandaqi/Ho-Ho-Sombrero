extends Spatial

var body
var active : bool = false

export var keep_on_ground : bool = false

onready var area = $Area
onready var col_shape = $Area/CollisionShape

func _ready():
	col_shape.shape = SphereShape.new()
	col_shape.shape.radius = 0.0

func _on_Input_button_press():
	active = true
	col_shape.shape.radius = 11.0
	area.set_translation(Vector3.ONE*randf())

func _on_Input_button_release():
	active = false
	col_shape.shape.radius = 0.0
	area.set_translation(Vector3.ONE*randf())

func _physics_process(dt):
	if not keep_on_ground: return
	
	var space_state = get_world().direct_space_state
	var start = body.transform.origin
	var end = start + Vector3.DOWN * 1000.0
	var exclude = [body]

	var result = space_state.intersect_ray(start, end, exclude)
	if not result: return
	
	area.global_transform.origin(result.position)
