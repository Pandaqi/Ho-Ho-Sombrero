extends Spatial

var type : String
var shape : String

onready var mesh_container = $MeshContainer
onready var mesh_instance = $MeshContainer/MeshInstance
onready var offscreen = get_node("../Offscreen")
onready var tween = $Tween
onready var body = get_parent()

var shapes = {
	"egg": preload("res://scenes/shapes/egg.tscn"),
	"egg_small": preload("res://scenes/shapes/egg_small.tscn"),
	"egg_big": preload("res://scenes/shapes/egg_big.tscn"),
	"sphere": preload("res://scenes/shapes/sphere.tscn"),
	"cube": preload("res://scenes/shapes/sphere.tscn"),
}

func _ready():
	mesh_instance.material_override = mesh_instance.material_override.duplicate(true)

func set_shape(shp : String):
	var node = shapes[shp].instance()
	
	var mesh = node.get_node("MeshContainer")
	node.remove_child(mesh)
	add_child(mesh)
	
	# NOTE: Collision shape must be direct child of body, so added to parent instead of ourselves
	var col_shape = node.get_node("CollisionShape")
	node.remove_child(col_shape)
	get_parent().add_child(col_shape)
	
	shape = shp

func set_type(tp : String):
	type = tp
	
	# TO DO: for now, only eggs have a shader and different params and stuff
	if not (shape in ["egg", "egg_small", "egg_big"]): return
	
	var offset = convert_frame_to_offset(GDict.eggs[type].frame)
	mesh_instance.material_override.set_shader_param("offset", offset)
	
	offscreen.set_type(tp)

func convert_frame_to_offset(frame : int):
	return Vector2(frame % 8, floor(frame/8.0))

func set_delivered():
	mesh_instance.material_override = null

func on_bounce(normal : Vector3):
	var dur = 0.2
	
	# rotate this to have our Z-axis point along the normal
	self.global_transform = self.global_transform.looking_at(self.transform.origin + normal, Vector3.UP)
	
	# then rotate our mesh the other way around (to keep it in the same place)
	mesh_container.global_transform.basis = self.global_transform.inverse().basis
	
	# why all these shenanigans?
	# so we know the normal is aligned with our Z-axis, and we can just scale that to get the squash :)
	var new_scale = Vector3(1.4, 1.4, 0.4)
	
	tween.interpolate_property(self, "scale", 
		Vector3.ONE, new_scale, dur,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tween.interpolate_property(self, "scale", 
		new_scale, Vector3.ONE, dur,
		Tween.TRANS_LINEAR, Tween.EASE_OUT,
		dur)
	tween.start()
	
	
	
	
