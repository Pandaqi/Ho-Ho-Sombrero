extends StaticBody

func _ready():
	if not GDict.cfg.delivery_points_attract_eggs:
		$AttractArea.queue_free()

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	
	body.status.set_delivered()
