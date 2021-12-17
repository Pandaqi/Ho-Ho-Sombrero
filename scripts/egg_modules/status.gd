extends Node

onready var state = get_node("/root/Main/State")

onready var body = get_parent()
onready var visuals = get_node("../Visuals")
onready var bouncer = get_node("../Bouncer")

var delivered : bool = false

func set_delivered():
	delivered = true
	
	bouncer.set_delivered()
	visuals.set_delivered()
	
	if body.auto_deliver: 
		body.auto_deliver.on_death()
	
	state.on_egg_delivered(body)
