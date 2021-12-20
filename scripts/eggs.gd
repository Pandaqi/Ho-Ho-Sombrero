extends Node

var NUM_EGG_BOUNDS

const EGG_CHECK_INTERVAL : float = 5.0
const NUM_TYPES_BOUNDS = { 'min': 3, 'max': 6 }
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
	available_types = []
	
	while available_types.size() < num_types and all_types.size() > 0:
		var new_type = all_types[0]
		if GDict.eggs[new_type].has('id'):
			var my_id = GDict.eggs[new_type].id
			var eggs_with_id = get_all_eggs_with_id(my_id)
			
			# this would shoot us over the limit? don't add anything and try something else
			if (available_types.size() + eggs_with_id.size()) >= num_types:
				all_types.pop_front()
				continue
			
			for egg in eggs_with_id:
				available_types.append(egg)
				all_types.erase(egg)
		else:
			available_types.append(new_type)
		
		all_types.erase(new_type)
	
	GUI.display_egg_tutorials(available_types)

func get_all_eggs_with_id(id : String):
	var arr = []
	for egg in GDict.eggs:
		var data = GDict.eggs[egg]
		if not data.has('id'): continue
		if data.id != id: continue
		arr.append(egg)
	return arr

func on_egg_delivered(node):
	active_eggs.erase(node)
	check_new_eggs()

func on_egg_broken(node):
	active_eggs.erase(node)
	check_new_eggs()

func check_new_eggs(only_essential = true):
	var num_eggs = count_total_eggs()
	var num_players = get_tree().get_nodes_in_group("Players").size()
	var solo_mode = (GInput.get_player_count() == 1)
	
	if only_essential and num_eggs > NUM_EGG_BOUNDS.min: return
	if num_eggs >= NUM_EGG_BOUNDS.max: return
	
	if not only_essential:
		var rand_max = NUM_EGG_BOUNDS.min + randi() % (NUM_EGG_BOUNDS.max + 1 - NUM_EGG_BOUNDS.min)
		
		# we're allowed to overshoot the number of players, but only with a low probability
		if rand_max > num_players:
			if solo_mode and randf() <= 0.75:
				rand_max = num_players
			elif (not solo_mode) and randf() <= 0.35:
				rand_max = num_players
		
		if num_eggs >= rand_max: return

	cannons.create_new_egg(available_types)

func count_total_eggs():
	return active_eggs.size() + cannons.get_eggs_planned()

func on_egg_created(node):
	active_eggs.append(node)

func _on_Timer_timeout():
	check_new_eggs(false)
