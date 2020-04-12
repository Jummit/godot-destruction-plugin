extends RigidBody

func _ready():
	apply_impulse(Vector3(randf(), .1, randf()) - Vector3.ONE * .5, -translation.normalized() / 10 + Vector3.UP * 6)
