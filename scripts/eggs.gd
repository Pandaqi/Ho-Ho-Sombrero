extends Node

var NUM_EGG_BOUNDS

const EGG_CHECK_INTERVAL : float = 10.0
const NUM_TYPES_BOUNDS = { 'min': 2, 'max': 6 }
var available_types : Array = []
var active_eggs : Array = []

onready var GUI = get_node("../GUI")
onready var cannons = get_node("../Cannons")

onready var timer : Timer = $Timer

func activate():
	NUM_EGG_BOUNDS = { 
		'min': max(GInput.get_player_count()-1, 1),
		'max': GInput.get_player_count()+1
	}
	determine_available_types()
	
	check_new_eggs()
	timer.wait_time = EGG_CHECK_INTERVAL
	timer.start()

func determine_available_types():
	var all_types = GDict.eggs.keys()
	all_types.shuffle()
	
	var num_types = floor(rand_range(NUM_TYPES_BOUNDS.min, NUM_TYPES_BOUNDS.max))
	available_types = all_types.slice(0, num_types)
	
	GUI.display_egg_tutorials(available_types)

func on_egg_delivered(node):
	active_eggs.erase(node)
	check_new_eggs()

func on_egg_broken(node):
	active_eggs.erase(node)
	check_new_eggs()

func check_new_eggs(only_essential = true):
	if only_essential and active_eggs.size() > NUM_EGG_BOUNDS.min: return
	if active_eggs.size() >= NUM_EGG_BOUNDS.max: return
	
	if not only_essential:
		var rand_max = NUM_EGG_BOUNDS.min + randi() % (NUM_EGG_BOUNDS.max - NUM_EGG_BOUNDS.min)
		if active_eggs.size() >= rand_max: return
	
	cannons.create_new_egg(available_types)

func on_egg_created(node):
	active_eggs.append(node)

func _on_Timer_timeout():
	check_new_eggs(false)
