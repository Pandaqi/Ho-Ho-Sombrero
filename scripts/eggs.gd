extends Node

var NUM_EGG_BOUNDS

const EGG_CHECK_INTERVAL : float = 5.0
const NUM_TYPES_BOUNDS = { 'min': 2, 'max': 6 }
var available_types : Array = []
var active_eggs : Array = []

onready var GUI = get_node("../GUI")
onready var cannons = get_node("../Cannons")

onready var timer : Timer = $Timer

var arena_data

func activate():
	var num_players = GInput.get_player_count()
	NUM_EGG_BOUNDS = { 
		'min': max(num_players-1, 1),
		'max': num_players+1
	}
	
	arena_data = GDict.arenas[G.get_current_arena()]
	determine_available_types()
	
	check_new_eggs()
	timer.wait_time = EGG_CHECK_INTERVAL
	timer.start()

func determine_available_types():
	var all_types = GDict.eggs.keys()
	if arena_data.has('eggs_allowed'):
		all_types = arena_data.eggs_allowed + []
	
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
		var rand_max = NUM_EGG_BOUNDS.min + randi() % (NUM_EGG_BOUNDS.max + 1 - NUM_EGG_BOUNDS.min)
		
		print("RAND EGG MAX")
		print(rand_max)
		
		if active_eggs.size() >= rand_max: return

	cannons.create_new_egg(available_types)

func on_egg_created(node):
	active_eggs.append(node)

func _on_Timer_timeout():
	check_new_eggs(false)
