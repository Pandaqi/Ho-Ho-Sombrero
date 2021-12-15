extends Spatial

onready var state = $State
onready var eggs = $Eggs
onready var cannons = $Cannons

func _init():
	randomize()
	if GInput.get_player_count() <= 0:
		GInput.create_debugging_players()

func _ready():
	state.activate()
	cannons.activate() # NOTE: must come before eggs
	eggs.activate()
