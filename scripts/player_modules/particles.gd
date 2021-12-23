extends Spatial

onready var part = $Particles

func _on_Mover_move_start():
	part.set_emitting(true)

func _on_Mover_move_stop():
	part.set_emitting(false)
