extends Node

var cannons : Array = []

func activate():
	cannons = get_tree().get_nodes_in_group("EggCannons")

func create_new_egg(options):
	# DEBUGGING
	options = ['frisbee']
	
	var type = options[randi() % options.size()]
	
	var rand_cannon = null
	cannons.shuffle()
	for i in range(cannons.size()):
		rand_cannon = cannons[i]
		if rand_cannon.is_busy(): continue
		break
	
	var no_option_available = not rand_cannon
	if no_option_available: return
	
	rand_cannon.plan_shoot_egg(type)
