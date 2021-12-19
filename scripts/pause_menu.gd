extends CanvasLayer

var input_enabled : bool = true
var active : bool = false
onready var state = get_node("/root/Main/State")
onready var control = $Control

func _unhandled_input(ev):
	if not input_enabled: return
	if G.in_menu(): return
	if not active: 
		if ev.is_action_released("back"): show()
		return
	
	if ev.is_action_released("restart_pause"):
		state.restart()
	elif ev.is_action_released("back"):
		state.back_to_menu()
	elif ev.is_action_released("continue"):
		hide()

func enable():
	input_enabled = true

func disable():
	input_enabled = false

func hide():
	get_tree().paused = false
	control.set_visible(false)
	active = false

func show():
	get_tree().paused = true
	control.set_visible(true)
	active = true
