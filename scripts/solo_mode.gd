extends CanvasLayer

onready var players = get_node("../Players")
onready var pause_menu = get_node("../PauseMenu")

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
	initialize_solo_mode()

func self_destruct():
	pause_menu.enable()
	self.queue_free()

func initialize_solo_mode():
	players.place_player(1, true)
	
	if G.get_current_arena() != "training": 
		self_destruct()
		return
	
	show_tutorial()

func show_tutorial():
	get_tree().paused = true
	
	tutorial_active = true
	tutorial_container.set_visible(true)

func hide_tutorial():
	tutorial_active = false
	tutorial_container.set_visible(false)
	
	get_tree().paused = false
	self_destruct()

func _input(ev):
	if not input_enabled: return
	if not tutorial_active: return
	
	if (ev is InputEventKey) or (ev is InputEventJoypadButton):
		if not ev.pressed:
			get_tree().set_input_as_handled()
			hide_tutorial()
			GAudio.play_static_sound("button")

func _on_Timer_timeout():
	input_enabled = true
