extends Node

onready var eggs = get_node("../Eggs")
var cannons : Array = []

func activate():
	cannons = get_tree().get_nodes_in_group("EggCannons")

func create_new_egg(options):
	var type = options[randi() % options.size()]

	var rand_cannon = null
	cannons.shuffle()
	for i in range(cannons.size()):
		rand_cannon = cannons[i]
		if rand_cannon.get_node("EggShooter").is_busy(): 
			rand_cannon = null
			continue
		break
	
	var no_option_available = not rand_cannon
	if no_option_available: 
		eggs.enable_quick_checks()
		return
	
	rand_cannon.get_node("EggShooter").plan_shoot_egg(type)
	eggs.disable_quick_checks()

func get_eggs_planned():
	var sum = 0
	for c in cannons:
		if c.get_node("EggShooter").has_egg_planned(): sum += 1
	return sum
