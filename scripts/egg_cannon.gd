extends Spatial

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")

const SHOOT_FORCE : float = 15.0

func _ready():
	_on_Timer_timeout()

func _on_Timer_timeout():
	shoot_egg()

func shoot_egg():
	var e = egg_scene.instance()
	e.set_translation(get_translation())
	e.apply_central_impulse(transform.basis.z*SHOOT_FORCE)
	main_node.call_deferred("add_child", e)
