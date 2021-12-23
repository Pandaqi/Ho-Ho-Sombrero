extends Spatial

var cur_gravity_multiplier : float = 1.0

var point_factor : float = 1.0
var egg_speed_modifier : float = 1.0
var cur_egg_shape = 'egg'

var powerup_scene = preload("res://scenes/single_powerup.tscn")

func activate():
	cur_egg_shape = GDict.cfg.fixed_egg_shape

func on_egg_broken(entity):
	if not GDict.cfg.broken_eggs_spawn_powerups: return
	spawn_powerup(entity.transform.origin, entity.visuals.type)

func spawn_powerup(pos : Vector3, type : String):
	if GDict.eggs[type].has('no_powerup'): return
	
	var p = powerup_scene.instance()
	p.set_translation(pos)
	p.set_type(type)
	add_child(p)

func change_global_gravity(factor : float):
	cur_gravity_multiplier = factor
	
	for body in get_tree().get_nodes_in_group("Eggs"):
		body.update_gravity_scale(cur_gravity_multiplier)
	
	for body in get_tree().get_nodes_in_group("Players"):
		body.update_gravity_scale(cur_gravity_multiplier)

func get_global_gravity_mult():
	return cur_gravity_multiplier

func modify_egg_speed(factor : float):
	egg_speed_modifier = clamp(egg_speed_modifier*factor, 0.3, 1.8)

func get_egg_speed_modifier():
	return egg_speed_modifier

func modify_point_factor(new_factor : float):
	point_factor = clamp(point_factor * new_factor, 0.5, 2.0)

func get_point_factor():
	return point_factor

func get_cur_egg_shape():
	return cur_egg_shape

func change_egg_shape(type : String = "egg"):
	# same as current type? it toggles back to regular
	if cur_egg_shape == type:
		cur_egg_shape = "egg"
		return
	
	# opposite of current type? it toggles back to regular
	if cur_egg_shape == "egg_big" and type == "egg_small":
		cur_egg_shape = "egg"
		return
	
	if cur_egg_shape == "egg_small" and type == "egg_big":
		cur_egg_shape = "egg"
		return
	
	# otherwise we just set it to what we received
	cur_egg_shape = type
