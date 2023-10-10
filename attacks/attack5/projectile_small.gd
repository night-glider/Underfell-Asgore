extends Projectile

var vel:Vector2
var damping:float
var min_spd:float

func init(vel:Vector2, damping:float, min_spd):
	self.vel = vel
	self.damping = damping
	self.min_spd = min_spd

func _process(delta):
	position+=vel
	if vel.length_squared() > min_spd:
		vel*=damping
