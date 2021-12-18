extends Spatial

var bodies_in_start : Array = []
var bodies_in_hover : Array = []

export var arena : String = "training"

onready var GUI = get_node("/root/Main/GUI")
onready var cam = get_node("/root/Main/Camera")

onready var tween = $Tween
onready var model = $Model
onready var tutorial = $Tutorial
onready var tutorial_sprite = $Tutorial/Sprite

const TUT_OFFSET : Vector2 = Vector2.LEFT*100

func _ready():
	tutorial.set_visible(false)
	
	remove_child(tutorial)
	GUI.add_child(tutorial)

func _on_StartArea_body_entered(body):
	bodies_in_start.append(body)
	
	if bodies_in_start.size() >= GInput.get_player_count(): 
		start()

func _on_StartArea_body_exited(body):
	bodies_in_start.erase(body)

func _on_HoverArea_body_entered(body):
	bodies_in_hover.append(body)
	
	if bodies_in_hover.size() == 1: set_hover(true)

func _on_HoverArea_body_exited(body):
	bodies_in_hover.erase(body)
	
	if bodies_in_hover.size() <= 0: set_hover(false)

func start():
	G.goto_game(arena)

func set_hover(val):
	var start = Vector3.ONE
	var end = Vector3.ONE*2
	if not val:
		var temp = end
		end = start
		start = temp
	
	model.set_scale(start)
	tween.interpolate_property(model, "scale",
		start, end, 1.0,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	
	set_arena_tutorial(val)

func set_arena_tutorial(val):
	tutorial.set_visible(val)
	
	var start = Vector2.ZERO
	var end = Vector2.ONE
	if not val:
		start = Vector2.ONE
		end = Vector2.ZERO
	
	tutorial.set_scale(start)
	tween.interpolate_property(tutorial, "scale",
		start, end, 1.0,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	
	tutorial_sprite.set_frame(GDict.arenas[arena].frame)

func _physics_process(dt):
	if not tutorial.is_visible(): return
	tutorial.set_position(cam.unproject_position(transform.origin) + TUT_OFFSET)
