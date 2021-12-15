extends Spatial

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")
onready var eggs = get_node("/root/Main/Eggs")
onready var powerups = get_node("/root/Main/Powerups")

onready var timer = $Timer

const SHOOT_FORCE : float = 20.0
const FORCE_BOUNDS : Dictionary = { 'min': 9.0, 'max': 30.0 }

const DELAY_PLANNED_SHOT = { 'min': 1.5, 'max': 4.0 }

export var fixed_type : String = "regular"
export var planned_type : String = ""

func _on_Timer_timeout():
	shoot_egg(planned_type)

func plan_shoot_egg(type : String):
	planned_type = type
	
	timer.wait_time = rand_range(DELAY_PLANNED_SHOT.min, DELAY_PLANNED_SHOT.max)
	timer.start()

# TO DO: wait until shooting animation is finished
func is_busy():
	return (timer.time_left > 0)

func shoot_egg(type : String = ""):
	var e = egg_scene.instance()
	e.set_translation(get_translation())
	
	var shoot_speed = SHOOT_FORCE*powerups.get_egg_speed_modifier()
	var rand_modifier = 0.6+randf()*0.6
	shoot_speed = clamp(shoot_speed * rand_modifier, FORCE_BOUNDS.min, FORCE_BOUNDS.max)
	
	var shoot_vec = -transform.basis.z*shoot_speed
	e.transform = e.transform.looking_at(translation + shoot_vec, Vector3.UP)
	e.apply_central_impulse(shoot_vec)
	
	main_node.add_child(e)
	
	if type == "": type = fixed_type
	e.visuals.set_type(type)
	
	eggs.on_egg_created(e)
