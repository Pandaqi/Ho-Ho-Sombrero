extends Spatial

onready var mesh_instance = $MeshInstance
var epsilon = 0.05
var dims : Vector2

var surface_image : Image = Image.new()
var surface_texture : ImageTexture = ImageTexture.new()

var image_size : Vector2
var resolution : float = 4.0

const UNIT_PIXEL_SIZE : float = 64.0 # how many pixels should go in one unit/one meter in 3D space
const PAINT_SIZE : Dictionary = { 'min': 8, 'max': 16 }

func get_dimensions():
	return Vector3(dims.x, 0, dims.y)

func _ready():
	drape_mesh_over_terrain()
	create_mask()

func drape_mesh_over_terrain():
	var old_mesh = mesh_instance.mesh
	dims = 0.5*old_mesh.size # save the dimensions BEFORE we convert
	
	var surface_tool := SurfaceTool.new()
	surface_tool.create_from(old_mesh,0)
	
	var mesh = surface_tool.commit()
	
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	var space_state = get_world().direct_space_state
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		var pos = shoot_down_raycast(space_state, vertex)
		vertex = pos
		mdt.set_vertex(i, vertex)
	
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)
	
	mesh_instance.mesh = mesh

func shoot_down_raycast(space_state, pos):
	var start = pos + Vector3.UP*20
	var end = pos + Vector3.DOWN * 10
	var col_layer = 8
	var result = space_state.intersect_ray(start, end, [], col_layer)
	if not result: return pos + Vector3.UP*epsilon
	return result.position + Vector3.UP*epsilon

func _physics_process(dt):
	update_paint_tex()

func update_paint_tex():
	surface_texture.create_from_image(surface_image)
	mesh_instance.mesh.surface_get_material(0).set_shader_param("paint_tex", surface_texture)

func create_mask():
	var canvas_size = 2*dims*UNIT_PIXEL_SIZE
	image_size = (canvas_size / resolution).floor()
	surface_image.create(int(image_size.x), int(image_size.y), false, Image.FORMAT_RGBAH)
	
	print("IMAGE SIZE")
	print(image_size)

func paint(body):
	surface_image.lock()
	
	var num_circles = randi() % 7 + 3
	var radii = []
	var positions = []
	
	for _i in range(num_circles):
		var temp_radius = floor(rand_range(PAINT_SIZE.min, PAINT_SIZE.max+1))
		radii.append( temp_radius )
		
		var rand_angle = 2*randf()*PI
		var offset_radius = randf() * 2*PAINT_SIZE.max
		
		positions.append( Vector2(cos(rand_angle), sin(rand_angle))*offset_radius )

	var col_name = GDict.eggs[body.visuals.type].col
	var col = GDict.colors[col_name]
	
	# slightly randomize the colors, looks better
	if randf() <= 0.5:
		col = col.darkened(randf()*0.2)
	else:
		col = col.lightened(randf()*0.2)

	var global_pos = body.global_transform.origin
	var local_pos = Vector2(global_pos.x, global_pos.z) + dims
	var local_pos_with_resolution = local_pos * UNIT_PIXEL_SIZE / resolution
	
	for x in range(-PAINT_SIZE.max*3, PAINT_SIZE.max*3+1):
		for y in range(-PAINT_SIZE.max*3, PAINT_SIZE.max*3+1):
			var pos_local_to_texture = Vector2(x,y)
			
			if not inside_circle(pos_local_to_texture, positions, radii): continue
			
			var temp_pos = (local_pos_with_resolution + pos_local_to_texture).floor()
			if out_of_mask_bounds(temp_pos): continue
			
			surface_image.set_pixelv(temp_pos, col)

	surface_image.unlock()

func out_of_mask_bounds(pos):
	return pos.x < 0 or pos.x >= image_size.x or pos.y < 0 or pos.y >= image_size.y

func inside_circle(pos, positions, radii):
	for i in range(positions.size()):
		if (pos - positions[i]).length() <= radii[i]: return true
	return false
