extends Spatial

onready var state = $State
onready var eggs = $Eggs
onready var cannons = $Cannons
onready var players = $Players

var map
var arenas = {
	'menu': preload("res://scenes/arenas/menu.tscn"),
	'training': preload("res://scenes/arenas/menu.tscn"), # TO DO: actual scene
	'forest': preload("res://scenes/arenas/menu.tscn"), # TO DO: actual scene
}

func _init():
	randomize()
	if GInput.get_player_count() <= 0:
		GInput.create_debugging_players()
	
	load_arena()

func _ready():
	# NOTE: must come before any stuff _in_ the map
	map.activate()
	
	if G.in_menu():
		players.activate()
	
	else:
		state.activate()
		cannons.activate() # NOTE: must come before eggs
		eggs.activate()
		players.activate()

func load_arena():
	var type = G.get_current_arena()
	
	GDict.create_temporary_config_for_arena(type)
	
	map = arenas[type].instance()
	map.name = "Map"
	add_child(map)
