extends Projectile

const center := Vector2(320,260)
const radius = 100
var vel:Vector2
const n_spd = 0.2
var stage = 0
var n
var target_n

static func angle_to_angle(from, to):
	return fposmod(to-from + PI, PI*2) - PI

func init(vel):
	self.vel = vel
	n = vel.angle() - PI
	target_n = n - PI
	rotation = target_n + PI/2

func _process(delta):
	if stage == 0:
		position += vel
		if position.distance_to(center) < radius:
			stage = 1
	if stage == 1:
		position.x = center.x + cos(n) * radius
		position.y = center.y + sin(n) * radius
		n = lerp_angle(n, target_n, n_spd)
		if angle_to_angle(n, target_n) < 0.02:
			position.x = center.x + cos(target_n) * radius
			position.y = center.y + sin(target_n) * radius
			stage = 2
	if stage == 2:
		position -= vel
		if position.distance_to(center) < 10:
			queue_free()
