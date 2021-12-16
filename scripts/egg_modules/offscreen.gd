extends Node

onready var body = get_parent()
onready var cam = get_node("/root/Main/Camera")
onready var GUI = get_node("/root/Main/GUI")

onready var offset_indicator = $OffsetIndicator
onready var egg_icon = $OffsetIndicator/EggIcon

func _ready():
	remove_child(offset_indicator)
	GUI.add_child(offset_indicator)
	
	body.connect("on_death", self, "on_death")

func set_type(tp : String):
	egg_icon.set_frame(GDict.eggs[tp].frame)

func _physics_process(dt):
	check_offscreen()

func check_offscreen():
	if not cam.is_offscreen(body.transform.origin):
		offset_indicator.set_visible(false)
		return
	
	# Returns the POSITION (clamped to screen) and DIRECTION (the arrow should face)
	var data = cam.get_offscreen_data(body.transform.origin)
	
	offset_indicator.set_position(data.pos)
	
	offset_indicator.set_rotation(data.rot)
	egg_icon.set_rotation(-data.rot)
	
	offset_indicator.set_visible(true)

func on_death():
	offset_indicator.queue_free()
