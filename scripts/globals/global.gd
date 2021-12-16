extends Node

var scenes = {
	'game': preload("res://Main.tscn")
}

var mode : String = "game"
var arena : String = "forest"

func get_current_arena():
	if in_menu(): return "menu"
	else: return arena

func goto_menu():
	mode = "menu"
	get_tree().change_scene_to(scenes.game)

func goto_game(arena_key : String):
	arena = arena_key
	mode = "game"
	get_tree().change_scene_to(scenes.game)

func in_game():
	return (mode == "game")

func in_menu():
	return (mode == "menu")
