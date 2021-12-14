extends Spatial

const SHOOT_AWAY_FORCE : float = 5.0

var type : String
var egg_material = preload("res://materials/egg_material.tres")

onready var tween = $Tween
onready var cont = $Container

func _ready():
	for child in cont.get_children():
		if not (child is RigidBody): continue
		
		var vec_away_from_center = child.translation.normalized()
		
		child.apply_central_impulse(vec_away_from_center * SHOOT_AWAY_FORCE)

func set_type(tp : String):
	type = tp
	var mat = egg_material.duplicate(true)
	
	var offset = convert_frame_to_offset(GDict.eggs[type].frame)
	mat.set_shader_param("offset", offset)
	
	for child in $Container.get_children():
		var mesh = child.get_node("MeshInstance")
		mesh.material_override = mat

func convert_frame_to_offset(frame : int):
	return Vector2(frame % 8, floor(frame/8.0))

func _on_Timer_timeout():
	for child in cont.get_children():
		tween.interpolate_property(child, "scale",
			Vector3.ONE, Vector3.ZERO, 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_IN,
			randf())
		tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()
