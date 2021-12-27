extends Node

var player_num : int = -1
var use_fake : bool = false
var fake_device_num : int = -1
var input_enabled : bool = true
var solo_mode : bool = false

onready var body = get_parent()

signal move_vec(vec, dt)

signal button_press()
signal button_release()

func _ready():
	solo_mode = (GInput.get_player_count() == 1 and G.in_menu())

func get_key(key : String):
	var device_num 
	
	if use_fake:
		device_num = fake_device_num
	else:
		device_num = GInput.device_order[player_num]
	
	return key + "_" + str(device_num)

func get_solo_key(key : String):
	return key + "_" + str(player_num) + "_solo"

func set_player_num(num : int):
	player_num = num

func _physics_process(dt):
	determine_move_vec(dt)

func determine_move_vec(dt):
	var override = check_special_solo_mode_controls(dt)
	if override: return
	
	if not input_enabled: return
	
	var h = Input.get_action_strength(get_key("right")) - Input.get_action_strength(get_key("left"))
	var v = Input.get_action_strength(get_key("down")) - Input.get_action_strength(get_key("up"))
	var move_vec = Vector2(h,v).normalized()
	
	emit_signal("move_vec", move_vec, dt)

func check_special_solo_mode_controls(dt):
	if not solo_mode: return false
	if GInput.is_keyboard_player(player_num): return false
	
	var h = Input.get_action_strength(get_solo_key("right")) - Input.get_action_strength(get_solo_key("left"))
	var v = Input.get_action_strength(get_solo_key("down")) - Input.get_action_strength(get_solo_key("up"))
	var move_vec = Vector2(h,v).normalized()
	
	emit_signal("move_vec", move_vec, dt)
	return true

func _input(ev):
	# There's no easy way to both assign and teach a second button for the second player, so just use that single button to control both!
	#if not input_enabled: return
	
	if ev.is_action_pressed(get_key("interact")):
		emit_signal("button_press")
	elif ev.is_action_released(get_key("interact")):
		emit_signal("button_release")

func is_disabled():
	return (not input_enabled)

func switch_on():
	input_enabled = true

func switch_off():
	emit_signal("move_vec", Vector2.ZERO, 0.16)
	input_enabled = false

func make_custom():
	use_fake = true
	
	var is_keyboard_player = (GInput.device_order[0] < 0)
	if is_keyboard_player:
		fake_device_num = -2
	else:
		fake_device_num = GInput.device_order[0]
		input_enabled = false
