extends Node

var broken_egg_scene = preload("res://scenes/egg_broken.tscn")
var bomb_scene = preload("res://scenes/egg_modules/powerup_bomb.tscn")

onready var body = get_parent()
onready var main_node = get_node("/root/Main")
onready var map = get_node("/root/Main/Map")

onready var state = get_node("/root/Main/State")
onready var powerups = get_node("/root/Main/Powerups")

onready var status = get_node("../Status")
onready var feedback = get_node("/root/Main/Feedback")

var epsilon = 0.05

func _integrate_forces(state):
	if status.delivered: return
	
	var break_limit = GDict.cfg.num_bounces_before_break
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		if not obj.is_in_group("Breakers"): continue
		
		var normal = state.get_contact_local_normal(i)
		if normal.y < (0 + epsilon): continue
		
		if break_limit > 1 and body.bouncer.num_bounces_on_ground < break_limit: continue
		
		destroy_myself()
		break

func destroy_myself():
	var e = broken_egg_scene.instance()
	e.transform = body.transform
	e.set_type(body.visuals.type)
	
	map.outline.paint(body)
	
	if body.visuals.type == "bomb": place_bomb()
	
	var break_fbs = ["Oh no!", "Lost", "Too bad", "Wow", "No way!", "Why?!", "So young ..."]
	feedback.create_for(body, break_fbs[randi() % break_fbs.size()])
	GAudio.play_dynamic_sound(body, "crack")
	
	body.queue_free()
	main_node.add_child(e)
	powerups.on_egg_broken(body)
	state.on_egg_broken(body)
	
	body.emit_signal("on_death")

func place_bomb():
	var b = bomb_scene.instance()
	b.set_translation(body.transform.origin)
	map.add_child(b)
