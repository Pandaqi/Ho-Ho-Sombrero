extends Spatial

const MOVE_SPEED = 1.0
export var max_move_length : float

var start_pos : Vector3

func _ready():
	start_pos = transform.origin

func _on_Area_body_entered(body):
	if not body.is_in_group("Eggs"): return
	
	body.status.set_delivered(1)

func _physics_process(dt):
	transform.origin += -transform.basis.z * MOVE_SPEED * dt
	
	if (transform.origin - start_pos).length() >= max_move_length:
		transform.origin = start_pos
