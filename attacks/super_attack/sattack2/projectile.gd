extends Projectile

var vel_x
var fade_spd
var damp

func init(vel, fade_spd, damp):
	self.vel_x = vel
	self.fade_spd = fade_spd
	self.damp = damp

func _process(delta):
	position.x += vel_x
	modulate.a -= fade_spd
	vel_x *= damp
	if modulate.a < 0.4:
		$CollisionShape2D.disabled = true
		if self.modulate.a < 0.05:
			queue_free()
