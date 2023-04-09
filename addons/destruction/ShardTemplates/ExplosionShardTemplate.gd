extends RigidBody3D


func _ready():
	await(get_tree().create_timer(0.0000001).timeout) #Required to skip the first loop due to bug #29888
	apply_impulse(Vector3(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1)), -position.normalized() * 50)
	
	
