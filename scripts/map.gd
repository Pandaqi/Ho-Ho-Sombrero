extends Spatial

onready var outline = $Outline

var starting_positions = []
const START_POS_OFFSET : Vector3 = Vector3.UP*2

func activate():
	for child in $StartingPositions.get_children():
		starting_positions.append(child.transform.origin + START_POS_OFFSET)

func get_start_pos(num : int):
	return starting_positions[num]

func get_dimensions():
	return outline.get_dimensions()

func get_floor_pos():
	return outline.transform.origin # TO DO: correct? useful? dunno
