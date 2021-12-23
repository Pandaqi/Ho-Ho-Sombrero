extends Node2D

var input_allowed : bool = false

onready var reminder = $Reminder

func temp_disable_input():
	input_allowed = false
	$Timer.start()

func _on_Timer_timeout():
	input_allowed = true
