extends Projectile
var passed_frames = 0
func _process(delta):
	if passed_frames > 1:
		queue_free()
	passed_frames+=1
