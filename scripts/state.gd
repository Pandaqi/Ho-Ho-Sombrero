extends Node

var eggs_broken : int = 0
var eggs_delivered : int = 0

var target_delivered : int = 10
var target_broken : int = 20

onready var gui = get_node("../GUI")

func activate():
	gui.update_broken(0, target_broken)
	gui.update_delivered(0, target_delivered)

func on_egg_broken(node):
	eggs_broken += 1
	gui.update_broken(eggs_broken, target_broken)
	
	check_game_over()

func on_egg_delivered(node):
	eggs_delivered += 1
	gui.update_delivered(eggs_delivered, target_delivered)
	
	check_game_over()

func check_game_over():
	if eggs_delivered >= target_delivered: game_over(true)
	elif eggs_broken >= target_broken: game_over(false)

func game_over(we_won):
	print("GAME OVER!")
	print("We won?")
	print(we_won)
	pass
