extends Projectile

var direction := Vector2.ZERO
var accel := 0.0
var spd := 0.0

func throw_at_target(pos:Vector2, accel:float):
	self.accel = accel
	direction = global_position.direction_to(pos)

func _process(delta):
	spd += accel
	position += direction * spd
