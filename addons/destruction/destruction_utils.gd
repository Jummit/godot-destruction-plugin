static func create_shards(object : Node3D,
		shard_scene : PackedScene, collision_layers : float,
		collision_masks : float, explosion_power : float, fade_delay : float,
		shrink_delay : float) -> Node3D:
	var shards := Node3D.new()
	shards.name = str(object.name) + "Shards"
	for shard_mesh in object.get_children():
		if not shard_mesh is MeshInstance3D:
			continue
		var new_shard : RigidBody3D = shard_scene.instantiate()
		
		var mesh_instance : MeshInstance3D = new_shard.get_node("MeshInstance")
		mesh_instance.mesh = shard_mesh.mesh
		shard_mesh.queue_free()
		
		var collision_shape : CollisionShape3D = new_shard.get_node("CollisionShape")
		collision_shape.shape = mesh_instance.mesh.create_convex_shape()
		
		new_shard.position = shard_mesh.position
		new_shard.collision_layer = collision_layers
		new_shard.collision_mask = collision_masks
		new_shard.fade_delay = fade_delay
		new_shard.explosion_power = explosion_power
		new_shard.shrink_delay = shrink_delay
		
		shards.add_child(new_shard)
	object.queue_free() #Another instance which needs to be queued free or it will end up as an orphan node.
	return shards
