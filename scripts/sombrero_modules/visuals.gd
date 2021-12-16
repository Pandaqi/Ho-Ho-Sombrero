extends Spatial

onready var mesh_instance = $MeshInstance

func _ready():
	mesh_instance.material_override = mesh_instance.material_override.duplicate(true)

func set_player_num(p_num : int):
	var offset = convert_frame_to_offset(p_num)
	mesh_instance.material_override.set_shader_param("offset", offset)

func convert_frame_to_offset(num : int):
	return Vector2(num % 4, floor(num / 4.0))
