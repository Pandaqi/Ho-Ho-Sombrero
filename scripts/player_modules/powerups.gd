extends Spatial

var type : String
var data

const BOUNCE_FAC_BOUNDS = { 'min': 0.5, 'max': 2.0 }
var bounce_factor : float = 1.0

var cur_module = null

onready var body = get_parent()
onready var mover = get_node("../Mover")
onready var input = get_node("../Input")

onready var powerups = get_node("/root/Main/Powerups")
onready var GUI = get_node("/root/Main/GUI")
onready var cam = get_node("/root/Main/Camera")

onready var icon_button = $IconButton
onready var button_anim_player = $IconButton/AnimationPlayer
onready var icons = $Icons
onready var anim_player = $Icons/AnimationPlayer
onready var influence_sphere = $InfluenceSphere

onready var sombrero = get_node("../../Sombrero")

const ICON_Y_OFFSET : Vector2 = Vector2.UP * 50

func _ready():
	remove_child(icon_button)
	GUI.add_child(icon_button)
	remove_influence_sphere()
	hide_icon()

func grab(tp : String):
	var same_as_current = (tp == type)
	if same_as_current: return
	
	hide_icon()
	remove_module_if_exists()
	undo_previous_effect()
	
	type = tp
	data = GDict.eggs[type]
	
	handle_immediate_effect()
	add_module_if_exists()
	toggle_influence_sphere_if_needed()
	show_icon()
	
	if not data.has('persistent'): type = ""

func handle_immediate_effect():
	match type:
		'move_faster':
			mover.speed_modifier *= 1.5
		'move_slower':
			mover.speed_modifier *= 0.75
		'extra_bouncy':
			bounce_factor *= 1.5
		'less_bouncy':
			bounce_factor *= 0.75
		'icy_movement':
			mover.slip_factor = 0.7
		'global_gravity_plus':
			powerups.change_global_gravity(1.3)
		'global_gravity_min':
			powerups.change_global_gravity(0.75)
		'global_egg_faster':
			powerups.modify_egg_speed(1.3)
		'global_egg_slower':
			powerups.modify_egg_speed(0.75)
		'earthquake':
			sombrero.joints.plan_joint("slanted")
		'racket':
			sombrero.joints.plan_joint("racket")
		'frisbee':
			sombrero.frisbee.activate()
		'size_grow':
			powerups.change_egg_shape("egg_big")
		'size_shrink':
			powerups.change_egg_shape("egg_small")
		'global_double_points':
			powerups.modify_point_factor(2.0)
		'global_half_points':
			powerups.modify_point_factor(0.5)

func undo_previous_effect():
	if type == "": return
	
	match type:
		'icy_movement':
			mover.slip_factor = 0.0
		'earthquake':
			sombrero.joints.plan_joint("regular")
		'racket':
			sombrero.joints.plan_joint("regular")
		'frisbee':
			sombrero.frisbee.deactivate()

func get_final_bounce_factor():
	return clamp(bounce_factor, BOUNCE_FAC_BOUNDS.min, BOUNCE_FAC_BOUNDS.max)

func add_module_if_exists():
	if not data.has('module'): return
	
	var m = load("res://scenes/powerup_modules/" + type + ".tscn").instance()
	m.body = body
	cur_module = m
	add_child(m)

	if data.has('button'):
		input.connect("button_press", m, "_on_Input_button_press")
		input.connect("button_release", m, "_on_Input_button_release")

func remove_influence_sphere():
	influence_sphere.set_visible(false)

func toggle_influence_sphere_if_needed():
	if not data.has('radius'): return
	
	influence_sphere.set_visible(true)

func remove_module_if_exists():
	if not cur_module: return
	
	if cur_module.has_method("on_death"):
		cur_module.on_death()
	
	cur_module.queue_free()
	cur_module = null

func hide_icon():
	icons.set_visible(false)
	icon_button.set_visible(false)
	anim_player.stop(true)

func show_icon():
	if not data.has('persistent'): return
	
	for child in icons.get_children():
		if not (child is Sprite3D): continue
		child.set_frame(data.frame)

	icons.set_visible(true)
	anim_player.play("IconFade")
	
	icon_button.set_visible(data.has('button'))
	if icon_button.is_visible():
		button_anim_player.play("ButtonHighlight")

func _physics_process(dt):
	var real_pos = body.transform.origin
	var offset = ICON_Y_OFFSET
	icon_button.set_position(cam.unproject_position(real_pos) + offset)
	influence_sphere.global_transform.origin = body.global_transform.origin
