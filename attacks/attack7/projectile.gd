extends Projectile

var velocity:= Vector2.ZERO

func init(velocity):
	self.velocity = velocity

func _process(delta):
	position += velocity
