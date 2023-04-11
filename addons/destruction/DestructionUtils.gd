static func create_shards(object : Node3D, shard_template : PackedScene = preload("res://addons/destruction/ShardTemplates/DefaultShardTemplate.tscn")) -> Node3D:
	var shards := Node3D.new()
	shards.name = str(object.name) + "Shards"
	var shard_num := 0
	for shard_mesh in object.get_children():
		if not shard_mesh is MeshInstance3D:
			continue
		reposition_mesh_to_middle(shard_mesh)
		var new_shard : RigidBody3D = shard_template.instantiate()
		new_shard.position = shard_mesh.position
		new_shard.name = str(new_shard.name).format({name = object.name, number = shard_num})
		
		var mesh_instance : MeshInstance3D = new_shard.get_node("MeshInstance")
		mesh_instance.mesh = shard_mesh.mesh
		shard_mesh.queue_free()
		
		var collision_shape : CollisionShape3D = new_shard.get_node("CollisionShape")
		collision_shape.shape = mesh_instance.mesh.create_convex_shape()
		
		shards.add_child(new_shard)
		shard_num += 1
	return shards


static func reposition_mesh_to_middle(mesh_instance : MeshInstance3D):
	var mesh : ArrayMesh = mesh_instance.mesh
	if mesh.get_faces().size() == 0:
		return
	var middle := get_middle(mesh.create_convex_shape().points)
	var mesh_tool := MeshDataTool.new()
# warning-ignore:return_value_discarded
	#mesh_instance.mesh = Mesh.new()
	for surface in mesh.get_surface_count():
		mesh_tool.create_from_surface(mesh, surface)
		for i in range(mesh_tool.get_vertex_count()):
			mesh_tool.set_vertex(i, mesh_tool.get_vertex(i) - middle)
# warning-ignore:return_value_discarded
		mesh_tool.commit_to_surface(mesh_instance.mesh)
	mesh_instance.translate(middle)


static func get_middle(points : PackedVector3Array) -> Vector3:
	if points.size() == 0:
		return Vector3()
	
	var sum := Vector3()
	for point in points:
		sum += point
	return sum / points.size()
