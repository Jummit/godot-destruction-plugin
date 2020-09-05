static func create_shards(object : Spatial, shard_template : PackedScene = preload("res://addons/destruction/ShardTemplates/DefaultShardTemplate.tscn")) -> Spatial:
	var shards := Spatial.new()
	shards.name = object.name + "Shards"
	var shard_num := 0
	for shard_mesh in object.get_children():
		if not shard_mesh is MeshInstance:
			continue
		reposition_mesh_to_middle(shard_mesh)
		var new_shard : RigidBody = shard_template.instance()
		new_shard.translation = shard_mesh.translation
		new_shard.name = new_shard.name.format(
				{name = object.name, number = shard_num})
		
		var mesh_instance : MeshInstance = new_shard.get_node("MeshInstance")
		mesh_instance.mesh = shard_mesh.mesh
		
		var collision_shape : CollisionShape = new_shard.get_node("CollisionShape")
		collision_shape.shape = mesh_instance.mesh.create_convex_shape()
		
		shards.add_child(new_shard)
		shard_num += 1
	return shards


static func reposition_mesh_to_middle(mesh_instance : MeshInstance):
	var mesh := mesh_instance.mesh
	if mesh.get_faces().size() == 0:
		return
	var middle := get_middle(mesh.create_convex_shape().points)
	var mesh_tool := MeshDataTool.new()
# warning-ignore:return_value_discarded
	mesh_instance.mesh = Mesh.new()
	for surface in mesh.get_surface_count():
		mesh_tool.create_from_surface(mesh, surface)
		for i in range(mesh_tool.get_vertex_count()):
			mesh_tool.set_vertex(i, mesh_tool.get_vertex(i) - middle)
# warning-ignore:return_value_discarded
		mesh_tool.commit_to_surface(mesh_instance.mesh)
	mesh_instance.translate(middle)


static func get_middle(points : PoolVector3Array) -> Vector3:
	if points.size() == 0:
		return Vector3()
	
	var sum := Vector3()
	for point in points:
		sum += point
	return sum / points.size()
