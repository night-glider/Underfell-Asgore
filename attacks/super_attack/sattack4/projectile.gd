extends Projectile

var vel := Vector2.ZERO
var accel:=Vector2.ZERO
var can_respawn = true

func init(accel:Vector2):
	self.accel = accel

func respawn():
	if not can_respawn:
		queue_free()
	position.y = 0
	vel = Vector2.ZERO
	position.x = rand_range(0,640)

func _process(delta):
	vel+=accel
	position += vel
	if position.y > 500:
		respawn()

func player_hitted():
	respawn()
