extends CanvasLayer

onready var players = get_node("../Players")
onready var pause_menu = get_node("../PauseMenu")
var player_bodies : Array

var input_enabled : bool = false
var tutorial_active : bool = false
onready var tutorial_container = $Control

func activate():
	var num_players = GInput.get_player_count()
	if num_players != 1: 
		self_destruct()
		return
	if not G.in_game(): 
		self_destruct()
		return
	if not GDict.cfg.solo_mode_two_sombreros: 
		self_destruct()
		return
	
	pause_menu.disable()
	player_bodies = get_tree().get_nodes_in_group("Players")
	initialize_solo_mode()

func self_destruct():
	pause_menu.enable()
	self.queue_free()

func initialize_solo_mode():
	players.place_player(1, true)
	
	if G.get_current_arena() == "training": 
		show_tutorial()
	else:
		hide_tutorial()

func show_tutorial():
	get_tree().paused = true
	
	tutorial_active = true
	tutorial_container.set_visible(true)

func hide_tutorial():
	tutorial_active = false
	tutorial_container.set_visible(false)
	
	get_tree().paused = false

func _input(ev):
	if not input_enabled: return
	if tutorial_active:
		if (ev is InputEventKey) or (ev is InputEventJoypadButton):
			hide_tutorial()
			GAudio.play_static_sound("button")
			get_tree().set_input_as_handled()
		return
	
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

func _on_Timer_timeout():
	input_enabled = true
