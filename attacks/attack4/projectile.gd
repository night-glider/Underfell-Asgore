extends Projectile

var vel := Vector2.ZERO

func init(vel:Vector2):
	self.vel = vel

func _process(delta):
	position += vel
