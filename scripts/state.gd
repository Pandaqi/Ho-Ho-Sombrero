extends Node

var eggs_broken : int = 0
var eggs_delivered : int = 0

var target_delivered : int = 10
var target_broken : int = 20

var start_time : float = 0.0

var in_game_over : bool = false

onready var gui = get_node("../GUI")
onready var game_over = get_node("../GameOver")
onready var pause_menu = get_node("../PauseMenu")
onready var powerups = get_node("../Powerups")
onready var eggs = get_node("../Eggs")

func activate():
	gui.update_broken(0, target_broken)
	gui.update_delivered(0, target_delivered)
	
	start_time = OS.get_ticks_msec()

func on_egg_broken(node):
	eggs_broken += 1
	gui.update_broken(eggs_broken, target_broken)
	eggs.on_egg_broken(node)
	
	check_game_over()

func on_egg_delivered(node, points : int = 0):
	var final_points = points * powerups.get_point_factor() * node.get_point_factor()
	eggs_delivered += int(ceil(final_points))
	gui.update_delivered(eggs_delivered, target_delivered)
	eggs.on_egg_delivered(node)
	
	check_game_over()

func check_game_over():
	if eggs_delivered >= target_delivered: 
		game_over(true)
		return
	
	if GDict.cfg.lose_game_by_broken_eggs:
		if eggs_broken >= target_broken: 
			game_over(false)
			return

func game_over(we_won):
	print("GAME OVER!")
	print("We won?")
	print(we_won)
	
	in_game_over = true
	get_tree().paused = true
	
	pause_menu.disable()
	
	var time_elapsed = (OS.get_ticks_msec() - start_time)/1000.0
	game_over.show(time_elapsed)

func _input(ev):
	if not in_game_over: return
	
	if ev.is_action_released("restart"):
		restart()
	
	elif ev.is_action_released("back"):
		back_to_menu()

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func back_to_menu():
	get_tree().paused = false
	G.goto_menu()
