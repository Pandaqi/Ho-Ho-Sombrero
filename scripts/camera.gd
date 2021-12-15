extends Camera

var cam_offset : Vector3 = Vector3(0,15,7)
var zoom_factor : float = 1.0
onready var map = get_node("../Map")

const EDGE_MARGIN : float = 40.0

func _physics_process(dt):
	center_on_map(dt)
	change_camera_angle(dt)

func change_camera_angle(dt):
	if Input.is_action_pressed("camera_to_top") or Input.get_action_strength("camera_to_top") > 0.5:
		cam_offset = cam_offset.rotated(Vector3.RIGHT, dt)
	elif Input.is_action_pressed("camera_to_side") or Input.get_action_strength("camera_to_side") > 0.5:
		cam_offset = cam_offset.rotated(Vector3.RIGHT, -dt)
	
	cam_offset.y = clamp(cam_offset.y, 0.05, 20)
	cam_offset.z = clamp(cam_offset.z, 0.05, 20)

func center_on_map(dt):
	var shape_offset = map.get_dimensions()
	var top_left = floor_shape.transform.origin - shape_offset
	var bottom_right = floor_shape.transform.origin + shape_offset
	
	var avg = (top_left + bottom_right)*0.5
	var new_pos = avg + cam_offset*zoom_factor
	
	set_translation(lerp(get_translation(), new_pos, 5*dt))
	
	look_at(avg, Vector3.UP)
	
	var top_left_2d = unproject_position(top_left)
	var bottom_right_2d = unproject_position(bottom_right)
	var vp = get_viewport().size
	
	if top_left_2d.x < EDGE_MARGIN or top_left_2d.y < EDGE_MARGIN:
		zoom_factor += dt
	
	if bottom_right_2d.x > (vp.x - EDGE_MARGIN) or bottom_right_2d.y > (vp.y - EDGE_MARGIN):
		zoom_factor += dt
