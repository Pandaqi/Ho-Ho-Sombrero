extends Spatial

var type : String

func set_type(tp : String):
	type = tp
	$Powerup/Sprite3D.set_frame(GDict.eggs[type].frame)

func _on_Area_body_entered(body):
	body.powerups.grab(type)
	self.queue_free()
