extends Node

const NUM_TYPES_BOUNDS = { 'min': 3, 'max': 6 }
var available_types = []

onready var GUI = get_node("../GUI")

func activate():
	determine_available_types()

func determine_available_types():
	var all_types = GDict.eggs.keys()
	all_types.shuffle()
	
	var num_types = floor(rand_range(NUM_TYPES_BOUNDS.min, NUM_TYPES_BOUNDS.max+1))
	available_types = all_types.slice(0, num_types)
	
	GUI.display_egg_tutorials(available_types)
