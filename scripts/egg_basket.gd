extends StaticBody

onready var state = get_node("/root/Main/State")

func _on_Area_body_entered(body):
	body.status.set_delivered()
	state.on_egg_delivered(body)
