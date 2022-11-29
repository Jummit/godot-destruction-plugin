extends RigidBody3D

func _ready():
	#apply_impulse(Vector3(randf_range(0, 1), .1, randf_range(0, 1)) - Vector3.ONE * .5, -position.normalized() / 10 + Vector3.UP * 6)
	apply_impulse(Vector3(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1)), -position.normalized() * 50)
