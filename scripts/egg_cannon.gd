extends Spatial

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")
onready var powerups = get_node("/root/Main/Powerups")

const SHOOT_FORCE : float = 20.0

export var fixed_type : String = "regular"

func _ready():
	call_deferred("_on_Timer_timeout")

func _on_Timer_timeout():
	shoot_egg()

func shoot_egg():
	var e = egg_scene.instance()
	e.set_translation(get_translation())
	
	var shoot_speed = SHOOT_FORCE*powerups.get_egg_speed_modifier()
	var shoot_vec = -transform.basis.z*shoot_speed
	e.transform = e.transform.looking_at(translation + shoot_vec, Vector3.UP)
	e.apply_central_impulse(shoot_vec)
	
	main_node.add_child(e)
	e.visuals.set_type(fixed_type)
