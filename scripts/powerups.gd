extends Spatial

const DEF_GRAVITY = 9.8/10

var point_factor : float = 1.0
var egg_speed_modifier : float = 1.0

var powerup_scene = preload("res://scenes/single_powerup.tscn")

func on_egg_broken(entity):
	spawn_powerup(entity.transform.origin, entity.visuals.type)

func spawn_powerup(pos : Vector3, type : String):
	var p = powerup_scene.instance()
	p.set_translation(pos)
	p.set_type(type)
	add_child(p)

func change_global_gravity(factor : float):
	var val = DEF_GRAVITY * factor
	
	PhysicsServer.area_set_param(get_world().get_space(), PhysicsServer.AREA_PARAM_GRAVITY, val)

func modify_egg_speed(factor : float):
	egg_speed_modifier = clamp(egg_speed_modifier*factor, 0.3, 1.8)

func get_egg_speed_modifier():
	return egg_speed_modifier

func modify_point_factor(new_factor : float):
	point_factor = new_factor

func get_point_factor():
	return point_factor
