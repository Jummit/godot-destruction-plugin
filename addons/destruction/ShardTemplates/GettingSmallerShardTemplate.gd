extends RigidBody

func _ready():
	$Tween.interpolate_property($MeshInstance, "scale", scale, scale * .6, randf() * 4, Tween.TRANS_LINEAR, Tween.EASE_IN, 4)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
