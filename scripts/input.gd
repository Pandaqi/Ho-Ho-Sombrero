extends Node

onready var main_node = get_node("/root/Main")
onready var players = get_node("/root/Main/Players")

func _unhandled_input(ev):
	check_device_status(ev)

func check_device_status(ev):
	var res = GInput.check_new_player(ev)
	if not res.failed:
		var p = players.create_menu_player(GInput.get_player_count() - 1)
		main_node.on_player_logged_in(p)
	
	# TO DO: also add option for REMOVING player/LOGGING out
