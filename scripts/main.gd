extends Spatial

onready var state = $State
onready var eggs = $Eggs
onready var cannons = $Cannons
onready var players = $Players
onready var solo_mode = $SoloMode
onready var settings = $TechnicalSettings
onready var powerups = $Powerups
onready var feedback = $Feedback
onready var cam = $Camera

var map
var arena_key : String
var arenas = {
	'menu': preload("res://scenes/arenas/menu.tscn"),
	'training': preload("res://scenes/arenas/training.tscn"),
	'forest': preload("res://scenes/arenas/forest.tscn"),
	'desert': preload("res://scenes/arenas/desert.tscn"),
	'north_pole': preload("res://scenes/arenas/north_pole.tscn"),
	"cuddly_clouds": preload("res://scenes/arenas/cuddly_clouds.tscn")
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
	
	finish_loading_arena()

func load_arena():
	var type = G.get_current_arena()
	arena_key = type
	GDict.create_temporary_config_for_arena(type)
	
	map = arenas[type].instance()
	map.name = "Map"
	
	add_child(map)

func finish_loading_arena():
	var data = GDict.arenas[arena_key]
	if data.has('light_strength'):
		$DirectionalLight.light_energy = data.light_strength
	
	if data.has('custom_light'):
		$DirectionalLight.queue_free()
	
	if map.has_node("WorldEnvironment"):
		cam.environment = map.get_node("WorldEnvironment")

func on_player_logged_in(node):
	GAudio.play_static_sound("button")
	feedback.create_for(node, "Welcome!")
