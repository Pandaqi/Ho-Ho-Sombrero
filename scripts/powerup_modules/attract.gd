extends Node

var body
var active : bool = false

onready var area = $Area

func _on_Input_button_press():
	active = true
	area.set_deferred("space_override", 4)

func _on_Input_button_release():
	active = false
	area.set_deferred("space_override", 0)
