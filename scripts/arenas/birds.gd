extends Spatial

var NUM_BIRDS : int
var birds = []
var bird_heights = [10,15,20,30,30]

var bird_scene = preload("res://scenes/arenas/models/bird.tscn")

func _ready():
	var num_players = GInput.get_player_count()
	
	NUM_BIRDS = 5
	
	create_birds()

func create_birds():
	for i in range(NUM_BIRDS):
		var b = bird_scene.instance()
		b.set_height(bird_heights[i])
		add_child(b)
		birds.append(b)
