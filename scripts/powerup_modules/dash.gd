extends Node

const DASH_RESET_DURATION : float = 0.8
const DASH_FORCE : float = 3000.0
const DAMPING : float = 4.0

var body
var force = 0.0
var dash_allowed = true

onready var timer = $Timer

func _on_Input_button_press():
	pass

func _on_Input_button_release():
	if not dash_allowed: return
	force = DASH_FORCE
	dash_allowed = false
	
	timer.wait_time = DASH_RESET_DURATION
	timer.start()

func _physics_process(dt):
	if force <= 0.03: return
	
	force *= (1.0 - DAMPING*dt)
	body.mover.set_extra_speed(force)
	
	if force <= 5:
		force = 0
		body.mover.set_extra_speed(0.0)

func _on_Timer_timeout():
	dash_allowed = true
