extends Node

const DEF_SOMBRERO_POS = Vector3(0, 0.437, 0)

var cur_joint_name : String = ""
var planned_joint : String = ""
var cur_joint = null
var weak_joint_ref = null
var is_busy : bool = false
var settling_joint : bool = false

onready var body = get_parent()

var pin_joint = preload("res://scenes/sombrero_modules/pin_joint.tscn")
var slanted_pin_joint = preload("res://scenes/sombrero_modules/slanted_pin_joint.tscn")

func _input(ev):
	if ev.is_action_released("restart"):
		var key = "regular"
		if cur_joint_name == "regular": key = "racket"
		
		plan_joint(key)

func _integrate_forces(state):
	if planned_joint == "": return
	
	state.linear_velocity = Vector3.ZERO
	state.angular_velocity = Vector3.ZERO
	
	if weak_joint_ref and weak_joint_ref.get_ref(): return
	
	cur_joint_name = planned_joint
	planned_joint = ""
	
	match cur_joint_name:
		"regular":
			create_regular_joint(state)
		
		"slanted":
			create_slanted_joint(state)
		
		"racket":
			create_racket_joint(state)

func destroy_joint():
	if not cur_joint: return
	
	cur_joint.queue_free()
	cur_joint = null
	
	print("JOINT DESTROYED")
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")

func plan_joint(type):
	if is_busy: return
	
	is_busy = true
	
	if cur_joint:
		#PhysicsServer.free_rid(cur_joint.get_rid())
		cur_joint.queue_free()
		cur_joint = null
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")

	planned_joint = type

func create_regular_joint(state):
	var p = body.player
	var player_pos = p.transform.origin
	
	state.transform.origin = player_pos + DEF_SOMBRERO_POS
	state.transform.basis = Basis(Vector3.RIGHT, Vector3.UP, Vector3.FORWARD)

	settling_joint = true

	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	settling_joint = false
	
	var j : Generic6DOFJoint = pin_joint.instance()
	j.transform.origin = player_pos + DEF_SOMBRERO_POS
	j.set('nodes/node_a', body.player.get_path())
	j.set('nodes/node_b', body.get_path())

	finish_joint_creation(j)

func create_slanted_joint(state):
	var p = body.player
	var player_pos = p.transform.origin
	
	state.transform.origin = player_pos + DEF_SOMBRERO_POS
	
	# Rotate the sombrero BEFORE adding, so the joint sticks it in that position
	state.transform.basis = state.transform.rotated(Vector3.RIGHT, -0.2*PI).basis
	
	settling_joint = true
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	settling_joint = false
	
	var j : Generic6DOFJoint = slanted_pin_joint.instance()
	j.transform.origin = player_pos + DEF_SOMBRERO_POS
	j.set('nodes/node_a', body.player.get_path())
	j.set('nodes/node_b', body.get_path())

	finish_joint_creation(j)

func create_racket_joint(state):
	var p = body.player
	var player_pos = p.transform.origin
	var forward_pos = -p.transform.basis.z
	var offset = 5.0
	
	state.transform.origin = player_pos + 0.5*DEF_SOMBRERO_POS + offset*forward_pos
	state.transform.basis = Basis(Vector3.RIGHT, Vector3.UP, Vector3.FORWARD)
	
	settling_joint = true
	
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	
	settling_joint = false
	
	var j : Generic6DOFJoint = pin_joint.instance()
	j.transform.origin = player_pos + 0.5*DEF_SOMBRERO_POS
	j.set('nodes/node_a', body.player.get_path())
	j.set('nodes/node_b', body.get_path())

	finish_joint_creation(j)

func finish_joint_creation(j):
	# NOTE: joints aren't added as our children, or the children of our body
	# as it would mess with its LOCATION any time we move
	body.get_parent().add_child(j)
	
	cur_joint = j
	weak_joint_ref = weakref(cur_joint)
	is_busy = false
