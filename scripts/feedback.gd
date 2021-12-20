extends CanvasLayer

const OFFSET : Vector2 = Vector2.UP*50
var fb_scene = preload("res://scenes/ui/feedback.tscn")

onready var cam = get_node("../Camera")

func create_for(node, txt : String):
	var fb = fb_scene.instance()
	fb.get_node("LabelContainer/Label").set_text(txt)
	fb.set_position(cam.unproject_position(node.global_transform.origin) + OFFSET)
	add_child(fb)
