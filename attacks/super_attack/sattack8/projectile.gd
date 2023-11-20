extends Projectile

var center_x
var n
var n_spd
var r
var y_spd
var final_y

func init(center_x, y, n, n_spd, r, y_spd, final_y):
	position = Vector2(center_x, y)
	self.center_x = center_x
	self.n = n
	self.n_spd = n_spd
	self.r = r
	self.y_spd = y_spd
	self.final_y = final_y

func explode():
	var direction := Vector2.RIGHT
	for i in 8:
		if i == 0 or i == 4:
			direction = direction.rotated(PI/4)
			continue
		var new_proj = preload("res://attacks/super_attack/sattack8/projectile_small.tscn").instance()
		new_proj.modulate = modulate
		new_proj.type = type
		new_proj.vel = direction*10
		new_proj.position = position
		get_parent().add_child(new_proj)
		direction = direction.rotated(PI/4)
	
	GlobalGeneral.camera_shake(10, 3)
	get_parent().play_explosion()
	queue_free()

func _process(delta):
	position.x = center_x + cos(n) * r
	position.y += y_spd
	n+=n_spd
	
	if position.y < final_y:
		explode()
