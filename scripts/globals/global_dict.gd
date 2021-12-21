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
	},
	
	"desert": {
		"eggs_allowed": ["regular", "jump", "attract", "repel", "extra_bouncy", "less_bouncy", "global_gravity_plus", "global_gravity_min", "levitate", "racket"],
		"frame": 2,
		"light_energy": 0.54
	},
	
	"north_pole": {
		"eggs_allowed": ["regular", "earthquake", "freeze", "icy_movement", "global_egg_faster", "global_egg_slower", "frisbee", "size_grow", "size_shrink", "point_bonus", "point_worthless"],
		"frame": 3,
		"outline_growth": Vector3(10,0,10)
	},
	
	"christmas_city": {
		"frame": 4
	},
	
	"cuddly_clouds": {
		"frame": 5
	},
	
	"easter_island": {
		"frame": 6
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
	"regular": { "frame": 0, "col": "red", "no_powerup": true, "fb": "" },
	"earthquake": { "frame": 1, "persistent": true, "col": "green", "fb": "Angled sombrero" }, # slanted sombrero
	"jump": { "frame": 2, "button": true, "module": true, "persistent": true, "col": "blue", "fb": "Jump", "fb_use": "Jump!" },
	"dash": { "frame": 3, "button": true, "module": true, "persistent": true, "col": "red", "fb": "Dash", "fb_use": "Dash!" },
	"attract": { "frame": 4, "button": true, "module": true, "persistent": true, "col": "lightblue", "id": "a", "radius": true, "fb": "Attract", "fb_use": "Attract!" },
	"repel": { "frame": 5, "button": true, "module": true, "persistent": true, "col": "lightblue", "id": "a", "radius": true, "fb": "Repel", "fb_use": "Repel!" },
	"freeze": { "frame": 6, "button": true, "module": true, "persistent": true, "col": "purple", "radius": true, "fb": "Freeze", "fb_use": "Freeze!" },
	"move_faster": { "frame": 7, "col": "red", "id": "m", "fb": "+Speed" },
	"move_slower": { "frame": 8, "col": "red", "id": "m", "fb": "-Speed" },
	"extra_bouncy": { "frame": 9, "col": "green", "id": "b", "fb": "+Bounce" },
	"less_bouncy": { "frame": 10, "col": "green", "id": "b", "fb": "-Bounce" },
	"icy_movement": { "frame": 11, "persistent": true, "col": "lightblue", "fb": "Skating on ice" },
	"global_gravity_plus": { "frame": 12, "col": "blue", "id": "g", "fb": "+Gravity" },
	"global_gravity_min": { "frame": 13, "col": "blue", "id": "g", "fb": "-Gravity" },
	"global_egg_faster": { "frame": 14, "col": "red", "id": "f", "fb": "+Egg Speed" },
	"global_egg_slower": { "frame": 15, "col": "red", "id": "f", "fb": "-Egg Speed" },
	"frisbee": { "frame": 16, "button": true, "persistent": true, "col": "blue", "fb": "Frisbee sombrero", "fb_use": "Throw!" },
	"racket": { "frame": 17, "persistent": true, "col": "green", "fb": "Racket sombrero" },
	"levitate": { "frame": 18, "button": true, "module": true, "persistent": true, "col": "purple", "radius": true, "fb": "Airfloat", "fb_use": "Fly!" },
	"size_grow": { "frame": 19, "col": "yellow", "id": "s", "fb": "+Egg Size" },
	"size_shrink": { "frame": 20, "col": "yellow", "id": "s", "fb": "-Egg Size" },
	"point_bonus": { "frame": 21, "col": "red", "id": "p", "no_powerup": true },
	"point_worthless": { "frame": 22, "col": "red", "id": "p", "no_powerup": true },
	"global_double_points": { "frame": 23, "col": "red", "id": "d", "fb": "Points x2" },
	"global_half_points": { "frame": 24, "col": "red", "id": "d", "fb": "Points /2" },
	"toucher": { "frame": 25, "col": "red", "no_powerup": true },
	"bomb": { "frame": 26, "col": "purple", "no_powerup": true }
}

func create_temporary_config_for_arena(arena : String):
	var data = arenas[arena]
	for key in base_cfg:
		var val = base_cfg[key]
		if data.has(key): val = data[key]
		cfg[key] = val
	
	print(cfg)
