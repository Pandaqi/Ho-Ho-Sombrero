extends Spatial

var body
var active : bool = false

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
