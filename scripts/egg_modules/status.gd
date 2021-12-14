extends Node

onready var visuals = get_node("../Visuals")
onready var bouncer = get_node("../Bouncer")

var delivered : bool = false

func set_delivered():
	delivered = true
	
	bouncer.set_delivered()
	visuals.set_delivered()
