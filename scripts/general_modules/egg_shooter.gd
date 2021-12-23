extends Node

var egg_scene = preload("res://scenes/egg.tscn")
onready var main_node = get_node("/root/Main")
onready var eggs = get_node("/root/Main/Eggs")
onready var powerups = get_node("/root/Main/Powerups")
onready var feedback = get_node("/root/Main/Feedback")

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

export var attract_area : NodePath
var attract_radius : float = 0.0

var disable_timer : Timer
const ATTRACT_DISABLE_DUR : float = 2.5

var puff_particles = preload("res://scenes/particles/self_remove_puff.tscn")

func _ready():
	if has_node("AnimationPlayer"): anim_player = $AnimationPlayer
	if has_node("DisableTimer"): disable_timer = $DisableTimer
	if attract_area:
		attract_radius = get_node(attract_area).get_node("CollisionShape").shape.radius

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
	
	if attract_area:
		get_node(attract_area).get_node("CollisionShape").shape.radius = 0.0
		get_node(attract_area).set_translation(Vector3.ZERO)
		
		disable_timer.wait_time = ATTRACT_DISABLE_DUR
		disable_timer.start()
	
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
	
	GAudio.play_dynamic_sound(get_node(barrel_tip), "shoot")
	feedback.create_for(get_node(barrel_tip), "New Egg!")
	if anim_player: anim_player.play("Shot")
	
	var part = puff_particles.instance()
	part.transform.origin = e.transform.origin
	main_node.add_child(part)

func _on_DisableTimer_timeout():
	get_node(attract_area).get_node("CollisionShape").shape.radius = attract_radius
