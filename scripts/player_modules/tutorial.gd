extends Node

onready var node = $Node2D
onready var node_sprite = $Node2D/Sprite

onready var body = get_parent()
onready var GUI = get_node("/root/Main/GUI")
onready var cam = get_node("/root/Main/Camera")

const TUT_OFFSET : Vector2 = Vector2.UP * 75

func _ready():
	remove_child(node)
	GUI.add_child(node)
	
	set_correct_frame()

func set_correct_frame():
	var num = body.status.player_num
	node_sprite.set_frame(GInput.get_tutorial_frame_for_player(num))

func _physics_process(dt):
	node.set_position(cam.unproject_position(body.transform.origin) + TUT_OFFSET)
