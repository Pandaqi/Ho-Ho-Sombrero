extends Spatial

onready var mesh_instance = $MeshInstance
var epsilon = 0.05
var dims : Vector2

func get_dimensions():
	return Vector3(dims.x, 0, dims.y)

func _ready():
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
