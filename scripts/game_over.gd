extends CanvasLayer

onready var control = $Control
onready var time_label = $Control/CenterContainer/TimeLabel

func _ready():
	hide()

func hide():
	control.set_visible(false)

func show(time):
	control.set_visible(true)
	time_label.set_text(format_time(time))

func format_time(time : float):
	var i_time = int(round(time))
	var seconds = i_time % 60
	if seconds < 9: seconds = "0" + str(seconds)
	
	var minutes = floor(i_time / 60.0)
	if minutes < 9: minutes = "0" + str(minutes)
	
	return str(minutes) + ":" + str(seconds)
