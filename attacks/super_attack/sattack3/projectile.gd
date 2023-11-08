extends Projectile

var vel := Vector2.ZERO

func _process(delta):
	position += vel
