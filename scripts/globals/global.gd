extends Node

var scenes = {
	'menu': preload("res://Menu.tscn"),
	'game': preload("res://Main.tscn")
}

func goto_menu():
	get_tree().change_scene_to(scenes.menu)

func goto_game():
	get_tree().change_scene_to(scenes.game)
