extends CanvasLayer

onready var delivered_label = $Delivered
onready var broken_label = $Broken

func update_delivered(val, target):
	delivered_label.set_text("Delivered: " + str(val) + "/" + str(target))

func update_broken(val, target):
	broken_label.set_text("Broken: " + str(val) + "/" + str(target))
