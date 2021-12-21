extends Spatial

const FLY_SPEED = { 'min': 3.0, 'max': 5.75 }
const STARTING_RADIUS : float = 29.0
const MIN_HEIGHT_FOR_EGG_DROP = 27.0

var bird_height : float

var speed : float
var flight_vec : Vector3

onready var cam = get_node("/root/Main/Camera")
onready var tween = $Tween

func _ready():
	if not GDict.cfg.delivery_points_attract_eggs:
		$AttractArea.queue_free()
	
	pick_new_flight_direction()

func set_height(h):
	bird_height = h

func pick_new_flight_direction():
	var ang = 2*randf()*PI
	var flight_vec_2d = Vector2(cos(ang), sin(ang))
	
	# We reposition ourselves so that our flight vector takes us right through the center, but add some randomization
	var offset_vec = -flight_vec_2d.rotated((randf()-0.5)*0.15*PI)
	var offset = Vector3(offset_vec.x, 0, offset_vec.y)
	var offset_without_y = (STARTING_RADIUS-1)*offset
	
	global_transform.origin = Vector3(offset_without_y.x, bird_height, offset_without_y.z)
	
	flight_vec = Vector3(flight_vec_2d.x, 0, flight_vec_2d.y).normalized()
	speed = rand_range(FLY_SPEED.min, FLY_SPEED.max)
	
	global_transform = global_transform.looking_at(global_transform.origin + flight_vec, Vector3.UP)

func is_busy():
	return is_at_edge(14.0) or (bird_height < MIN_HEIGHT_FOR_EGG_DROP)

func _physics_process(dt):
	var was_near_edge = is_at_edge(3.0)
	
	global_transform.origin += dt*flight_vec*speed
	
	if is_at_edge(0.0):
		pick_new_flight_direction()
		perform_scale_tween(true)
		return
	
	var is_near_edge = is_at_edge(3.0)
	if not was_near_edge and is_near_edge:
		perform_scale_tween(false)

func perform_scale_tween(val : bool):
	var start = Vector3.ONE
	var end = Vector3.ONE*0.01
	if val:
		start = Vector3.ONE*0.01
		end = Vector3.ONE
	
	tween.interpolate_property(self, "scale", 
		start, end, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

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
	body.queue_free()
	body.emit_signal("on_death") 
