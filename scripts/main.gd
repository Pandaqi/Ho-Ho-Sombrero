extends Spatial

onready var state = $State
onready var eggs = $Eggs
onready var cannons = $Cannons
onready var players = $Players
onready var solo_mode = $SoloMode
onready var settings = $TechnicalSettings
onready var powerups = $Powerups

var map
var arenas = {
	'menu': preload("res://scenes/arenas/menu.tscn"),
	'training': preload("res://scenes/arenas/training.tscn"),
	'forest': preload("res://scenes/arenas/forest.tscn"),
	'desert': preload("res://scenes/arenas/desert.tscn")
}

func _init():
	randomize()
	
	if G.in_game() and GInput.get_player_count() <= 0:
		GInput.create_debugging_players()
	
	load_arena()

func _ready():
	# NOTE: must come before any stuff _in_ the map
	map.activate()
	
	if G.in_menu():
		players.activate()
		settings.activate()
	
	else:
		state.activate()
		cannons.activate() # NOTE: must come before eggs
		eggs.activate()
		players.activate()
		powerups.activate()
		settings.queue_free()
	
	solo_mode.activate()

func load_arena():
	var type = G.get_current_arena()
	
	GDict.create_temporary_config_for_arena(type)
	
	var data = GDict.arenas[type]
	if data.has('light_strength'):
		$DirectionalLight.light_energy = data.light_strength
	
	map = arenas[type].instance()
	map.name = "Map"
	add_child(map)

func on_player_logged_in():
	pass
