extends Camera

var cam_offset : Vector3 = Vector3(0,15,7)
var zoom_factor : float = 1.0
onready var map = get_node("../Map")

const ZOOM_SPEED : float = 3.0

# Values ar given based on the "base_vp" => they are rescaled if necessary for (wildly) different viewports
const EDGE_MARGIN : float = 120.0
const INNER_EDGE_MARGIN : float = EDGE_MARGIN + 35.0
const OFFSCREEN_MARGIN : float = 10.0

var base_vp = Vector2(1920, 1080)

var top_left_2d
var bottom_right_2d
var vp
var vp_compensate

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
	
	top_left_2d = unproject_position(top_left)
	bottom_right_2d = unproject_position(bottom_right)
	vp = get_viewport().size
	vp_compensate = max((vp/base_vp).x, (vp/base_vp).y)

	if inside_margin(EDGE_MARGIN * vp_compensate):
		zoom_factor += dt*ZOOM_SPEED
	elif not inside_margin(INNER_EDGE_MARGIN * vp_compensate):
		zoom_factor -= dt*ZOOM_SPEED

func inside_margin(m : float) -> bool:
	if top_left_2d.x < m or top_left_2d.y < m:
		return true
	
	if bottom_right_2d.x > (vp.x - m) or bottom_right_2d.y > (vp.y - m):
		return true
	return false

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
	
	obj.pos = pos_2d
	obj.rot = 0
	
	var weight = 0
	
	if pos_2d.x < m:
		obj.pos.x = icon_size
		obj.rot += PI
		weight += 1
	elif pos_2d.x > (vp.x - m):
		obj.pos.x = vp.x - icon_size
		obj.rot += 0
		weight += 1
	
	if pos_2d.y < m:
		obj.pos.y = icon_size
		obj.rot += 1.5*PI
		weight += 1
	elif pos_2d.y > (vp.y - m):
		obj.pos.y = vp.y - icon_size
		obj.rot += 0.5*PI
		weight += 1
	
	obj.rot /= weight
	
	return obj
