extends Node

const UP_INFLUENCE : float = 5.0 # how much more eggs bounce upward than realistically
const WALL_INFLUENCE : float = 4.0 # how much walls push you _extra _inward
const BOUNCE_POWER : float = 6.0

var epsilon = 0.1
var active : bool = true
var players_touched = []
var num_bounces_on_ground : int = 0

onready var body = get_parent()
onready var powerups = get_node("/root/Main/Powerups")

func _integrate_forces(state):
	if not active: return
	
	for i in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(i)
		var normal = state.get_contact_local_normal(i)
		var original_normal = normal
		if obj.is_in_group("NormalBouncer"): continue
	
		if obj.is_in_group("Floor"): 
			num_bounces_on_ground += 1
		
		# to prevent eggs getting stuck under the sombrero and YEETING us upwards
		if obj.is_in_group("Sombreros") or obj.is_in_group("Players"):
			if normal.y < 0: continue
		
		if normal.y < 0: normal.y += 1.0
		normal.y *= UP_INFLUENCE
		
		# bouncing from the walls pushes us more into the center
		if obj.is_in_group("Walls"):
			if abs(normal.x) > abs(normal.z):
				normal.x *= WALL_INFLUENCE
			else:
				normal.z *= WALL_INFLUENCE
		
		normal = normal.normalized()

		var final_bounce_power = BOUNCE_POWER
		if obj.is_in_group("Sombreros"):
			var linked_player = obj.player
			final_bounce_power *= linked_player.powerups.get_final_bounce_factor()
			
			var num = linked_player.status.player_num
			if not (num in players_touched):
				players_touched.append(num)
			
			GAudio.play_dynamic_sound(body, "bounce")
		else:
			GAudio.play_dynamic_sound(body, "thud")
			
		final_bounce_power *= powerups.get_egg_speed_modifier()
		
		state.apply_central_impulse(normal * final_bounce_power)
		body.visuals.on_bounce(original_normal)
		break

func get_num_unique_players_touched():
	return players_touched.size()

func set_delivered():
	active = false
