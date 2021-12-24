extends Node

var player_scene = preload("res://scenes/player.tscn")
onready var map = get_node("../Map")

var player_bodies : Array = []
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
	
	# just update this array every time to be sure
	player_bodies = get_tree().get_nodes_in_group("Players")
	
	return p

func create_menu_player(p_num : int):
	var p = place_player(p_num)
	
	var t = tutorial_module.instance()
	p.get_node("Player").add_child(t)
	
	return p

func _input(ev):
	var solo_mode = GInput.get_player_count() == 1
	if not solo_mode: return
	if ev.is_action_released("switch"):
		switch_between_players()
		GAudio.play_static_sound("player_switch")

func switch_between_players():
	var cur_active = player_bodies[0]
	var new_active = player_bodies[1]
	
	if player_bodies[0].input.is_disabled(): 
		cur_active = player_bodies[1]
		new_active = player_bodies[0]
	
	cur_active.input.switch_off()
	new_active.input.switch_on()
	
	print("SWITCHING")
	print(cur_active.status.player_num)
	print(new_active.status.player_num)
