extends Spatial

const FLY_SPEED : float = 5.5
const STARTING_RADIUS : float = 33.0
const BIRD_HEIGHT : float = 27.0
var flight_vec : Vector3

onready var cam = get_node("/root/Main/Camera")

func _ready():
	if not GDict.cfg.delivery_points_attract_eggs:
		$AttractArea.queue_free()
	
	pick_new_flight_direction()

func pick_new_flight_direction():
	var ang = 2*randf()*PI
	var flight_vec_2d = Vector2(cos(ang), sin(ang))
	
	# We reposition ourselves so that our flight vector takes us right through the center, but add some randomization
	var offset_vec = -flight_vec_2d.rotated((randf()-0.5)*0.15*PI)
	var offset = Vector3(offset_vec.x, 0, offset_vec.y)
	var offset_without_y = (STARTING_RADIUS-1)*offset
	global_transform.origin = Vector3(offset_without_y.x, BIRD_HEIGHT, offset_without_y.z)
	
	flight_vec = Vector3(flight_vec_2d.x, 0, flight_vec_2d.y).normalized()
	
	global_transform = global_transform.looking_at(global_transform.origin + flight_vec, Vector3.UP)

func is_busy():
	return is_at_edge(5.0)

func _physics_process(dt):
	global_transform.origin += dt*flight_vec*FLY_SPEED
	
	if is_at_edge(0.0):
		pick_new_flight_direction()

func is_at_edge(margin : float):
	var pos = global_transform.origin
	var pos_without_y = Vector3(pos.x, 0, pos.z)
	return pos_without_y.length() >= (STARTING_RADIUS - margin)

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	if body.bouncer.get_num_unique_players_touched() <= 0: return
	body.status.set_delivered(1)
	
	# we are not a basket, so just destroy delivered eggs 
	# (alternative = keep with us until we re-orient, destroy then)
	body.emit_signal("on_death") 
