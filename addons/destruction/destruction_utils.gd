extends Node

var cached_meshes := {}
var cached_shapes := {}

## Use a scene of [MeshInstance]s and a shard template to create [RigidBody3D]s.
func create_shards(meshes : PackedScene, shard_scene : PackedScene,
		collision_layers : float, collision_masks : float,
		explosion_power : float, fade_delay : float,
		shrink_delay : float) -> Node3D:
	
	if not meshes in cached_meshes:
		cached_meshes[meshes] = meshes.instantiate()
		for shard_mesh in cached_meshes[meshes].get_children():
			cached_shapes[shard_mesh] = shard_mesh.mesh.create_convex_shape()
	var original_meshes = cached_meshes[meshes]
	
	var shards := Node3D.new()
	shards.name = str(cached_meshes[meshes].name) + "Shards"
	
	# Used to place the loop back on the main frame and avoid thread errors
	await get_tree().process_frame
	for original in original_meshes.get_children():
		if not original is MeshInstance3D:
			continue
		var new_shard : RigidBody3D = shard_scene.instantiate()
		
		
		var mesh_instance : MeshInstance3D = new_shard.get_node("MeshInstance")
		mesh_instance.mesh = original.mesh
		
		var collision_shape : CollisionShape3D = new_shard.get_node("CollisionShape")
		collision_shape.shape = cached_shapes[original]
		
		new_shard.position = original.position
		new_shard.collision_layer = collision_layers
		new_shard.collision_mask = collision_masks
		new_shard.fade_delay = fade_delay
		new_shard.explosion_power = explosion_power
		new_shard.shrink_delay = shrink_delay
		
		shards.add_child(new_shard)
	return shards
