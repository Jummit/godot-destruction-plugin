extends RigidBody3D

var explosion_power = 10

func _ready():
	await(get_tree().physics_frame) #Both of these are required to skip the first loop due to bug https://github.com/godotengine/godot/issues/75934
	await(get_tree().physics_frame)
	apply_impulse(Vector3(randf(), randf(), randf()), -position.normalized() * explosion_power)
	
	
