extends Projectile

var direction := Vector2.ZERO
var accel := 0.0
var spd := 0.0
var player:Player

func init(player, accel, time:float):
	self.player = player
	self.accel = accel
	$Timer.start(time)

func _process(delta):
	spd += accel
	position += direction * spd

func _on_throw_timeout():
	direction = global_position.direction_to(player.global_position)
