extends Spatial

func _init():
	if GInput.get_player_count() <= 0:
		GInput.create_debugging_players()
