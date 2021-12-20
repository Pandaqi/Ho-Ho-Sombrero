extends Node

var player_scene = preload("res://scenes/player.tscn")
onready var map = get_node("../Map")

var tutorial_module = preload("res://scenes/player_modules/tutorial.tscn")
var num_players

func activate():
	place_players()

func place_players():
	num_players = GInput.get_player_count()
	for i in range(num_players):
		place_player(i)

func place_player(p_num : int, custom : bool = false):
	var p = player_scene.instance()
	var player_rigidbody = p.get_node("Player")
	var player_sombrero = p.get_node("Sombrero")
	
	# IMPORTANT: we set the position of the _rigid body_ inside this scene,
	# 			 not the whole scene, as that would misalign physics
	player_rigidbody.set_translation(map.get_start_pos(p_num))
	player_sombrero.set_translation(player_rigidbody.transform.origin + Vector3.UP)
	
	map.add_child(p)
	player_rigidbody.status.set_player_num(p_num)
	
	if custom: player_rigidbody.status.make_custom()
	
	return p

func create_menu_player(p_num : int):
	var p = place_player(p_num)
	
	var t = tutorial_module.instance()
	p.get_node("Player").add_child(t)
	
	return p
