extends Node

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")
onready var eggs = get_node("/root/Main/Eggs")
onready var powerups = get_node("/root/Main/Powerups")

onready var timer = $Timer

const SHOOT_FORCE : float = 40.0
const FORCE_BOUNDS : Dictionary = { 'min': 22.0, 'max': 60.0 }

const DELAY_PLANNED_SHOT = { 'min': 1.5, 'max': 4.0 }

export var fixed_type : String = "regular"
export var planned_type : String = ""

var anim_player = null

export var drop_instead_of_shoot : bool = false
export var barrel : NodePath # determines shooting direction
export var barrel_tip : NodePath # determines shooting starting pos

func _ready():
	if has_node("AnimationPlayer"): anim_player = $AnimationPlayer

func _on_Timer_timeout():
	shoot_egg(planned_type)
	planned_type = ''

func plan_shoot_egg(type : String):
	planned_type = type
	
	if anim_player: anim_player.play("Windup")
	timer.wait_time = rand_range(DELAY_PLANNED_SHOT.min, DELAY_PLANNED_SHOT.max)
	timer.start()

func has_egg_planned():
	return (planned_type != '')

func is_busy():
	var parent_is_busy : bool = false
	if get_parent().has_method("is_busy"): parent_is_busy = get_parent().is_busy()
	return (timer.time_left > 0) or (anim_player and anim_player.is_playing()) or parent_is_busy

func shoot_egg(type : String = ""):
	var e = egg_scene.instance()
	
	var shoot_speed = SHOOT_FORCE*powerups.get_egg_speed_modifier()
	var rand_modifier = 0.6+randf()*0.6
	shoot_speed = clamp(shoot_speed * rand_modifier, FORCE_BOUNDS.min, FORCE_BOUNDS.max)
	
	var shoot_vec = Vector3(0.01, -1, 0.01)
	var shoot_pos = get_node(barrel_tip).global_transform.origin
	
	if not drop_instead_of_shoot:
		# NOTE: I modeled the cannon mesh the wrong way -.-
		# That's why we use +X, instead of the default -Z
		shoot_vec = get_node(barrel).global_transform.basis.x*shoot_speed 
	
	e.transform.origin = shoot_pos
	e.transform = e.transform.looking_at(shoot_pos + shoot_vec, Vector3.UP)
	
	if not drop_instead_of_shoot:
		e.apply_central_impulse(shoot_vec)
	
	e.get_node("Visuals").set_shape(powerups.get_cur_egg_shape())
	main_node.add_child(e)
	
	if type == "": type = fixed_type
	e.visuals.set_type(type)
	
	eggs.on_egg_created(e)
	
	if anim_player: anim_player.play("Shot")
