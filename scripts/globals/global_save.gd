extends Node

var save_data

var arena_order = ["training", "forest", "desert", "north_pole", "cuddly_clouds"]
var default_save_data = {
	'unlocked': {
		'training': true
	}
}

func _ready():
	load_game()

#
# Taking care of saving/loading games
# Save file is at: %APPDATA%\Godot\app_userdata\<game name>\
#
func save_level_completion():
	print("SAVING LEVEL COMPLETION")
	print(G.get_current_arena())
	
	var cur_world_index = arena_order.find(G.get_current_arena())
	var next_world_index = (cur_world_index + 1)
	
	print(cur_world_index)
	if next_world_index >= arena_order.size(): return
	
	var next_world = arena_order[next_world_index]
	save_data.unlocked[next_world] = true
	save_game()
	
	print(save_data)

func get_unlocked_worlds():
	var arr = []
	for key in save_data.unlocked:
		if save_data.unlocked[key]:
			arr.append(key)
	return arr

func save_game(empty = false):
	var save_game = File.new()
	save_game.open(get_save_path(), File.WRITE)

	if empty: save_data = default_save_data

	save_game.store_line(to_json(save_data))
	save_game.close()

func get_save_path():
	return "user://savegame.save"

func load_game():
	var save_game = File.new()
	
	# if file doesn't exist, create it now, with empty content
	if not save_game.file_exists(get_save_path()):
		save_game(true)

	# otherwise, set the save_data variable immediately to the known value
	save_game.open(get_save_path(), File.READ)
	save_data = parse_json(save_game.get_line())
	save_game.close()
	
	# some failsafes, in case there are different save file versions floating around (or something else goes wrong
	if not save_data or not save_data.has("unlocked"):
		save_data = default_save_data
		save_game(true)
