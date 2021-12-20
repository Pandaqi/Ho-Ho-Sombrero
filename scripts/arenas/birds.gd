extends Spatial

var NUM_BIRDS : int
var birds = []

var bird_scene = preload("res://scenes/arenas/bird.tscn")

func _ready():
	var num_players = GInput.get_player_count()
	
	NUM_BIRDS = 1
	if num_players == 3:
		NUM_BIRDS = 2
	elif num_players == 4:
		NUM_BIRDS = 3
	
	create_birds()

func create_birds():
	for i in range(NUM_BIRDS):
		var b = bird_scene.instance()
		add_child(b)
		birds.append(b)
