extends Spatial

onready var state = $State
onready var eggs = $Eggs

func _init():
	randomize()
	if GInput.get_player_count() <= 0:
		GInput.create_debugging_players()

func _ready():
	state.activate()
	eggs.activate()
