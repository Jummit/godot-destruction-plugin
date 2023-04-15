extends RigidBody3D

func _ready():
	var tween = create_tween()
	tween.tween_property($MeshInstance, "scale", scale * 0.6, randf() * 4).from(scale).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN).set_delay(4)
	await(tween.finished) #Await the tween to finish making the shards smaller then queues free the base rock along with the shards.
	get_parent().queue_free()
