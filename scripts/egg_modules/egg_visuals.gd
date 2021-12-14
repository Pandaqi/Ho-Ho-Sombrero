extends Spatial

var type : String

onready var mesh_instance = $MeshInstance

func _ready():
	mesh_instance.material_override = mesh_instance.material_override.duplicate(true)

func set_type(tp : String):
	type = tp
	
	var offset = convert_frame_to_offset(GDict.eggs[type].frame)
	mesh_instance.material_override.set_shader_param("offset", offset)

func convert_frame_to_offset(frame : int):
	return Vector2(frame % 8, floor(frame/8.0))
