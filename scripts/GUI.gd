extends CanvasLayer

onready var delivered_label = $Counters/Delivered
onready var broken_label = $Counters/Broken

const TUT_HEIGHT : float = 256*0.25
const TUT_MARGIN : float = 7.0

onready var egg_tutorials = $EggTutorials
var egg_tutorial = preload("res://scenes/ui/egg_tutorial.tscn")

func _ready():
	get_tree().get_root().connect("size_changed", self, "on_resize")
	on_resize()

func update_delivered(val, target):
	delivered_label.set_text("Delivered: " + str(val) + "/" + str(target))

func update_broken(val, target):
	broken_label.set_text("Broken: " + str(val) + "/" + str(target))

func on_resize():
	var vp = get_viewport().size
	egg_tutorials.set_position(vp)

func display_egg_tutorials(list):
	var counter = 0
	for key in list:
		var frame = GDict.eggs[key].frame
		
		var t = egg_tutorial.instance()
		t.get_node("Sprite").set_frame(frame)
		t.set_position(Vector2.UP*TUT_HEIGHT*counter - Vector2.ONE*TUT_MARGIN)
		egg_tutorials.add_child(t)
		
		counter += 1
