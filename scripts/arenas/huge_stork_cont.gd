extends Spatial

onready var tween = $Tween
var start_pos : Vector3
var end_pos : Vector3
var dur : float = 1.56

func _ready():
	start_pos = transform.origin
	end_pos = start_pos + Vector3.UP*6
	
	play_hover_tween()

func play_hover_tween():
	tween.interpolate_property(self, "translation", 
		start_pos, end_pos, dur,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "translation", 
		end_pos, start_pos, dur,
		Tween.TRANS_LINEAR, Tween.EASE_OUT,
		dur)
	tween.start()

func _on_Tween_tween_all_completed():
	play_hover_tween()
