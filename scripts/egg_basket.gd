extends StaticBody

export var point_value : int = 1

func _ready():
	$PointSprite.set_frame(point_value - 1)
	if not GDict.cfg.delivery_points_attract_eggs:
		$AttractArea.queue_free()

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	
	body.status.set_delivered(point_value)
