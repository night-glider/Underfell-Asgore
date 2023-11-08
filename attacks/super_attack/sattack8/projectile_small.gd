extends Projectile

var vel:=Vector2.ZERO
var damp:=0.9

func _process(delta):
	position += vel
	if vel.length_squared() > 5:
		vel*=0.95
	
