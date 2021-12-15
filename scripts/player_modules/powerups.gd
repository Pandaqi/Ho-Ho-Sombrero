extends Node

var type : String
var data

const BOUNCE_FAC_BOUNDS = { 'min': 0.5, 'max': 2.0 }
var bounce_factor : float = 1.0

var cur_module = null

onready var body = get_parent()
onready var mover = get_node("../Mover")
onready var input = get_node("../Input")

onready var powerups = get_node("/root/Main/Powerups")

func grab(tp : String):
	remove_module_if_exists()
	undo_previous_effect()
	
	type = tp
	data = GDict.eggs[type]
	
	handle_immediate_effect()
	add_module_if_exists()
	show_icon()

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
		'global_double_points':
			powerups.modify_point_factor(2.0)

func undo_previous_effect():
	if type == "": return
	
	match type:
		'icy_movement':
			mover.slip_factor = 0.0

func get_final_bounce_factor():
	return clamp(bounce_factor, BOUNCE_FAC_BOUNDS.min, BOUNCE_FAC_BOUNDS.max)

func add_module_if_exists():
	if not data.has('module'): return
	
	var m = load("res://scenes/powerup_modules/" + type + ".tscn").instance()
	m.body = body
	cur_module = m
	add_child(m)
	
	print("ADDING MODULE")
	print(type)
	
	if data.has('button'):
		input.connect("button_press", m, "_on_Input_button_press")
		input.connect("button_release", m, "_on_Input_button_release")
		
		print("CONNECTING BUTTONS")

func remove_module_if_exists():
	if not cur_module: return
	
	cur_module.queue_free()

func show_icon():
	if not data.has('persistent'): return
