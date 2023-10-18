extends Projectile

var n = 0
var center_x = 0
var amp = 0
var spd_y = 0
var fade_spd

func init(amp, spd_y, fade_spd):
	self.amp = amp
	self.spd_y = spd_y
	self.fade_spd = fade_spd
	self.center_x = position.x

func _process(delta):
	position.x = center_x + sin(n) * amp
	position.y += spd_y
	
	modulate.a -= fade_spd
	if modulate.a <= 0.1:
		queue_free()
