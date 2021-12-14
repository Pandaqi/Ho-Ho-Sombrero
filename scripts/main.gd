extends Spatial

onready var state = $State

func _init():
	if GInput.get_player_count() <= 0:
		GInput.create_debugging_players()

func _ready():
	state.activate()
