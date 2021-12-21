extends Spatial

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	
	body.status.set_delivered(1)
