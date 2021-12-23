extends Node

var scenes = {
	'game': preload("res://Main.tscn")
}

var mode : String = "menu"
var arena : String = "forest"
var last_played_arena : String = ""

func get_current_arena():
	if in_menu(): return "menu"
	else: return arena

func get_last_played_arena():
	if last_played_arena == "": return null
	return last_played_arena

func goto_menu():
	mode = "menu"
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scenes.game)
	GAudio.change_bg_stream("menu")

func goto_game(arena_key : String):
	arena = arena_key
	last_played_arena = arena_key
	mode = "game"
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scenes.game)
	GAudio.change_bg_stream(arena_key)

func in_game():
	return (mode == "game")

func in_menu():
	return (mode == "menu")
