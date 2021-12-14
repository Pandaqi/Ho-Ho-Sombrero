extends Node

var broken_egg_scene = preload("res://scenes/egg_broken.tscn")

onready var body = get_parent()
onready var main_node = get_node("/root/Main")

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		if not obj.is_in_group("Breakers"): continue
		
		destroy_myself()
		break

# TO DO: inform some counter or something
func destroy_myself():
	var e = broken_egg_scene.instance()
	e.transform = body.transform
	e.set_type(body.visuals.type)
	
	body.queue_free()
	main_node.add_child(e)
