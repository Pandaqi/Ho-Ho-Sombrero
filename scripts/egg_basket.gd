extends StaticBody

onready var state = get_node("/root/Main/State")

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	
	body.status.set_delivered()
	state.on_egg_delivered(body)
