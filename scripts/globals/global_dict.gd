extends Node

var cfg = {
	"lose_game_by_broken_eggs": false,
	"level_wrapping": true,
}

var eggs = {
	"regular": { "frame": 0 },
	"??": { "frame": 1 },
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
	"global_egg_slower": { "frame": 15 }
}
