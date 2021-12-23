extends Node

const TIME_UNTIL_AUTO_DELIVERY : float = 10.0
onready var timer = $Timer
onready var progress = $Progress
onready var body = get_parent()

onready var map = get_node("/root/Main/Map")
onready var cam = get_node("/root/Main/Camera")

func _ready():
	remove_child(progress)
	map.add_child(progress)
	
	timer.wait_time = TIME_UNTIL_AUTO_DELIVERY
	timer.start()
	
	body.connect("on_death", self, "on_death")

func _physics_process(dt):
	progress.set_position(cam.unproject_position(body.transform.origin))
	
	var time_left_as_ratio = (timer.time_left / TIME_UNTIL_AUTO_DELIVERY)
	progress.get_node("TextureProgress").set_value(time_left_as_ratio)

func _on_Timer_timeout():
	body.status.set_delivered(1)

func on_death():
	progress.queue_free()
	self.queue_free()
