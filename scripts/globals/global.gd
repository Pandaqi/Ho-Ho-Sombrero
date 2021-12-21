extends Node

var scenes = {
	'game': preload("res://Main.tscn")
}

var mode : String = "menu"
var arena : String = "forest"

func get_current_arena():
	if in_menu(): return "menu"
	else: return arena

func goto_menu():
	mode = "menu"
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scenes.game)
	GAudio.change_bg_stream("menu")

func goto_game(arena_key : String):
	arena = arena_key
	mode = "game"
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scenes.game)
	GAudio.change_bg_stream(arena_key)

func in_game():
	return (mode == "game")

func in_menu():
	return (mode == "menu")
