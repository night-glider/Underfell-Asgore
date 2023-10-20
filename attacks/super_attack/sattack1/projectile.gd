extends Projectile

var target:Vector2
var spd:float

func init(target, spd):
	self.target = target
	self.spd = spd

func _process(delta):
	position = position.move_toward(target, spd)
	
	if position == target:
		get_parent().spawn_circle(position)
		queue_free()
