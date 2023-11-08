extends Projectile

var center:Vector2
var n = 0
var n_spd
var r = 0
var r_spd = 0
var n_drag = 0

func init(type, color, center, n, n_spd, r, r_spd, n_drag):
	self.type = type
	self.modulate = color
	self.center = center
	self.n = n
	self.n_spd = n_spd
	self.r = r
	self.r_spd = r_spd
	self.n_drag = n_drag
	
	position = center + Vector2(cos(n), sin(n)) * r

func _process(delta):
	position = center + Vector2(cos(n), sin(n)) * r
	r-=r_spd
	n+=n_spd
	n_spd*=n_drag
	
	if r <= 0:
		queue_free()
