extends Spatial

var type : String

const POWERUP_FADE_TIME : float = 10.0
onready var timer = $Timer
onready var anim_player = $AnimationPlayer

func _ready():
	if not GDict.cfg.egg_lights:
		$OmniLight.queue_free()
	
	timer.wait_time = POWERUP_FADE_TIME
	timer.start()

func set_type(tp : String):
	type = tp
	
	var frame = GDict.eggs[type].frame
	$Powerup/SpriteFront.set_frame(frame)
	$Powerup/SpriteBack.set_frame(frame)

func _on_Area_body_entered(body):
	body.powerups.grab(type)
	self.queue_free()

func _on_Timer_timeout():
	anim_player.play("PowerupDisappear")

func on_death():
	self.queue_free()
