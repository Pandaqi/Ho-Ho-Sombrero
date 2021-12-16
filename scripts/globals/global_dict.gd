extends Node

var base_cfg = {
	"lose_game_by_broken_eggs": false,
	"level_wrapping": false,
	"auto_deliver_eggs": false,
	"broken_eggs_spawn_powerups": true,
}

var cfg = {
	
}

var arenas = {
	"menu": {
		
	},
	
	"training": {
		"tutorial": ["solo_mode"],
		"auto_deliver_eggs": true,
		"broken_eggs_spawn_powerups": false,
		"eggs_allowed": ["regular"]
	},
	
	"forest": {
		"eggs_allowed": ["regular", "jump", "dash", "move_faster", "move_slower"]
	}
}

var eggs = {
	"regular": { "frame": 0 },
	"earthquake": { "frame": 1, "persistent": true }, # slanted sombrero
	"jump": { "frame": 2, "button": true, "module": true, "persistent": true },
	"dash": { "frame": 3, "button": true, "module": true, "persistent": true },
	"attract": { "frame": 4, "button": true, "module": true, "persistent": true },
	"repel": { "frame": 5, "button": true, "module": true, "persistent": true },
	"freeze": { "frame": 6, "button": true, "module": true, "persistent": true },
	"move_faster": { "frame": 7 },
	"move_slower": { "frame": 8 },
	"extra_bouncy": { "frame": 9 },
	"less_bouncy": { "frame": 10 },
	"icy_movement": { "frame": 11, "persistent": true },
	"global_gravity_plus": { "frame": 12 },
	"global_gravity_min": { "frame": 13 },
	"global_egg_faster": { "frame": 14 },
	"global_egg_slower": { "frame": 15 },
	"frisbee": { "frame": 16, "button": true, "persistent": true },
	"racket": { "frame": 17, "persistent": true }
}

func create_temporary_config_for_arena(arena : String):
	var data = arenas[arena]
	for key in base_cfg:
		var val = base_cfg[key]
		if data.has('key'): val = data[key]
		cfg[key] = val
