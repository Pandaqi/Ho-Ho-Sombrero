extends CanvasLayer

onready var counters = $Counters
onready var delivered_label = $Counters/Sprite/Delivered
onready var delivered_target_label = $Counters/Sprite/DeliveredTarget
onready var broken_label = $Counters/Sprite/Broken
onready var settings_hint = $Settings

const TUT_HEIGHT : float = 256*0.25
const TUT_MARGIN : float = 7.0

onready var egg_tutorials = $EggTutorials
var egg_tutorial = preload("res://scenes/ui/egg_tutorial.tscn")

func _ready():
	if not GDict.cfg.lose_game_by_broken_eggs: broken_label.set_visible(false)
	
	settings_hint.set_visible(false)
	if G.in_menu(): 
		counters.set_visible(false)
		settings_hint.set_visible(true)
	
	get_tree().get_root().connect("size_changed", self, "on_resize")
	on_resize()

func update_delivered(val, target):
	var val_as_string = str(val)
	if val < 10: val_as_string = str("0") + str(val)
	
	delivered_label.set_text(val_as_string)
	delivered_target_label.set_text("/" + str(target))

func update_broken(val, target):
	broken_label.set_text("Broken: " + str(val) + "/" + str(target))

func on_resize():
	var vp = get_viewport().size
	var anchor_pos = Vector2(vp.x, 0)
	egg_tutorials.set_position(anchor_pos)

func display_egg_tutorials(list):
	var counter = 0
	for key in list:
		var frame = GDict.eggs[key].frame
		
		var t = egg_tutorial.instance()
		t.get_node("Sprite").set_frame(frame)
		t.set_position(Vector2.DOWN*TUT_HEIGHT*counter + Vector2(-1,1)*TUT_MARGIN)
		egg_tutorials.add_child(t)
		
		counter += 1
