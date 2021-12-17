extends Node

var player_num : int = -1
var use_fake : bool = false
var fake_device_num : int = -1
var input_enabled : bool = true

onready var body = get_parent()

signal move_vec(vec, dt)

signal button_press()
signal button_release()

func get_key(key : String):
	var device_num 
	
	if use_fake:
		device_num = fake_device_num
	else:
		device_num = GInput.device_order[player_num]
	
	return key + "_" + str(device_num)

func set_player_num(num : int):
	player_num = num

func _physics_process(dt):
	determine_move_vec(dt)

func determine_move_vec(dt):
	if not input_enabled: return
	
	var h = Input.get_action_strength(get_key("right")) - Input.get_action_strength(get_key("left"))
	var v = Input.get_action_strength(get_key("down")) - Input.get_action_strength(get_key("up"))
	var move_vec = Vector2(h,v).normalized()
	
	emit_signal("move_vec", move_vec, dt)

func _input(ev):
	if not input_enabled: return
	
	if ev.is_action_pressed(get_key("interact")):
		emit_signal("button_press")
	elif ev.is_action_released(get_key("interact")):
		emit_signal("button_release")

func is_disabled():
	return (not input_enabled)

func switch_on():
	input_enabled = true

func switch_off():
	input_enabled = false

func make_custom():
	use_fake = true
	
	var is_keyboard_player = (GInput.device_order[0] < 0)
	if is_keyboard_player:
		fake_device_num = -2
	else:
		fake_device_num = GInput.device_order[0]
		input_enabled = false
