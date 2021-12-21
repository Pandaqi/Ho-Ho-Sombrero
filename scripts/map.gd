extends Spatial

onready var outline = $Outline

var starting_positions = []
const START_POS_OFFSET : Vector3 = Vector3.UP*2

var arena_data

func activate():
	arena_data = GDict.arenas[G.get_current_arena()]
	for child in $StartingPositions.get_children():
		starting_positions.append(child.transform.origin + START_POS_OFFSET)

func get_start_pos(num : int):
	return starting_positions[num]

func get_dimensions():
	var extra_growth = Vector3.ZERO
	if arena_data.has('outline_growth'):
		extra_growth = arena_data.outline_growth
	
	return outline.get_dimensions() + extra_growth

func get_floor_pos():
	return outline.transform.origin # TO DO: correct? useful? dunno
