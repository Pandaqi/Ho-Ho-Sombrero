extends Node

onready var body = get_parent()
var player_num : int = -1

func set_player_num(p_num : int):
	player_num = p_num
	body.input.set_player_num(p_num)
	body.sombrero.visuals.set_player_num(p_num)
