extends Projectile

var r:float = 0
var r_spd:float
var n:float
var n_spd:float
var center:Vector2

func init(center, r_spd, n, n_spd):
	self.center = center
	self.r_spd = r_spd
	self.n = n
	self.n_spd = n_spd

func _process(delta):
	position = center + polar2cartesian(r, n)
	n += n_spd
	r += r_spd
	if r > 640:
		queue_free()
