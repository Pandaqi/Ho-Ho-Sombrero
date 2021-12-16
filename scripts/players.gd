extends Node

var player_scene = preload("res://scenes/player.tscn")
onready var map = get_node("../Map")

func activate():
	place_players()

func place_players():
	for i in range(GInput.get_player_count()):
		place_player(i)

func place_player(p_num : int):
	var p = player_scene.instance()
	var player_rigidbody = p.get_node("Player")
	
	# IMPORTANT: we set the position of the _rigid body_ inside this scene,
	# 			 not the whole scene, as that would misalign physics
	player_rigidbody.set_translation(map.get_start_pos(p_num))
	
	map.add_child(p)
	player_rigidbody.status.set_player_num(p_num)
