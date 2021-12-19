extends Node

var base_cfg = {
	"lose_game_by_broken_eggs": false,
	"level_wrapping": false,
	"auto_deliver_eggs": false,
	"broken_eggs_spawn_powerups": true,
	"solo_mode_two_sombreros": true,
	"delivery_points_attract_eggs": true,
	"fixed_egg_shape": "egg",
}

var cfg = {
	
}

var arenas = {
	"menu": {
		"frame": -1
	},
	
	"training": {
		"tutorial": ["solo_mode"],
		"auto_deliver_eggs": true,
		"broken_eggs_spawn_powerups": false,
		"eggs_allowed": ["regular"],
		"frame": 0
	},
	
	"forest": {
		"eggs_allowed": ["regular", "jump", "dash", "move_faster", "move_slower"],
		"frame": 1
	}
}

#var colors = {
#	"green": Color(123/255.0, 1.0, 47/255.0),
#	"red": Color(1.0, 163/255.0, 125/255.0),
#	"blue": Color(47/255.0, 129/255.0, 1.0),
#	"lightblue": Color(152/255.0, 239/255.0, 1.0)
#}

var colors = {
	"green": Color(0.0, 1.0, 0.0),
	"red": Color(1.0, 0.0, 0.0),
	"blue": Color(0, 0, 1.0),
	"lightblue": Color(0.0, 1.0, 1.0),
	"purple": Color(1.0, 0.0, 1.0),
	"yellow": Color(1.0, 1.0, 0.0),
}

var eggs = {
	"regular": { "frame": 0, "col": "red", "no_powerup": true },
	"earthquake": { "frame": 1, "persistent": true, "col": "green" }, # slanted sombrero
	"jump": { "frame": 2, "button": true, "module": true, "persistent": true, "col": "blue" },
	"dash": { "frame": 3, "button": true, "module": true, "persistent": true, "col": "red" },
	"attract": { "frame": 4, "button": true, "module": true, "persistent": true, "col": "lightblue", "id": "a", "radius": true },
	"repel": { "frame": 5, "button": true, "module": true, "persistent": true, "col": "lightblue", "id": "a", "radius": true },
	"freeze": { "frame": 6, "button": true, "module": true, "persistent": true, "col": "purple", "radius": true },
	"move_faster": { "frame": 7, "col": "red", "id": "m" },
	"move_slower": { "frame": 8, "col": "red", "id": "m" },
	"extra_bouncy": { "frame": 9, "col": "green", "id": "b" },
	"less_bouncy": { "frame": 10, "col": "green", "id": "b" },
	"icy_movement": { "frame": 11, "persistent": true, "col": "lightblue" },
	"global_gravity_plus": { "frame": 12, "col": "blue", "id": "g" },
	"global_gravity_min": { "frame": 13, "col": "blue", "id": "g" },
	"global_egg_faster": { "frame": 14, "col": "red", "id": "f" },
	"global_egg_slower": { "frame": 15, "col": "red", "id": "f" },
	"frisbee": { "frame": 16, "button": true, "persistent": true, "col": "blue" },
	"racket": { "frame": 17, "persistent": true, "col": "green" },
	"levitate": { "frame": 18, "button": true, "module": true, "persistent": true, "col": "purple", "radius": true },
	"size_grow": { "frame": 19, "col": "yellow", "id": "s" },
	"size_shrink": { "frame": 20, "col": "yellow", "id": "s" },
	"point_bonus": { "frame": 21, "col": "red", "id": "p" },
	"point_worthless": { "frame": 22, "col": "red", "id": "p" },
	"global_double_points": { "frame": 23, "col": "red", "id": "d" },
	"global_half_points": { "frame": 24, "col": "red", "id": "d" },
	"toucher": { "frame": 25, "col": "red" },
	"bomb": { "frame": 26, "col": "purple" }
}

func create_temporary_config_for_arena(arena : String):
	var data = arenas[arena]
	for key in base_cfg:
		var val = base_cfg[key]
		if data.has(key): val = data[key]
		cfg[key] = val
	
	print(cfg)
