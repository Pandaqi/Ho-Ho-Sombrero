extends Spatial

onready var outline = $Outline

var starting_positions = []
const START_POS_OFFSET : Vector3 = Vector3.UP*2

var arena_data

func activate():
	arena_data = GDict.arenas[G.get_current_arena()]
	for child in $StartingPositions.get_children():
		starting_positions.append(child.global_transform.origin + START_POS_OFFSET)
	
	if G.in_menu() and G.get_last_played_arena():
		starting_positions = []
		
		var selector_node = get_node("Selector_" + G.get_last_played_arena())
		for i in range(4):
			var ang = -i*0.5*PI + PI
			var radius = 7
			starting_positions.append(selector_node.global_transform.origin + Vector3(cos(ang), 0, sin(ang))*radius)
	
	for key in GSave.get_unlocked_worlds():
		if has_node("Gate_" + key):
			get_node("Gate_" + key).queue_free()

func get_start_pos(num : int):
	return starting_positions[num]

func get_dimensions():
	var extra_growth = Vector3.ZERO
	if arena_data.has('outline_growth'):
		extra_growth = arena_data.outline_growth
	
	return outline.get_dimensions() + extra_growth

func get_floor_pos():
	return outline.transform.origin # TO DO: correct? useful? dunno
