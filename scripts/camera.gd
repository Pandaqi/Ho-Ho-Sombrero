extends Camera

var cam_offset : Vector3 = Vector3(0,15,7)
var zoom_factor : float = 1.0
onready var map = get_node("../Map")

const EDGE_MARGIN : float = 40.0
const OFFSCREEN_MARGIN : float = 10.0

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
	var shape_pos = map.get_floor_pos()
	var top_left = shape_pos - shape_offset
	var bottom_right = shape_pos + shape_offset
	
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

func is_offscreen(pos : Vector3):
	var pos_2d = unproject_position(pos)
	var m = OFFSCREEN_MARGIN
	var vp = get_viewport().size
	return (pos_2d.x < m or pos_2d.x > (vp.x-m)) or (pos_2d.y < m or pos_2d.y > (vp.y-m))

func get_offscreen_data(pos : Vector3):
	var obj = {
		'pos': Vector3.ZERO,
		'rot': 0
	}
	
	var m = OFFSCREEN_MARGIN
	var vp = get_viewport().size
	var icon_size : float = 25.0
	var pos_2d = unproject_position(pos)
	
	if pos_2d.x < m:
		obj.pos = Vector2(icon_size, pos_2d.y)
		obj.rot = PI
	elif pos_2d.x > (vp.x - m):
		obj.pos = Vector2(vp.x - icon_size, pos_2d.y)
		obj.rot = 0
	elif pos_2d.y < m:
		obj.pos = Vector2(pos_2d.x, icon_size)
		obj.rot = 1.5*PI
	elif pos_2d.y > (vp.y - m):
		obj.pos = Vector2(pos_2d.x, vp.y - icon_size)
		obj.rot = 0.5*PI
	
	return obj
