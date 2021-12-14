extends Spatial

func _init():
	if GlobalInput.get_player_count() <= 0:
		GlobalInput.create_debugging_players()
