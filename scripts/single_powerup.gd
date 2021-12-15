extends Spatial

var type : String

func set_type(tp : String):
	type = tp
	
	var frame = GDict.eggs[type].frame
	$Powerup/SpriteFront.set_frame(frame)
	$Powerup/SpriteBack.set_frame(frame)

func _on_Area_body_entered(body):
	body.powerups.grab(type)
	self.queue_free()
